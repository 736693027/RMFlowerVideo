//
//  CustomSVProgressHUD.h
//  RMCustomPlay
//
//  Created by 润华联动 on 14-11-5.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMCustomSVProgressHUD : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *beginLable;
@property (weak, nonatomic) IBOutlet UILabel *totalLable;
@property (copy, nonatomic) NSString *totalTimeString;

- (void)showWithState:(BOOL)isFastForward andNowTime:(int)time;

@end
