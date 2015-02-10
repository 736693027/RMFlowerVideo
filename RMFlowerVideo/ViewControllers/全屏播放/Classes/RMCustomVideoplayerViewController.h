//
//  RMCustomVideoplayerViewController.h
//  RMCustomPlayer
//
//  Created by runmobile on 14-12-3.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMModel.h"

typedef enum : NSInteger {
    UnknownType = 0,
    MovieType = 1,
    TeleplayType = 2
}VideoType;

@interface RMCustomVideoplayerViewController : UIViewController

@property (nonatomic, strong) RMModel * videlModel;                 //单个视频播放相关
@property (nonatomic, copy) NSMutableArray *playModelArr;           //电视剧相关

@property (nonatomic, assign) VideoType videoType;                  //将要播放视频的类型

@property (nonatomic, strong) UIButton * playBtn;                   //播放 暂停
@property (nonatomic, strong) UISlider * progressBar;               //播放进度条
@property (nonatomic, strong) UIProgressView * cacheProgress;       //已缓存进度条
@property (nonatomic, strong) UIImageView * belowView;              //下工具条
@property (nonatomic, assign) NSInteger currentPlayOrder;           //电视剧当前播放的集数
@property (nonatomic, assign) BOOL isLoactionVideo;                //是否播放本地视频

- (void)playerFinishedPlay;
- (void)showHUD;
- (void)hideHUD;


@end
