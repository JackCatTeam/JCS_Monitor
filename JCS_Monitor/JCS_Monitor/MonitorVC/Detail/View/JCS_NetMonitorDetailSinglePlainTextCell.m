//
//  JCS_NetMonitorDetailPlainTextCell.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetMonitorDetailSinglePlainTextCell.h"
#import <JCS_Create/JCS_Create.h>

@interface JCS_NetMonitorDetailSinglePlainTextCell()
/** 标题 **/
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation JCS_NetMonitorDetailSinglePlainTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [UILabel jcs_create].jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.equalTo(self.contentView);
        }).jcs_toLabel()
        .jcs_fontSize(14)
        .jcs_textColorHex(0x222222)
        .jcs_associated(&_titleLabel);
    }
    return self;
}

- (void)setData:(id)data {
    [super setData:data];
    self.titleLabel.text = [data valueForKey:@"title"];
}

@end
