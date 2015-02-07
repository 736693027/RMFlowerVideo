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

@interface RMLoginViewController ()<UMSocialUIDelegate,RMAFNRequestManagerDelegate>{
    RMAFNRequestManager *requestManager;
    NSString *userName;
    NSString *userIconUrl;
    __weak IBOutlet UIButton *sinaLoginBtn;
    __weak IBOutlet UIButton *QQLoginBtn;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    [self setCustomNavTitle:@"登录"];
    
    leftBarButton.hidden = YES;
    [rightBarButton setBackgroundImage:LOADIMAGE(@"nav_cancel_btn") forState:UIControlStateNormal];
    requestManager = [[RMAFNRequestManager alloc] init];
    requestManager.delegate = self;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerDismiss) name:@"LoginSuccessCallback" object:nil];
    
//    if(IS_IPHONE_6_SCREEN){
//        [sinaLoginBtn setImage:LOADIMAGE(@"weibo_login_6") forState:UIControlStateNormal];
//        [QQLoginBtn setImage:LOADIMAGE(@"QQ_login_6") forState:UIControlStateNormal];
//    }else if (IS_IPHONE_6p_SCREEN){
//        [sinaLoginBtn setImage:LOADIMAGE(@"weibo_login_6p") forState:UIControlStateNormal];
//        [QQLoginBtn setImage:LOADIMAGE(@"QQ_login_6p") forState:UIControlStateNormal];
//    }

}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
    
            break;
        }
        case 2:{
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
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

- (void)requestFinishiDownLoadWithToken:(NSString *)token{
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
@end
