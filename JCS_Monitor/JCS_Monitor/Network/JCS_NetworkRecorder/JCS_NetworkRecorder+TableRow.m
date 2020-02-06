//
//  JCS_NetworkRecorder+TableRow.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/2/6.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetworkRecorder+TableRow.h"

@implementation JCS_NetworkRecorder (TableRow)

- (void)insertNewTransaction:(JCS_NetworkTransaction*)transaction {
    JCS_TableRowModel *row = [JCS_TableRowModel jcs_create];
    row.data = transaction;
    row.cellClass = @"JCS_NetMonitorListCell";
    row.clickRouter = @"jcs://MonitorRouter/showRequestDetail:";
    [self.sections.firstObject.rows insertObject:row atIndex:0];
}
- (void)clearAllTransactions {
    [self.sections.firstObject.rows removeAllObjects];
}

@end
