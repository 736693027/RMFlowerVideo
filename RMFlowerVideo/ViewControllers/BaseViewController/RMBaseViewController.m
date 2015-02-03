//
//  RMBaseViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 14-12-30.
//  Copyright (c) 2014年 润滑联动. All rights reserved.
//

#import "RMBaseViewController.h"
#import "UIButton+EnlargeEdge.h"
#import <unistd.h>

@interface RMBaseViewController ()<MBProgressHUDDelegate>{
    UIView * customNav;
    UILabel * titleLabel;
    UIView * statusView;
    
    UIView * emptyView;
    UIImageView * emptyImg;
    UILabel * emptyTitle;
}

@end

@implementation RMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
        
    }
    
    statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    statusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:statusView];
    
    customNav = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    customNav.backgroundColor = [UIColor whiteColor];
    customNav.userInteractionEnabled = YES;
    customNav.multipleTouchEnabled = YES;
    [self.view addSubview:customNav];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, ScreenWidth - 80, 44)];
    titleLabel.userInteractionEnabled = YES;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = FONT(20.0);
    titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(ScreenWidth/2, 22);
    [customNav addSubview:titleLabel];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 42, ScreenWidth, 2)];
    line.backgroundColor = [UIColor colorWithRed:0.91 green:0.33 blue:0.22 alpha:1];
    line.userInteractionEnabled = YES;
    [customNav addSubview:line];
    
    leftBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarButton.frame = CGRectMake(7, 14, 43, 16);
    leftBarButton.tag = 1;
    [leftBarButton addTarget:self action:@selector(navgationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftBarButton setEnlargeEdgeWithTop:25 right:25 bottom:25 left:25];
    [customNav addSubview:leftBarButton];
    
    rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButton.frame = CGRectMake(ScreenWidth - 50, 14, 43, 16);
    rightBarButton.tag = 2;
    [rightBarButton addTarget:self action:@selector(navgationBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButton setEnlargeEdgeWithTop:25 right:25 bottom:25 left:25];
    [customNav addSubview:rightBarButton];

    if (!emptyView){
        emptyView = [[UIView alloc] init];
        emptyView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight-64);
        emptyView.userInteractionEnabled = YES;
        emptyView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:emptyView];
        emptyView.hidden = YES;
        
        emptyImg = [[UIImageView alloc] init];
        emptyImg.backgroundColor = [UIColor clearColor];
        emptyImg.userInteractionEnabled = YES;
        [emptyView addSubview:emptyImg];
        
        emptyTitle = [[UILabel alloc] init];
        emptyTitle.frame = CGRectMake(0, 0, ScreenWidth, 30);
        emptyTitle.center = CGPointMake(ScreenWidth/2, ScreenHeight/2 + 110);
        emptyTitle.textAlignment = NSTextAlignmentCenter;
        emptyTitle.textColor = [UIColor blackColor];
        emptyTitle.backgroundColor = [UIColor clearColor];
        emptyTitle.font = FONT(18.0);
        [emptyView addSubview:emptyTitle];
    }
}

- (void)hideCustomNavigationBar:(BOOL)navigationBar withHideCustomStatusBar:(BOOL)statusBar {
    customNav.hidden = navigationBar;
    statusView.hidden = statusBar;
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    //Ignore this super method
}

- (void)setCustomNavTitle:(NSString *)title {
    titleLabel.text = title;
}

- (void)showEmptyWithImage:(NSString *)imageName withImageSize:(CGSize)size withTitle:(NSString *)title {
    emptyView.hidden = NO;
    emptyImg.frame = CGRectMake(0, 0, size.width, size.height);
    emptyImg.center = CGPointMake(ScreenWidth/2, ScreenHeight/2 - 64);
    emptyImg.image = LOADIMAGE(imageName);
    emptyTitle.text = title;
    emptyTitle.center = CGPointMake(ScreenWidth/2, emptyImg.center.y + size.height/2 + 30);
}

- (void)hideEmpty {
    emptyView.hidden = YES;
}

#pragma mark - HUD Method-

