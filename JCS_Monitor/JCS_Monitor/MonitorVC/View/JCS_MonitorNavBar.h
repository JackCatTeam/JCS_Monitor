//
//  JCS_MonitorNavBar.h
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/24.
//  Copyright © 2020 yongping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JCS_BaseLib/JCS_BaseLib.h>

@class RACSubject;

NS_ASSUME_NONNULL_BEGIN

@interface JCS_MonitorNavBar : JCS_BaseView

/** 有效内容区域 **/
@property (nonatomic, strong) UIView *contentView;
/** 标题 **/
@property (nonatomic, strong) UILabel *titleLabel;
/** 返回 **/
@property (nonatomic, strong) RACSubject *backSubject;

@end

NS_ASSUME_NONNULL_END
