//
//  JCS_NetMonitorDetailSingleArrowCell.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetMonitorDetailSingleArrowCell.h"
#import <JCS_Kit/JCS_Kit.h>

@interface JCS_NetMonitorDetailSingleArrowCell()
/** 标题 **/
@property (nonatomic, strong) UILabel *titleLabel;
/** 副标题 **/
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation JCS_NetMonitorDetailSingleArrowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [UILabel jcs_create].jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.equalTo(self.contentView);
        }).jcs_toLabel()
        .jcs_fontSize(14)
        .jcs_textColorHex(0x222222)
        .jcs_associated(&_titleLabel);
        
        [UILabel jcs_create].jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
                   make.right.mas_equalTo(-10);
                   make.centerY.equalTo(self.contentView);
       }).jcs_toLabel()
       .jcs_fontSize(14)
       .jcs_textColorHex(0x222222)
       .jcs_numberOfLines(0)
       .jcs_associated(&_subTitleLabel);
    }
    return self;
}

- (void)setData:(id)data {
    [super setData:data];
    self.titleLabel.text = [data valueForKey:@"title"];
    self.subTitleLabel.text = [data valueForKey:@"subTitle"];
}

@end
