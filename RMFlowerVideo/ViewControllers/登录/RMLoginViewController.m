//
//  RMLoginViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-2.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMLoginViewController.h"
#import "UMSocial.h"
#import "RMAFNRequestManager.h"
#import "CUSFileStorage.h"
#import "CUSSerializer.h"
#import "RMGenderTabViewController.h"
#import "Flurry.h"
#import "RMRegisteredAccountViewController.h"
#import "RMRetrievePasswordViewController.h"
#import "RMChangePasswordViewController.h"

@interface RMLoginViewController ()<UMSocialUIDelegate,RMAFNRequestManagerDelegate>{
    RMAFNRequestManager *requestManager;
    NSString *userName;
    NSString *userIconUrl;
    __weak IBOutlet UIButton *sinaLoginBtn;
    __weak IBOutlet UIButton *QQLoginBtn;
    __weak IBOutlet UITextField *accountTextField;
    __weak IBOutlet UITextField *passwordTextField;
    __weak IBOutlet UIView *contentView;
}

@end

@implementation RMLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Flurry logEvent:@"VIEW_UserLogin" timed:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"VIEW_UserLogin" withParameters:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideLoading];
    [requestManager cancelRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    [self setCustomNavTitle:@"登录"];
    
    leftBarButton.hidden = YES;
    [rightBarButton setBackgroundImage:LOADIMAGE(@"nav_cancel_btn") forState:UIControlStateNormal];
    requestManager = [[RMAFNRequestManager alloc] init];
    requestManager.delegate = self;
    
    CALayer * layer = [self.passwordContentView layer];
    layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    layer.borderWidth = 1.0f;
    
    CALayer *layer1 = [self.accountContentView layer];
    layer1.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    layer1.borderWidth = 1.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)  name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardDidHideNotification object:nil];

}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
    
            break;
        }
        case 2:{
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:^{
            }];
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)sinaLoginBtnClick:(UIButton *)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            userName = snsAccount.userName;
            userIconUrl = snsAccount.iconURL;
            [requestManager loginWithSource_type:@"4"
                                       Source_id:snsAccount.usid
                                        Username:[snsAccount.userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                            Face:[snsAccount.iconURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    });
    
    /* 删除登录

     [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
     NSLog(@"response is %@",response);
     }];
     */
    
}

- (IBAction)QQLoginBtnClick:(UIButton *)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
            userName = snsAccount.userName;
            userIconUrl = snsAccount.iconURL;
            [requestManager loginWithSource_type:@"3"
                                       Source_id:snsAccount.usid
                                        Username:[snsAccount.userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                            Face:[snsAccount.iconURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        //这里可以获取到腾讯微博openid,Qzone的token等
        /*
         if ([platformName isEqualToString:UMShareToTencent]) {
         [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToTencent completion:^(UMSocialResponseEntity *respose){
         NSLog(@"get openid  response is %@",respose);
         }];
         }
         */
    });
}
//小花账号登录
- (IBAction)xiaohuaLogin:(UIButton *)sender {
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
    [requestManager loginWithEmail:accountTextField.text andUserPassWord:passwordTextField.text];
}

- (void)requestFinishiDownLoadWithToken:(NSString *)token{
    [self hideLoading];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:userName forKey:@"userName"];
    [dict setValue:userIconUrl forKey:@"userIconUrl"];
    [dict setValue:token forKey:@"token"];
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
    [storage beginUpdates];
    NSString * loginStatus = [AESCrypt encrypt:@"islogin" password:PASSWORD];
    [storage setObject:dict forKey:UserLoginInformation_KEY];
    [storage setObject:loginStatus forKey:LoginStatus_KEY];
    [storage endUpdates];
    
//    RMGenderTabViewController *genderTarVC = [[RMGenderTabViewController alloc] init];
//    [self.navigationController pushViewController:genderTarVC animated:YES];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestFinishiDownLoadWithUserInfo:(NSDictionary *)userInfo{
    [self hideLoading];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[userInfo objectForKey:@"name"] forKey:@"userName"];
    [dict setValue:nil forKey:@"userIconUrl"];
    [dict setValue:[userInfo objectForKey:@"token"] forKey:@"token"];
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
    [storage beginUpdates];
    NSString * loginStatus = [AESCrypt encrypt:@"islogin" password:PASSWORD];
    [storage setObject:dict forKey:UserLoginInformation_KEY];
    [storage setObject:loginStatus forKey:LoginStatus_KEY];
    [storage endUpdates];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)requestFinishiDownLoadWithResults:(NSString *)results{
    [self hideLoading];
    [self showMessage:results duration:1 withUserInteractionEnabled:YES];
}
- (void)keyboardWillShow:(NSNotification *)notification{
    
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    NSLog(@"duration:%@",duration);
    [UIView animateWithDuration:0.3 animations:^{
        //            [self replacePickerContainerViewTopConstraintWithConstant:-(250-49)];
        contentView.bounds = CGRectMake(0, 252-49, contentView.bounds.size.width, contentView.bounds.size.height);
    }];
}
- (void)keyBoardWillHide:(NSNotification *)notification{
    
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
//    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:0.25 animations:^{
        contentView.bounds = CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height);
    }];
}
//注册账号
- (IBAction)registeredAccountClick:(UIButton *)sender {
    RMRegisteredAccountViewController *accountViewController;
    if(IS_IPHONE_6_SCREEN){
        accountViewController = [[RMRegisteredAccountViewController alloc] initWithNibName:@"RMRegisteredAccountViewController_6" bundle:nil];
    }else if (IS_IPHONE_6p_SCREEN){
        accountViewController = [[RMRegisteredAccountViewController alloc] initWithNibName:@"RMRegisteredAccountViewController_6p" bundle:nil];
    }else{
        accountViewController = [[RMRegisteredAccountViewController alloc] init];
    }
    [self.navigationController pushViewController:accountViewController animated:YES];
}
//找回密码
- (IBAction)retrievePasswordClick:(UIButton *)sender {
    RMRetrievePasswordViewController *passWordViewController;
    if(IS_IPHONE_6_SCREEN){
        passWordViewController = [[RMRetrievePasswordViewController alloc] initWithNibName:@"RMRetrievePasswordViewController_6" bundle:nil];
    }else if (IS_IPHONE_6p_SCREEN){
        passWordViewController = [[RMRetrievePasswordViewController alloc] initWithNibName:@"RMRetrievePasswordViewController_6p" bundle:nil];
    }else{
        passWordViewController = [[RMRetrievePasswordViewController alloc] init];
    }
    [self.navigationController pushViewController:passWordViewController animated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)replacePickerContainerViewTopConstraintWithConstant:(CGFloat)constant
{
    for (NSLayoutConstraint *constraint in contentView.superview.constraints) {
        if (constraint.firstItem == contentView && constraint.firstAttribute == NSLayoutAttributeTop) {
            constraint.constant = constant;
        }
    }
}
@end
