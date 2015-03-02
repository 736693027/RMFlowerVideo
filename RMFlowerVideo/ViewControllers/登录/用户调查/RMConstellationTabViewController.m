//
//  RMConstellationTabViewController.m
//  yemianbuju
//
//  Created by 润华联动 on 14-12-17.
//  Copyright (c) 2014年 润华联动. All rights reserved.
//

#import "RMConstellationTabViewController.h"
#import "RMSetViewController.h"

@interface RMConstellationTabViewController ()<RMAFNRequestManagerDelegate>{
    NSString *likeTypeString;
    NSString *constellationString;
    RMAFNRequestManager * manager;
}

@end

@implementation RMConstellationTabViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideLoading];
    [manager cancelRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    manager = [[RMAFNRequestManager alloc] init];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)likeGenreBtnClick:(UIButton *)sender {
    //重口味
    if(sender.tag == 200){
        likeTypeString = @"1";
        [SmallFreshBtn setImage:[UIImage imageNamed:@"no-select_cellImage"] forState:UIControlStateNormal];
        [HeavyTasteBtn setImage:[UIImage imageNamed:@"select_cellImage"] forState:UIControlStateNormal];
    }
    //小清新
    else{
        likeTypeString = @"2";
        [HeavyTasteBtn setImage:[UIImage imageNamed:@"no-select_cellImage"] forState:UIControlStateNormal];
        [SmallFreshBtn setImage:[UIImage imageNamed:@"select_cellImage"] forState:UIControlStateNormal];
    }
}

- (IBAction)constellation:(UIButton *)sender {
    constellationString = sender.titleLabel.text;
    [sender setBackgroundImage:[UIImage imageNamed:@"redbg"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    for(int i=100; i<112; i++){
        if(i==sender.tag) continue;
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        [button setBackgroundImage:[UIImage imageNamed:@"bg"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (IBAction)finishBtnClick:(UIButton *)sender {
    if(likeTypeString==nil||constellationString==nil){
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择相应的选项" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alview show];
        return;
    }
    if ([UtilityFunc isConnectionAvailable] == 0){
        [self showMessage:kShowConnectionAvailableError duration:1.0 position:1 withUserInteractionEnabled:NO];
        return ;
    }
    [self showMessage:@"加载中..." duration:1.0 position:1 withUserInteractionEnabled:NO];
        CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
        NSDictionary *dict = [storage objectForKey:UserLoginInformation_KEY];
    manager.delegate = self;
    [manager setInfoWithToken:[dict objectForKey:@"token"] Gender:self.genderString Age:self.yearString Preferences:likeTypeString Constellation:[constellationString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (void)requestFinishiDownLoadWithResults:(NSString *)results {
    if ([results isEqualToString:@"success"]){
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccessCallback" object:nil];
    }
}

- (void)requestError:(NSError *)error {
    NSLog(@"Info error:%@",error);
}

@end
