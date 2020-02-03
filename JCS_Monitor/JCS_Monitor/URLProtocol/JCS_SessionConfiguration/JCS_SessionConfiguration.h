//
//  JCS_SessionConfiguration.h
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/29.
//  Copyright © 2020 yongping. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCS_SessionConfiguration : NSObject

//是否交换方法
@property (nonatomic,assign) BOOL isExchanged;

+ (JCS_SessionConfiguration *)defaultConfiguration;

// 交换掉NSURLSessionConfiguration的 protocolClasses方法
- (void)load;

// 还原初始化
- (void)unload;

@end

NS_ASSUME_NONNULL_END
