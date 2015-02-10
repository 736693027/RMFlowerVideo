//
//  RMPlayer.m
//  RMCustomPlayer
//
//  Created by runmobile on 14-12-5.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMPlayer.h"
#import "RMCustomVideoplayerViewController.h"
#import "RMUtilityFunc.h"

@interface RMPlayer () {

}

@end

@implementation RMPlayer

+ (RMCustomVideoplayerViewController *)initVideoPlay:(id)sender {
    if ([RMUtilityFunc isConnectionAvailable] == 0){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前无网络连接，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    [self getUIScreenBounds];
    RMCustomVideoplayerViewController * customVideoplayerCtl = [[RMCustomVideoplayerViewController alloc] init];
    [sender presentViewController:customVideoplayerCtl animated:YES completion:^{
    }];
    return customVideoplayerCtl;
}

+ (void)presentVideoPlayerWithPlayModel:(RMModel *)model
                   withUIViewController:(id)sender
                          withVideoType:(NSInteger)type
                    withIsLocationVideo:(BOOL)location{
    RMCustomVideoplayerViewController * customVideoplayerCtl = [self initVideoPlay:sender];
    customVideoplayerCtl.videlModel = model;
    customVideoplayerCtl.videoType = type;
    customVideoplayerCtl.isLoactionVideo = location;
}

+ (void)presentVideoPlayerWithPlayArr:(NSMutableArray *)playArr
                    withUIViewController:(id)sender
                           withVideoType:(NSInteger)type
                  withIsLocationVideo:(BOOL)location{
    RMCustomVideoplayerViewController * customVideoplayerCtl = [self initVideoPlay:sender];
    customVideoplayerCtl.currentPlayOrder = 0;
    customVideoplayerCtl.playModelArr = playArr;
    customVideoplayerCtl.videoType = type;
    customVideoplayerCtl.isLoactionVideo = location;
}

+ (void)presentVideoPlayerCurrentOrder:(NSInteger)current
                        withPlayArr:(NSMutableArray *)playArr
                  withUIViewController:(id)sender
                         withVideoType:(NSInteger)type
                   withIsLocationVideo:(BOOL)location{
    RMCustomVideoplayerViewController * customVideoplayerCtl = [self initVideoPlay:sender];
    customVideoplayerCtl.currentPlayOrder = current;
    customVideoplayerCtl.playModelArr = playArr;
    customVideoplayerCtl.videoType = type;
    customVideoplayerCtl.isLoactionVideo = location;
}

+ (void)getUIScreenBounds{
    //屏幕宽 高
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [RMUtilityFunc shareInstance].globleWidth = screenRect.size.width;
    [RMUtilityFunc shareInstance].globleHeight = screenRect.size.height-20;
    [RMUtilityFunc shareInstance].globleAllHeight = screenRect.size.height;
}

/**
 *  获取当前显示的UIViewController
 */
+ (UIViewController *)getCurrentRootViewController {
    UIViewController *result;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (topWindow.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows){
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [topWindow subviews].firstObject;
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isMemberOfClass:[UIViewController class]]){
        result = nextResponder;
    }else if([nextResponder isMemberOfClass:[UITabBarController class]] | [nextResponder isMemberOfClass:[UINavigationController class]]){
        result = [self findViewController:nextResponder];
    }else if([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil){
        result = topWindow.rootViewController;
    }else{
        NSAssert(NO, @"找不到顶端VC");
    }
    return result;
}

+ (UIViewController *)findViewController:(id)controller{
    if ([controller isMemberOfClass:[UINavigationController class]]) {
        return [self findViewController:[(UINavigationController *)controller visibleViewController]];
    }else if([controller isMemberOfClass:[UITabBarController class]]){
        return [self findViewController:[(UITabBarController *)controller selectedViewController]];
    }else if([controller isKindOfClass:[UIViewController class]]){
        return controller;
    }else{
        NSAssert(NO, @"找不到顶端VC");
        return nil;
    }
}

@end
