//
//  CXInvocation.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import <Foundation/Foundation.h>

typedef void(^CXInvocationActionBlock)(id executor);

@interface CXInvocation : NSObject

+ (instancetype)invocationWithTarget:(id)target action:(SEL)action;
+ (instancetype)invocationWithActionBlock:(CXInvocationActionBlock)actionBlock;

- (instancetype)initWithTarget:(id)target action:(SEL)action;
- (instancetype)initWithActionBlock:(CXInvocationActionBlock)actionBlock;

- (void)setExecutor:(id)executor;

- (void)getArg:(void *)arg atIndex:(NSInteger)index;
- (void)setArg:(void *)arg atIndex:(NSInteger)index;

- (void)invoke;

@end

extern NSUInteger const CXInvocationFirstArgumentIndex;
