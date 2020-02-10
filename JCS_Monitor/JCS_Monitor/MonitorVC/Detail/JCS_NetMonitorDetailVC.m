//
//  JCS_NetMonitorDetailVC.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetMonitorDetailVC.h"
#import <JCS_Kit/JCS_Kit.h>
#import "JCS_NetMonitorDetailContentVC.h"
#import "JCS_NetworkTransaction.h"

@interface JCS_NetMonitorDetailVC ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) JCS_NetMonitorDetailContentVC *requestVC;
@property (nonatomic, strong) JCS_NetMonitorDetailContentVC *responseVC;

@property (nonatomic, strong) JCS_NetworkTransaction *transaction;

@end

@implementation JCS_NetMonitorDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    self.view.jcs_whiteBackgroundColor();
        
    [UISegmentedControl createWithItems:@[@"Request",@"Response"]].jcs_layout(self.view, ^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(JCS_NAVIGATION_BAR_HEIGHT + 20);
    }).jcs_toSegmentedControl()
    .jcs_selectedSegmentIndex(0)
    .jcs_associated(&_segmentedControl);
    
    //Request VC
    self.requestVC = [[JCS_NetMonitorDetailContentVC alloc] init];
    [self addChildViewController:self.requestVC];
    self.requestVC.view.jcs_layout(self.view, ^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.segmentedControl.mas_bottom).mas_offset(8);
        make.bottom.mas_equalTo(-JCS_HOME_INDICATOR_HEIGHT);
    });
    
    //Response VC
    self.responseVC = [[JCS_NetMonitorDetailContentVC alloc] init];
    self.responseVC.isResponse = YES;
    [self addChildViewController:self.responseVC];
    self.responseVC.view.jcs_layout(self.view, ^(MASConstraintMaker *make) {
        make.edges.equalTo(self.requestVC.view);
    }).jcs_hidden(YES);
    
    @weakify(self)
    [RACObserve(self.segmentedControl, selectedSegmentIndex) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSInteger index = [x integerValue];
        if(index == 0){
            self.requestVC.view.hidden = NO;
            self.responseVC.view.hidden = YES;
        } else {
            self.requestVC.view.hidden = YES;
            self.responseVC.view.hidden = NO;
        }
    }];
    
    RAC(self.requestVC,transaction) = RACObserve(self, transaction);
    RAC(self.responseVC,transaction) = RACObserve(self, transaction);
}

- (JCS_NetworkTransaction *)transaction {
    return [self.jcs_params valueForKey:JCS_ROUTER_DATA];
}

@end
