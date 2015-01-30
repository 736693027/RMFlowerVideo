//
//  RMFeedBackViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMFeedBackViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RMAFNRequestManager.h"

@interface RMFeedBackViewController ()<UITextViewDelegate,RMAFNRequestManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation RMFeedBackViewController

- (void)viewDidAppear:(BOOL)animated{
    [self.textView becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    [rightBarButton setBackgroundImage:LOADIMAGE(@"send_message") forState:UIControlStateNormal];
    [self setCustomNavTitle:@"用户反馈"];
    self.textView.layer.borderColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor;
    self.textView.layer.borderWidth = 1;
    
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 2:{
            CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
            NSDictionary *userIofn = [storage objectForKey:UserLoginInformation_KEY];
            RMAFNRequestManager *requestManager = [[RMAFNRequestManager alloc] init];
            requestManager.delegate = self;
            [self showLoadingSimpleWithUserInteractionEnabled:YES];
            [requestManager userFeedbackWithToken:[userIofn objectForKey:@"token"] Text:[self.textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)requestFinishiDownLoadWithResults:(NSString *)results{
    [self hideLoading];
    if([results isEqualToString:@"success"]){
        [self performSelector:@selector(popViewController) withObject:nil afterDelay:1];
    }
}
- (void)requestError:(NSError *)error{
    [self hideLoading];
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
