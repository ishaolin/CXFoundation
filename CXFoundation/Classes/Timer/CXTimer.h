//
//  CXTimer.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import "CXInvocation.h"

@class CXTimerConfig;

@interface CXTimer : NSObject

@property (nonatomic, strong) NSDate *fireDate;
@property (nonatomic, assign, readonly) NSTimeInterval timeInterval;
@property (nonatomic, assign, readonly) BOOL isValid;
@property (nonatomic, strong, readonly) id userInfo;

@property (nonatomic, assign, readonly) BOOL isSuspended;
@property (nonatomic, assign) NSTimeInterval tolerance;

+ (instancetype)taskTimerWithInvocation:(CXInvocation *)invocation
                                 config:(CXTimerConfig *)config;

+ (instancetype)scheduledTimerWithInvocation:(CXInvocation *)invocation
                                      config:(CXTimerConfig *)config;

+ (instancetype)timerWithInvocation:(CXInvocation *)invocation
                             config:(CXTimerConfig *)config;

- (instancetype)initWithInvocation:(CXInvocation *)invocation
                            config:(CXTimerConfig *)config;

- (void)fire;
- (void)invalidate;
- (void)pause;
- (void)resume;

- (void)addToRunLoop:(NSRunLoop *)runLoop forMode:(NSRunLoopMode)mode;

@end

@interface CXTimerConfig : NSObject

@property (nonatomic, assign, readonly) NSTimeInterval interval;
@property (nonatomic, assign, readonly) BOOL repeats;

@property (nonatomic, strong) NSDate *fireDate;
@property (nonatomic, strong) id userInfo;

+ (instancetype)configWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats;

- (instancetype)initWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats;

@end
