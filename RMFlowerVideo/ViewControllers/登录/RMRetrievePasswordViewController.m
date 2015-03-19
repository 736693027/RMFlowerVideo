//
//  RMRetrievePasswordViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15/3/4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMRetrievePasswordViewController.h"
#import "RMAFNRequestManager.h"

@interface RMRetrievePasswordViewController ()<UITextFieldDelegate,RMAFNRequestManagerDelegate,UIAlertViewDelegate>{
    RMAFNRequestManager *requestManager;
}
@property (weak, nonatomic) IBOutlet UITextField *e_mailTextField;

@end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
@implementation RMRetrievePasswordViewController

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"找回密码"];
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    rightBarButton.hidden = YES;
    
    CALayer * emailLayer = [self.emailContentView layer];
    emailLayer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    emailLayer.borderWidth = 1.0f;
    requestManager = [[RMAFNRequestManager alloc] init];
    requestManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitInfo:(UIButton *)sender {
    [self.view endEditing:YES];
    if([self isValidateEmail:self.e_mailTextField.text]){
        [self showLoadingSimpleWithUserInteractionEnabled:YES];
        [requestManager resetPasswordWithEmail:self.e_mailTextField.text];
    }
    else{
        [self showMessage:@"请输入正确的邮箱格式" duration:1 withUserInteractionEnabled:YES];
    }
}
- (void)requestFinishiDownLoadWithResults:(NSString *)results{
    [self hideLoading];
    if([results isEqualToString:@"success"]){
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:@"您的请求也处理，请及时查看相关邮件" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alerView show];
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

-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

@end
