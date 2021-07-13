//
//  NSString+CXFoundation.m
//  Pods
//
//  Created by wshaolin on 2018/12/21.
//

#import "NSString+CXFoundation.h"
#import "CXStringUtils.h"

@implementation NSString (CXFoundation)

- (NSString *)cx_phoneNumber{
    NSString *phoneNumber = [self stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    return phoneNumber;
}

- (NSString *)cx_pinyinFirstLetter{
    if(self.length > 0){
        NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:0];
        NSString *substring = [self substringWithRange:range];
        NSString *pinyinString = [substring cx_pinyin];
        pinyinString = [self handlePinyinByPolyphone:substring pinyin:pinyinString];
        if(pinyinString.length > 0){
            unichar character = [pinyinString characterAtIndex:0];
            if((character >= 'a' && character <= 'z') ||
               (character >= 'A' && character <= 'Z')){
                return [pinyinString substringToIndex:1].uppercaseString;
            }
        }
    }
    
    return @"#";
}

- (NSString *)cx_pinyin{
    NSMutableString *pinyin = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripDiacritics, false);
    return [pinyin copy];
}

- (NSString *)handlePinyinByPolyphone:(NSString *)polyphone pinyin:(NSString *)pinyin{
    if([polyphone isEqualToString:@"长"]){
        return @"chang";
    }
    
    if([polyphone isEqualToString:@"沈"]){
        return @"shen";
    }
    
    if([polyphone isEqualToString:@"厦"]){
        return @"xia";
    }
    
    if([polyphone isEqualToString:@"地"]){
        return @"di";
    }
    
    if([polyphone isEqualToString:@"重"]){
        return @"chong";
    }
    
    return pinyin;
}

- (NSString *)cx_URLStringByAppendingParams:(NSDictionary<NSString *, NSString *> *)params{
    if(params.count > 0 && ([CXStringUtils isHTTPURL:self] || [CXStringUtils isFileURL:self])){
        NSURLComponents *components = [NSURLComponents componentsWithString:self];
        NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
        if(components.queryItems){
            [queryItems addObjectsFromArray:components.queryItems];
        }
        
        [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:key value:obj];
            [queryItems addObject:queryItem];
        }];
        
        components.queryItems = [queryItems copy];
        return components.URL.absoluteString;
    }
    
    return self;
}

@end

NSString *CXValidPinyinString(NSString *pinyin){
    if(pinyin.length > 0){
        unichar character = [pinyin characterAtIndex:0];
        if((character >= 'a' && character <= 'z') ||
           (character >= 'A' && character <= 'Z')){
            return pinyin.uppercaseString;
        }
    }
    
    return @"#";
}
