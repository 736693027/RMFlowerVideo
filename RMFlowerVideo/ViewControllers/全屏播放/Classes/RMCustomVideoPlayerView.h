//
//  RMCustomVideoPlayerView.h
//  RMCustomPlayer
//
//  Created by runmobile on 14-12-3.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class RMCustomVideoPlayerView;

@interface RMCustomVideoPlayerView : UIView
@property (assign, nonatomic) BOOL isFullScreenMode;
@property (assign, nonatomic) BOOL isPlaying;

@property (strong, nonatomic) NSURL *contentURL;

@property (strong, nonatomic) AVPlayer *moviePlayer;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, assign) id RMCustomVideoplayerDeleagte;

- (void)contentURL:(NSURL*)contentURL;      //加载url
- (void)replaceCurrentItem;                 //释放当前播放资源

- (void)play;                               //播放
- (void)pause;                              //暂停

- (void)removeObserver;                     //移除监听

@end
