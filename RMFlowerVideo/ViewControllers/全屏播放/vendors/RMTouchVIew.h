//
//  TouchVIew.h
//  RMCustomPlay
//
//  Created by 润华联动 on 14-11-3.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    kCameraMoveDirectionNone,
    kCameraMoveDirectionUp,
    kCameraMoveDirectionDown,
    kCameraMoveDirectionRight,
    kCameraMoveDirectionLeft
} CameraMoveDirection;

@protocol TouchViewDelegate <NSObject>
@optional
/**
 *  @param space     偏移量
 *  @param direction 滑动方向 ()
 *  @param position  上下滑动时位置是偏左还是偏右
 */
- (void)touchInViewOfLocation:(float)space andDirection:(NSString *)direction slidingPosition:(NSString *)position;
- (void)gestureRecognizerStateEnded;
- (void)gestureRecognizerStateBegan;

- (void)gestureRecognizerOneTapMetohd;
- (void)gestureRecognizerTwoTapMetohd;

@end
@interface RMTouchVIew : UIView{
    CameraMoveDirection direction;
    NSString *directionString;
    float startPoint;
    NSString *position;
}
@property (nonatomic, assign) id<TouchViewDelegate> delegate;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end
