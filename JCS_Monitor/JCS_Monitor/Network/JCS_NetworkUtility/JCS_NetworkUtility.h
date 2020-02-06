//
//  JCS_NetworkUtility.h
//  JCS_Monitor
//
//  Created by 永平 on 2020/2/6.
//  Copyright © 2020 yongping. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JCS_NetworkUtility : NSObject

+ (SEL)swizzledSelectorForSelector:(SEL)selector;

+ (BOOL)instanceRespondsButDoesNotImplementSelector:(SEL)selector class:(Class)cls;

+ (void)replaceImplementationOfKnownSelector:(SEL)originalSelector onClass:(Class)class withBlock:(id)block swizzledSelector:(SEL)swizzledSelector;

+ (void)replaceImplementationOfSelector:(SEL)selector withSelector:(SEL)swizzledSelector forClass:(Class)cls withMethodDescription:(struct objc_method_description)methodDescription implementationBlock:(id)implementationBlock undefinedBlock:(id)undefinedBlock;

+ (UIImage *)thumbnailedImageWithMaxPixelDimension:(NSInteger)dimension fromImageData:(NSData *)data;

+ (UIFont *)defaultFontOfSize:(CGFloat)size;
+ (UIFont *)defaultTableViewCellLabelFont;

+ (NSString *)stringFromRequestDuration:(NSTimeInterval)duration;
+ (NSString *)statusCodeStringFromURLResponse:(NSURLResponse *)response;
+ (BOOL)isErrorStatusCodeFromURLResponse:(NSURLResponse *)response;

+ (NSArray<NSURLQueryItem *> *)itemsFromQueryString:(NSString *)query;
+ (BOOL)isValidJSONData:(NSData *)data;

+ (NSString *)prettyJSONStringFromData:(NSData *)data;

+ (NSData *)inflatedDataFromCompressedData:(NSData *)compressedData;

@end

NS_ASSUME_NONNULL_END
