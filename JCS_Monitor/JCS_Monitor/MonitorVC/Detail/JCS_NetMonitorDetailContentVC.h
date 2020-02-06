//
//  JCS_NetMonitorDetailContentVC.h
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCS_NetworkTransaction;

NS_ASSUME_NONNULL_BEGIN

@interface JCS_NetMonitorDetailContentVC : UIViewController

/** 是否是Reponse **/
@property (nonatomic, assign) BOOL isResponse;

@property (nonatomic, strong) JCS_NetworkTransaction *transaction;

- (void)configRequestData;
- (void)configResponseData;

@end

NS_ASSUME_NONNULL_END
