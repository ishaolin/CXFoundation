//
//  CXNumberFormatter.h
//  Pods
//
//  Created by wshaolin on 2019/7/22.
//

#import <Foundation/Foundation.h>
#import "CXFoundationDefines.h"

@interface CXNumberFormatter : NSObject

/// 使用自动格式：CXNumberFormatDynamicMaxTwo
+ (NSString *)stringFromFloat:(float)floatValue;
+ (NSString *)stringFromDouble:(double)doubleValue;
+ (NSString *)stringFromNumber:(NSNumber *)number;

+ (NSString *)stringFromFloat:(float)floatValue format:(NSString *)format;
+ (NSString *)stringFromDouble:(double)doubleValue format:(NSString *)format;
+ (NSString *)stringFromNumber:(NSNumber *)number format:(NSString *)format;

@end

/**
 * 格式中"0"和"#"的区别
 * 1. 以"0"补位时：
 *   如果数字少了，就会补"0"，小数和整数都会补；
 *   如果数字多了，就切掉，但只切小数的末尾，整数不能切；
 *   同时被切掉的小数位会进行四舍五入处理。
 * 2. 以"#"补位时：
 *   如果数字少了，则不处理，不会补"0"，也不会补"#"；
 *   如果数字多了，就切掉，但只切小数的末尾，整数不能切；
 *   同时被切掉的小数位会进行四舍五入处理。
 * 常见格式有如下几种：
 **/
/// 最多保留两位小数，自动去掉小数的无效位
CX_FOUNDATION_EXTERN NSString * const CXNumberFormatDynamicMaxTwo;
/// 最少保留一位小数，最大保留两位小数
CX_FOUNDATION_EXTERN NSString * const CXNumberFormatDynamicMinOne;
/// 只保留整数位
CX_FOUNDATION_EXTERN NSString * const CXNumberFormatFixedInteger;
/// 固定保留一位小数
CX_FOUNDATION_EXTERN NSString * const CXNumberFormatFixedOne;
/// 固定保留两位小数
CX_FOUNDATION_EXTERN NSString * const CXNumberFormatFixedTwo;
