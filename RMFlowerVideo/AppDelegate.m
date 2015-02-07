//
//  AppDelegate.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 14-12-30.
//  Copyright (c) 2014年 润滑联动. All rights reserved.
//

#import "AppDelegate.h"
#import "RMLoadingLaunchView.h"                 //启动loadingView页面
#import "Animations.h"                          //动画

#import "RMCustomNavViewController.h"           //自定义Nav
#import "RMCustomTabBarController.h"            //自定义TabBar
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "RMHomeViewController.h"
#import "RMRankingViewController.h"
#import "RMSpecialEditionViewController.h"
#import "RMSetViewController.h"
#import "CONST.h"
#import "RMDownLoadingViewController.h"
#import "Flurry.h"
#import "Harpy.h"
#import "APService.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#define SocialJump @"http://vodadmin.runmobile.cn/app_check.html"

@interface AppDelegate ()<LoadingDelegate,RMAFNRequestManagerDelegate> {
    BOOL isFadeOut;
    RMLoadingLaunchView *loadingView;
    RMCustomTabBarController *customTabBarCtl;
    RMPublicModel *downLoadModel;
    RMHomeViewController *homeCtl;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self laodDefaultBackgroundView];

    [self loadSocial];
    [self loadFlurry];
    [self loadFileStorage];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger device = 0;
        if (IS_IPHONE_4_SCREEN){
            device = 1;
        }else{
            device = 2;
        }
        RMAFNRequestManager * manager = [[RMAFNRequestManager alloc] init];
        manager.delegate = self;
        [manager getLoadingWithDevice:[NSString stringWithFormat:@"%ld",(long)device]];
    });
    
    //检查App更新(UpData)
    if ([UtilityFunc isConnectionAvailable] != 0) {
        [Harpy checkVersion];
    }
    
    if (launchOptions) {
        NSDictionary * pushDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushDict) {
            [application setApplicationIconBadgeNumber:0];
        }
    }
    //JPush
    [self loadJPushWithOptions:launchOptions];
    
    [Fabric with:@[CrashlyticsKit]];

    return YES;
}

- (void)laodDefaultBackgroundView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(self.window.frame.size.height==480){
        [imageView setImage:[UIImage imageNamed:@"Default_4"]];
    }else if (self.window.frame.size.height == 568){
        [imageView setImage:[UIImage imageNamed:@"Default_5"]];
    }else if (self.window.frame.size.height == 667){
        [imageView setImage:[UIImage imageNamed:@"Default_6"]];
    }else{
        [imageView setImage:[UIImage imageNamed:@"Default_6p"]];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:imageView];
}

- (void)loadMainViewCrollers{
    homeCtl = [[RMHomeViewController alloc] init];
    RMRankingViewController *rankingCtl = [[RMRankingViewController alloc] init];
    RMSpecialEditionViewController *specialEditionCtl = [[RMSpecialEditionViewController alloc] init];
    RMSetViewController *setCtl = [[RMSetViewController alloc] init];
    
    NSArray *controllers = [[NSArray alloc] initWithObjects:homeCtl, rankingCtl, specialEditionCtl,setCtl, nil];
    
    customTabBarCtl = [[RMCustomTabBarController alloc] init];
    ((RMCustomTabBarController *)customTabBarCtl).tabbarHeight = TabBarHeight;
    ((RMCustomTabBarController *)customTabBarCtl).TabarItemWidth = kScreenWidth/4.0f;
    ((RMCustomTabBarController *)customTabBarCtl).isInDeck = YES;
    ((UITabBarController *)customTabBarCtl).viewControllers = controllers;
    UIButton *button0 = [((RMCustomTabBarController *)customTabBarCtl) customTabbarItemWithIndex:0];
    UIButton *button1 = [((RMCustomTabBarController *)customTabBarCtl) customTabbarItemWithIndex:1];
    UIButton *button2 = [((RMCustomTabBarController *)customTabBarCtl) customTabbarItemWithIndex:2];
    UIButton *button3 = [((RMCustomTabBarController *)customTabBarCtl) customTabbarItemWithIndex:3];
    
    NSArray * imageName;
    if (IS_IPHONE_6_SCREEN){
        imageName = [NSArray arrayWithObjects:@"home_selected_6", @"ranking_unselected_6", @"myChannel_unselected_6", @"setUp_unselected_6", nil];
    }else if (IS_IPHONE_6p_SCREEN){
        imageName = [NSArray arrayWithObjects:@"home_selected_6p", @"ranking_unselected6_6p", @"myChannel_unselected_6p", @"setUp_unselected_6p", nil];
    }else{
        imageName = [NSArray arrayWithObjects:@"home_selected", @"ranking_unselected", @"myChannel_unselected", @"setUp_unselected", nil];
    }
    
    [button0 setBackgroundImage:LOADIMAGE([imageName objectAtIndex:0]) forState:UIControlStateNormal];
    [button1 setBackgroundImage:LOADIMAGE([imageName objectAtIndex:1]) forState:UIControlStateNormal];
    [button2 setBackgroundImage:LOADIMAGE([imageName objectAtIndex:2])  forState:UIControlStateNormal];
    [button3 setBackgroundImage:LOADIMAGE([imageName objectAtIndex:3]) forState:UIControlStateNormal];
    
    [((RMCustomTabBarController *)customTabBarCtl) clickButtonWithIndex:0];
    RMCustomNavViewController *nav = [[RMCustomNavViewController alloc] initWithRootViewController:customTabBarCtl];
    nav.navigationBar.hidden = YES;
    [self.window setRootViewController:nav];
}

