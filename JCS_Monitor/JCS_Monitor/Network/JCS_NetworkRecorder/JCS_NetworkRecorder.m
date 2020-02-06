//
//  JCS_NetworkRecorder.m
//  Flipboard
//
//  Created by Ryan Olson on 2/4/15.
//  Copyright (c) 2015 Flipboard. All rights reserved.
//

#import "JCS_NetworkRecorder.h"
#import "JCS_NetworkTransaction.h"
#import "JCS_NetworkUtility.h"
#import "JCS_NetworkRecorder+TableRow.h"

NSString *const kJCS_NetworkRecorderNewTransactionNotification = @"kJCS_NetworkRecorderNewTransactionNotification";
NSString *const kJCS_NetworkRecorderTransactionUpdatedNotification = @"kJCS_NetworkRecorderTransactionUpdatedNotification";
NSString *const kJCS_NetworkRecorderUserInfoTransactionKey = @"transaction";
NSString *const kJCS_NetworkRecorderTransactionsClearedNotification = @"kJCS_NetworkRecorderTransactionsClearedNotification";

NSString *const kJCS_NetworkRecorderResponseCacheLimitDefaultsKey = @"com.JCS_.responseCacheLimit";

@interface JCS_NetworkRecorder ()

@property (nonatomic) NSCache *responseCache;
@property (nonatomic) NSMutableArray<JCS_NetworkTransaction *> *orderedTransactions;
@property (nonatomic) NSMutableDictionary<NSString *, JCS_NetworkTransaction *> *networkTransactionsForRequestIdentifiers;
@property (nonatomic) dispatch_queue_t queue;

/** JCS_ConfigTableView Secton **/
@property (nonatomic, strong) JCS_TableSectionModel *sectionModel;

@end

@implementation JCS_NetworkRecorder

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.responseCache = [NSCache new];
        NSUInteger responseCacheLimit = [[[NSUserDefaults standardUserDefaults] objectForKey:kJCS_NetworkRecorderResponseCacheLimitDefaultsKey] unsignedIntegerValue];
        if (responseCacheLimit) {
            [self.responseCache setTotalCostLimit:responseCacheLimit];
        } else {
            // Default to 25 MB max. The cache will purge earlier if there is memory pressure.
            [self.responseCache setTotalCostLimit:25 * 1024 * 1024];
        }
        self.orderedTransactions = [NSMutableArray array];
        self.networkTransactionsForRequestIdentifiers = [NSMutableDictionary dictionary];

        // Serial queue used because we use mutable objects that are not thread safe
        self.queue = dispatch_queue_create("com.JCS_.JCS_NetworkRecorder", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (instancetype)defaultRecorder
{
    static JCS_NetworkRecorder *defaultRecorder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultRecorder = [self new];
    });
    return defaultRecorder;
}

#pragma mark - Public Data Access

- (NSUInteger)responseCacheByteLimit
{
    return [self.responseCache totalCostLimit];
}

- (void)setResponseCacheByteLimit:(NSUInteger)responseCacheByteLimit
{
    [self.responseCache setTotalCostLimit:responseCacheByteLimit];
    [[NSUserDefaults standardUserDefaults] setObject:@(responseCacheByteLimit) forKey:kJCS_NetworkRecorderResponseCacheLimitDefaultsKey];
}

- (NSArray<JCS_NetworkTransaction *> *)networkTransactions
{
    __block NSArray<JCS_NetworkTransaction *> *transactions = nil;
    dispatch_sync(self.queue, ^{
        transactions = [self.orderedTransactions copy];
    });
    return transactions;
}

- (NSData *)cachedResponseBodyForTransaction:(JCS_NetworkTransaction *)transaction
{
    return [self.responseCache objectForKey:transaction.requestID];
}

- (void)clearRecordedActivity
{
    dispatch_async(self.queue, ^{
        [self.responseCache removeAllObjects];
        [self.orderedTransactions removeAllObjects];
        [self clearAllTransactions];
        [self.networkTransactionsForRequestIdentifiers removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSNotificationCenter.defaultCenter postNotificationName:kJCS_NetworkRecorderTransactionsClearedNotification object:self];
        });
    });
}

#pragma mark - Network Events

- (void)recordRequestWillBeSentWithRequestID:(NSString *)requestID request:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    for (NSString *host in self.hostBlacklist) {
        if ([request.URL.host hasSuffix:host]) {
            return;
        }
    }
    
    NSDate *startDate = [NSDate date];

    if (redirectResponse) {
        [self recordResponseReceivedWithRequestID:requestID response:redirectResponse];
        [self recordLoadingFinishedWithRequestID:requestID responseBody:nil];
    }

    dispatch_async(self.queue, ^{
        JCS_NetworkTransaction *transaction = [JCS_NetworkTransaction new];
        transaction.requestID = requestID;
        transaction.request = request;
        transaction.startTime = startDate;
        
        [self insertNewTransaction:transaction];
        [self.orderedTransactions insertObject:transaction atIndex:0];
        [self.networkTransactionsForRequestIdentifiers setObject:transaction forKey:requestID];
        transaction.transactionState = JCS_NetworkTransactionStateAwaitingResponse;

        [self postNewTransactionNotificationWithTransaction:transaction];
    });
}

- (void)recordResponseReceivedWithRequestID:(NSString *)requestID response:(NSURLResponse *)response
{
    NSDate *responseDate = [NSDate date];

    dispatch_async(self.queue, ^{
        JCS_NetworkTransaction *transaction = self.networkTransactionsForRequestIdentifiers[requestID];
        if (!transaction) {
            return;
        }
        transaction.response = response;
        transaction.transactionState = JCS_NetworkTransactionStateReceivingData;
        transaction.latency = -[transaction.startTime timeIntervalSinceDate:responseDate];

        [self postUpdateNotificationForTransaction:transaction];
    });
}

