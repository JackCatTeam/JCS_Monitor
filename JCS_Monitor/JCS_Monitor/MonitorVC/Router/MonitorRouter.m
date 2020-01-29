//
//  MonitorRouter.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/29.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "MonitorRouter.h"
#import <JCS_BaseLib/JCS_BaseLib.h>
#import "JCS_NetMonitorDetailVC.h"

@implementation MonitorRouter

- (void)showRequestDetail:(NSDictionary*)params {
    JCS_NetMonitorDetailVC *detailVC = [[JCS_NetMonitorDetailVC alloc] init];
    [[NSObject new].jcs_currentVC.navigationController pushViewController:detailVC animated:YES];
}

@end