- (void)laodLoadingViewWithImage:(NSString *)imageUrl {
    [self loadMainViewCrollers];
    loadingView = [[RMLoadingLaunchView alloc] init];
    loadingView.loadingDelegate = self;
    loadingView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    if([downLoadModel.video_id isEqualToString:@"0"]){  //推广
        [loadingView initLoadingViewWithImageUrl:imageUrl isVideo:NO];
    }else{  //视频
        [loadingView initLoadingViewWithImageUrl:imageUrl isVideo:YES];
    }
    loadingView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:loadingView];
}

- (void)loadFileStorage {
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
    NSString * loginStatus = [AESCrypt decrypt:[storage objectForKey:LoginStatus_KEY] password:PASSWORD];
    if (loginStatus == nil){
        [storage beginUpdates];
        NSString * loginStatus = [AESCrypt encrypt:@"notlogin" password:PASSWORD];
        [storage setObject:loginStatus forKey:LoginStatus_KEY];
        [storage endUpdates];
    }
}

/**
 *  跳过loadingView
 */
- (void)jumpLoadingMethod {
    [Animations fadeOut:loadingView andAnimationDuration:1 andWait:NO];
    isFadeOut = YES;
}

/**
 *  播放loadingView视频
 */
- (void)playLoadingMethod {
    isFadeOut = YES;
    [loadingView removeFromSuperview];
    if([downLoadModel.video_id isEqualToString:@"0"]){
        [homeCtl loadingViewJumpWebWithURL:downLoadModel.source_url];
    }else{
        [homeCtl loadingViewJumpVideoDetailWithID:downLoadModel.video_id];
    }
}

#pragma mark - 请求 RMAFNRequestManagerDelegate

- (void)requestFinishiDownLoadWithModel:(RMPublicModel *)model {
    downLoadModel = model;
    [self laodLoadingViewWithImage:model.pic];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (!isFadeOut){
            [Animations fadeOut:loadingView andAnimationDuration:1 andWait:NO];
        }
    });
}

- (void)requestError:(NSError *)error {
    [self loadMainViewCrollers];
}

- (void)loadJPushWithOptions:(NSDictionary *)launchOptions {
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
}

#pragma mark - Flurry

- (void)loadFlurry {
    [Flurry setCrashReportingEnabled:NO];
    [Flurry startSession:@"PJZBVWP6HTXW8FZFFZW5"];
}

#pragma mark- 社会化

- (void)loadSocial {//@"http://sns.whalecloud.com/sina2/callback"
    [UMSocialData setAppKey:UMengAppKey];
    [UMSocialData openLog:NO];
    [UMSocialWechatHandler setWXAppId:@"wx4ec79b76fc3d8f4e" appSecret:@"7ea6a6911a6e1b6982e41b06c15073f8" url:SocialJump];
    [UMSocialQQHandler setQQWithAppId:@"1103514725" appKey:@"DPr140rgS4i2L53j" url:SocialJump];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialQQHandler setSupportWebView:YES];
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *urlStr = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    if ([urlStr isEqualToString:@"flowervideo://flower/open"]){
        //第三方跳到小花视频
        return  YES;
    }else{
        //处理社会化事件
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    // 在这里加上你需要长久运行的代码
    RMDownLoadingViewController *downLoading = [RMDownLoadingViewController shared];
    if(downLoading.dataArray.count>0){
        [downLoading saveData];
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:downLoading.dataArray];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:DownLoadDataArray_KEY];
        NSLog(@"成功保存");
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:DownLoadDataArray_KEY];
        
    }
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler {
    self.backgroundSessionCompletionHandler = completionHandler;
    //add notification
}

#pragma mark- JPush

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [application setApplicationIconBadgeNumber:0];
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)beingBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}

@end
