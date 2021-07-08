//
//  NSNotificationCenter+CXExtensions.m
//  Pods
//
//  Created by wshaolin on 2019/1/16.
//

#import "NSNotificationCenter+CXExtensions.h"

@implementation NSNotificationCenter (CXExtensions)

+ (void)notify:(NSNotificationName)name{
    [self notify:name userInfo:nil];
}

+ (void)notify:(NSNotificationName)name userInfo:(NSDictionary<NSString *, id> *)userInfo{
    [self notify:name object:nil userInfo:userInfo];
}

+ (void)notify:(NSNotificationName)name object:(id)object userInfo:(NSDictionary<NSString *, id> *)userInfo{
    [[self defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}

+ (void)addObserver:(id)observer action:(SEL)action name:(NSNotificationName)name{
    [self addObserver:observer action:action name:name object:nil];
}

+ (void)addObserver:(id)observer action:(SEL)action name:(NSNotificationName)name object:(id)object{
    [[self defaultCenter] addObserver:observer selector:action name:name object:object];
}

+ (void)removeObserver:(id)observer{
    [[self defaultCenter] removeObserver:observer];
}

+ (void)removeObserver:(id)observer name:(NSNotificationName)name object:(id)object{
    [[self defaultCenter] removeObserver:observer name:name object:object];
}

@end
