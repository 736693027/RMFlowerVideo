//
//  RMSearchErrorView.m
//  RMFlowerVideo
//
//  Created by runmobile on 15/2/5.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMSearchErrorView.h"
#import "CONST.h"

@implementation RMSearchErrorView

- (void)loadSearchErrorView {
    UIImageView * errorImg = [[UIImageView alloc] init];
    errorImg.frame = CGRectMake(0, 0, 55, 55);
    errorImg.center = CGPointMake(ScreenWidth/2, (ScreenHeight-60)/2);
    errorImg.backgroundColor = [UIColor clearColor];
    errorImg.image = LOADIMAGE(@"empty");
    [self addSubview:errorImg];
    
    UILabel * error = [[UILabel alloc] init];
    error.text = @"没有搜索结果";
    error.textAlignment = NSTextAlignmentCenter;
    error.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    error.frame = CGRectMake(0, 0, ScreenWidth, 30);
    error.center = CGPointMake(ScreenWidth/2, (ScreenHeight+60)/2);
    error.backgroundColor = [UIColor clearColor];
    error.font = FONT(18.0);
    [self addSubview:error];
}

@end
