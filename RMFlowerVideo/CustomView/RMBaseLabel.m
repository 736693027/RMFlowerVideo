//
//  RMBaseLabel.m
//  RMVideo
//
//  Created by runmobile on 14-10-16.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMBaseLabel.h"

@implementation RMBaseLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    return CGRectMake(10, 0, bounds.size.width-5, bounds.size.height);
}

@end
