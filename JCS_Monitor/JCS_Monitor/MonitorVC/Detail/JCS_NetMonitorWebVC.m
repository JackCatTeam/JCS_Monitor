//
//  JCS_NetMonitorWebVC.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/2/6.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_NetMonitorWebVC.h"
#import <WebKit/WebKit.h>
#import <JCS_Kit/JCS_Kit.h>
#import "JCS_NetworkUtility.h"

@interface JCS_NetMonitorWebVC ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *content;

@end

@implementation JCS_NetMonitorWebVC

+ (instancetype)monitorWebVC:(NSString*)content {
    JCS_NetMonitorWebVC *instance = [[JCS_NetMonitorWebVC alloc] init];
    instance.content = content;
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WKWebView jcs_create].jcs_layout(self.view, ^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    })
    .jcs_associated(&_webView);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *htmlString = [NSString stringWithFormat:@"<head><meta name='viewport' content='initial-scale=1.0'></head><body><pre>%@</pre></body>", [JCS_NetworkUtility stringByEscapingHTMLEntitiesInString:self.content]];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}


@end
