//
//  JCS_RequestStore.h
//  JCS_Monitor
//
//  Created by 永平 on 2020/1/29.
//  Copyright © 2020 yongping. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JCS_RequestInfo;
@class JCS_TableRowModel;
@class JCS_TableSectionModel;

NS_ASSUME_NONNULL_BEGIN

@interface JCS_RequestStore : NSObject

/** 需要显示的记录 **/
@property (nonatomic, strong, readonly) NSArray<JCS_TableSectionModel*> *displayRequests;

+ (instancetype)sharedInstance;

- (void)addNewRequest:(JCS_RequestInfo*)requestInfo;

@end

NS_ASSUME_NONNULL_END
