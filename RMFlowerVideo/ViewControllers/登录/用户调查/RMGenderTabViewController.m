//
//  RMGenderTabViewController.m
//  yemianbuju
//
//  Created by 润华联动 on 14-12-17.
//  Copyright (c) 2014年 润华联动. All rights reserved.
//

#import "RMGenderTabViewController.h"
#import "RMConstellationTabViewController.h"
#import "UIButton+EnlargeEdge.h"

@interface RMGenderTabViewController (){
    NSString *genderString;
    NSString *yearString;
}

@end

@implementation RMGenderTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.grilBtn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    [self.boyBtn setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
//    [self setCustomNavTitle:@"观看记录"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)NextClick:(UIButton *)sender {
    if(genderString==nil||yearString==nil){
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择相应的选项" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alview show];
        return;
    }
    RMConstellationTabViewController *viewContro = [[RMConstellationTabViewController alloc] init];
    viewContro.yearString = [yearString substringToIndex:[yearString rangeOfString:@"后"].location];
    viewContro.genderString = genderString;
    viewContro.viewControlerrIdentify = viewContro.viewControlerrIdentify;
    [self.navigationController pushViewController:viewContro animated:YES];
}

- (IBAction)afterYearBtnClick:(UIButton *)sender {
    yearString = sender.titleLabel.text;
    [sender setBackgroundImage:[UIImage imageNamed:@"redbg"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    for(int i=100;i<104;i++){
        if(i==sender.tag) continue;
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        [button setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (IBAction)genderBtnClick:(UIButton *)sender {
    //男
    if(sender.tag == 200){
        genderString = @"1";
        [self.grilBtn setImage:[UIImage imageNamed:@"no-select_cellImage"] forState:UIControlStateNormal];
        [self.boyBtn setImage:[UIImage imageNamed:@"select_cellImage"] forState:UIControlStateNormal];
    }
    //女
    else{
        genderString = @"2";
        [self.boyBtn setImage:[UIImage imageNamed:@"no-select_cellImage"] forState:UIControlStateNormal];
        [self.grilBtn setImage:[UIImage imageNamed:@"select_cellImage"] forState:UIControlStateNormal];
    }
}
@end
