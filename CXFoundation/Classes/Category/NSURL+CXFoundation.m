//
//  NSURL+CXFoundation.m
//  Pods
//
//  Created by wshaolin on 2017/6/19.
//
//

#import "NSURL+CXFoundation.h"
#import "CXStringUtils.h"

@implementation NSURL (CXFoundation)

- (NSDictionary<NSString *,NSString *> *)cx_params{    
    return [self.class cx_paramsWithString:self.query];
}

+ (NSDictionary<NSString *,NSString *> *)cx_paramsWithString:(NSString *)string{
    if(CXStringIsEmpty(string)){
        return nil;
    }
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
    NSMutableDictionary<NSString *, NSString *> *dictionary = [NSMutableDictionary dictionary];
    NSScanner *scanner = [[NSScanner alloc] initWithString:string];
    
    while(![scanner isAtEnd]){
        NSString *pairString = nil;
        [scanner scanUpToCharactersFromSet:characterSet intoString:&pairString];
        [scanner scanCharactersFromSet:characterSet intoString:NULL];
        NSArray *array = [pairString componentsSeparatedByString:@"="];
        if(array.count >= 2){
            NSString *key = [[array firstObject] stringByRemovingPercentEncoding];
            // 防止出现多个'='分割key-value错误的问题
            NSString *value = [pairString substringFromIndex:(key.length + 1)].stringByRemovingPercentEncoding;
            dictionary[key] = value;
        }
    }
    
    return [dictionary copy];
}

+ (NSURL *)cx_validURL:(id)url{
    if(!url){
        return nil;
    }
    
    if([url isKindOfClass:[NSURL class]]){
        return (NSURL *)url;
    }
    
    if([CXStringUtils isHTTPURL:url]){
        return [NSURL URLWithString:(NSString *)url];
    }
    
    return nil;
}

@end
