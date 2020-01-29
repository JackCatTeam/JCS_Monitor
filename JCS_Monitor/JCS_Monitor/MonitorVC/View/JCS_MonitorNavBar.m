//
//  JCS_MonitorNavBar.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/24.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_MonitorNavBar.h"
#import <JCS_Create/JCS_Create.h>

@interface JCS_MonitorNavBar()
/** 返回按钮 **/
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation JCS_MonitorNavBar

- (void)setupUI{
    
    self.jcs_whiteBackgroundColor();
    
    //有效内容区域
    [UIView jcs_create].jcs_layout(self, ^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }).jcs_whiteBackgroundColor()
    .jcs_associated(&_contentView);
    
    //返回按钮
    @weakify(self)
    [UIButton jcs_create].jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(22);
        make.centerY.equalTo(self.contentView);
    }).jcs_toButton()
    .jcs_enlargeEdge(10,10,10,10)
    .jcs_normalImageWithName(@"start_back")
    .jcs_tapBlock(^{
        @strongify(self)
        [self.backSubject sendNext:nil];
    })
    .jcs_associated(&_backButton);
    
    //标题
    [UILabel jcs_create].jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }).jcs_toLabel()
    .jcs_textColor(0x000000)
    .jcs_fontSize(16)
    .jcs_text(@"标题")
    .jcs_associated(&_titleLabel);
}

JCS_LAZY_SUBJECT(backSubject)

@end
