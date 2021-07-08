//
//  CXAudioRecorder.h
//  Pods
//
//  Created by wshaolin on 2019/3/26.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class CXAudioRecorder;

typedef void(^CXAudioRecorderProgressBlock)(CXAudioRecorder *recorder,
                                            NSUInteger progress);

// peakPower range [0, 1], 0 is min, 1 is max.
typedef void(^CXAudioRecorderPeakPowerBlock)(CXAudioRecorder *recorder,
                                             CGFloat peakPower);

typedef void(^CXAudioRecorderFinishedBlock)(CXAudioRecorder *recorder,
                                            NSString *filePath,
                                            NSUInteger duration,
                                            NSError *error);

typedef void(^CXAudioRecorderCancelledBlock)(CXAudioRecorder *recorder);

@interface CXAudioRecorder : NSObject

/// Max record duration. Defaults 60, unit second. Range [10, 120]
@property (nonatomic, assign) NSUInteger maxDuration;
@property (nonatomic, assign, readonly) BOOL isRecording;

+ (CXAudioRecorder *)sharedRecorder;

- (void)startRecording:(CXAudioRecorderProgressBlock)progressBlock
        peakPowerBlock:(CXAudioRecorderPeakPowerBlock)peakPowerBlock
         finishedBlock:(CXAudioRecorderFinishedBlock)finishedBlock
        cancelledBlock:(CXAudioRecorderCancelledBlock)cancelledBlock;

- (void)stopRecording;

- (void)cancelRecording;

@end