- (void)showLoadingSimpleWithUserInteractionEnabled:(BOOL)enabled {
    if (!HUD){
        HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.userInteractionEnabled  = !enabled;
    // Set the hud to display with a color
    HUD.color = [UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:0.5];
    
    HUD.delegate = self;
    [HUD show:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)showLoadingWithText:(NSString *)text withUserInteractionEnabled:(BOOL)enabled {
    if (!HUD){
        HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    }
    HUD.userInteractionEnabled  = !enabled;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = text;
    [HUD show:YES];
}

- (void)showLoadingWithLabelDeterminate:(NSString *)text withUserInteractionEnabled:(BOOL)enabled{
    if (!HUD){
        HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    }
    HUD.userInteractionEnabled  = !enabled;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = text;
    [HUD show:YES];
}

- (void)showLoadingWithLabelAnnularDeterminate:(NSString *)text withUserInteractionEnabled:(BOOL)enabled{
    if (!HUD){
        HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    }
    HUD.userInteractionEnabled  = !enabled;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    HUD.labelText = text;
    [HUD showWhileExecuting:@selector(hudProgressTask:) onTarget:self withObject:HUD animated:YES];
}


- (void)showLoadingCustomViewWithImage:(NSString *)imageName withText:(NSString *)text withUserInteractionEnabled:(BOOL)enabled{
    if (!HUD){
        HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    }
    HUD.userInteractionEnabled  = !enabled;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = text;
    [HUD show:YES];
}

- (void)showLoadingWithGradientWithUserInteractionEnabled:(BOOL)enabled{
    if (!HUD){
        HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    }
    HUD.userInteractionEnabled  = !enabled;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
}

- (void)showLoadingWithGradientAndText:(NSString *)text withUserInteractionEnabled:(BOOL)enabled{
    if (!HUD){
        HUD = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    }
    HUD.userInteractionEnabled  = !enabled;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.labelText = text;
    HUD.delegate = self;
    [HUD show:YES];
}

- (void)showMessage:(NSString *)message duration:(NSTimeInterval)interval withUserInteractionEnabled:(BOOL)enabled{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    HUD.userInteractionEnabled  = !enabled;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:interval];
}

- (void)showMessage:(NSString *)message duration:(NSTimeInterval)interval position:(NSInteger)position withUserInteractionEnabled:(BOOL)enabled {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    HUD.userInteractionEnabled  = enabled;

    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.labelFont = FONT(12.0);
    hud.margin = 10.f;
    
    switch (position) {
        case CENTER:{
            hud.yOffset = 0;
        }
            break;
        case TOP:{
            hud.yOffset = 110 - CGRectGetHeight(self.view.frame)/2;
        }
            break;
        case BOTTOM:{
            hud.yOffset = CGRectGetHeight(self.view.frame)/2 - 40;
        }
            break;
            
        default:
            break;
    }
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.0];
}

- (void)hideLoading {
    [HUD hide:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//进度处理交给子类去实现
- (void)hudProgressTask:(MBProgressHUD *)hud {
    
}

#pragma mark - MBProgressHUD delegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)showHUDWithImage:(NSString *)imageName imageFrame:(CGRect)frame duration:(NSTimeInterval)interval userInteractionEnabled:(BOOL)enabled {
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = enabled;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    if (!HUDImageView){
        HUDImageView = [[UIImageView alloc] init];
        HUDImageView.frame = frame;
        HUDImageView.center = CGPointMake(width/2, height/2);
        HUDImageView.backgroundColor = [UIColor clearColor];
        HUDImageView.image = [UIImage imageNamed:imageName];
        HUDImageView.alpha = 0.f;
        [[UIApplication sharedApplication].keyWindow addSubview:HUDImageView];
    }
    
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        HUDImageView.alpha = 1.0f;
    } completion:^(BOOL finished) {

    }];
    
    [self hideHUDImageWithAnimation:YES afterDelay:interval];
}

- (void)hideHUDImageWithAnimation:(BOOL)animation afterDelay:(NSTimeInterval)interval {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            HUDImageView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [HUDImageView removeFromSuperview];
            HUDImageView = nil;
        }];
    });
}

@end
