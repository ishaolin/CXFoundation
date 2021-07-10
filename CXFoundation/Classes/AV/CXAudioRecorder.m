//
//  CXAudioRecorder.m
//  Pods
//
//  Created by wshaolin on 2019/3/26.
//

#import "CXAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "CXTimer.h"
#import "CXInvocation.h"
#import "CXFileCacheHandler.h"
#import "CXFileHandler.h"

@interface CXAudioRecorder () <AVAudioRecorderDelegate> {
    AVAudioRecorder *_recorder;
    NSDictionary<NSString *, id> *_setting;
    CXTimer *_recordingTimer;
    CXTimer *_peakPowerTimer;
    
    NSUInteger _recordingProgress;
    NSString *_filePath;
}

@property (nonatomic, copy) CXAudioRecorderProgressBlock progressBlock;
@property (nonatomic, copy) CXAudioRecorderPeakPowerBlock peakPowerBlock;
@property (nonatomic, copy) CXAudioRecorderFinishedBlock finishedBlock;
@property (nonatomic, copy) CXAudioRecorderCancelledBlock cancelledBlock;

@end

@implementation CXAudioRecorder

+ (CXAudioRecorder *)sharedRecorder{
    static CXAudioRecorder *_audioRecorder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _audioRecorder = [[CXAudioRecorder alloc] init];
        _audioRecorder.maxDuration = 60;
        
        _audioRecorder->_setting = @{AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                     AVSampleRateKey : @(44100),
                                     AVNumberOfChannelsKey : @(1),
                                     AVLinearPCMBitDepthKey : @(16),
                                     AVEncoderAudioQualityKey : @(AVAudioQualityHigh)};
    });
    
    return _audioRecorder;
}

- (void)setMaxDuration:(NSUInteger)maxDuration{
    _maxDuration = MIN(MAX(maxDuration, 10), 120);
}

- (void)configAudioSession{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDuckOthers | AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionDefaultToSpeaker
                        error:nil];
    
    UInt32 audioRouteOverrides = kAudioSessionOverrideAudioRoute_Speaker;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverrides),  &audioRouteOverrides);
#pragma clang diagnostic pop
    [audioSession setActive:YES error:nil];
}

- (void)startRecording:(CXAudioRecorderProgressBlock)progressBlock
        peakPowerBlock:(CXAudioRecorderPeakPowerBlock)peakPowerBlock
         finishedBlock:(CXAudioRecorderFinishedBlock)finishedBlock
        cancelledBlock:(CXAudioRecorderCancelledBlock)cancelledBlock{
    if(_recorder.isRecording){
        if(finishedBlock){
            finishedBlock(self, nil, 0, nil);
        }
        
        return;
    }
    
    NSString *fileName = CXCreateCacheFileName(@".mp4");
    _filePath = CX_RECORD_PATH_GET(fileName);
    NSError *error = nil;
    _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_filePath]
                                            settings:_setting
                                               error:&error];
    if(error){
        if(finishedBlock){
            finishedBlock(self, _filePath, 0, error);
        }
        
        return;
    }
    
    self.progressBlock = progressBlock;
    self.finishedBlock = finishedBlock;
    self.peakPowerBlock = peakPowerBlock;
    self.cancelledBlock = cancelledBlock;
    
    [self configAudioSession];
    
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    [_recorder record];
    
    [self addRecordingTimer];
    [self addPeakPowerTimer];
}

- (void)stopRecording{
    if(_recorder.isRecording){
        [self removeRecordingTimer];
        [self removePeakPowerTimer];
        
        [_recorder stop];
    }
}

- (void)cancelRecording{
    if(_recorder.isRecording){
        [self removeRecordingTimer];
        [self removePeakPowerTimer];
        
        if(self.cancelledBlock){
            self.cancelledBlock(self);
        }
        
        self.finishedBlock = nil;
        self.progressBlock = nil;
        self.peakPowerBlock = nil;
        self.cancelledBlock = nil;
        
        [_recorder stop];
    }
}

- (void)addRecordingTimer{
    if(_recordingTimer){
        return;
    }
    
    _recordingProgress = 0;
    _recordingTimer = [CXTimer taskTimerWithConfig:^(CXTimerConfig *config) {
        config.target = self;
        config.action = @selector(handleRecordingTimer:);
        config.interval = 1.0;
        config.repeats = YES;
    }];
    [_recordingTimer fire];
}

- (void)removeRecordingTimer{
    if(_recordingTimer.isValid){
        [_recordingTimer invalidate];
    }
    
    _recordingTimer = nil;
}

- (void)handleRecordingTimer:(NSTimer *)recordingTimer{
    if(self.progressBlock){
        self.progressBlock(self, _recordingProgress);
    }
    
    if(_recordingProgress >= self.maxDuration){
        [self stopRecording];
    }
    
    _recordingProgress ++;
}

- (void)addPeakPowerTimer{
    if(_peakPowerTimer){
        return;
    }
    
    _peakPowerTimer = [CXTimer taskTimerWithConfig:^(CXTimerConfig *config) {
        config.target = self;
        config.action = @selector(handlePeakPowerTimer:);
        config.interval = 1.0;
        config.repeats = YES;
    }];
    [_peakPowerTimer fire];
}

- (void)removePeakPowerTimer{
    if(_peakPowerTimer.isValid){
        [_peakPowerTimer invalidate];
    }
    
    _peakPowerTimer = nil;
}

- (void)handlePeakPowerTimer:(NSTimer *)peakPowerTimer{
    [_recorder updateMeters];
    
    CGFloat peakPower = [_recorder peakPowerForChannel:0];
    peakPower = pow(10, (0.05 * peakPower));
    if(self.peakPowerBlock){
        self.peakPowerBlock(self, peakPower);
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if(self.finishedBlock){
        self.finishedBlock(self, _filePath, _recordingProgress, nil);
    }else{
        CX_REMOVE_FILE(_filePath);
    }
    
    self.finishedBlock = nil;
    self.progressBlock = nil;
    self.peakPowerBlock = nil;
    self.cancelledBlock = nil;
    
    _recordingProgress = 0;
    _recorder.delegate = nil;
    _recorder = nil;
    _filePath = nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    if(self.finishedBlock){
        self.finishedBlock(self, nil, 0, error);
    }else{
        CX_REMOVE_FILE(_filePath);
    }
    
    self.finishedBlock = nil;
    self.progressBlock = nil;
    self.peakPowerBlock = nil;
    self.cancelledBlock = nil;
    
    _recordingProgress = 0;
    _recorder.delegate = nil;
    _recorder = nil;
    _filePath = nil;
}

- (BOOL)isRecording{
    return _recorder.isRecording;
}

@end
