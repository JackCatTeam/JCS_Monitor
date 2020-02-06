//
//  JCS_NetMonitorDetailHeaderView.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetMonitorDetailHeaderView.h"
#import <JCS_Kit/JCS_Kit.h>

@interface JCS_NetMonitorDetailHeaderView()

/** 标题 **/
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JCS_NetMonitorDetailHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self){
        [UILabel jcs_create].jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-5);
        }).jcs_toLabel()
        .jcs_fontSize(14)
        .jcs_textColorHex(0x929396)
        .jcs_text(@"未设置")
        .jcs_associated(&_titleLabel);
    }
    return self;
}

- (void)setData:(id)data {
    [super setData:data];
    self.titleLabel.text = [data valueForKey:@"title"];
}

@end
