//
//  NSCharacterSet+CXFoundation.m
//  Pods
//
//  Created by wshaolin on 2019/1/24.
//

#import "NSCharacterSet+CXFoundation.h"

@implementation NSCharacterSet (CXFoundation)

+ (NSCharacterSet *)cx_URLWholeAllowedCharacterSet{
    static NSCharacterSet *characterSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        characterSet = [NSCharacterSet characterSetWithCharactersInString:@"\"#%/:<>?@&+=[\\]^`{|}"];
        characterSet = characterSet.invertedSet;
    });
    
    return [characterSet copy];
}

@end
