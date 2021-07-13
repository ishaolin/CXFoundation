//
//  NSDictionary+CXFoundation.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CXFoundation)

- (id)cx_objectForKey:(id<NSCopying>)key;

- (BOOL)cx_hasKey:(id<NSCopying>)key;

- (NSString *)cx_stringForKey:(id<NSCopying>)key;
- (NSNumber *)cx_numberForKey:(id<NSCopying>)key;

- (NSArray *)cx_arrayForKey:(id<NSCopying>)key;
- (NSDictionary *)cx_dictionaryForKey:(id<NSCopying>)key;

@end

@interface NSMutableDictionary (CXFoundation)

- (void)cx_setObject:(id)object forKey:(id<NSCopying>)key;

- (void)cx_setValue:(id)value forKey:(NSString *)key;

- (void)cx_setString:(NSString *)string forKey:(id<NSCopying>)key;

@end
