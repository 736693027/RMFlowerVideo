//
//  RMLoginView.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMLoginView.h"
#import "CONST.h"

@implementation RMLoginView

- (void)initLoginView {
    UILabel * mTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, 30)];
    mTitle.text = @"使用社交账号登陆小花视频";
    mTitle.textAlignment = NSTextAlignmentCenter;
    mTitle.textColor = [UIColor colorWithRed:0.21 green:0.22 blue:0.21 alpha:1];
    mTitle.font = FONT(18.0);
    [self addSubview:mTitle];
    
    NSArray * nameArr = [NSArray arrayWithObjects:@"新浪", @"腾讯", nil];
    
    for (int i=0; i<2; i++){
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+1;
        button.frame = CGRectMake((ScreenWidth-100)/2, 100 + i*80, 100, 40);
        [button setTitle:[nameArr objectAtIndex:i] forState:UIControlStateNormal];
        [self addSubview:button];
    }
    
}

- (void)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(loginMethodWithSender:)]){
        [self.delegate loginMethodWithSender:sender.tag];
    }
}

@end
