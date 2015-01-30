//
//  CustomTabBarController.h
//  自定义UITabBarController
//
//  Created by 严明俊 on 13-6-9.
//  Copyright (c) 2013年 严明俊. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenHeight       [UIScreen mainScreen].bounds.size.height
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width

#define isIOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7

@protocol CustomTabBarControllerDelegate <NSObject>

- (void)selctTabbarItemWithIndex:(NSInteger)index;

@end

@interface RMCustomTabBarController : UITabBarController
{
    UIScrollView *_myTabbarView;
}
@property (nonatomic) int tabbarHeight;
@property (nonatomic) float TabarItemWidth;
@property (nonatomic) BOOL isTabbarHidden;
@property (nonatomic, weak) id<CustomTabBarControllerDelegate> selectDelegate;
@property (nonatomic) BOOL isInDeck;

- (UIButton *)customTabbarItemWithIndex:(NSInteger)index;

- (void)setTabbarHidden:(BOOL)isHidden animated:(BOOL)animated;

- (void)tabbarButtonClicked:(id)sender;

- (void)clickButtonWithIndex:(NSInteger)index;
@end
