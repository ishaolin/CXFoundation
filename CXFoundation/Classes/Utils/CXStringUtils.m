//
//  CXStringUtils.m
//  Pods
//
//  Created by lcc on 2018/8/6.
//

#import "CXStringUtils.h"

@implementation CXStringUtils

+ (BOOL)isValidString:(NSString *)string{
    if(!string){
        return NO;
    }
    
    if(![string isKindOfClass:[NSString class]]){
        return NO;
    }
    
    return string.length > 0;
}

+ (BOOL)isHTTPURL:(NSString *)URL{
    if(CXStringIsEmpty(URL)){
        return NO;
    }
    
    if([URL hasPrefix:@"http://"] || [URL hasPrefix:@"https://"]){
        return YES;
    }
    
    return NO;
}

+ (BOOL)isFileURL:(NSString *)URL{
    if(CXStringIsEmpty(URL)){
        return NO;
    }
    
    return [URL hasPrefix:@"file://"];
}

@end

BOOL CXStringIsEmpty(NSString *string){
    if(!string){
        return YES;
    }
    
    if(![string isKindOfClass:[NSString class]]){
        return YES;
    }
    
    return string.length == 0;
}

BOOL CXStringIsAllSpace(NSString *string){
    if(!string || string.length == 0){
        return NO;
    }
    
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [string stringByTrimmingCharactersInSet:characterSet].length == 0;
}

BOOL CXStringContainsEmoji(NSString *string){
    if(CXStringIsEmpty(string)){
        return NO;
    }
    
    __block BOOL contains = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        const unichar unichar0 = [substring characterAtIndex: 0];
        if(0xD800 <= unichar0 && unichar0 <= 0xDBFF){
            const unichar unichar1 = [substring characterAtIndex:1];
            const int64_t codepoint = ((unichar0 - 0xD800) * 0x400) + (unichar1 - 0xDC00) + 0x10000;
            
            if(0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                contains = YES;
                *stop = YES;
            }
        }else if(0x2100 <= unichar0 && unichar0 <= 0x27BF){
            contains = YES;
            *stop = YES;
        }
    }];
    
    return contains;
}

NSString *CXStringTrim(NSString *string){
    while([string hasPrefix:@" "]){
        string = [string substringFromIndex:1];
    }
    
    while([string hasSuffix:@" "]){
        string = [string substringToIndex:string.length - 1];
    }
    
    return string;
}

BOOL CXMatchRegexString(NSString *string, NSString *regex){
    if(!string || !regex){
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}
