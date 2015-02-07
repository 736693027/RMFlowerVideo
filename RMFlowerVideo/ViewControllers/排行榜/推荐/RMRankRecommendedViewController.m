//
//  RMRankRecommendedViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15/1/21.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMRankRecommendedViewController.h"

@interface RMRankRecommendedViewController ()

@end

@implementation RMRankRecommendedViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideLoading];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:self.titleString];
    NSURL *URL = [NSURL URLWithString:self.webUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideLoading];
}
@end
