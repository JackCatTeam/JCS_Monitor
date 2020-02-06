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

@interface JCS_NetMonitorDetailContentVC ()

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
//    .jcs_configDelegate(self)
    .jcs_configDidSelectRowBlock(^(NSIndexPath*indexPath,JCS_TableRowModel*model){
        
    })
    .jcs_associated(&_tableView);
    
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
        row.cellHeight = 40;
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
                @"title":[self.transaction.request.allHTTPHeaderFields valueForKey:@"content-type"],
                @"subTitle":[NSByteCountFormatter stringFromByteCount:self.transaction.cachedRequestBody.length countStyle:NSByteCountFormatterCountStyleBinary]
            };
            row.cellClass = @"JCS_NetMonitorDetailSingleArrowCell";
            row.cellHeight = 40;
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
        row.cellHeight = 40;
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
        row.cellHeight = 40;
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
        row.cellHeight = 40;
        [section.rows addObject:row];
        
        row = [JCS_TableRowModel jcs_create];
        row.data = @{
            @"title":self.transaction.response.MIMEType,
            @"subTitle":[NSByteCountFormatter stringFromByteCount:self.transaction.receivedDataLength countStyle:NSByteCountFormatterCountStyleBinary]
        };
        row.cellClass = @"JCS_NetMonitorDetailSingleArrowCell";
        row.cellHeight = 40;
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
        row.cellHeight = 40;
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

@end
