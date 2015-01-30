//
//  RMGenderTabViewController.h
//  yemianbuju
//
//  Created by 润华联动 on 14-12-17.
//  Copyright (c) 2014年 润华联动. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMGenderTabViewController : RMBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *boyBtn;
@property (weak, nonatomic) IBOutlet UIButton *grilBtn;

@property (weak, nonatomic) IBOutlet UIButton *after2000Btn;
@property (weak, nonatomic) IBOutlet UIButton *after1900Btn;
@property (weak, nonatomic) IBOutlet UIButton *after1800Btn;
@property (weak, nonatomic) IBOutlet UIButton *after1700Btn;

@property (nonatomic, copy) NSString * viewControlerrIdentify;   //记录是从哪个模块登录

- (IBAction)NextClick:(UIButton *)sender;
- (IBAction)afterYearBtnClick:(UIButton *)sender;
- (IBAction)genderBtnClick:(UIButton *)sender;

@end
