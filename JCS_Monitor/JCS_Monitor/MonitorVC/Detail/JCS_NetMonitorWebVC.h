//
//  JCS_NetMonitorWebVC.h
//  JCS_Monitor
//
//  Created by 永平 on 2020/2/6.
//  Copyright © 2020 yongping. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MonitorWebVC(__CONTENT__) [JCS_NetMonitorWebVC monitorWebVC:__CONTENT__]

NS_ASSUME_NONNULL_BEGIN

@interface JCS_NetMonitorWebVC : UIViewController

+ (instancetype)monitorWebVC:(NSString*)content;

@end

NS_ASSUME_NONNULL_END
