//
//  NSNotificationCenter+CXFoundation.h
//  Pods
//
//  Created by wshaolin on 2019/1/16.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (CXFoundation)

+ (void)notify:(NSNotificationName)name;

+ (void)notify:(NSNotificationName)name userInfo:(NSDictionary<NSString *, id> *)userInfo;

+ (void)notify:(NSNotificationName)name object:(id)object userInfo:(NSDictionary<NSString *, id> *)userInfo;

+ (void)addObserver:(id)observer action:(SEL)action name:(NSNotificationName)name;

+ (void)addObserver:(id)observer action:(SEL)action name:(NSNotificationName)name object:(id)object;

+ (void)removeObserver:(id)observer;

+ (void)removeObserver:(id)observer name:(NSNotificationName)name object:(id)object;

@end
