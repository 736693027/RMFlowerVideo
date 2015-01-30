//
//  RMPlayTVEpisodeViewController.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 15/1/15.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMBaseViewController.h"

@protocol TVEpisodeDelegate <NSObject>

- (void)videoEpisodeWithOrder:(NSInteger)order;

@end

@interface RMPlayTVEpisodeViewController : RMBaseViewController
@property (nonatomic, assign) id<TVEpisodeDelegate>delegate;
@property (nonatomic, assign) id videoPlaybackDetailsDelegate;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

- (void)reloadDataWithModel:(RMPublicModel *)model withVideoSourceType:(NSString *)type;


@end
