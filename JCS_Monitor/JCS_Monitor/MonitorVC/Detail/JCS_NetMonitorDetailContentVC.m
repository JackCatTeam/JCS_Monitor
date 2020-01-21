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

/** <#备注#> **/
@property (nonatomic, strong) UITableView *tableView;
/** <#备注#> **/
@property (nonatomic, strong) NSMutableArray<JCS_TableSectionModel*> *sections;

@end

@implementation JCS_NetMonitorDetailContentVC

- (void)dealloc
{
    NSLog(@"---JCS_NetMonitorDetailContentVC--dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    self.view.jcs_whiteBackgroundColor();
    [UITableView jcs_createGroupTableView].jcs_layout(self.view, ^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-100);
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
        NSLog(@"");
    })
    .jcs_associated(&_tableView);
    
//    @weakify(self)
//    [UIButton jcs_create].jcs_layout(self.view, ^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(16);
//        make.right.mas_equalTo(-16);
//        make.bottom.mas_equalTo(-16);
//        make.height.mas_equalTo(44);
//    }).jcs_toButton()
//    .jcs_normalTitle(@"Add Row")
////    .jcs_normalTitleColorHex(0x000000)
//    .jcs_tapBlock(^{
//        @strongify(self)
//        JCS_TableRowModel *row = [JCS_TableRowModel jcs_create];
//        row.data = @{@"title":[NSDate jcs_todayLongTimeString]};
//        row.cellClass = @"JCS_NetMonitorDetailRowsPlainTextCell";
//        row.cellHeight = 40;
//        [self.sections.lastObject.rows addObject:row];
//        [self.tableView reloadData];
//    });
}

- (void)jcs_tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath didSelectModel:(JCS_TableRowModel *)didSelectModel {
    NSLog(@"");
}

#pragma mark - 懒加载

- (NSMutableArray<JCS_TableSectionModel *> *)sections {
    if(!_sections){
        _sections = [NSMutableArray array];
        
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
        
    }
    return _sections;
}

@end
