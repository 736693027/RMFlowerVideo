//
//  HMSegmentedControl.m
//  HMSegmentedControlExample
//
//  Created by Hesham Abd-Elmegid on 23/12/12.
//  Copyright (c) 2012 Hesham Abd-Elmegid. All rights reserved.
//

#import "RMSegmentedController.h"
#import <QuartzCore/QuartzCore.h>

#define kIndicatorHeight                38.0
#define XiaHuaXianHight                     0.0f

@interface RMSegmentedController (){
    NSArray * normalArr;
    NSArray * selectArr;
}

@property (nonatomic, strong) CALayer *selectedSegmentLayer;
@property (nonatomic, readwrite) CGFloat segmentWidth;

@end

@implementation RMSegmentedController
@synthesize identifierType = _identifierType;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self setDefaults];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame withSectionTitles:(NSArray *)sectiontitles withIdentifierType:(NSString *)str withLineEdge:(float)edge withAddLine:(BOOL)line {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.sectionTitles = sectiontitles;
        self.identifierType = str;
        [self setDefaultsLabelTitleAndEdge:edge withFrame:frame withAddLine:line];
        [self setDefaults];
    }
    
    return self;
}

- (void)setDefaults {
    self.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18.0f];
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.selectionIndicatorColor = [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    
    self.selectedIndex = 0;
    self.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.height = 32.0f;
    self.selectionIndicatorHeight = XiaHuaXianHight;
    self.selectionIndicatorMode = HMSelectionIndicatorFillsSegment;
    
    self.selectedSegmentLayer = [CALayer layer];
}

-(void)setDefaultsLabelTitleAndEdge:(float)edge withFrame:(CGRect)frame withAddLine:(BOOL)isLine {
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSInteger count = self.sectionTitles.count;
    
    for (int i=0; i<count; i++){
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0 + i * screenWidth/count, 0, screenWidth/count, frame.size.height);
        button.tag = 100+i;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:[self.sectionTitles objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(switchSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0];
        button.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        [self addSubview:button];
        
        if (self.selectedIndex == i){
            [button setTitleColor:[UIColor colorWithRed:0.88 green:0.27 blue:0.16 alpha:1] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1] forState:UIControlStateNormal];
        }
    }
    
    for (int i=0; i<count; i++){
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(i * screenWidth/count, edge, 1, frame.size.height-2*edge)];
        line.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
        [self addSubview:line];
    }
    
    if (isLine){
        for (NSInteger i=0; i<2; i++) {
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + i * frame.size.height-21, screenWidth, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
            [self addSubview:lineView];
        }
    }
}

- (void)switchSelected:(UIButton *)sender{
    for (int i=100; i<103; i++){
        UIButton * button = (UIButton *)[self viewWithTag:i];
        [button setTitleColor:[UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1] forState:UIControlStateNormal];
    }
    [sender setTitleColor:[UIColor colorWithRed:0.88 green:0.27 blue:0.16 alpha:1] forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(switchSelectedMethodWithValue:withTitle:)]){
        [self.delegate switchSelectedMethodWithValue:(int)sender.tag-100 withTitle:sender.titleLabel.text];
    }
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [self.backgroundColor set];
    UIRectFill([self bounds]);
    
    [self.textColor set];
    
    [self.sectionTitles enumerateObjectsUsingBlock:^(id titleString, NSUInteger idx, BOOL *stop) {
        CGFloat stringHeight = [titleString sizeWithFont:self.font].height;
        CGFloat y = ((self.height - self.selectionIndicatorHeight) / 2) + (self.selectionIndicatorHeight - stringHeight / 2);
        CGRect rect = CGRectMake(self.segmentWidth * idx, y, self.segmentWidth, stringHeight);
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        [titleString drawInRect:rect
                       withFont:self.font
                  lineBreakMode:UILineBreakModeClip
                      alignment:UITextAlignmentCenter];
#else
        [titleString drawInRect:rect
                       withFont:self.font
                  lineBreakMode:NSLineBreakByClipping
                      alignment:NSTextAlignmentCenter];
#endif

        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        self.selectedSegmentLayer.backgroundColor = self.selectionIndicatorColor.CGColor;
        [self.layer addSublayer:self.selectedSegmentLayer];

    }];
}

