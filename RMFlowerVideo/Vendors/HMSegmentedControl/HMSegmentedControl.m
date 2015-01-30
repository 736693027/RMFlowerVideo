//
//  HMSegmentedControl.m
//  HMSegmentedControlExample
//
//  Created by Hesham Abd-Elmegid on 23/12/12.
//  Copyright (c) 2012 Hesham Abd-Elmegid. All rights reserved.
//

#import "HMSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>
#import "UtilityFunc.h"
#import "CONST.h"

#define kIndicatorHeight                38.0
#define FixValue_TAG                    2000
#define BGViewFixValue_TAG              3001
#define XiaHuaXianHight                     0.0f

@interface HMSegmentedControl (){
    NSArray * normalArr;
    NSArray * selectArr;
}

@property (nonatomic, strong) CALayer *selectedSegmentLayer;
@property (nonatomic, readwrite) CGFloat segmentWidth;

@end

@implementation HMSegmentedControl
@synthesize identifierType = _identifierType;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self setDefaults];
    }
    
    return self;
}

- (id)initWithSectionTitles:(NSArray *)sectiontitles withIdentifierType:(NSString *)str {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.sectionTitles = sectiontitles;
        self.identifierType = str;
        [self setDefaultsLabelTitle];
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

-(void)setDefaultsLabelTitle{
    if ([self.identifierType isEqualToString:@"starIdentifier"]){
        for (int i=0; i<self.sectionTitles.count; i++) {
            UIImageView * image;
            if (IS_IPHONE_6_SCREEN){
                image = [[UIImageView alloc] initWithFrame:CGRectMake(50.5 + i * 92, 0, 93, 30)];
            }else if (IS_IPHONE_6p_SCREEN){
                image = [[UIImageView alloc] initWithFrame:CGRectMake(65.5 + i * 92, 0, 93, 30)];
            }else{
                image = [[UIImageView alloc] initWithFrame:CGRectMake(22.5 + i * 92, 0, 93, 30)];
            }
            image.tag = FixValue_TAG+i;
            image.userInteractionEnabled = YES;
            if (i==0){
                image.image = LOADIMAGE(@"movie_selected", kImageTypePNG);
            }else if (i == 1){
                image.image = LOADIMAGE(@"teleplay_unSelected", kImageTypePNG);
            }else if (i == 2){
                image.image = LOADIMAGE(@"variety_unSelected", kImageTypePNG);
            }
            image.backgroundColor = [UIColor clearColor];
            [self addSubview:image];
        }
    }else if ([self.identifierType isEqualToString:@"videoIdentifier"]){
        NSArray * titleArr = [NSArray arrayWithObjects:@"剧情介绍", @"播放地址", @"主创人员", nil];
        for (int i=1; i<3; i++) {
            UIView * verticalLine = [[UIView alloc] init];
            verticalLine.backgroundColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1];
            verticalLine.frame = CGRectMake([UtilityFunc shareInstance].globleWidth/3 * i, 0, 1, 40);
            [self addSubview:verticalLine];
        }
        
        for (int i=0; i<self.sectionTitles.count; i++) {
            
            UILabel * title = [[UILabel alloc] init];
            if (IS_IPHONE_6_SCREEN){
                title.frame = CGRectMake(0 + [UtilityFunc shareInstance].globleWidth/3 * i, 0, [UtilityFunc shareInstance].globleWidth/3, 40);
            }else if (IS_IPHONE_6p_SCREEN){
                title.frame = CGRectMake(0 + [UtilityFunc shareInstance].globleWidth/3 * i, 0, [UtilityFunc shareInstance].globleWidth/3, 40);
            }else{
                title.frame = CGRectMake(0 + [UtilityFunc shareInstance].globleWidth/3 * i, 0, [UtilityFunc shareInstance].globleWidth/3, 40);
            }
            if (i==0){
                title.backgroundColor = [UIColor colorWithRed:0.76 green:0.03 blue:0.09 alpha:1];
                title.textColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.95 alpha:1];
            } else {
                title.backgroundColor = [UIColor clearColor];
                title.textColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1];
            }
            title.text = [titleArr objectAtIndex:i];
            title.tag = BGViewFixValue_TAG+i;
            title.font = [UIFont systemFontOfSize:15.0];
            title.textAlignment = NSTextAlignmentCenter;
            [self addSubview:title];
        }
    }
    
    
//    for (int i=0; i<self.sectionTitles.count; i++){
//        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(5 + i*[UtilityFunc shareInstance].globleWidth/[self.sectionTitles count], 5, [UtilityFunc shareInstance].globleWidth/[self.sectionTitles count] - 10, 35)];
//        if (i==0){
//            view.backgroundColor = [UIColor redColor];
//        }else{
//            view.backgroundColor = [UIColor clearColor];
//        }
//        view.tag = BGViewFixValue_TAG + i;
//        [self addSubview:view];
//        
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = view.bounds;
//        maskLayer.path = maskPath.CGPath;
//        view.layer.mask = maskLayer;
//    }
}

- (void)ChangeLabelTitleColor:(NSInteger)index{
    if ([self.identifierType isEqualToString:@"starIdentifier"]){
        normalArr = [NSArray arrayWithObjects:@"movie_unSelected", @"teleplay_unSelected", @"variety_unSelected", nil];
        selectArr = [NSArray arrayWithObjects:@"movie_selected", @"teleplay_selected", @"variety_selected", nil];
        
        for (int i=0; i<(self.sectionTitles.count); i++){
            UIImageView * image = (UIImageView *)[self viewWithTag:i+FixValue_TAG];
            if (i==index){
                image.image = LOADIMAGE([selectArr objectAtIndex:index], @"png");
            }else{
                image.image = LOADIMAGE([normalArr objectAtIndex:i], @"png");
            }
        }
    }else if ([self.identifierType isEqualToString:@"videoIdentifier"]){
        for (int i=0; i<self.sectionTitles.count; i++) {
            if (i==index){
                ((UILabel *)[self viewWithTag:i+BGViewFixValue_TAG]).backgroundColor = [UIColor colorWithRed:0.76 green:0.03 blue:0.09 alpha:1];
                ((UILabel *)[self viewWithTag:i+BGViewFixValue_TAG]).textColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.95 alpha:1];
            }else{
                ((UILabel *)[self viewWithTag:i+BGViewFixValue_TAG]).backgroundColor = [UIColor clearColor];
                ((UILabel *)[self viewWithTag:i+BGViewFixValue_TAG]).textColor = [UIColor colorWithRed:0.31 green:0.31 blue:0.31 alpha:1];
            }
        }
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
    
    if (animated) {
        // Restore CALayer animations
        self.selectedSegmentLayer.actions = nil;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.15f];
        [CATransaction setCompletionBlock:^{
            if (self.superview)
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            
            if (self.indexChangeBlock)
                self.indexChangeBlock(index);
        }];
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        [CATransaction commit];
    } else {
        // Disable CALayer animations
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
        self.selectedSegmentLayer.actions = newActions;
        
        self.selectedSegmentLayer.frame = [self frameForSelectionIndicator];
        
        if (self.superview)
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        if (self.indexChangeBlock)
            self.indexChangeBlock(index);

    }    
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
