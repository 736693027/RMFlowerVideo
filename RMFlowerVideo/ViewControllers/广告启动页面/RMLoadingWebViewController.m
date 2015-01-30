//
//  RMLoadingWebViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15/1/26.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMLoadingWebViewController.h"

@interface RMLoadingWebViewController()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation RMLoadingWebViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:self.name];
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    rightBarButton.hidden = YES;
    NSURL *url = [NSURL URLWithString:self.loadingUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoading];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideLoading];
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self showMessage:@"地址解析失败" duration:1.0 position:1 withUserInteractionEnabled:YES];
//    });
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIDeviceOrientationIsLandscape(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
