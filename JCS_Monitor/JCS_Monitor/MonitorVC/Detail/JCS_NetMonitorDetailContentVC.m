//
//  JCS_NetMonitorDetailContentVC.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetMonitorDetailContentVC.h"
#import <JCS_Kit/JCS_Kit.h>

#import "JCS_NetworkTransaction.h"
#import "JCS_NetworkUtility.h"
#import "JCS_NetMonitorWebVC.h"
#import "JCS_NetworkRecorder.h"

#define kRequestBodyKey @"requestBody"
#define kResponseBodyKey @"responseBody"

@interface JCS_NetMonitorDetailContentVC ()<JCS_UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<JCS_TableSectionModel*> *sections;

@end

@implementation JCS_NetMonitorDetailContentVC

- (void)dealloc {
    JCS_LogInfo(@"---JCS_NetMonitorDetailContentVC--dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    self.sections = [NSMutableArray array];
    
    self.view.jcs_whiteBackgroundColor();
    [UITableView jcs_createGroupTableView].jcs_layout(self.view, ^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }).jcs_toTableView()
    .jcs_registerCellClasses(@[
        @"JCS_NetMonitorDetailSinglePlainTextCell",
        @"JCS_NetMonitorDetailRowsPlainTextCell",
        @"JCS_NetMonitorDetailHeaderFieldCell",
        @"JCS_NetMonitorDetailSingleArrowCell",
    ])
    .jcs_registerSectionHeaderFooterClass(@"JCS_NetMonitorDetailHeaderView")
    .jcs_estimatedRowHeight(30)
    .jcs_separatorNone()
    .jcs_configSections(self.sections)
    .jcs_configDelegate(self)
    .jcs_associated(&_tableView);
    
}

#pragma mark - JCS_UITableViewDelegate

- (void)jcs_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath didSelectModel:(JCS_TableRowModel *)didSelectModel {
    NSString *type = [didSelectModel.data valueForKey:@"type"];
    if(type.jcs_isValid) {
        
        if([kRequestBodyKey isEqualToString:type]){
            
        } else if([kResponseBodyKey isEqualToString:type]){
            [self showResponseBody];
        }
    }
}

#pragma mark - getter && setter

- (void)setTransaction:(JCS_NetworkTransaction *)transaction {
    _transaction = transaction;
    if(self.isResponse){
        [self configResponseData];
    } else {
        [self configRequestData];
    }
}

#pragma mark - 私有方法

- (void)configRequestData {
    [self.sections removeAllObjects];

    JCS_TableSectionModel *section = nil;
    JCS_TableRowModel *row = nil;
    
    //链接
    {
        section = [JCS_TableSectionModel jcs_create];
        section.headerClass = @"JCS_NetMonitorDetailHeaderView";
        section.headerHeight = 40;
        section.data = @{@"title":@"相对链接"};
        [_sections addObject:section];
        
        row = [JCS_TableRowModel jcs_create];
        row.data = @{
            @"title":[NSString stringWithFormat:@"%@ %@",self.transaction.request.HTTPMethod,self.transaction.relativeUrlString]
        };
        row.cellClass = @"JCS_NetMonitorDetailRowsPlainTextCell";
        [section.rows addObject:row];
    }
    
    //请求体
    {
        if([self.transaction.request.HTTPMethod isEqualToString:@"POST"]){
            section = [JCS_TableSectionModel jcs_create];
            section.headerClass = @"JCS_NetMonitorDetailHeaderView";
            section.headerHeight = 40;
            section.data = @{@"title":@"请求体"};
            [_sections addObject:section];
    
            row = [JCS_TableRowModel jcs_create];
            row.data = @{
                @"type":kRequestBodyKey,
                @"title":[self.transaction.request.allHTTPHeaderFields valueForKey:@"content-type"],
                @"subTitle":[NSByteCountFormatter stringFromByteCount:self.transaction.cachedRequestBody.length countStyle:NSByteCountFormatterCountStyleBinary]
            };
            row.cellClass = @"JCS_NetMonitorDetailSingleArrowCell";
            [section.rows addObject:row];
        }
    }
    
    //请求头
    {
        section = [JCS_TableSectionModel jcs_create];
        section.headerClass = @"JCS_NetMonitorDetailHeaderView";
        section.headerHeight = 40;
        section.data = @{@"title":@"请求头"};
        [_sections addObject:section];
        
        row = [JCS_TableRowModel jcs_create];
        row.data = @{@"title":[self headerFieldsString:self.transaction.request.allHTTPHeaderFields]};
        row.cellClass = @"JCS_NetMonitorDetailRowsPlainTextCell";
        [section.rows addObject:row];
    }
    
    //全链接
    {
        section = [JCS_TableSectionModel jcs_create];
        section.headerClass = @"JCS_NetMonitorDetailHeaderView";
        section.headerHeight = 40;
        section.data = @{@"title":@"全链接"};
        [_sections addObject:section];
        
        row = [JCS_TableRowModel jcs_create];
        row.data = @{
            @"title":self.transaction.request.URL.absoluteString
        };
        row.cellClass = @"JCS_NetMonitorDetailRowsPlainTextCell";
        [section.rows addObject:row];
    }
    
    [self.tableView reloadData];
}
- (void)configResponseData {
    [self.sections removeAllObjects];

    JCS_TableSectionModel *section = nil;
    JCS_TableRowModel *row = nil;
    
    //响应体
    {
        section = [JCS_TableSectionModel jcs_create];
        section.headerClass = @"JCS_NetMonitorDetailHeaderView";
        section.headerHeight = 40;
        section.data = @{@"title":@"响应体"};
        [_sections addObject:section];
        
        row = [JCS_TableRowModel jcs_create];
        row.data = @{
            @"title":@"耗时",
            @"subTitle":[JCS_NetworkUtility stringFromRequestDuration:self.transaction.duration]
        };
        row.cellClass = @"JCS_NetMonitorDetailSinglePlainTextCell";
        [section.rows addObject:row];
        
        row = [JCS_TableRowModel jcs_create];
        row.data = @{
            @"type":kResponseBodyKey,
            @"title":self.transaction.response.MIMEType,
            @"subTitle":[NSByteCountFormatter stringFromByteCount:self.transaction.receivedDataLength countStyle:NSByteCountFormatterCountStyleBinary]
        };
        row.cellClass = @"JCS_NetMonitorDetailSingleArrowCell";
        [section.rows addObject:row];
    }
    
    //响应头
    {
        section = [JCS_TableSectionModel jcs_create];
        section.headerClass = @"JCS_NetMonitorDetailHeaderView";
        section.headerHeight = 40;
        section.data = @{@"title":@"响应头"};
        [_sections addObject:section];
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)self.transaction.response;
        
        row = [JCS_TableRowModel jcs_create];
        row.data = @{@"title":[self headerFieldsString:response.allHeaderFields]};
        row.cellClass = @"JCS_NetMonitorDetailRowsPlainTextCell";
        [section.rows addObject:row];
    }
    
    [self.tableView reloadData];
}

