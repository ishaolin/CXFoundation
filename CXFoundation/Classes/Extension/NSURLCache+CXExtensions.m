//
//  NSURLCache+CXExtensions.m
//  Pods
//
//  Created by wshaolin on 2019/1/28.
//

#import "NSURLCache+CXExtensions.h"
#import "CXUtils.h"
#import "NSBundle+CXExtensions.h"
#import "CXStringUtils.h"
#import <objc/runtime.h>

@implementation NSURLCache (CXExtensions)

- (NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, id> *> *)cx_cachedData{
    NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, id> *> *cachedData = objc_getAssociatedObject(self, _cmd);
    if(!cachedData){
        cachedData = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, cachedData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return cachedData;
}

- (void)cx_cacheData:(NSDictionary<NSString *,id> *)data forDomain:(NSString *)domain{
    if(CXDictionaryIsEmpty(data)){
        return;
    }
    
    NSString *cacheKey = domain ?: [NSBundle mainBundle].cx_appId;
    NSMutableDictionary<NSString *, id> *dictionary = [self cx_cachedData][cacheKey];
    if(!dictionary){
        dictionary = [NSMutableDictionary dictionary];
        [self cx_cachedData][cacheKey] = dictionary;
    }
    
    [dictionary addEntriesFromDictionary:data];
}

- (NSDictionary<NSString *, id> *)cx_dataForDomain:(NSString *)domain{
    if(CXStringIsEmpty(domain)){
        return nil;
    }
    
    NSString *cacheKey = domain ?: [NSBundle mainBundle].cx_appId;
    return [[self cx_cachedData][cacheKey] copy];
}

- (void)cx_removeCacheForKey:(NSString *)key domain:(NSString *)domain{
    NSString *cacheKey = domain ?: [NSBundle mainBundle].cx_appId;
    
    if(CXStringIsEmpty(key)){
        [[self cx_cachedData] removeObjectForKey:cacheKey];
    }else{
        NSMutableDictionary<NSString *, id> *dictionary = [self cx_cachedData][cacheKey];
        [dictionary removeObjectForKey:key];
    }
}

@end
