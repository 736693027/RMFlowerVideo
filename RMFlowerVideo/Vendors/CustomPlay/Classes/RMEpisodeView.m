//
//  EpisodeView.m
//  RMCustomPlayer
//
//  Created by runmobile on 14-12-12.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMEpisodeView.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation RMEpisodeView

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

- (void)loadEpisodeViewWithNumber:(NSString *)num {
    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    label.userInteractionEnabled = YES;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12.0];
    label.text = num;
    [self addSubview:label];
    self.currentNum = num.intValue;
}

@end
