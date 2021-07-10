//
//  CXTimer.h
//  Pods
//
//  Created by wshaolin on 2017/6/14.
//
//

#import <Foundation/Foundation.h>

@class CXTimerConfig;

typedef void(^CXTimerConfigBlock)(CXTimerConfig *config);

@interface CXTimer : NSObject

@property (nonatomic, strong) NSDate *fireDate;
@property (nonatomic, assign, readonly) NSTimeInterval timeInterval;
@property (nonatomic, assign, readonly) BOOL isValid;
@property (nonatomic, strong, readonly) id userInfo;

@property (nonatomic, assign, readonly) BOOL isSuspended;
@property (nonatomic, assign) NSTimeInterval tolerance;

/**
 * Creates and returns a new CXTimer object initialized with the specified block object and schedules it on the current run loop in the `NSRunLoopCommonModes` mode.
 */
+ (instancetype)taskTimerWithConfig:(CXTimerConfigBlock)config;

/**
 * Creates and returns a new CXTimer object initialized with the specified block object. This timer needs to be scheduled on a run loop (via -[CXTimer addToRunLoop: forMode:]) before it will fire.
 */
+ (instancetype)timerWithConfig:(CXTimerConfigBlock)config;

/**
 * Creates and returns a new CXTimer object initialized with the specified block object and schedules it on the current run loop in the default mode.
 */
+ (instancetype)scheduledTimerWithConfig:(CXTimerConfigBlock)config;

/**
 * Initializes a new CXTimer object using the block as the main body of execution for the timer. This timer needs to be scheduled on a run loop (via -[CXTimer addToRunLoop: forMode:]) before it will fire.
 * In this way, appropriate `fireDate` must be set in config block.
 */
- (instancetype)initWithConfig:(CXTimerConfigBlock)config;

- (void)fire;
- (void)invalidate;
- (void)pause;
- (void)resume;

- (void)addToRunLoop:(NSRunLoop *)runLoop forMode:(NSRunLoopMode)mode;

@end

@interface CXTimerConfig : NSObject

@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) BOOL repeats;
@property (nonatomic, strong) NSDate *fireDate;
@property (nonatomic, strong) id userInfo;

@end
