//
//  JCS_NetMonitor.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetMonitorVC.h"
#import <JCS_Create/JCS_Create.h>
#import "JCS_NetMonitorListCell.h"
#import "JCS_NetMonitorDetailVC.h"
#import "JCS_NetMonitorDetailContentVC.h"

@interface JCS_NetMonitorVC ()<UITableViewDelegate,UITableViewDataSource>

/** <#备注#> **/
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JCS_NetMonitorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.jcs_randomBackgroundColor();
    
    [UITableView jcs_create].jcs_layout(self.view, ^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }).jcs_toTableView()
    .jcs_dataSource(self)
    .jcs_delegate(self)
    .jcs_registerCellClass(@"JCS_NetMonitorListCell")
    .jcs_estimatedRowHeight(30)
    .jcs_separatorColorHex(0xD0D1D1)
    .jcs_associated(&_tableView);
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JCS_NetMonitorListCell *cell = [JCS_NetMonitorListCell getCell:tableView indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JCS_NetMonitorDetailContentVC *vc = [[JCS_NetMonitorDetailContentVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