- (CGRect)frameForSelectionIndicator {
    CGFloat stringWidth = [[self.sectionTitles objectAtIndex:self.selectedIndex] sizeWithFont:self.font].width;
    
    if (self.selectionIndicatorMode == HMSelectionIndicatorResizesToStringWidth) {
        CGFloat widthTillEndOfSelectedIndex = (self.segmentWidth * self.selectedIndex) + self.segmentWidth;
        CGFloat widthTillBeforeSelectedIndex = (self.segmentWidth * self.selectedIndex);
        
        CGFloat x = ((widthTillEndOfSelectedIndex - widthTillBeforeSelectedIndex) / 2) + (widthTillBeforeSelectedIndex - stringWidth / 2);
        return CGRectMake(x, kIndicatorHeight, stringWidth, self.selectionIndicatorHeight);
    } else {
        return CGRectMake(self.segmentWidth * self.selectedIndex, kIndicatorHeight, self.segmentWidth, self.selectionIndicatorHeight);
    }
}

- (void)updateSegmentsRects {
    // If there's no frame set, calculate the width of the control based on the number of segments and their size
    if (CGRectIsEmpty(self.frame)) {
        self.segmentWidth = 0;
        
        for (NSString *titleString in self.sectionTitles) {
            CGSize resultSize;
            NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil];
            CGRect rect = [titleString boundingRectWithSize:CGSizeMake(500, 500)
                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                            attributes:attrs
                                               context:nil];
            resultSize = rect.size;
            resultSize = CGSizeMake(ceil(resultSize.width), ceil(resultSize.height));
//            CGFloat stringWidth = [titleString sizeWithFont:self.font].width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            CGFloat stringWidth = resultSize.width + self.segmentEdgeInset.left + self.segmentEdgeInset.right;
            self.segmentWidth = MAX(stringWidth, self.segmentWidth);
        }
        
        self.bounds = CGRectMake(0, 0, self.segmentWidth * self.sectionTitles.count, self.height);
    } else {
        self.segmentWidth = self.frame.size.width / self.sectionTitles.count;
        self.height = self.frame.size.height;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    // Control is being removed
    if (newSuperview == nil)
        return;
    
    [self updateSegmentsRects];
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        NSInteger segment = touchLocation.x / self.segmentWidth;
        
        if (segment != self.selectedIndex) {
            [self setSelectedIndex:segment animated:YES];
        }
    }
}

#pragma mark -

- (void)setSelectedIndex:(NSInteger)index {
    [self setSelectedIndex:index animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated {
    _selectedIndex = index;
    for (int i=100; i<103; i++){
        UIButton * button = (UIButton *)[self viewWithTag:i];
        [button setTitleColor:[UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1] forState:UIControlStateNormal];
    }
    UIButton * button = (UIButton *)[self viewWithTag:index + 100];
    [button setTitleColor:[UIColor colorWithRed:0.88 green:0.27 blue:0.16 alpha:1] forState:UIControlStateNormal];
    
    
//    if (animated) {
//        // Restore CALayer animations
//        self.selectedSegmentLayer.actions = nil;
//        
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:0.15f];
//        [CATransaction setCompletionBlock:^{
//            if (self.superview)
//                [self sendActionsForControlEvents:UIControlEventValueChanged];
//            
//            if (self.indexChangeBlock)
//                self.indexChangeBlock(index);
//        }];
//        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
//        [CATransaction commit];
//    } else {
//        // Disable CALayer animations
//        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
//        self.selectedSegmentLayer.actions = newActions;
//        
//        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
//        
//        if (self.superview)
//            [self sendActionsForControlEvents:UIControlEventValueChanged];
//        
//        if (self.indexChangeBlock)
//            self.indexChangeBlock(index);
//
//    }    
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if (self.sectionTitles)
        [self updateSegmentsRects];
    
    [self setNeedsDisplay];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    if (self.sectionTitles)
        [self updateSegmentsRects];
    
    [self setNeedsDisplay];
}

@end
