//
//  CXAudioPlayer.m
//  Pods
//
//  Created by wshaolin on 2019/3/26.
//

#import "CXAudioPlayer.h"
#import "CXTimer.h"
#import "CXInvocation.h"
#import <AVFoundation/AVFoundation.h>

@interface CXAudioPlayer () <AVAudioPlayerDelegate> {
    AVAudioPlayer *_player;
    CXTimer *_progresTimer;
}

@property (nonatomic, copy) CXAudioPlayerCompletionBlock completion;
@property (nonatomic, copy) CXAudioPlayerProgressBlock progress;

@end

@implementation CXAudioPlayer

+ (CXAudioPlayer *)sharedPlayer{
    static CXAudioPlayer *_audioPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _audioPlayer = [[CXAudioPlayer alloc] init];
    });
    
    return _audioPlayer;
}

- (void)setAudioPlayerCategory:(AVAudioSessionCategory)category{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:category
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionDuckOthers | AVAudioSessionCategoryOptionAllowBluetooth | AVAudioSessionCategoryOptionDefaultToSpeaker
                        error:nil];
    [audioSession setActive:YES error:nil];
}

- (void)playWithData:(NSData *)data completion:(CXAudioPlayerCompletionBlock)completion{
    [self playWithData:data progress:nil completion:completion];
}

- (void)playWithURL:(NSURL *)fileURL completion:(CXAudioPlayerCompletionBlock)completion{
    [self playWithURL:fileURL progress:nil completion:completion];
}

- (void)playWithData:(NSData *)data
            progress:(CXAudioPlayerProgressBlock)progress
          completion:(CXAudioPlayerCompletionBlock)completion{
    if(!data){
        if(completion){
            completion(self, nil);
        }
        return;
    }
    
    [self stopPlay];
    
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    [self playByPlayer:player progress:progress completion:completion error:error];
}

- (void)playWithURL:(NSURL *)fileURL
           progress:(CXAudioPlayerProgressBlock)progress
         completion:(CXAudioPlayerCompletionBlock)completion{
    if(!fileURL){
        if(completion){
            completion(self, nil);
        }
        return;
    }
    
    [self stopPlay];
    
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    [self playByPlayer:player progress:progress completion:completion error:error];
}

- (void)playByPlayer:(AVAudioPlayer *)player
            progress:(CXAudioPlayerProgressBlock)progress
          completion:(CXAudioPlayerCompletionBlock)completion
               error:(NSError *)error{
    if(player){
        self.progress = progress;
        self.completion = completion;
        
        _player = player;
        _player.delegate = self;
        [_player prepareToPlay];
        [_player play];
        
        if(self.progress && !_progresTimer){
            _progresTimer = [CXTimer taskTimerWithConfig:^(CXTimerConfig *config) {
                config.target = self;
                config.action = @selector(handlePlayProgres:);
                config.interval = 1.0;
                config.repeats = YES;
            }];
        }
    }else{
        if(completion){
            completion(self, error);
        }
    }
}

- (void)handlePlayProgres:(CXTimer *)timer{
    !self.progress ?: self.progress(self, _player.currentTime, _player.duration);
}

- (void)removeProgresTimer{
    if(_progresTimer.isValid){
        [_progresTimer invalidate];
    }
    
    _progresTimer = nil;
}

- (void)stopPlay{
    if(!_player){
        return;
    }
    
    if(_player.isPlaying){
        [_player stop];
    }
    
    _player.delegate = nil;
    _player = nil;
    [self removeProgresTimer];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    CXAudioPlayerCompletionBlock completion = self.completion;
    self.completion = nil;
    self.progress = nil;
    _player.delegate = nil;
    _player = nil;
    [self removeProgresTimer];
    !completion ?: completion(self, nil);
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    CXAudioPlayerCompletionBlock completion = self.completion;
    self.completion = nil;
    self.progress = nil;
    _player.delegate = nil;
    _player = nil;
    [self removeProgresTimer];
    !completion ?: completion(self, nil);
}

- (BOOL)isPlaying{
    return _player.isPlaying;
}

@end
