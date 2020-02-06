//
//  JCS_NetworkTransaction.m
//  Flipboard
//
//  Created by Ryan Olson on 2/8/15.
//  Copyright (c) 2015 Flipboard. All rights reserved.
//

#import "JCS_NetworkTransaction.h"

@interface JCS_NetworkTransaction ()

@property (nonatomic, readwrite) NSData *cachedRequestBody;

@end

@implementation JCS_NetworkTransaction

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shortMIMEType = @"unknow";
    }
    return self;
}

- (NSString *)description
{
    NSString *description = [super description];

    description = [description stringByAppendingFormat:@" id = %@;", self.requestID];
    description = [description stringByAppendingFormat:@" url = %@;", self.request.URL];
    description = [description stringByAppendingFormat:@" duration = %f;", self.duration];
    description = [description stringByAppendingFormat:@" receivedDataLength = %lld", self.receivedDataLength];

    return description;
}

- (NSData *)cachedRequestBody {
    if (!_cachedRequestBody) {
        if (self.request.HTTPBody != nil) {
            _cachedRequestBody = self.request.HTTPBody;
        } else if ([self.request.HTTPBodyStream conformsToProtocol:@protocol(NSCopying)]) {
            NSInputStream *bodyStream = [self.request.HTTPBodyStream copy];
            const NSUInteger bufferSize = 1024;
            uint8_t buffer[bufferSize];
            NSMutableData *data = [NSMutableData data];
            [bodyStream open];
            NSInteger readBytes = 0;
            do {
                readBytes = [bodyStream read:buffer maxLength:bufferSize];
                [data appendBytes:buffer length:readBytes];
            } while (readBytes > 0);
            [bodyStream close];
            _cachedRequestBody = data;
        }
    }
    return _cachedRequestBody;
}

+ (NSString *)readableStringFromTransactionState:(JCS_NetworkTransactionState)state
{
    NSString *readableString = nil;
    switch (state) {
        case JCS_NetworkTransactionStateUnstarted:
            readableString = @"Unstarted";
            break;

        case JCS_NetworkTransactionStateAwaitingResponse:
            readableString = @"Awaiting Response";
            break;

        case JCS_NetworkTransactionStateReceivingData:
            readableString = @"Receiving Data";
            break;

        case JCS_NetworkTransactionStateFinished:
            readableString = @"Finished";
            break;

        case JCS_NetworkTransactionStateFailed:
            readableString = @"Failed";
            break;
    }
    return readableString;
}

- (NSString *)relativeUrlString {
    if(!_relativeUrlString){
        //从absoluteString去除baseUrl
       NSString *absoluteString = self.request.URL.absoluteString;
       NSString *host = self.request.URL.host;
       NSString *scheme = self.request.URL.scheme;
       NSString *baseUrl = [NSString stringWithFormat:@"%@://%@",scheme,host];
       NSString *relativeString = [absoluteString stringByReplacingOccurrencesOfString:baseUrl withString:@""];
       //从relativeString去除参数(?后面部分)
       if([relativeString containsString:@"?"]){
           NSRange range = [relativeString rangeOfString:@"?"];
           relativeString = [relativeString substringToIndex:range.location];
       }
        _relativeUrlString = relativeString;
    }
    return _relativeUrlString;
}

@end
