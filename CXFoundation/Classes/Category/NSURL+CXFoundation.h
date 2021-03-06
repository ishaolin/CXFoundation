//
//  NSURL+CXFoundation.h
//  Pods
//
//  Created by wshaolin on 2017/6/19.
//
//

#import <Foundation/Foundation.h>

@interface NSURL (CXFoundation)

- (NSDictionary<NSString *, NSString *> *)cx_params;

+ (NSDictionary<NSString *, NSString *> *)cx_paramsWithString:(NSString *)string;

+ (NSURL *)cx_validURL:(id)url;

@end
