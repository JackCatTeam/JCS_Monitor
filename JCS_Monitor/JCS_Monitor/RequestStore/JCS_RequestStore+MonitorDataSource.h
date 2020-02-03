//
//  JCS_RequestStore+MonitorDataSource.h
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/31.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_RequestStore.h"

@class JCS_TableSectionModel;

NS_ASSUME_NONNULL_BEGIN

@interface JCS_RequestStore (MonitorDataSource)

@property (nonatomic, strong, readonly) NSArray<JCS_TableSectionModel *> *sections;

@end

NS_ASSUME_NONNULL_END
