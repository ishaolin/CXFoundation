//
//  CXUKeychainQuery.m
//  Pods
//
//  Created by wshaolin on 2017/8/30.
//

#import "CXUKeychainQuery.h"

@implementation CXUKeychainQuery

- (BOOL)save:(CXUKeychainError *)error{
    OSStatus status = [self _save];
    if(error){
        *error = status;
    }
    
    return status == errSecSuccess;
}

- (BOOL)remove:(CXUKeychainError *)error{
    OSStatus status = [self _remove];
    if(error){
        *error = status;
    }
    
    return status == errSecSuccess;
}

- (BOOL)fetch:(CXUKeychainError *)error {
    OSStatus status = [self _fetch];
    if(error){
        *error = status;
    }
    
    return status == errSecSuccess;
}

- (OSStatus)_save{
    if(!self.service || !self.key || !self.data){
        return CXUKeychainBadArguments;
    }
    
    NSMutableDictionary<NSString *, id> *query = [self _queryInfo];
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)[query copy], NULL);
    
    if(status == errSecSuccess){
        status = SecItemUpdate((__bridge CFDictionaryRef)([query copy]),
                               (__bridge CFDictionaryRef)(@{(__bridge id)kSecValueData : self.data}));
    }else if(status == errSecItemNotFound){
        [query setObject:self.data forKey:(__bridge id)kSecValueData];
        if(self.label){
            [query setObject:self.label forKey:(__bridge id)kSecAttrLabel];
        }
        
#if __IPHONE_4_0 && TARGET_OS_IPHONE
        CFTypeRef accessibilityType = [self.class accessibilityType];
        if(accessibilityType){
            [query setObject:(__bridge id)accessibilityType forKey:(__bridge id)kSecAttrAccessible];
        }
#endif
        status = SecItemAdd((__bridge CFDictionaryRef)[query copy], NULL);
    }
    
    return status;
}

- (OSStatus)_remove{
    if(!self.service || !self.key){
        return CXUKeychainBadArguments;
    }
    
    NSMutableDictionary<NSString *, id> *query = [self _queryInfo];
#if TARGET_OS_IPHONE
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)[query copy]);
#else
    [query setObject:@(YES) forKey:(__bridge id)kSecReturnRef];
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)[query copy], &result);
    if(status == errSecSuccess){
        status = SecKeychainItemDelete((SecKeychainItemRef)result);
        CFRelease(result);
    }
#endif
    return status;
}

- (NSArray<NSDictionary<NSString *, id> *> *)fetchAll:(CXUKeychainError *)error {
    NSMutableDictionary<NSString *, id> *query = [self _queryInfo];
    
    [query setObject:@(YES) forKey:(__bridge id)kSecReturnAttributes];
    [query setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
#if __IPHONE_4_0 && TARGET_OS_IPHONE
    CFTypeRef accessibilityType = [self.class accessibilityType];
    if(accessibilityType){
        [query setObject:(__bridge id)accessibilityType forKey:(__bridge id)kSecAttrAccessible];
    }
#endif
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)[query copy], &result);
    if(status != errSecSuccess){
        if(error){
            *error = status;
        }
        
        return nil;
    }
    
    return (__bridge_transfer NSArray<NSDictionary<NSString *, id> *> *)result;
}

- (OSStatus)_fetch{
    if(!self.service || !self.key){
        return CXUKeychainBadArguments;
    }
    
    CFTypeRef result = NULL;
    NSMutableDictionary<NSString *, id> *query = [self _queryInfo];
    [query setObject:@(YES) forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)[query copy], &result);
    
    if(status == errSecSuccess){
        self.data = (__bridge_transfer NSData *)result;
    }
    
    return status;
}

- (void)setObject:(id<NSCoding>)object {
    self.data = [NSKeyedArchiver archivedDataWithRootObject:object];
}

- (id<NSCoding>)object {
    if(self.data.length > 0){
        return [NSKeyedUnarchiver unarchiveObjectWithData:self.data];
    }
    
    return nil;
}

- (void)setValue:(NSString *)value {
    self.data = [value dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)value {
    if(self.data.length){
        return [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

- (NSMutableDictionary<NSString *, id> *)_queryInfo {
    NSMutableDictionary<NSString *, id> *info = [NSMutableDictionary dictionary];
    [info setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    if(self.service){
        [info setObject:self.service forKey:(__bridge id)kSecAttrService];
    }
    
    if(self.key){
        [info setObject:self.key forKey:(__bridge id)kSecAttrAccount];
    }
    
#if TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
    if(self.accessGroup){
        [info setObject:self.accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
#endif
    
    switch (self.syncMode) {
        case CXUKeychainSyncModeFalse:{
            [info setObject:@(NO) forKey:(__bridge id)(kSecAttrSynchronizable)];
            break;
        }
        case CXUKeychainSyncModeTrue:{
            [info setObject:@(YES) forKey:(__bridge id)(kSecAttrSynchronizable)];
            break;
        }
        case CXUKeychainSyncModeAny:{
            [info setObject:(__bridge id)(kSecAttrSynchronizableAny) forKey:(__bridge id)(kSecAttrSynchronizable)];
            break;
        }
    }
    
    return info;
}

#if __IPHONE_4_0 && TARGET_OS_IPHONE

static CFTypeRef _CXUKeychainAccessibilityType = NULL;

+ (CFTypeRef)accessibilityType {
    return _CXUKeychainAccessibilityType;
}

+ (void)setAccessibilityType:(CFTypeRef)accessibilityType {
    if(accessibilityType){
        CFRetain(accessibilityType);
    }
    
    if(_CXUKeychainAccessibilityType){
        CFRelease(_CXUKeychainAccessibilityType);
    }
    
    _CXUKeychainAccessibilityType = accessibilityType;
}

#endif

@end
