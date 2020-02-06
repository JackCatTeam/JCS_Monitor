//
//  JCS_RequestInfo.h
//  JCS_Category
//
//  Created by 永平 on 2020/1/20.
//  Copyright © 2020 yongping. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCS_RequestInfo : NSObject

/** <#备注#> **/
@property (nonatomic, strong) NSURLRequest *request;
/** <#备注#> **/
@property (nonatomic, strong) NSHTTPURLResponse *response;

/** <#备注#> **/
@property (nonatomic, copy) NSString *host;
/** <#备注#> **/
@property (nonatomic, copy) NSString *scheme;

/** <#备注#> **/
@property (nonatomic, copy) NSString *method;

/** <#备注#> **/
@property (nonatomic, strong) NSDictionary *reqeustHeaders;
/** <#备注#> **/
@property (nonatomic, copy) NSString *requestContentType;
/** 请求发出时间 **/
@property (nonatomic, strong) NSDate *requestTime;


/** <#备注#> **/
@property (nonatomic, assign) NSInteger statusCode;

/** <#备注#> **/
@property (nonatomic, strong) NSDictionary *responseHeaders;
/** <#备注#> **/
@property (nonatomic, copy) NSString *responseContentType;

/** <#备注#> **/
@property (nonatomic, strong) NSData *data;

@end

NS_ASSUME_NONNULL_END
