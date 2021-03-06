//
//  JCS_NetMonitorDetailPlainTextCell.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetMonitorDetailSinglePlainTextCell.h"
#import <JCS_Kit/JCS_Kit.h>

@interface JCS_NetMonitorDetailSinglePlainTextCell()
/** 标题 **/
@property (nonatomic, strong) UILabel *titleLabel;
/** 副标题 **/
@property (nonatomic, strong) UILabel *subTitleLabel;
/** 分割线 **/
@property (nonatomic, strong) UIView *separatorLine;
@end

@implementation JCS_NetMonitorDetailSinglePlainTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [UILabel jcs_create].jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
            make.top.mas_equalTo(14);
            make.bottom.mas_equalTo(-14);
            make.left.mas_equalTo(10);
//            make.height.mas_equalTo(20);
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
        
        //分割线
        [UIView jcs_create].jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1/UIScreen.mainScreen.scale);
        }).jcs_backgroundColorHex(0xe6e6e6)
        .jcs_hidden(YES)
        .jcs_associated(&_separatorLine);
    }
    return self;
}

- (void)setData:(id)data {
    [super setData:data];
    self.titleLabel.text = [data valueForKey:@"title"];
    self.subTitleLabel.text = [data valueForKey:@"subTitle"];
    self.separatorLine.hidden = ![[data valueForKey:@"showSeparator"] boolValue];
}

@end
