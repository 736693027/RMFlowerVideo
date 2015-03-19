//
//  RMChangePasswordViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15/3/5.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMChangePasswordViewController.h"
#import "RMAFNRequestManager.h"

@interface RMChangePasswordViewController ()<RMAFNRequestManagerDelegate,UIAlertViewDelegate>{
    RMAFNRequestManager *requestManager;
}

@property (weak, nonatomic) IBOutlet UITextField *oldPassWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *nowPassWordTextField;
@end

@implementation RMChangePasswordViewController

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    requestManager = [[RMAFNRequestManager alloc] init];
    requestManager.delegate = self;
    
    [self setCustomNavTitle:@"修改密码"];
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    rightBarButton.hidden = YES;
    
    CALayer * passWordLayer = [self.passWordContentView layer];
    passWordLayer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    passWordLayer.borderWidth = 1.0f;
    
    CALayer * oldPassWordLayer = [self.oldPassWordContentView layer];
    oldPassWordLayer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    oldPassWordLayer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitChangePassWord:(UIButton *)sender {
    
    if(self.nowPassWordTextField.text.length<6){
        [self showMessage:@"密码必须是六位以上" duration:1 withUserInteractionEnabled:YES];
        return;
    }
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
    NSDictionary *userIofn = [storage objectForKey:UserLoginInformation_KEY];
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
    [requestManager changePasswordWithToken:[userIofn objectForKey:@"token"] oldPassword:self.oldPassWordTextField.text newPassword:self.nowPassWordTextField.text];
}
- (void)requestFinishiDownLoadWithResults:(NSString *)results{
    [self hideLoading];
    if([results isEqualToString:@"success"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }else{
        [self showMessage:results duration:1 withUserInteractionEnabled:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
