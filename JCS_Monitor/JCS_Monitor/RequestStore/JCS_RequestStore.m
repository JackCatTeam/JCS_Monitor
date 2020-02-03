//
//  JCS_RequestStore.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/29.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_RequestStore.h"
#import <JCS_BaseLib/JCS_BaseLib.h>

@interface JCS_RequestStore()

/** 原始记录 **/
@property (nonatomic, strong) NSMutableArray<JCS_RequestInfo*> *originalRequests;
/** 已过虑记录 **/
@property (nonatomic, strong) NSMutableArray<JCS_RequestInfo*> *filterRequests;

@end

@implementation JCS_RequestStore

+ (instancetype)sharedInstance {
    static JCS_RequestStore *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[JCS_RequestStore alloc] init];
    });
    return __instance;
}

- (void)addNewRequest:(JCS_RequestInfo *)requestInfo {
    [self.originalRequests insertObject:requestInfo atIndex:0];
    [self.filterRequests insertObject:requestInfo atIndex:0];
}

#pragma mark - 懒加载

JCS_LAZY(NSMutableArray, originalRequests)
JCS_LAZY(NSMutableArray, filterRequests)

- (NSArray<JCS_RequestInfo *> *)displayRequests {
    return [self.filterRequests copy];
}

@end
