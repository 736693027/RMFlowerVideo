//
//  RMCustomPresentNavViewController.m
//  RMVideo
//
//  Created by runmobile on 14-11-11.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMCustomPresentNavViewController.h"

#define JuV [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0

@interface RMCustomPresentNavViewController ()

@end

@implementation RMCustomPresentNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIDeviceOrientationIsLandscape(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
