//
//  JCS_NetMonitor.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetMonitorVC.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <JCS_Create/JCS_Create.h>
#import "JCS_NetMonitorListCell.h"
#import "JCS_NetMonitorDetailVC.h"
#import "JCS_NetMonitorDetailContentVC.h"

@interface JCS_NetMonitorVC ()

/** <#备注#> **/
@property (nonatomic, strong) UITableView *tableView;
/** <#备注#> **/
@property (nonatomic, strong) NSMutableArray<JCS_TableSectionModel*> *sections;

@end

@implementation JCS_NetMonitorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.jcs_randomBackgroundColor();
    
    @weakify(self)
    
    //导航栏
    [JCS_MonitorNavBar jcs_create].jcs_layout(self.view, ^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(JCS_NAVIGATION_BAR_HEIGHT);
    })
    .jcs_whiteBackgroundColor()
    .jcs_associated(&_navbar);
    
    [self.navbar.backSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self backhandler];
    }];
    
    [RACObserve(self, title) subscribeNext:^(NSString *x) {
        @strongify(self)
        self.navbar.titleLabel.text = x;
    }];
    
    [UITableView jcs_createPlainTableView].jcs_layout(self.view, ^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }).jcs_toTableView()
    .jcs_dataSource(self)
    .jcs_delegate(self)
    .jcs_registerCellClass(@"JCS_NetMonitorListCell")
    .jcs_estimatedRowHeight(30)
    .jcs_separatorColorHex(0xD0D1D1)
    .jcs_configSections(self.sections)
    .jcs_configDidSelectRowBlock(^(NSIndexPath*indexPath,JCS_TableRowModel*model){
        @strongify(self)
        JCS_NetMonitorDetailContentVC *vc = [[JCS_NetMonitorDetailContentVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    })
    .jcs_associated(&_tableView);
    
}

- (NSMutableArray<JCS_TableSectionModel *> *)sections {
    if(!_sections){
        _sections = [NSMutableArray array];
        
        //链接
        JCS_TableSectionModel *section = [JCS_TableSectionModel jcs_create];
        [_sections addObject:section];
        for(int i=0;i<5;i++){
            JCS_TableRowModel *row = [JCS_TableRowModel jcs_create];
            row.data = @{
        @"link":@"/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList/banner/getList.action",
            @"method":@"POST",
        @"contentType":@"json",
        @"status":@200,
        @"agent":@"BlackCard",
        @"host":@"api.jiakeniu.com",
        @"time":@"2019-01-01 12:12:22"
            };
            row.cellClass = @"JCS_NetMonitorListCell";
            row.cellHeight = 40;
            row.clickRouter = @"jcs://MonitorRouter/showRequestDetail:?requestId=1111";
            [section.rows addObject:row];
        }
        
    }
    return _sections;
}

@end
