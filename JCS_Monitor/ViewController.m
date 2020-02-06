//
//  ViewController.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/21.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "ViewController.h"
#import "JCS_NetMonitorVC.h"
#import <SDWebImage/SDWebImage.h>
#import <FLEX/FLEX.h>
#import "JCS_NetworkObserver.h"
#import "JCS_NetworkRecorder.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [JCS_URLProtocol startMonitor];
    
    //开启监控
    [JCS_NetworkObserver setEnabled:YES];
    //清空记录
//    [[JCS_NetworkRecorder defaultRecorder] clearRecordedActivity];
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
    
    NSURL *url = [NSURL URLWithString:@"/flyfish-pre/banner/getList.action?title=lal" relativeToURL:[NSURL URLWithString:@"https://api.jiakeniu.com/"]];

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

- (IBAction)post_form_json:(id)sender {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.jiakeniu.com/flyfish-pre/banner/getList-form.action"]
      cachePolicy:NSURLRequestUseProtocolCachePolicy
      timeoutInterval:10.0];
    NSDictionary *headers = @{
      @"Content-Type": @"application/x-www-form-urlencoded"
    };

    [request setAllHTTPHeaderFields:headers];
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[@"type=1" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"&key2=张三" dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postData];

    [request setHTTPMethod:@"POST"];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (error) {
        NSLog(@"%@", error);
      } else {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        NSLog(@"%@",responseDictionary);
      }
    }];
    [dataTask resume];
    
}

- (IBAction)get_json:(id)sender {
    NSURL *url = [NSURL URLWithString:@"/flyfish-pre/banner/getList-get.action?type=1" relativeToURL:[NSURL URLWithString:@"https://api.jiakeniu.com/"]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
      cachePolicy:NSURLRequestUseProtocolCachePolicy
      timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (error) {
        NSLog(@"%@", error);
      } else {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        NSLog(@"%@",responseDictionary);
      }
    }];
    [dataTask resume];
}

- (IBAction)showH5:(id)sender {
//    NSString *url = @"https://www.jiakeniu.com/service-agreement.html";
    NSString *url = @"https://www.baidu.com";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//       [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
}

- (IBAction)showFlex:(id)sender {
    [[FLEXManager sharedManager] showExplorer];
}

- (IBAction)showImage:(id)sender {
//    NSString *url = @"https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif?imageView2/1/w/80/h/80";
    NSString *url = @"https://www.baidu.com/img/bd_logo1.png";
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
}

@end
