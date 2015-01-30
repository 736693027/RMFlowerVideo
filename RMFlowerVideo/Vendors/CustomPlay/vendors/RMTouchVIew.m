//
//  TouchVIew.m
//  RMCustomPlay
//
//  Created by 润华联动 on 14-11-3.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMTouchVIew.h"
#import "RMUtilityFunc.h"

CGFloat constgestureMinimumTranslation =20.0;

@implementation RMTouchVIew

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        //滑动手势
        self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        
        self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self addGestureRecognizer:self.leftSwipeGestureRecognizer];
        [self addGestureRecognizer:self.rightSwipeGestureRecognizer];
        startPoint = 0;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:pan];
        
        directionString = @"none";
        position = @"none";
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"左");
    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"右");
    } else if (sender.direction == UISwipeGestureRecognizerDirectionUp){
        NSLog(@"上");
    }else{
        NSLog(@"下");
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    if([self.delegate respondsToSelector:@selector(touchInViewOfLocation:andDirection: slidingPosition:)]){
        CGPoint point = [gestureRecognizer locationInView:self];
        if(point.x>[UIScreen mainScreen].bounds.size.height/2){
            position = @"right";
        }else{
            position = @"left";
        }
        CGPoint translation = [gestureRecognizer translationInView:self];
        if(gestureRecognizer.state ==UIGestureRecognizerStateBegan) {
            direction = kCameraMoveDirectionNone;
            if([self.delegate respondsToSelector:@selector(gestureRecognizerStateBegan)]){
                [self.delegate gestureRecognizerStateBegan];
            }
        }else if(gestureRecognizer.state ==UIGestureRecognizerStateChanged&& direction == kCameraMoveDirectionNone){
            direction = [self determineCameraDirectionIfNeeded:translation];
            // ok, now initiate movement in the direction indicated by the user's gesture
            switch(direction) {
                case kCameraMoveDirectionDown:{
                    startPoint = translation.y;
                    NSLog(@"Start moving down");
                    directionString = @"down";
                    break;
                }
                case kCameraMoveDirectionUp:{
                    startPoint = translation.y;
                    NSLog(@"Start moving up");
                    directionString = @"up";
                    break;
                }
                case kCameraMoveDirectionRight:{
                    startPoint = translation.x;
                    NSLog(@"Start moving right");
                    directionString = @"right";
                    break;
                }
                case kCameraMoveDirectionLeft:{
                    startPoint = translation.x;
                    NSLog(@"Start moving left");
                    directionString = @"left";
                    break;
                }
                default:
                    break;
            }
        }else if(gestureRecognizer.state ==UIGestureRecognizerStateEnded) {
            // now tell the camera to stop
            directionString = @"none";
            position = @"none";
            NSLog(@"Stop");
            if([self.delegate respondsToSelector:@selector(gestureRecognizerStateEnded)]){
                [self.delegate gestureRecognizerStateEnded];
            }
        }
        if([directionString isEqualToString:@"down"] || [directionString isEqualToString:@"up"]){
            [self.delegate touchInViewOfLocation:startPoint-translation.y andDirection:directionString slidingPosition:position];
            startPoint = translation.y;
        }else if([directionString isEqualToString:@"left"] || [directionString isEqualToString:@"right"]){
            
            [self.delegate touchInViewOfLocation:startPoint-translation.x andDirection:directionString slidingPosition:nil];
            startPoint = translation.x;
        }
    }
}

- (CameraMoveDirection)determineCameraDirectionIfNeeded:(CGPoint)translation {
    if(direction != kCameraMoveDirectionNone)
        return direction;
    // determine if horizontal swipe only if you meet some minimum velocity
    if(fabs(translation.x) > constgestureMinimumTranslation) {
        BOOL gestureHorizontal = NO;
        if(translation.y ==0.0){
            gestureHorizontal = YES;
        }else{
            gestureHorizontal = (fabs(translation.x / translation.y) >5.0);
        }
        if(gestureHorizontal) {
            if(translation.x >0.0){
                return kCameraMoveDirectionRight;
            }else{
                return kCameraMoveDirectionLeft;
            }
        }
    }
    // determine if vertical swipe only if you meet some minimum velocity
    else if(fabs(translation.y) > constgestureMinimumTranslation) {
        BOOL gestureVertical = NO;
        if(translation.x ==0.0){
            gestureVertical = YES;
        }else{
            gestureVertical = (fabs(translation.y / translation.x) >5.0);
        }
        if(gestureVertical) {
            if(translation.y >0.0){
                return kCameraMoveDirectionDown;
            }else{
                return kCameraMoveDirectionUp;
            }
        }
    }
    return direction;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (touch.tapCount == 1) {
        [self performSelector:@selector(handleSingleTap:) withObject:[NSValue valueWithCGPoint:touchPoint] afterDelay:0.2];
    }else if(touch.tapCount == 2)  {
        [self handleDoubleTap:[NSValue valueWithCGPoint:touchPoint]];
    }
}

- (void)handleSingleTap:(NSValue*)pointValue {
    if([self.delegate respondsToSelector:@selector(gestureRecognizerOneTapMetohd)]){
        [self.delegate gestureRecognizerOneTapMetohd];
    }
}

- (void)handleDoubleTap:(NSValue*)pointValue {
    if([self.delegate respondsToSelector:@selector(gestureRecognizerTwoTapMetohd)]){
        [self.delegate gestureRecognizerTwoTapMetohd];
    }
}

@end
