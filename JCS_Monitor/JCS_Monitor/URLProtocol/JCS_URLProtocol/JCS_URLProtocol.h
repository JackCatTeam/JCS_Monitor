//
//  JCS_URLProtocol.h
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/29.
//  Copyright © 2020 yongping. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCS_URLProtocol : NSURLProtocol

//开始监听
+(void)startMonitor;

//停止监听
+ (void)stopMonitor;

@end

NS_ASSUME_NONNULL_END
