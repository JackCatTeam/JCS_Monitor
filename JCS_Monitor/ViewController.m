//
//  ViewController.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "ViewController.h"
#import "JCS_NetMonitorVC.h"
#import "JCS_URLProtocol.h"
//#import <FLEX/FLEX.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [JCS_URLProtocol startMonitor];
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

- (IBAction)post_json_json:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"/flyfish-pre/banner/getList.action" relativeToURL:[NSURL URLWithString:@"https://api.jiakeniu.com/"]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
      cachePolicy:NSURLRequestUseProtocolCachePolicy
      timeoutInterval:10.0];
    NSDictionary *headers = @{
      @"Content-Type": @"application/json"
    };
        [request setHTTPMethod:@"POST"];

    [request setAllHTTPHeaderFields:headers];
    NSData *postData = [[NSData alloc] initWithData:[@"{\n    \"type\":1\n}" dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postData];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (error) {
        NSLog(@"%@", error);
      } else {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        NSLog(@"%@",responseDictionary);
      }
    }];
    [dataTask resume];
}

- (IBAction)showFlex:(id)sender {
//    [[FLEXManager sharedManager] showExplorer];
}

@end
