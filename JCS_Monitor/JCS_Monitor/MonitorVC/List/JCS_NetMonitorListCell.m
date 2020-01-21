//
//  JCS_NetMonitorListCell.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetMonitorListCell.h"
#import <JCS_Create/JCS_Create.h>

@interface JCS_NetMonitorListCell()
/** <#备注#> **/
@property (nonatomic, strong) UILabel *linkLabel;
/** <#备注#> **/
@property (nonatomic, strong) UILabel *mineTypeLabel;
/** <#备注#> **/
@property (nonatomic, strong) UIView *mineTypeView;
/** <#备注#> **/
@property (nonatomic, strong) UILabel *statusCodeLabel;
/** <#备注#> **/
@property (nonatomic, strong) UILabel *agentLabel;
/** <#备注#> **/
@property (nonatomic, strong) UILabel *hostLabel;
/** <#备注#> **/
@property (nonatomic, strong) UILabel *timeLabel;
/** <#备注#> **/
@property (nonatomic, strong) UIImageView *imageIV;
@end

@implementation JCS_NetMonitorListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupUI];
        [self bindingData];
    }
    return self;
}

- (void)setupUI {
    self.contentView.jcs_whiteBackgroundColor();
    
    //Link
    [UILabel jcs_create].jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(UIScreen.mainScreen.bounds.size.width - 10 * 2);
        make.top.mas_equalTo(10);
    }).jcs_toLabel()
    .jcs_textColorHex(0x567ABC)
    .jcs_fontSize(14)
    .jcs_numberOfLines(0)
    .jcs_associated(&_linkLabel);
    
    //MINE type View
    [UIView jcs_create].jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
        make.left.equalTo(self.linkLabel);
        make.top.equalTo(self.linkLabel.mas_bottom).mas_offset(3);
    })
    .jcs_cornerRadius(2)
    .jcs_backgroundColorHex(0xF47A59)
    .jcs_associated(&_mineTypeView);
    
    //MINE type Label
    [UILabel jcs_create].jcs_layout(self.mineTypeView, ^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-5);
    }).jcs_toLabel()
    .jcs_textColorHex(0xFCF1E8)
    .jcs_fontSize(14)
    .jcs_associated(&_mineTypeLabel);
    
    //status code
    [UILabel jcs_create].jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
        make.left.equalTo(self.mineTypeView.mas_right).mas_offset(3);
        make.baseline.equalTo(self.mineTypeLabel);
    }).jcs_toLabel()
    .jcs_textColorHex(0x609B5B)
    .jcs_fontSize(14)
    .jcs_associated(&_statusCodeLabel);
    
    //agent
    [UILabel jcs_create].jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusCodeLabel.mas_right).mas_offset(3);
        make.baseline.equalTo(self.mineTypeLabel);
    }).jcs_toLabel()
    .jcs_textColorHex(0x555657)
    .jcs_fontSize(14)
    .jcs_associated(&_agentLabel);
    
    //host
    [UILabel jcs_create].jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
        make.left.equalTo(self.linkLabel);
        make.top.equalTo(self.mineTypeView.mas_bottom).mas_offset(3);
    }).jcs_toLabel()
    .jcs_textColorHex(0x222222)
    .jcs_fontSize(14)
    .jcs_associated(&_hostLabel);
    
    //time
    [UILabel jcs_create].jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
        make.left.equalTo(self.linkLabel);
        make.top.equalTo(self.hostLabel.mas_bottom).mas_offset(3);
        make.bottom.equalTo(self.contentView.mas_bottom).mas_offset(-10);
    }).jcs_toLabel()
    .jcs_textColorHex(0x7E7E7F)
    .jcs_fontSize(14)
    .jcs_associated(&_timeLabel);
    
    //UIImageView
    [UIImageView jcs_create].jcs_associated(&_imageIV);
    self.imageIV.jcs_layout(self.contentView, ^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.equalTo(self.mineTypeView);
        make.bottom.equalTo(self.timeLabel);
        make.width.equalTo(self.imageIV.mas_height);
    });
}

- (void)bindingData{
    self.linkLabel.text = @"/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList.action";
    self.mineTypeLabel.text = @"POST > json";
    self.statusCodeLabel.text = @"200";
    self.agentLabel.text = @"BlackCard";
    self.hostLabel.text = @"api.jiakeniu.com";
    self.timeLabel.text = @"2019-01-01 23:22:22";
    self.imageIV.backgroundColor = [UIColor jcs_randomColor];
}

@end
