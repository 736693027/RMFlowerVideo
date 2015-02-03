//
//  RMBaseViewController.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 14-12-30.
//  Copyright (c) 2014年 润滑联动. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CONST.h"
#import <QuartzCore/QuartzCore.h>
#import "CUSFileStorage.h"
#import "UtilityFunc.h"
#import "AESCrypt.h"
#import "UIImageView+WebCache.h"
#import "RMAFNRequestManager.h"
#import "MBProgressHUD.h"
#import "Database.h"
#import "UIImageView+WebCache.h"


#define CENTER 1
#define TOP 2
#define BOTTOM 3
#define DOWNLOADLISTNAME @"DownLoadListname"

@interface RMBaseViewController : UIViewController{
    UIButton *leftBarButton;
    UIButton *rightBarButton;
    MBProgressHUD *HUD;
    UIImageView * HUDImageView;
}

@property (weak, nonatomic) IBOutlet UIImageView *emptyImageView;
@property (weak, nonatomic) IBOutlet UILabel *errorTitleLable;

/**
 *  @param navigationBar    自定义的navigationBar
 *  @param statusBar        自定义的statusBar
 */
- (void)hideCustomNavigationBar:(BOOL)navigationBar withHideCustomStatusBar:(BOOL)statusBar;

/**
 *  设置custom Nav Title
 */
- (void)setCustomNavTitle:(NSString *)title;
- (void)navgationBarButtonClick:(UIBarButtonItem *)sender;

#pragma mark - HUD Method-

- (void)showLoadingSimpleWithUserInteractionEnabled:(BOOL)enabled;//加载框
- (void)showLoadingWithText:(NSString *)text withUserInteractionEnabled:(BOOL)enabled;//加载框+文字
- (void)showLoadingWithLabelDeterminate:(NSString *)text withUserInteractionEnabled:(BOOL)enabled;//圆形进度＋文字
- (void)showLoadingWithLabelAnnularDeterminate:(NSString *)text withUserInteractionEnabled:(BOOL)enabled;//圆框进度＋文字
- (void)showLoadingCustomViewWithImage:(NSString *)imageName withText:(NSString *)text withUserInteractionEnabled:(BOOL)enabled;//图片＋文字
- (void)showLoadingWithGradientWithUserInteractionEnabled:(BOOL)enabled;//加载框＋蒙板
- (void)showLoadingWithGradientAndText:(NSString *)text withUserInteractionEnabled:(BOOL)enabled;//加载框＋文字＋蒙板
- (void)showMessage:(NSString *)message duration:(NSTimeInterval)interval withUserInteractionEnabled:(BOOL)enabled;//提示文字,设置显示时间,位置居中
- (void)showMessage:(NSString *)message duration:(NSTimeInterval)interval position:(NSInteger)position withUserInteractionEnabled:(BOOL)enabled;//提示文字，显示时间，位置

-(void)hideLoading;

- (void)showHUDWithImage:(NSString *)imageName imageFrame:(CGRect)frame duration:(NSTimeInterval)interval userInteractionEnabled:(BOOL)enabled;

@end