//将header解析为NSAttributeString
- (NSString*)headerFieldsString:(NSDictionary*)headers {
    NSMutableString *fieldsString = [NSMutableString string];
    for (NSString *key in headers.allKeys) {
        [fieldsString appendFormat:@"%@: %@\n",key,headers[key]];
    }
    if([fieldsString hasSuffix:@"\n"]){ //去掉最后\n
        return [fieldsString stringByTrimmingCharactersInSet:NSMutableCharacterSet.whitespaceAndNewlineCharacterSet];
    }
    if(!fieldsString.jcs_isValid){
        [fieldsString appendFormat:@"无"];
    }
    return [fieldsString copy];
}

- (void)showResponseBody {

      NSData *responseData = [[JCS_NetworkRecorder defaultRecorder] cachedResponseBodyForTransaction:self.transaction];
        if (responseData.length > 0) {
            if ([JCS_NetworkUtility isValidJSONData:responseData]) {
                JCS_NetMonitorWebVC *vc = [[JCS_NetMonitorWebVC alloc] init];
                NSString *prettyJSON = [JCS_NetworkUtility prettyJSONStringFromData:responseData];
                if (prettyJSON.length > 0) {
                    vc.content = prettyJSON;
                }
                [self.jcs_currentVC.navigationController pushViewController:vc animated:YES];
                
//                } else if ([mimeType hasPrefix:@"image/"]) {
//                    UIImage *image = [UIImage imageWithData:data];
//                    detailViewController = [[FLEXImagePreviewViewController alloc] initWithImage:image];
//                } else if ([mimeType isEqual:@"application/x-plist"]) {
//                    id propertyList = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:NULL];
//                    detailViewController = [[FLEXWebViewController alloc] initWithText:[propertyList description]];
//                }
            }
        }
}

- (NSString*)getRequestPostBody {
    NSString *bodyString = @"";
    if (self.transaction.cachedRequestBody.length > 0) {
        NSString *contentType = [self.transaction.request valueForHTTPHeaderField:@"Content-Type"];
        if ([contentType hasPrefix:@"application/x-www-form-urlencoded"]) {
            bodyString = [NSString stringWithCString:[self postBodyDataForTransaction].bytes encoding:NSUTF8StringEncoding];
        }
    }
    return bodyString;
}

- (NSData *)postBodyDataForTransaction {
    NSData *bodyData = self.transaction.cachedRequestBody;
    if (bodyData.length > 0) {
        NSString *contentEncoding = [self.transaction.request valueForHTTPHeaderField:@"Content-Encoding"];
        if ([contentEncoding rangeOfString:@"deflate" options:NSCaseInsensitiveSearch].length > 0 || [contentEncoding rangeOfString:@"gzip" options:NSCaseInsensitiveSearch].length > 0) {
            bodyData = [JCS_NetworkUtility inflatedDataFromCompressedData:bodyData];
        }
    }
    return bodyData;
}

@end
