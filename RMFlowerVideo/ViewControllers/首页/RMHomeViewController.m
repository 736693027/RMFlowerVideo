//
//  RMHomeViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 14-12-30.
//  Copyright (c) 2014年 润滑联动. All rights reserved.
//

#import "RMHomeViewController.h"
#import "SUNSlideSwitchView.h"
#import "RMHomeMovieViewController.h"
#import "RMHomeTVViewController.h"
#import "RMHomeVarietyViewController.h"
#import "RMHomeStartViewController.h"
#import "RMLoadingWebViewController.h"
#import "RMVideoPlaybackDetailsViewController.h"
#import "Flurry.h"

@interface RMHomeViewController ()<SUNSlideSwitchViewDelegate>{
    RMHomeMovieViewController *movieViewContro;
    RMHomeTVViewController *tvViewContro;
    RMHomeVarietyViewController *varietyViewContro;
    RMHomeStartViewController *startViewContro;
    SUNSlideSwitchView *slideSwitchView;
}

@end

@implementation RMHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Flurry logEvent:@"VIEW_Home" timed:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"VIEW_Home" withParameters:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [movieViewContro startRequest];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:NO];

    slideSwitchView = [[SUNSlideSwitchView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight-49-20)];
    slideSwitchView.viewControllerIdentify = @"首页";
    slideSwitchView.tabItemNormalColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    slideSwitchView.tabItemSelectedColor = [UIColor colorWithRed:0.9 green:0.29 blue:0.2 alpha:1];

    slideSwitchView.slideSwitchViewDelegate = self;
    slideSwitchView.isAmplificationBtn = YES;
    [self.view addSubview:slideSwitchView];

    movieViewContro = [[RMHomeMovieViewController alloc] init];
    movieViewContro.delegate = self;
    movieViewContro.title = @"电影";
    
    tvViewContro = [[RMHomeTVViewController alloc] init];
    tvViewContro.delegate = self;
    tvViewContro.title = @"电视剧";
    
    varietyViewContro = [[RMHomeVarietyViewController alloc] init];
    varietyViewContro.delegate = self;
    varietyViewContro.title = @"综艺";
    
    startViewContro = [[RMHomeStartViewController alloc] init];
    startViewContro.delegate = self;
    startViewContro.title = @"明星";
    
    [slideSwitchView buildUI];

}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view {
    return 4;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return movieViewContro;
    } else if (number == 1) {
        return tvViewContro;
    } else if (number == 2) {
        return varietyViewContro;
    } else if (number == 3) {
        return startViewContro;
    } else {
        return nil;
    }
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam {
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number {
    RMBaseViewController *viewContro = nil;
    if (number == 0) {
        viewContro = movieViewContro;
        [self hideLoading];
    } else if (number == 1) {
        viewContro = tvViewContro;
        [self hideLoading];
        [tvViewContro requestData];
    } else if (number == 2) {
        viewContro = varietyViewContro;
        [self hideLoading];
        [varietyViewContro requestData];
    } else if (number == 3) {
        viewContro = startViewContro;
        [self hideLoading];
        [startViewContro requestData];
    }
}

- (void)loadingViewJumpWebWithURL:(NSString *)url{
    RMLoadingWebViewController *loadingWebVC = [[RMLoadingWebViewController alloc] init];
    loadingWebVC.loadingUrl = url;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [self presentViewController:loadingWebVC animated:YES completion:nil];
}

- (void)loadingViewJumpVideoDetailWithID:(NSString *)video_ID{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    RMVideoPlaybackDetailsViewController * videoPlaybackDetailsCtl = [[RMVideoPlaybackDetailsViewController alloc] init];
    videoPlaybackDetailsCtl.video_id = video_ID;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [self presentViewController:videoPlaybackDetailsCtl animated:YES completion:^{
    }];
}

@end
