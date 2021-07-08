//
//  NSJSONSerialization+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import <Foundation/Foundation.h>
#import "CXFoundationDefines.h"

@interface NSJSONSerialization (CXExtensions)

+ (NSDictionary *)cx_deserializeJSONToDictionary:(id)obj;

+ (NSArray *)cx_deserializeJSONToArray:(id)obj;

+ (NSString *)cx_stringWithJSONObject:(id)obj;

/// options在obj类型为NSArray或者NSDictionary时有效
+ (NSString *)cx_stringWithJSONObject:(id)obj options:(NSJSONWritingOptions)options;

@end
