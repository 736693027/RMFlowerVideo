//
//  RMRankRecommendedViewController.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 15/1/21.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMRankRecommendedViewController : RMBaseViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic ,copy) NSString *webUrl;

@property (nonatomic, copy)NSString *titleString;

@end
