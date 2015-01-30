//
//  RMAboutViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMAboutViewController.h"
#import "RMAFNRequestManager.h"

@interface RMAboutViewController ()<RMAFNRequestManagerDelegate,UIWebViewDelegate>{
    RMAFNRequestManager *requestManager;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation RMAboutViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self hideLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    rightBarButton.hidden = YES;
    [self setCustomNavTitle:@"关于"];
    requestManager = [[RMAFNRequestManager alloc] init];
    requestManager.delegate = self;
    [requestManager aboutWithVersionNumber:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey] Os:@"iPhone"];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoading];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self showMessage:@"加载失败" duration:1 withUserInteractionEnabled:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestFinishiDownLoadWithResults:(NSString *)results{
    NSURL *url = [NSURL URLWithString:results];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
