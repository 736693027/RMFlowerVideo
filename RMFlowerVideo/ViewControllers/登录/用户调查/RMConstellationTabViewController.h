//
//  RMConstellationTabViewController.h
//  yemianbuju
//
//  Created by 润华联动 on 14-12-17.
//  Copyright (c) 2014年 润华联动. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMConstellationTabViewController : RMBaseViewController{
    
    __weak IBOutlet UIButton *SmallFreshBtn;
    __weak IBOutlet UIButton *HeavyTasteBtn;
}

@property (nonatomic ,copy) NSString *genderString;
@property (nonatomic ,copy) NSString *yearString;
@property (nonatomic, copy) NSString * viewControlerrIdentify;   //记录是从哪个模块登录

- (IBAction)likeGenreBtnClick:(UIButton *)sender;

- (IBAction)constellation:(UIButton *)sender;

- (IBAction)finishBtnClick:(UIButton *)sender;

@end
