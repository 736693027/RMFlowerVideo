//
//  RMBaseTextView.m
//  RMVideo
//
//  Created by runmobile on 14-11-27.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMBaseTextView.h"

@implementation RMBaseTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
