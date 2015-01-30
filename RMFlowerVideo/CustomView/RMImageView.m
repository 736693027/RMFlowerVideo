//
//  RMImageView.m
//  RMVideo
//
//  Created by runmobile on 14-10-13.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMImageView.h"
#import "CONST.h"
#import "UIImageView+WebCache.h"

@implementation RMImageView
@synthesize identifierString;

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

- (void)addTopNumber:(int)num {
    
    UILabel *lable = [[UILabel alloc] init];
    lable.frame = CGRectMake(-1, 0, self.frame.size.width, self.frame.size.height/2-5);
    lable.text = [NSString stringWithFormat:@"TOP"];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = FONT(10.0);
    lable.tag = 100;
    [self addSubview:lable];
    
    UILabel *lable1 = [[UILabel alloc] init];
    lable1.frame = CGRectMake(-1, self.frame.size.height/2-5, self.frame.size.width, self.frame.size.height/2-5);
    lable1.text = [NSString stringWithFormat:@"%d",num];
    lable1.textColor = [UIColor whiteColor];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.font = FONT(10.0);
    lable.tag = 200;
    [self addSubview:lable1];
}

- (void)addRotatingViewWithName:(NSString *)str {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 37, 20)];
    label.text = str;
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT(8.0);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.userInteractionEnabled = YES;
    [self addSubview:label];
    
    [self rotatingView:self];
}

- (UIView *)rotatingView:(UIView *)view {
    CGAffineTransform transform = view.transform;
    transform =  CGAffineTransformRotate(transform, (- M_PI / 4.0));
    view.transform = transform;
    return view;
}

- (void)setFileShowImageView:(NSString *)imageUrl{
//    self.image = LOADIMAGE(@"file_bg_Image", kImageTypePNG);
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.frame = CGRectMake(5, 10, self.frame.size.width-10, self.frame.size.height-10);
//    [showImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:LOADIMAGE(@"Default90_119", kImageTypePNG)];
    [self addSubview:showImageView];
    
    UIImageView *beforeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2+5, self.frame.size.width, self.frame.size.height/2-5)];
//    beforeImage.image = LOADIMAGE(@"file_before_Image", kImageTypePNG);
    
    beforeImage.layer.shadowColor = [UIColor whiteColor].CGColor;
    
    beforeImage.layer.shadowOffset = CGSizeMake(0, 0);
    
    beforeImage.layer.shadowOpacity = 0.5;
    
    beforeImage.layer.shadowRadius = 10.0;
    [self addSubview:beforeImage];
}

@end
