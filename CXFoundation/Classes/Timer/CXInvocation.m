//
//  CXInvocation.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "CXInvocation.h"

@interface CXInvocation(){
    NSInvocation *_invocation;
}

@property (nonatomic, assign, readonly) BOOL hasArgs;
@property (nonatomic, copy) CXInvocationActionBlock actionBlock;

@end

@implementation CXInvocation

+ (instancetype)invocationWithTarget:(id)target action:(SEL)action{
    return [[self alloc] initWithTarget:target action:action];
}

+ (instancetype)invocationWithActionBlock:(CXInvocationActionBlock)actionBlock{
    return [[self alloc] initWithActionBlock:actionBlock];
}

- (instancetype)initWithTarget:(id)target action:(SEL)action{
    if(!target || !action){
        return nil;
    }
    
    if(![target respondsToSelector:action]){
        return nil;
    }
    
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:action];
    if(!methodSignature){
        return nil;
    }
    
    if(self = [super init]){
        _invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        _invocation.target = target;
        _invocation.selector = action;
        
        _hasArgs = methodSignature.numberOfArguments > CXInvocationFirstArgumentIndex;
    }
    
    return self;
}

- (instancetype)initWithActionBlock:(CXInvocationActionBlock)actionBlock{
    if(!actionBlock){
        return nil;
    }
    
    if(self = [super init]){
        self.actionBlock = actionBlock;
    }
    
    return self;
}

- (void)setInvoker:(id)invoker{
    if(_invoker == invoker){
        return;
    }
    
    _invoker = invoker;
    if(_invocation && invoker){
        [_invocation setArgument:&invoker atIndex:CXInvocationFirstArgumentIndex];
    }
}

- (void)getArg:(void *)arg atIndex:(NSInteger)index{
    if(self.hasArgs && [self isValidArgIndex:index]){
        [_invocation getArgument:arg atIndex:index];
    }
}

- (void)setArg:(void *)arg atIndex:(NSInteger)index{
    if(self.hasArgs && [self isValidArgIndex:index]){
        [_invocation setArgument:arg atIndex:index];
    }
}

- (BOOL)isValidArgIndex:(NSInteger)index{
    if(!_invocation){
        return NO;
    }
    
    return index >= CXInvocationFirstArgumentIndex &&
    index < _invocation.methodSignature.numberOfArguments;
}

- (void)invoke{
    if(_invocation){
        [_invocation invoke];
    }else{
        !_actionBlock ?: _actionBlock(_invoker);
    }
}

- (void)dealloc{
    _invocation = nil;
    _actionBlock = NULL;
}

@end

NSUInteger const CXInvocationFirstArgumentIndex = 2;
