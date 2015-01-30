//
//  RMBaseView.m
//  RMVideo
//
//  Created by runmobile on 14-10-17.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMBaseView.h"
#import "CONST.h"

@implementation RMBaseView

- (void)addTarget:(id)target WithSelector:(SEL)sel{
    _target = target;
    _sel = sel;
    self.userInteractionEnabled = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_target) {
        SuppressPerformSelectorLeakWarning (
                                            [_target performSelector:_sel withObject:self]
                                            );
    }
}

- (void)loadSearchViewWithTitle:(NSString *)str {
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    bgView.userInteractionEnabled = YES;
    bgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:bgView];
    
    UILabel * title = [[UILabel alloc] init];
    title.text = str;
    title.textColor = [UIColor whiteColor];
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    title.font = FONT(20.0);
    title.userInteractionEnabled = YES;
    title.backgroundColor = [UIColor clearColor];
    [self addSubview:title];
}

@end
