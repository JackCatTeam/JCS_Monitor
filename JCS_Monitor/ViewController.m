//
//  ViewController.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "ViewController.h"
#import "JCS_NetMonitorVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showVC:(id)sender {
    JCS_NetMonitorVC *vc = [[JCS_NetMonitorVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
//    #if __has_include(<YLT_BaseLib/YLT_BaseLib.h>)
//        NSLog(@"包含 YLT_BaseLib");
//    #else
//        NSLog(@"不包含 YLT_BaseLib");
//    #endif
}


@end
