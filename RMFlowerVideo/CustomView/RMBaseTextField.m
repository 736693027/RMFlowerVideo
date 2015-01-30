//
//  RMBaseTextField.m
//  RMVideo
//
//  Created by runmobile on 14-9-29.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMBaseTextField.h"

@implementation RMBaseTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(10, 0, bounds.size.width, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(10, 0, bounds.size.width, bounds.size.height);
}

//控制placeHolder的位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectMake(10, 0, bounds.size.width-5, bounds.size.height);
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

//控制placeHolder的颜色、字体
- (void)drawPlaceholderInRect:(CGRect)rect {
    if (self.placeHolderColor) {
        [self.placeHolderColor setFill];
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil];
        [[self placeholder] drawInRect:rect withAttributes:attrs];
    } else {
        [super drawPlaceholderInRect:rect];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
