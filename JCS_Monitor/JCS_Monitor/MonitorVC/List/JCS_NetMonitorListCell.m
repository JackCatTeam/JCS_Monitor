//
//  JCS_NetMonitorListCell.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetMonitorListCell.h"
#import <JCS_Create/JCS_Create.h>
#import <JCS_Category/JCS_Category.h>

#import "JCS_NetworkTransaction.h"
#import "JCS_NetworkUtility.h"

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
        make.bottom.mas_equalTo(-6);
        make.width.equalTo(self.imageIV.mas_height);
    });
}

- (void)setData:(JCS_NetworkTransaction*)data {
    [super setData:data];
    
    //relativeString
    self.linkLabel.text = [self relativeStringInTransaction:data];

    //状态码
    self.statusCodeLabel.text = [self stateCodeWithTransaction:data];
    //Agent
    self.agentLabel.text = [data.request valueForHTTPHeaderField:@"UserAgent"];
    //HOST
    self.hostLabel.text = data.request.URL.host;
    //请求时间
    self.timeLabel.text = [data.startTime jcs_dateString:@"YYYY-MM-dd HH:mm:ss"];
    //Method > MIMEType
    NSString *method = data.request.HTTPMethod;
    self.mineTypeLabel.text = [NSString stringWithFormat:@"%@ > %@",method,data.shortMIMEType];
    //缩略图
    self.imageIV.image = data.responseThumbnail;
}

///从transaction提取relativeString
- (NSString*)relativeStringInTransaction:(JCS_NetworkTransaction*)transaction {
    
    //从absoluteString去除baseUrl
    NSString *absoluteString = transaction.request.URL.absoluteString;
    NSString *host = transaction.request.URL.host;
    NSString *scheme = transaction.request.URL.scheme;
    NSString *baseUrl = [NSString stringWithFormat:@"%@://%@",scheme,host];
    NSString *relativeString = [absoluteString stringByReplacingOccurrencesOfString:baseUrl withString:@""];
    
    //从relativeString去除参数(?后面部分)
    if([relativeString containsString:@"?"]){
        NSRange range = [relativeString rangeOfString:@"?"];
        relativeString = [relativeString substringToIndex:range.location];
    }
    
    return relativeString;
}

- (NSString*)stateCodeWithTransaction:(JCS_NetworkTransaction*)transaction {
    if (transaction.transactionState == JCS_NetworkTransactionStateFinished || transaction.transactionState == JCS_NetworkTransactionStateFailed) {
        
        NSMutableString *result = [NSMutableString string];
        
        //状态码
        NSString *statusCodeString = [JCS_NetworkUtility statusCodeStringFromURLResponse:transaction.response];
        [result appendString:statusCodeString];

//        //接受数据大小
//        if (transaction.receivedDataLength > 0) {
//            NSString *responseSize = [NSByteCountFormatter stringFromByteCount:transaction.receivedDataLength countStyle:NSByteCountFormatterCountStyleBinary];
//            [result appendFormat:@" %@",responseSize];
//        }
//
//        //响应时间
//        NSString *totalDuration = [JCS_NetworkUtility stringFromRequestDuration:transaction.duration];
//        NSString *latency = [JCS_NetworkUtility stringFromRequestDuration:transaction.latency];
//        NSString *duration = [NSString stringWithFormat:@"%@ (%@)", totalDuration, latency];
//
//        [result appendFormat:@" %@",duration];
        
        return [result copy];
    }
    
    // Unstarted, Awaiting Response, Receiving Data, etc.
    NSString *state = [JCS_NetworkTransaction readableStringFromTransactionState:transaction.transactionState];
    return state;
}

@end
