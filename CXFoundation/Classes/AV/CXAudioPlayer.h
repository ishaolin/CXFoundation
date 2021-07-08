//
//  CXAudioPlayer.h
//  Pods
//
//  Created by wshaolin on 2019/3/26.
//

#import <Foundation/Foundation.h>

@class CXAudioPlayer;

typedef void(^CXAudioPlayerCompletionBlock)(CXAudioPlayer *player, NSError *error);

typedef void(^CXAudioPlayerProgressBlock)(CXAudioPlayer *player,
                                          NSTimeInterval currentTime,
                                          NSTimeInterval totalTime);

@interface CXAudioPlayer : NSObject

@property (nonatomic, assign, readonly) BOOL isPlaying;

+ (CXAudioPlayer *)sharedPlayer;

- (void)setAudioPlayerCategory:(NSString *)category;

- (void)playWithData:(NSData *)data
          completion:(CXAudioPlayerCompletionBlock)completion;

- (void)playWithURL:(NSURL *)fileURL
         completion:(CXAudioPlayerCompletionBlock)completion;

- (void)playWithData:(NSData *)data
            progress:(CXAudioPlayerProgressBlock)progress
          completion:(CXAudioPlayerCompletionBlock)completion;

- (void)playWithURL:(NSURL *)fileURL
           progress:(CXAudioPlayerProgressBlock)progress
         completion:(CXAudioPlayerCompletionBlock)completion;

- (void)stopPlay;

@end
