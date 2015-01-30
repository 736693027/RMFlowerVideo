//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "RMTagList.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 10.0f
#define LABEL_MARGIN 10.0f
#define BOTTOM_MARGIN 10.0f
#define FONT_SIZE 18.0f
#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING 3.0f
#define BACKGROUND_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor].CGColor
#define BORDER_WIDTH 1.0f

@implementation RMTagList

@synthesize view, textArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        [self addSubview:view];
    }
    return self;
}

- (void)setTags:(NSArray *)array
{
    textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
}

- (void)setLabelBackgroundColor:(UIColor *)color
{
    lblBackgroundColor = color;
    [self display];
}

- (void)display
{
    for (UILabel *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    int value = 0;
    for (NSString *text in textArray) {
        CGSize textSize;
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:FONT_SIZE], NSFontAttributeName, nil];
        CGRect rect = [text boundingRectWithSize:CGSizeMake(self.frame.size.width, 1500)
                                         options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                      attributes:attrs
                                         context:nil];
        textSize = rect.size;
        textSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
        
        textSize.width += HORIZONTAL_PADDING*2 + 10;
        textSize.height += VERTICAL_PADDING*2 + 10;
        UILabel *label = nil;
        if (!gotPreviousFrame) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
            totalHeight = textSize.height;
        } else {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > self.frame.size.width) {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                totalHeight += textSize.height + BOTTOM_MARGIN;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }
            newRect.size = textSize;
            label = [[UILabel alloc] initWithFrame:newRect];
        }
        previousFrame = label.frame;
        gotPreviousFrame = YES;
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        if (!lblBackgroundColor) {
            [label setBackgroundColor:BACKGROUND_COLOR];
        } else {
            [label setBackgroundColor:lblBackgroundColor];
        }
        label.userInteractionEnabled = YES;
        [label setTextColor:TEXT_COLOR];
        [label setText:text];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label.layer setMasksToBounds:YES];
        
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];

//        [label setShadowColor:TEXT_SHADOW_COLOR];
//        [label setShadowOffset:TEXT_SHADOW_OFFSET];
        [label.layer setCornerRadius:CORNER_RADIUS];
//        [label.layer setBorderColor:BORDER_COLOR];
//        [label.layer setBorderWidth: BORDER_WIDTH];
        [self addSubview:label];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.text = text;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = value+10;
        [self addSubview:button];
        value ++;
    }
    sizeFit = CGSizeMake(self.frame.size.width, totalHeight + 1.0f);
    
    if ([self.delegate respondsToSelector:@selector(refreshTagListViewHeight:)]) {
        [self.delegate refreshTagListViewHeight:sizeFit.height];
    }
}

- (void)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickTagWithTitle:)]) {
        [self.delegate clickTagWithTitle:sender.titleLabel.text];
    }
}

- (CGSize)fittedSize
{
    return sizeFit;
}

@end
