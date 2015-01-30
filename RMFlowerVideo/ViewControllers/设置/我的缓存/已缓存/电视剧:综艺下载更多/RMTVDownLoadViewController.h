//
//  RMTVDownLoadViewController.h
//  RMVideo
//
//  Created by 润华联动 on 14-10-15.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMTVDownLoadViewController : RMBaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *headScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (copy, nonatomic) NSString *video_id;
@property (copy, nonatomic) NSString *videoName;
@property (copy, nonatomic) NSString *videoHeadImage;
@property (copy, nonatomic) NSString *actors;
@property (copy, nonatomic) NSString *director;
@property (copy ,nonatomic) NSString *PlayCount;
@property (strong, nonatomic) NSMutableArray *TVdataArray;
@property (nonatomic) BOOL isNavPushViewController;
@property (weak, nonatomic) IBOutlet UIButton *showDownLoadTVCountBtn;
- (IBAction)showDownLoadDetailClick:(UIButton *)sender;

- (IBAction)downAllTVEpisode:(UIButton *)sender;
@end
