//
//  JCS_NetMonitorDetailContentVC.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetMonitorDetailContentVC.h"
#import <JCS_Create/JCS_Create.h>
#import <ReactiveObjC/ReactiveObjC.h>

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
//    .jcs_dataSource(self)
//    .jcs_delegate(self)
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
    .jcs_configDidSelectRowBlock(^(NSIndexPath*indexPath,JCS_TableRowModel*model){
        JCS_LogInfo(@"");
    })
    .jcs_associated(&_tableView);
    
}

- (void)addRow{
    JCS_TableRowModel *row = [JCS_TableRowModel jcs_create];
    row.data = @{@"title":[NSDate jcs_todayLongTimeString]};
    row.cellClass = @"JCS_NetMonitorDetailRowsPlainTextCell";
    row.cellHeight = 40;
    [self.sections.lastObject.rows addObject:row];
    [self.tableView reloadData];
    [self aaaa:@"张三"];
}

- (void)aaaa:(NSString*)value {
    JCS_LogInfo(@"---aaaa");
}

- (void)jcs_tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath didSelectModel:(JCS_TableRowModel *)didSelectModel {
    JCS_LogInfo(@"");
}

#pragma mark - 私有方法

- (void)configRequestData {
    [self.sections removeAllObjects];

    //链接
    JCS_TableSectionModel *section = [JCS_TableSectionModel jcs_create];
    section.headerClass = @"JCS_NetMonitorDetailHeaderView";
    section.headerHeight = 40;
    section.data = @{@"title":@"链接"};
    [_sections addObject:section];
    
    JCS_TableRowModel *row = [JCS_TableRowModel jcs_create];
    row.data = @{@"title":@"/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList.action"};
    row.cellClass = @"JCS_NetMonitorDetailRowsPlainTextCell";
    row.cellHeight = 40;
    [section.rows addObject:row];
    
    //方法
    section = [JCS_TableSectionModel jcs_create];
    section.headerClass = @"JCS_NetMonitorDetailHeaderView";
    section.headerHeight = 40;
    section.data = @{@"title":@"方法"};
    [_sections addObject:section];
    
    row = [JCS_TableRowModel jcs_create];
    row.data = @{@"title":@"POST"};
    row.cellClass = @"JCS_NetMonitorDetailSinglePlainTextCell";
    row.cellHeight = 40;
    [section.rows addObject:row];
    
    //请求体
    section = [JCS_TableSectionModel jcs_create];
    section.headerClass = @"JCS_NetMonitorDetailHeaderView";
    section.headerHeight = 40;
    section.data = @{@"title":@"请求体"};
    [_sections addObject:section];
    
    row = [JCS_TableRowModel jcs_create];
    row.data = @{@"title":@"application/json"};
    row.cellClass = @"JCS_NetMonitorDetailSingleArrowCell";
    row.cellHeight = 40;
    [section.rows addObject:row];
    
    //请求头
    section = [JCS_TableSectionModel jcs_create];
    section.headerClass = @"JCS_NetMonitorDetailHeaderView";
    section.headerHeight = 40;
    section.data = @{@"title":@"请求头"};
    [_sections addObject:section];
    
    row = [JCS_TableRowModel jcs_create];
    row.data = @{@"title":@"application/json"};
    row.cellClass = @"JCS_NetMonitorDetailRowsPlainTextCell";
    row.cellHeight = 40;
    [section.rows addObject:row];
    
    [self.tableView reloadData];
}
- (void)configResponseData {
    [self.sections removeAllObjects];

    JCS_TableSectionModel *section = nil;
    JCS_TableRowModel *row = nil;
    
    //响应体
    section = [JCS_TableSectionModel jcs_create];
    section.headerClass = @"JCS_NetMonitorDetailHeaderView";
    section.headerHeight = 40;
    section.data = @{@"title":@"响应体"};
    [_sections addObject:section];
    
    row = [JCS_TableRowModel jcs_create];
    row.data = @{@"title":@"application/json"};
    row.cellClass = @"JCS_NetMonitorDetailSingleArrowCell";
    row.cellHeight = 40;
    [section.rows addObject:row];
    
    //响应头
    section = [JCS_TableSectionModel jcs_create];
    section.headerClass = @"JCS_NetMonitorDetailHeaderView";
    section.headerHeight = 40;
    section.data = @{@"title":@"响应头"};
    [_sections addObject:section];
    
    row = [JCS_TableRowModel jcs_create];
    row.data = @{@"title":@"application/json"};
    row.cellClass = @"JCS_NetMonitorDetailRowsPlainTextCell";
    row.cellHeight = 40;
    [section.rows addObject:row];
    
    [self.tableView reloadData];
}

@end
