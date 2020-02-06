//
//  JCS_URLProtocol.m
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/29.
//  Copyright © 2020 yongping. All rights reserved.
//

#import "JCS_URLProtocol.h"

#import "JCS_SessionConfiguration.h"
#import "JCS_RequestInfo.h"
#import "JCSNetMonitorMacros.h"

#import "JCS_RequestStore.h"

//soutu.css

static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";

@interface JCS_URLProtocol ()<NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation JCS_URLProtocol

// 开始监听
+ (void)startMonitor {
    JCS_SessionConfiguration *sessionConfiguration = [JCS_SessionConfiguration defaultConfiguration];
    [NSURLProtocol registerClass:[JCS_URLProtocol class]];
    if (![sessionConfiguration isExchanged]) {
        [sessionConfiguration load];
    }
}
// 停止监听
+ (void)stopMonitor {
    JCS_SessionConfiguration *sessionConfiguration = [JCS_SessionConfiguration defaultConfiguration];
    [NSURLProtocol unregisterClass:[JCS_URLProtocol class]];
    if ([sessionConfiguration isExchanged]) {
        [sessionConfiguration unload];
    }
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    //看看是否已经处理过了，防止无限循环 根据业务来截取
    if ([NSURLProtocol propertyForKey: URLProtocolHandledKey inRequest:request]) {
        NSLog(@"----canInitWithRequest -- NO %@",request);
        return NO;
    }
    
    NSString * scheme = [[request.URL scheme] lowercaseString];
    if ([scheme isEqual:@"http"] || [scheme isEqual:@"https"]) {
        NSLog(@"----canInitWithRequest -- YES %@",request);
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id <NSURLProtocolClient>)client {
    return [super initWithRequest:request cachedResponse:cachedResponse client:client];
}

//开始请求
- (void)startLoading{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //标示该request已经处理过了，防止无限循环
    [NSURLProtocol setProperty:@(YES) forKey:URLProtocolHandledKey inRequest:mutableReqeust];
    
    NSLog(@"----canInitWithRequest -- startLoading %@",mutableReqeust);
    //这个enableDebug随便根据自己的需求了，可以直接拦截到数据返回本地的模拟数据，进行测试
//    BOOL enableDebug = NO;
//    if (enableDebug) {
//
//        NSString *str = @"测试数据";
//        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableReqeust.URL
//                                                            MIMEType:@"text/plain"
//                                               expectedContentLength:data.length
//                                                    textEncodingName:nil];
//        [self.client URLProtocol:self
//              didReceiveResponse:response
//              cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//        [self.client URLProtocol:self didLoadData:data];
//        [self.client URLProtocolDidFinishLoading:self];
//    }
//    else {
        //使用NSURLSession继续把request发送出去
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:mainQueue];
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:mutableReqeust];
        [task resume];
//    }
    
    
}

//结束请求
- (void)stopLoading {
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    [self.client URLProtocol:self didLoadData:data];
    
    JCS_RequestInfo *requestInfo = [[JCS_RequestInfo alloc] init];
    
    NSLog(@"----canInitWithRequest -- didReceiveData.originalRequest %@",dataTask.originalRequest);
    NSLog(@"----canInitWithRequest -- didReceiveData.currentRequest  %@",dataTask.currentRequest);
    
    //添加记录
    [[JCS_RequestStore sharedInstance] addNewRequest:requestInfo];
    
    requestInfo.request = dataTask.originalRequest;
    requestInfo.host = requestInfo.request.URL.host;
    requestInfo.scheme = requestInfo.request.URL.scheme;
    //请求类型
    requestInfo.method = requestInfo.request.HTTPMethod;
    //请求头
    requestInfo.reqeustHeaders = requestInfo.request.allHTTPHeaderFields;
    //请求Content-Type
    requestInfo.requestContentType = [requestInfo.request.allHTTPHeaderFields valueForKey:@"Content-Type"];
    
    
    requestInfo.response = (NSHTTPURLResponse*)dataTask.response;
   //状态码
   requestInfo.statusCode = requestInfo.response.statusCode;
   //响应头
   requestInfo.responseHeaders = requestInfo.response.allHeaderFields;
   //响应Content-Type
   requestInfo.responseContentType = [requestInfo.response.allHeaderFields valueForKey:@"Content-Type"];
    
    requestInfo.data = data;
    
    [self getReponseData:requestInfo];
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    if (error) {
        //错误信息
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (NSString*)bodyFromRequest:(NSURLRequest*)request {
    if ([request.HTTPMethod isEqualToString:@"POST"]) {
        
        NSData *bodyData = nil;

        if (!request.HTTPBody) {
            
            NSInputStream *bodyStream = request.HTTPBodyStream;
            const NSUInteger bufferSize = 1024;
            uint8_t buffer[bufferSize];
            NSMutableData *data = [NSMutableData data];
            [bodyStream open];
            NSInteger readBytes = 0;
            do {
                readBytes = [bodyStream read:buffer maxLength:bufferSize];
                [data appendBytes:buffer length:readBytes];
            } while (readBytes > 0);
            [bodyStream close];
            bodyData = data;
        } else {
            bodyData = request.HTTPBody;
        }
        if(bodyData){
            return [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
        }
        return nil;
    }
    return nil;
}

- (void)getReponseData:(JCS_RequestInfo*)requestInfo {
    if([requestInfo.method.uppercaseString isEqualToString:kPOST]){
        //application/json;charset=UTF-8
        if([requestInfo.responseContentType containsString:CONTENT_TYPE_JSON]){
            //请求body
            NSString *requestParams = [self bodyFromRequest:requestInfo.request];
            //响应数据
            NSString *dataStr = [[NSString alloc] initWithData:requestInfo.data encoding:NSUTF8StringEncoding];
            NSLog(@"");
        }
        NSLog(@"");
    } else if([requestInfo.method.uppercaseString isEqualToString:kGET]){
        NSLog(@"");
    }
}


@end
