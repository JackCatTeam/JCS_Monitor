//
//  JCS_NetworkRecorder+TableRow.h
//  JCS_Monitor
//
//  Created by 永平 on 2020/2/6.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetworkRecorder.h"

NS_ASSUME_NONNULL_BEGIN

@interface JCS_NetworkRecorder (TableRow)

- (void)insertNewTransaction:(JCS_NetworkTransaction*)transaction;
- (void)clearAllTransactions;

@end

NS_ASSUME_NONNULL_END
