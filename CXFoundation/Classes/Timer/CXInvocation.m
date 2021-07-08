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
    __weak id _executor;
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

- (void)setExecutor:(id)executor{
    if(_executor != executor){
        _executor = executor;
        
        [self setArg:&_executor atIndex:CXInvocationFirstArgumentIndex];
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
    if(_invocation){
        return (index >= CXInvocationFirstArgumentIndex) &&
        (index < _invocation.methodSignature.numberOfArguments);
    }
    
    return NO;
}

- (void)invoke{
    if(_invocation){
        [_invocation invoke];
    }else{
        if(_actionBlock){
            _actionBlock(_executor);
        }
    }
}

- (void)dealloc{
    _invocation = nil;
    _actionBlock = NULL;
}

@end

NSUInteger const CXInvocationFirstArgumentIndex = 2;
