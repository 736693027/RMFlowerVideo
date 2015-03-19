//
//  RMRegisteredAccountViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15/3/4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMRegisteredAccountViewController.h"
#import "RMAFNRequestManager.h"
#import "UITextField+LimitLength.h"

@interface RMRegisteredAccountViewController ()<UITextFieldDelegate,RMAFNRequestManagerDelegate,UIAlertViewDelegate>{
    RMAFNRequestManager *requestManager;
}
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@end

@implementation RMRegisteredAccountViewController

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"注册"];
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    rightBarButton.hidden = YES;
    
    [self.userNameTextField limitTextLength:30];
    
    requestManager = [[RMAFNRequestManager alloc] init];
    requestManager.delegate = self;
    
    CALayer * passWordLayer = [self.passWordContentView layer];
    passWordLayer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    passWordLayer.borderWidth = 1.0f;
    
    CALayer * userNameLayer = [self.userNameContentView layer];
    userNameLayer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    userNameLayer.borderWidth = 1.0f;
    
    CALayer *accountLayer = [self.accountContentView layer];
    accountLayer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    accountLayer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
//!!!!:注册
- (IBAction)registerButtonClick:(UIButton *)sender {
    if(![self isValidateEmail:self.accountTextField.text]){
        [self showMessage:@"请输入正确的邮箱地址" duration:1 withUserInteractionEnabled:YES];
        return;
    }
    if(self.passWordTextField.text.length<6){
        [self showMessage:@"密码必须是六位以上" duration:1 withUserInteractionEnabled:YES];
        return;
    }
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
    [requestManager userRegisteredWithEmail:self.accountTextField.text
                                   userName:self.userNameTextField.text
                                   passWord:self.passWordTextField.text];
}

- (void)requestFinishiDownLoadWithResults:(NSString *)results{
    [self hideLoading];
    if([results isEqualToString:@"success"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else{
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
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

@end
