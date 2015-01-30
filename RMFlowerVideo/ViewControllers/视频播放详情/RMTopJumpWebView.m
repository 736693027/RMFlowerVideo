//
//  RMTopJumpWebView.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-26.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMTopJumpWebView.h"
#import "CONST.h"

@implementation RMTopJumpWebView

- (void)initTopJumpWebView {
    self.userInteractionEnabled = YES;
    UILabel * name = [[UILabel alloc] init];
    name.text = @"将为您跳到第三方视频";
    name.textColor = [UIColor whiteColor];
    name.backgroundColor = [UIColor clearColor];
    name.frame = CGRectMake(0, 0, ScreenWidth, 180);
    name.textAlignment = NSTextAlignmentCenter;
    name.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:name];
    
    UIButton * jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jumpBtn.frame = name.frame;
    [jumpBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:jumpBtn];
}

- (void)buttonClick {
    if ([self.delegate respondsToSelector:@selector(refreshPlayAddressMethod)]){
        [self.delegate refreshPlayAddressMethod];
    }
    
    
}

@end
