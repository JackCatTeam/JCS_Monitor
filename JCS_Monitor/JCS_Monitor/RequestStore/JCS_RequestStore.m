//
//  JCS_RequestStore.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/29.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_RequestStore.h"
#import <JCS_Create/JCS_Create.h>

@interface JCS_RequestStore()

@property (nonatomic, strong) JCS_TableSectionModel *originalSection;
@property (nonatomic, strong) JCS_TableSectionModel *filterSection;
/** 原始记录 **/
@property (nonatomic, strong) NSMutableArray<JCS_TableSectionModel*> *originalRequests;
/** 已过虑记录 **/
@property (nonatomic, strong) NSMutableArray<JCS_TableSectionModel*> *filterRequests;

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

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.originalRequests addObject:self.originalSection];
        [self.filterRequests addObject:self.filterSection];
    }
    return self;
}

- (void)addNewRequest:(JCS_RequestInfo *)requestInfo {
    
    JCS_TableRowModel *model = [JCS_TableRowModel jcs_create];
    model.cellClass = @"JCS_NetMonitorListCell";
    model.clickRouter = @"jcs://MonitorRouter/showRequestDetail:?requestId=1111";
    model.data = requestInfo;
    
    [self.originalSection.rows insertObject:model atIndex:0];
    [self.filterSection.rows insertObject:model atIndex:0];
}

#pragma mark - 懒加载

JCS_LAZY(NSMutableArray, originalRequests)
JCS_LAZY(NSMutableArray, filterRequests)
JCS_LAZY(JCS_TableSectionModel, originalSection)
JCS_LAZY(JCS_TableSectionModel, filterSection)

- (NSArray<JCS_TableSectionModel *> *)displayRequests {
    return [self.filterRequests copy];
}

@end
