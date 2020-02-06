//
//  JCS_NetworkRecorder.h
//  Flipboard
//
//  Created by Ryan Olson on 2/4/15.
//  Copyright (c) 2015 Flipboard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JCS_Create.h>

// Notifications posted when the record is updated
extern NSString *const kJCS_NetworkRecorderNewTransactionNotification;
extern NSString *const kJCS_NetworkRecorderTransactionUpdatedNotification;
extern NSString *const kJCS_NetworkRecorderUserInfoTransactionKey;
extern NSString *const kJCS_NetworkRecorderTransactionsClearedNotification;

@class JCS_NetworkTransaction;

@interface JCS_NetworkRecorder : NSObject

/// In general, it only makes sense to have one recorder for the entire application.
+ (instancetype)defaultRecorder;

/** JCS_ConfigTableView Sections **/
@property (nonatomic, strong) NSMutableArray<JCS_TableSectionModel*> *sections;

/// Defaults to 25 MB if never set. Values set here are persisted across launches of the app.
@property (nonatomic) NSUInteger responseCacheByteLimit;

/// If NO, the recorder not cache will not cache response for content types with an "image", "video", or "audio" prefix.
@property (nonatomic) BOOL shouldCacheMediaResponses;

@property (nonatomic, copy) NSArray<NSString *> *hostBlacklist;


// Accessing recorded network activity

/// Array of JCS_NetworkTransaction objects ordered by start time with the newest first.
- (NSArray<JCS_NetworkTransaction *> *)networkTransactions;

/// The full response data IFF it hasn't been purged due to memory pressure.
- (NSData *)cachedResponseBodyForTransaction:(JCS_NetworkTransaction *)transaction;

/// Dumps all network transactions and cached response bodies.
- (void)clearRecordedActivity;


// Recording network activity

/// Call when app is about to send HTTP request.
- (void)recordRequestWillBeSentWithRequestID:(NSString *)requestID request:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse;

/// Call when HTTP response is available.
- (void)recordResponseReceivedWithRequestID:(NSString *)requestID response:(NSURLResponse *)response;

/// Call when data chunk is received over the network.
- (void)recordDataReceivedWithRequestID:(NSString *)requestID dataLength:(int64_t)dataLength;

/// Call when HTTP request has finished loading.
- (void)recordLoadingFinishedWithRequestID:(NSString *)requestID responseBody:(NSData *)responseBody;

/// Call when HTTP request has failed to load.
- (void)recordLoadingFailedWithRequestID:(NSString *)requestID error:(NSError *)error;

/// Call to set the request mechanism anytime after recordRequestWillBeSent... has been called.
/// This string can be set to anything useful about the API used to make the request.
- (void)recordMechanism:(NSString *)mechanism forRequestID:(NSString *)requestID;

@end
