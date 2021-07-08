//
//  CXTimer.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "CXTimer.h"

typedef NS_ENUM(NSInteger, CXTimerInstanceMethod) {
    CXTimerInstanceMethodInitializer    = 0,
    CXTimerInstanceMethodTimer          = 1,
    CXTimerInstanceMethodScheduledTimer = 2
};

@interface CXTimer(){
    NSTimer *_timer;
}

@end

@implementation CXTimer

+ (instancetype)taskTimerWithInvocation:(CXInvocation *)invocation
                                 config:(CXTimerConfig *)config{
    CXTimer *timer = [self timerWithInvocation:invocation
                                        config:config];
    [timer addToRunLoop:[NSRunLoop currentRunLoop]
                forMode:NSRunLoopCommonModes];
    return timer;
}

+ (instancetype)timerWithInvocation:(CXInvocation *)invocation
                             config:(CXTimerConfig *)config{
    return [[self alloc] initWithMethod:CXTimerInstanceMethodTimer
                             invocation:invocation
                                 config:config];
}

+ (instancetype)scheduledTimerWithInvocation:(CXInvocation *)invocation
                                      config:(CXTimerConfig *)config{
    return [[self alloc] initWithMethod:CXTimerInstanceMethodScheduledTimer
                             invocation:invocation
                                 config:config];
}

- (instancetype)initWithInvocation:(CXInvocation *)invocation
                            config:(CXTimerConfig *)config{
    return [self initWithMethod:CXTimerInstanceMethodInitializer
                     invocation:invocation config:config];
}

- (instancetype)initWithMethod:(CXTimerInstanceMethod)mothed
                    invocation:(CXInvocation *)invocation
                        config:(CXTimerConfig *)config{
    NSParameterAssert(invocation);
    NSParameterAssert(config);
    if(mothed == CXTimerInstanceMethodInitializer){
        NSParameterAssert(config.fireDate);
    }
    
    if(self = [super init]){
        _isSuspended = NO;
        [invocation setExecutor:self];
        
        switch (mothed) {
            case CXTimerInstanceMethodTimer:{
                _timer = [NSTimer timerWithTimeInterval:config.interval
                                                 target:invocation
                                               selector:@selector(invoke)
                                               userInfo:config.userInfo
                                                repeats:config.repeats];
            }
                break;
            case CXTimerInstanceMethodScheduledTimer:{
                _timer = [NSTimer scheduledTimerWithTimeInterval:config.interval
                                                          target:invocation
                                                        selector:@selector(invoke)
                                                        userInfo:config.userInfo
                                                         repeats:config.repeats];
            }
                break;
            case CXTimerInstanceMethodInitializer:{
                _timer = [[NSTimer alloc] initWithFireDate:config.fireDate
                                                  interval:config.interval
                                                    target:invocation
                                                  selector:@selector(invoke)
                                                  userInfo:config.userInfo
                                                   repeats:config.repeats];
            }
                break;
            default:
                break;
        }
    }
    
    return self;
}

- (NSDate *)fireDate{
    return _timer.fireDate;
}

- (void)setFireDate:(NSDate *)fireDate{
    _timer.fireDate = fireDate;
}

- (NSTimeInterval)timeInterval{
    return _timer.timeInterval;
}

- (void)setTolerance:(NSTimeInterval)tolerance{
    _timer.tolerance = tolerance;
}

- (NSTimeInterval)tolerance{
    return _timer.tolerance;
}

- (BOOL)isValid{
    return _timer.isValid;
}

- (id)userInfo{
    return _timer.userInfo;
}

- (void)fire{
    [_timer fire];
    _isSuspended = NO;
}

- (void)invalidate{
    [_timer invalidate];
    _isSuspended = NO;
}

- (void)pause{
    if(_timer.isValid){
        _timer.fireDate = [NSDate distantFuture];
        _isSuspended = YES;
    }
}

- (void)resume{
    if(_timer.isValid){
        _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:_timer.timeInterval];
    }
    
    _isSuspended = NO;
}

- (void)addToRunLoop:(NSRunLoop *)runLoop forMode:(NSRunLoopMode)mode{
    NSParameterAssert(runLoop);
    NSParameterAssert(mode);
    
    if(_timer){
        if([mode isEqualToString:NSDefaultRunLoopMode] || [mode isEqualToString:NSRunLoopCommonModes]){
            [runLoop addTimer:_timer forMode:mode];
        }
    }
}

- (void)dealloc{
    [_timer invalidate];
    
    _timer = nil;
}

@end

@implementation CXTimerConfig

+ (instancetype)configWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats{
    return [[self alloc] initWithInterval:interval repeats:repeats];
}

- (instancetype)initWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats{
    if(self = [super init]){
        _interval = interval;
        _repeats = repeats;
    }
    
    return self;
}

@end