- (void)recordDataReceivedWithRequestID:(NSString *)requestID dataLength:(int64_t)dataLength
{
    dispatch_async(self.queue, ^{
        JCS_NetworkTransaction *transaction = self.networkTransactionsForRequestIdentifiers[requestID];
        if (!transaction) {
            return;
        }
        transaction.receivedDataLength += dataLength;

        [self postUpdateNotificationForTransaction:transaction];
    });
}

- (void)recordLoadingFinishedWithRequestID:(NSString *)requestID responseBody:(NSData *)responseBody
{
    NSDate *finishedDate = [NSDate date];

    dispatch_async(self.queue, ^{
        JCS_NetworkTransaction *transaction = self.networkTransactionsForRequestIdentifiers[requestID];
        if (!transaction) {
            return;
        }
        transaction.transactionState = JCS_NetworkTransactionStateFinished;
        transaction.duration = -[transaction.startTime timeIntervalSinceDate:finishedDate];

        BOOL shouldCache = responseBody.length > 0;
        if (!self.shouldCacheMediaResponses) {
            NSArray<NSString *> *ignoredMIMETypePrefixes = @[ @"audio", @"image", @"video" ];
            for (NSString *ignoredPrefix in ignoredMIMETypePrefixes) {
                shouldCache = shouldCache && ![transaction.response.MIMEType hasPrefix:ignoredPrefix];
            }
        }
        
        if (shouldCache) {
            [self.responseCache setObject:responseBody forKey:requestID cost:responseBody.length];
        }

        NSString *mimeType = transaction.response.MIMEType;
        if ([mimeType hasPrefix:@"image/"] && responseBody.length > 0) {
            // Thumbnail image previews on a separate background queue
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSInteger maxPixelDimension = UIScreen.mainScreen.scale * 32.0;
                transaction.responseThumbnail = [JCS_NetworkUtility thumbnailedImageWithMaxPixelDimension:maxPixelDimension fromImageData:responseBody];
                [self postUpdateNotificationForTransaction:transaction];
            });
            transaction.shortMIMEType = [mimeType stringByReplacingOccurrencesOfString:@"image/" withString:@""];
        }
        else if ([mimeType isEqual:@"application/json"]) {
            transaction.shortMIMEType = @"json";
        } else if ([mimeType isEqual:@"text/plain"]){
            transaction.shortMIMEType = @"plain";
        } else if ([mimeType isEqual:@"text/html"]) {
            transaction.shortMIMEType = @"html";
        } else if ([mimeType isEqual:@"application/x-plist"]) {
            transaction.shortMIMEType = @"x-plist";
        } else if ([mimeType isEqual:@"application/octet-stream"]) {
            transaction.shortMIMEType = @"octet-stream";
        } else if([mimeType isEqual:@"application/binary"]) {
            transaction.shortMIMEType = @"binary";
        } else if ([mimeType rangeOfString:@"javascript"].length > 0) {
            transaction.shortMIMEType = @"js";
        } else if ([mimeType rangeOfString:@"xml"].length > 0) {
            transaction.shortMIMEType = @"xml";
        } else if ([mimeType hasPrefix:@"audio"]) {
            transaction.shortMIMEType = @"audio";
        } else if ([mimeType hasPrefix:@"video"]) {
            transaction.shortMIMEType = @"video";
        } else if ([mimeType hasPrefix:@"text"]) {
            transaction.shortMIMEType = @"text";
        }
        
        [self postUpdateNotificationForTransaction:transaction];
    });
}

- (void)recordLoadingFailedWithRequestID:(NSString *)requestID error:(NSError *)error
{
    dispatch_async(self.queue, ^{
        JCS_NetworkTransaction *transaction = self.networkTransactionsForRequestIdentifiers[requestID];
        if (!transaction) {
            return;
        }
        transaction.transactionState = JCS_NetworkTransactionStateFailed;
        transaction.duration = -[transaction.startTime timeIntervalSinceNow];
        transaction.error = error;

        [self postUpdateNotificationForTransaction:transaction];
    });
}

- (void)recordMechanism:(NSString *)mechanism forRequestID:(NSString *)requestID
{
    dispatch_async(self.queue, ^{
        JCS_NetworkTransaction *transaction = self.networkTransactionsForRequestIdentifiers[requestID];
        if (!transaction) {
            return;
        }
        transaction.requestMechanism = mechanism;

        [self postUpdateNotificationForTransaction:transaction];
    });
}

#pragma mark Notification Posting

- (void)postNewTransactionNotificationWithTransaction:(JCS_NetworkTransaction *)transaction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary<NSString *, id> *userInfo = @{ kJCS_NetworkRecorderUserInfoTransactionKey : transaction };
        [NSNotificationCenter.defaultCenter postNotificationName:kJCS_NetworkRecorderNewTransactionNotification object:self userInfo:userInfo];
    });
}

- (void)postUpdateNotificationForTransaction:(JCS_NetworkTransaction *)transaction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary<NSString *, id> *userInfo = @{ kJCS_NetworkRecorderUserInfoTransactionKey : transaction };
        [NSNotificationCenter.defaultCenter postNotificationName:kJCS_NetworkRecorderTransactionUpdatedNotification object:self userInfo:userInfo];
    });
}

- (NSMutableArray<JCS_TableSectionModel *> *)sections {
    if(!_sections){
        _sections = [NSMutableArray array];
        [_sections addObject:self.sectionModel];
    }
    return _sections;
}

- (JCS_TableSectionModel *)sectionModel {
    if(!_sectionModel){
        _sectionModel = [JCS_TableSectionModel jcs_create];
    }
    return _sectionModel;
}

@end
