//
//  JCS_RequestStore+MonitorDataSource.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/31.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_RequestStore+MonitorDataSource.h"
#import <JCS_Create/JCS_Create.h>

@implementation JCS_RequestStore (MonitorDataSource)

- (NSMutableArray<JCS_TableSectionModel *> *)sections {
    NSMutableArray *sections = [NSMutableArray array];
    JCS_TableSectionModel *section = [[JCS_TableSectionModel alloc] init];
    [sections addObject:section];
    for (JCS_RequestInfo *request in self.displayRequests) {
        JCS_TableRowModel *row = [JCS_TableRowModel jcs_create];
        row.data = request;
        row.cellClass = @"JCS_NetMonitorListCell";
        row.cellHeight = 40;
        row.clickRouter = @"jcs://MonitorRouter/showRequestDetail:?requestId=1111";
        [section.rows addObject:row];
    }
    return [sections copy];
}

@end
