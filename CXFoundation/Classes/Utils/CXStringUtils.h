//
//  CXStringUtils.h
//  Pods
//
//  Created by lcc on 2018/8/6.
//

#import <Foundation/Foundation.h>
#import "CXFoundationDefines.h"

@interface CXStringUtils : NSObject

+ (BOOL)isValidString:(NSString *)string; // 字符串类型，长度大于0

+ (BOOL)isHTTPURL:(NSString *)URL;

+ (BOOL)isFileURL:(NSString *)URL;

@end

/// nil，或者长度等于0的字符串
CX_FOUNDATION_EXTERN BOOL CXStringIsEmpty(NSString *string);

/// 是不是全为空格的字符串
CX_FOUNDATION_EXTERN BOOL CXStringIsAllSpace(NSString *string);

/// 包含Emoji字符串
CX_FOUNDATION_EXTERN BOOL CXStringContainsEmoji(NSString *string);

/// 去掉首尾的空格
CX_FOUNDATION_EXTERN NSString *CXStringTrim(NSString *string);

/// 字符串正则匹配
CX_FOUNDATION_EXTERN BOOL CXMatchRegexString(NSString *string, NSString *regex);
