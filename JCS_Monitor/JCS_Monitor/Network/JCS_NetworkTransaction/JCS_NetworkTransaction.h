//
//  JCS_NetworkTransaction.h
//  Flipboard
//
//  Created by Ryan Olson on 2/8/15.
//  Copyright (c) 2015 Flipboard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

typedef NS_ENUM(NSInteger, JCS_NetworkTransactionState) {
    JCS_NetworkTransactionStateUnstarted,
    JCS_NetworkTransactionStateAwaitingResponse,
    JCS_NetworkTransactionStateReceivingData,
    JCS_NetworkTransactionStateFinished,
    JCS_NetworkTransactionStateFailed
};

@interface JCS_NetworkTransaction : NSObject

@property (nonatomic, copy) NSString *requestID;

@property (nonatomic) NSURLRequest *request;
@property (nonatomic) NSURLResponse *response;
@property (nonatomic, copy) NSString *requestMechanism;
@property (nonatomic) JCS_NetworkTransactionState transactionState;
@property (nonatomic) NSError *error;

@property (nonatomic, copy) NSString *shortMIMEType;

@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSTimeInterval latency;
@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) int64_t receivedDataLength;

/// Only applicable for image downloads. A small thumbnail to preview the full response.
@property (nonatomic) UIImage *responseThumbnail;

/// Populated lazily. Handles both normal HTTPBody data and HTTPBodyStreams.
@property (nonatomic, readonly) NSData *cachedRequestBody;

/** 相对连接 **/
@property (nonatomic, copy) NSString *relativeUrlString;

+ (NSString *)readableStringFromTransactionState:(JCS_NetworkTransactionState)state;

@end
