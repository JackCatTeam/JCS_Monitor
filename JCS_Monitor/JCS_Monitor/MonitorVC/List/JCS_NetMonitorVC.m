//
//  JCS_NetMonitor.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetMonitorVC.h"
#import <JCS_Kit/JCS_Kit.h>
#import "JCS_NetMonitorListCell.h"
#import "JCS_NetMonitorDetailVC.h"
#import "JCS_NetMonitorDetailContentVC.h"

//#import "JCS_RequestStore.h"
#import "JCS_NetworkTransaction.h"
#import "JCS_NetworkRecorder.h"
#import "JCS_NetworkObserver.h"

@interface JCS_NetMonitorVC ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<JCS_TableSectionModel*> *sections;

@property (nonatomic, copy) NSArray<JCS_NetworkTransaction *> *networkTransactions;
@property (nonatomic, copy) NSArray<JCS_NetworkTransaction *> *filteredNetworkTransactions;

@end

@implementation JCS_NetMonitorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self registerNotification];
}

- (void)setupUI {
    self.view.jcs_randomBackgroundColor();
    
    self.title = @"📡  Network";
    
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
    .jcs_registerCellClass(@"JCS_NetMonitorListCell")
    .jcs_estimatedRowHeight(30)
    .jcs_separatorColorHex(0xD0D1D1)
    .jcs_tableFooterView([UIView jcs_create])
    .jcs_configSections([JCS_NetworkRecorder defaultRecorder].sections)
    .jcs_configDidSelectRowBlock(^(NSIndexPath*indexPath,JCS_TableRowModel*model){
        @strongify(self)
        JCS_NetMonitorDetailContentVC *vc = [[JCS_NetMonitorDetailContentVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    })
    .jcs_associated(&_tableView);
    
}

- (void)registerNotification {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleNewTransactionRecordedNotification:) name:kJCS_NetworkRecorderNewTransactionNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleTransactionUpdatedNotification:) name:kJCS_NetworkRecorderTransactionUpdatedNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleTransactionsClearedNotification:) name:kJCS_NetworkRecorderTransactionsClearedNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleNetworkObserverEnabledStateChangedNotification:) name:kJCS_NetworkObserverEnabledStateChangedNotification object:nil];
}

- (void)backhandler {
    
}

#pragma mark - Notification Handlers

- (void)handleNewTransactionRecordedNotification:(NSNotification *)notification {
    [self tryUpdateTransactions];
}

- (void)tryUpdateTransactions {
    [self.tableView reloadData];
    // Let the previous row insert animation finish before starting a new one to avoid stomping.
    // We'll try calling the method again when the insertion completes, and we properly no-op if there haven't been changes.
//    if (self.rowInsertInProgress) {
//        return;
//    }
//
//    if (self.searchController.isActive) {
//        [self updateTransactions];
//        [self updateSearchResults:nil];
//        return;
//    }
//
//    NSInteger existingRowCount = self.networkTransactions.count;
//    [self updateTransactions];
//    NSInteger newRowCount = self.networkTransactions.count;
//    NSInteger addedRowCount = newRowCount - existingRowCount;
//
//    if (addedRowCount != 0 && !self.isPresentingSearch) {
//        // Insert animation if we're at the top.
//        if (self.tableView.contentOffset.y <= 0.0 && addedRowCount > 0) {
//            [CATransaction begin];
//
//            self.rowInsertInProgress = YES;
//            [CATransaction setCompletionBlock:^{
//                self.rowInsertInProgress = NO;
//                [self tryUpdateTransactions];
//            }];
//
//            NSMutableArray<NSIndexPath *> *indexPathsToReload = [NSMutableArray array];
//            for (NSInteger row = 0; row < addedRowCount; row++) {
//                [indexPathsToReload addObject:[NSIndexPath indexPathForRow:row inSection:0]];
//            }
//            [self.tableView insertRowsAtIndexPaths:indexPathsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
//
//            [CATransaction commit];
//        } else {
//            // Maintain the user's position if they've scrolled down.
//            CGSize existingContentSize = self.tableView.contentSize;
//            [self.tableView reloadData];
//            CGFloat contentHeightChange = self.tableView.contentSize.height - existingContentSize.height;
//            self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + contentHeightChange);
//        }
//    }
}

- (void)handleTransactionUpdatedNotification:(NSNotification *)notification {
    [self.tableView reloadData];
//    [self updateBytesReceived];
//    [self updateFilteredBytesReceived];
//
//    JCS_NetworkTransaction *transaction = notification.userInfo[kJCS_NetworkRecorderUserInfoTransactionKey];
//
//    // Update both the main table view and search table view if needed.
//    for (FLEXNetworkTransactionTableViewCell *cell in [self.tableView visibleCells]) {
//        if ([cell.transaction isEqual:transaction]) {
//            // Using -[UITableView reloadRowsAtIndexPaths:withRowAnimation:] is overkill here and kicks off a lot of
//            // work that can make the table view somewhat unresponsive when lots of updates are streaming in.
//            // We just need to tell the cell that it needs to re-layout.
//            [cell setNeedsLayout];
//            break;
//        }
//    }
//    [self updateFirstSectionHeader];
}

- (void)handleTransactionsClearedNotification:(NSNotification *)notification {
//    [self updateTransactions];
    [self.tableView reloadData];
}

- (void)handleNetworkObserverEnabledStateChangedNotification:(NSNotification *)notification {
    [self.tableView reloadData];
    // Update the header, which displays a warning when network debugging is disabled
//    [self updateFirstSectionHeader];
}

#pragma mark - 懒加载

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
