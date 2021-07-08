//
//  NSURLCache+CXExtensions.h
//  Pods
//
//  Created by wshaolin on 2019/1/28.
//

#import <Foundation/Foundation.h>

@interface NSURLCache (CXExtensions)

- (void)cx_cacheData:(NSDictionary<NSString *, id> *)data forDomain:(NSString *)domain;

- (NSDictionary<NSString *, id> *)cx_dataForDomain:(NSString *)domain;

- (void)cx_removeCacheForKey:(NSString *)key domain:(NSString *)domain;

@end
