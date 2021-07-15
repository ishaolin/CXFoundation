//
//  CXObjectManager.m
//  Pods
//
//  Created by wshaolin on 2021/7/15.
//

#import "CXObjectManager.h"

static NSMutableSet *_holdObjects = nil;

@implementation CXObjectManager

+ (BOOL)addObject:(NSObject *)object{
    if(!object){
        return NO;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _holdObjects = [NSMutableSet set];
    });
    
    if([_holdObjects containsObject:object]){
        return NO;
    }
    
    [_holdObjects addObject:object];
    return YES;
}

+ (void)removeObject:(NSObject *)object{
    if(object && _holdObjects){
        [_holdObjects removeObject:object];
    }
}

+ (BOOL)containsObject:(NSObject *)object{
    if(object && _holdObjects){
        return [_holdObjects containsObject:object];
    }
    
    return NO;
}

@end
