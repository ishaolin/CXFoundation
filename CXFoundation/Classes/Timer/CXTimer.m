//
//  CXTimer.m
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "CXTimer.h"
#import "CXInvocation.h"

@interface CXTimer(){
    NSTimer *_timer;
}

@end

@implementation CXTimer

+ (instancetype)taskTimerWithConfig:(CXTimerConfigBlock)config{
    CXTimer *timer = [[self alloc] init];
    [timer createForTimerWithConfigBlock:config];
    return timer;
}

+ (instancetype)timerWithConfig:(CXTimerConfigBlock)config{
    CXTimer *timer = [[self alloc] init];
    [timer createForTimerWithConfigBlock:config];
    return timer;
}

+ (instancetype)scheduledTimerWithConfig:(CXTimerConfigBlock)config{
    CXTimer *timer = [[self alloc] init];
    [timer createForScheduledTimerWithConfigBlock:config];
    return timer;
}

- (instancetype)initWithConfig:(CXTimerConfigBlock)config{
    if(self = [super init]){
        [self createForInitTimerWithConfigBlock:config];
    }
    
    return self;
}

- (void)createForTimerWithConfigBlock:(CXTimerConfigBlock)configBlock{
    CXTimerConfig *config = [[CXTimerConfig alloc] init];
    configBlock(config);
    
    CXInvocation *invocation = [CXInvocation invocationWithTarget:config.target action:config.action];
    _timer = [NSTimer timerWithTimeInterval:config.interval
                                     target:invocation
                                   selector:@selector(invoke)
                                   userInfo:config.userInfo
                                    repeats:config.repeats];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)createForScheduledTimerWithConfigBlock:(CXTimerConfigBlock)configBlock{
    CXTimerConfig *config = [[CXTimerConfig alloc] init];
    configBlock(config);
    
    CXInvocation *invocation = [CXInvocation invocationWithTarget:config.target action:config.action];
    _timer = [NSTimer scheduledTimerWithTimeInterval:config.interval
                                              target:invocation
                                            selector:@selector(invoke)
                                            userInfo:config.userInfo
                                             repeats:config.repeats];
}

- (void)createForInitTimerWithConfigBlock:(CXTimerConfigBlock)configBlock{
    CXTimerConfig *config = [[CXTimerConfig alloc] init];
    configBlock(config);
    
    NSParameterAssert(config.fireDate);
    
    CXInvocation *invocation = [CXInvocation invocationWithTarget:config.target action:config.action];
    _timer = [[NSTimer alloc] initWithFireDate:config.fireDate
                                      interval:config.interval
                                        target:invocation
                                      selector:@selector(invoke)
                                      userInfo:config.userInfo
                                       repeats:config.repeats];
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
    if(_isSuspended){
        return;
    }
    
    if(_timer.isValid){
        _timer.fireDate = [NSDate distantFuture];
        _isSuspended = YES;
    }
}

- (void)resume{
    if(!_isSuspended){
        return;
    }
    
    if(_timer.isValid){
        _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:_timer.timeInterval];
    }
    
    _isSuspended = NO;
}

- (void)addToRunLoop:(NSRunLoop *)runLoop forMode:(NSRunLoopMode)mode{
    NSParameterAssert(runLoop);
    NSParameterAssert(mode);
    
    if(!_timer){
        return;
    }
    
    if([mode isEqualToString:NSDefaultRunLoopMode] || [mode isEqualToString:NSRunLoopCommonModes]){
        [runLoop addTimer:_timer forMode:mode];
    }
}

- (void)dealloc{
    [_timer invalidate];
    
    _timer = nil;
}

@end

@implementation CXTimerConfig

@end
