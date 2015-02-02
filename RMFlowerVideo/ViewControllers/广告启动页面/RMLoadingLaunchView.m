//
//  RMLoadingView.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-1.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMLoadingLaunchView.h"
#import "CONST.h"
#import "UIImageView+WebCache.h"

@implementation RMLoadingLaunchView

- (void)initLoadingViewWithImageUrl:(NSString *)url isVideo:(BOOL)video{
    UIImageView * headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , ScreenWidth, ScreenHeight)];
    
    NSString * placehouderImg;
    if(self.window.frame.size.height==480){
        placehouderImg = @"Default_4";
    }else if (self.window.frame.size.height == 568){
        placehouderImg = @"Default_5";
    }else if (self.window.frame.size.height == 667){
        placehouderImg = @"Default_6";
    }else{
        placehouderImg = @"Default_6p";
    }
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:LOADIMAGE(placehouderImg) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        UIButton * jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jumpBtn.frame = CGRectMake(ScreenWidth - 90, 30, 70, 27);
        [jumpBtn setBackgroundImage:LOADIMAGE(@"jump") forState:UIControlStateNormal];
        [jumpBtn addTarget:self action:@selector(jumpClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:jumpBtn];
        
        if(!video){
            headImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playClick)];
            tapGesture.numberOfTouchesRequired = 1;
            [headImageView addGestureRecognizer:tapGesture];
        }else{
            UIButton *PlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            PlayBtn.frame = CGRectMake(ScreenWidth - 90, ScreenHeight - 90, 60, 60);
            [PlayBtn setBackgroundImage:LOADIMAGE(@"loadingPlay") forState:UIControlStateNormal];
            [PlayBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:PlayBtn];
        }
    }];
    headImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:headImageView];
}

/**
 *  跳过loadingView
 */
- (void)jumpClick {
    if ([self.loadingDelegate respondsToSelector:@selector(jumpLoadingMethod)]){
        [self.loadingDelegate jumpLoadingMethod];
    }
}

/**
 *  播放loadingView视频
 */
- (void)playClick {
    if ([self.loadingDelegate respondsToSelector:@selector(playLoadingMethod)]){
        [self.loadingDelegate playLoadingMethod];
    }
}

@end
