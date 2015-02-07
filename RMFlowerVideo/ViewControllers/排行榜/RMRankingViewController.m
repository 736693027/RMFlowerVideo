//
//  RMRankingViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 14-12-30.
//  Copyright (c) 2014年 润滑联动. All rights reserved.
//

#import "RMRankingViewController.h"
#import "RMRankingMovieViewController.h"
#import "RMRankingTVViewController.h"
#import "RMRankingVarietyViewController.h"
#import "SUNSlideSwitchView.h"
#import "Flurry.h"

@interface RMRankingViewController ()<SUNSlideSwitchViewDelegate>{
    RMRankingMovieViewController *rankingMovieCtl;
    RMRankingTVViewController *rankingTVCtl;
    RMRankingVarietyViewController *rankingVarietyCtl;
    SUNSlideSwitchView *slideSwitchView;
}

@end

@implementation RMRankingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Flurry logEvent:@"VIEW_Ranking" timed:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"VIEW_Ranking" withParameters:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [rankingMovieCtl startRequest];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:NO];

    slideSwitchView = [[SUNSlideSwitchView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight-49-20)];
    slideSwitchView.viewControllerIdentify = @"排行榜";
    slideSwitchView.tabItemNormalColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    slideSwitchView.tabItemSelectedColor = [UIColor colorWithRed:0.9 green:0.29 blue:0.2 alpha:1];
//    slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"] stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    slideSwitchView.slideSwitchViewDelegate = self;
    slideSwitchView.isAmplificationBtn = YES;
    [self.view addSubview:slideSwitchView];

    rankingMovieCtl = [[RMRankingMovieViewController alloc] init];
    rankingMovieCtl.delegate = self;
    rankingMovieCtl.title = @"电影";
    
    rankingTVCtl = [[RMRankingTVViewController alloc] init];
    rankingTVCtl.delegate = self;
    rankingTVCtl.title = @"电视剧";
    
    rankingVarietyCtl = [[RMRankingVarietyViewController alloc] init];
    rankingVarietyCtl.delegate = self;
    rankingVarietyCtl.title = @"综艺";
  
    [slideSwitchView buildUI];

}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view {
    return 3;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number {
    if (number == 0) {
        return rankingMovieCtl;
    } else if (number == 1) {
        return rankingTVCtl;
    } else if (number == 2) {
        return rankingVarietyCtl;
    } else {
        return nil;
    }
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam {
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number {
    if (number == 0) {
        
    } else if (number == 1) {
        [rankingTVCtl requestData];
    } else if (number == 2) {
        [rankingVarietyCtl requestData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
