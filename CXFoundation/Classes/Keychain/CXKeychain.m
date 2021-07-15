//
//  CXKeychain.m
//  Pods
//
//  Created by wshaolin on 2017/8/30.
//

#import "CXKeychain.h"
#import "CXKeychainQuery.h"

@implementation CXKeychain

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service{
    return [self stringForKey:key service:service error:nil];
}

+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service error:(CXKeychainError *)error{
    CXKeychainQuery *query = [[CXKeychainQuery alloc] init];
    query.key = key;
    query.service = service;
    [query fetch:error];
    return query.value;
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service{
    return [self dataForKey:key service:service error:nil];
}

+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service error:(CXKeychainError *)error{
    CXKeychainQuery *query = [[CXKeychainQuery alloc] init];
    query.key = key;
    query.service = service;
    [query fetch:error];
    return query.data;
}

+ (BOOL)removeForKey:(NSString *)key service:(NSString *)service{
    return [self removeForKey:key service:service error:nil];
}

+ (BOOL)removeForKey:(NSString *)key service:(NSString *)service error:(CXKeychainError *)error{
    CXKeychainQuery *query = [[CXKeychainQuery alloc] init];
    query.key = key;
    query.service = service;
    return [query remove:error];
}

+ (BOOL)setValue:(NSString *)value forKey:(NSString *)key service:(NSString *)service{
    return [self setValue:value forKey:key service:service error:nil];
}

+ (BOOL)setValue:(NSString *)value forKey:(NSString *)key service:(NSString *)service error:(CXKeychainError *)error{
    CXKeychainQuery *query = [[CXKeychainQuery alloc] init];
    query.key = key;
    query.service = service;
    query.value = value;
    return [query save:error];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service{
    return [self setData:data forKey:key service:service error:nil];
}

+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service error:(CXKeychainError *)error{
    CXKeychainQuery *query = [[CXKeychainQuery alloc] init];
    query.key = key;
    query.service = service;
    query.data = data;
    return [query save:error];
}

+ (NSArray<NSDictionary<NSString *, id> *> *)allAccounts {
    return [self allAccounts:nil];
}

+ (NSArray<NSDictionary<NSString *, id> *> *)allAccounts:(CXKeychainError *)error {
    return [self accountsForService:nil error:error];
}

+ (NSArray<NSDictionary<NSString *, id> *> *)accountsForService:(NSString *)service {
    return [self accountsForService:service error:nil];
}

+ (NSArray<NSDictionary<NSString *, id> *> *)accountsForService:(NSString *)service error:(CXKeychainError * _Nullable)error {
    CXKeychainQuery *query = [[CXKeychainQuery alloc] init];
    query.service = service;
    return [query fetchAll:error];
}

#if __IPHONE_4_0 && TARGET_OS_IPHONE

+ (CFTypeRef)accessibilityType {
    return [CXKeychainQuery accessibilityType];
}

+ (void)setAccessibilityType:(CFTypeRef)accessibilityType {
    [CXKeychainQuery setAccessibilityType:accessibilityType];
}

#endif

@end
