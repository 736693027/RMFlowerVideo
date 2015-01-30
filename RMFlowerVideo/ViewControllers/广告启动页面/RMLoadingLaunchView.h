//
//  RMLoadingView.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-1.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadingDelegate <NSObject>

/**
 *  跳过loadingView
 */
- (void)jumpLoadingMethod;

/**
 *  播放loadingView视频
 */
- (void)playLoadingMethod;

@end

@interface RMLoadingLaunchView : UIView
@property (nonatomic, weak) id<LoadingDelegate> loadingDelegate;

/**
 *  加载loadingView图片
 *  @param  image               loadingView图片
 */
- (void)initLoadingViewWithImage:(UIImage *)image isVideo:(BOOL)video;

@end
