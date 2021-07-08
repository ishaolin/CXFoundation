//
//  NSString+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2018/12/21.
//

#import <Foundation/Foundation.h>
#import "CXFoundationDefines.h"

@interface NSString (CXExtensions)

- (NSString *)cx_phoneNumber;

- (NSString *)cx_pinyinFirstLetter;

- (NSString *)cx_pinyin;

- (NSString *)cx_URLStringByAppendingParams:(NSDictionary<NSString *, NSString *> *)params;

@end

CX_FOUNDATION_EXTERN NSString *CXValidPinyinString(NSString *pinyin);
