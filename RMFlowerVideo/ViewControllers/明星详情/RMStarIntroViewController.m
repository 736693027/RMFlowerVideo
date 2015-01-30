//
//  RMStarIntroViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-6.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMStarIntroViewController.h"

@interface RMStarIntroViewController ()<UIScrollViewDelegate>

@end

@implementation RMStarIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:self.starName];
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    rightBarButton.hidden = YES;
    
    UIScrollView * scroll= [[UIScrollView alloc] init];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    scroll.showsVerticalScrollIndicator = YES;
    scroll.showsHorizontalScrollIndicator = YES;
    scroll.delegate = self;
    [self.view addSubview:scroll];
    
    UILabel * introduce = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 0)];
    introduce.numberOfLines = 0;
    introduce.font = FONT(14.0);
    introduce.backgroundColor = [UIColor clearColor];
    [scroll addSubview:introduce];
    
    // 设置字体间每行的间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.lineHeightMultiple = 15.0f;
    //    paragraphStyle.maximumLineHeight = 15.0f;
    //    paragraphStyle.minimumLineHeight = 15.0f;
    paragraphStyle.lineSpacing = 10.0f;// 行间距
    NSDictionary *ats = @{
                          NSParagraphStyleAttributeName : paragraphStyle,
                          };
    introduce.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.starIntrodue] attributes:ats];
    [introduce sizeToFit];
    
    CGRect introFrame =introduce.frame;
    introFrame.size.width = ScreenWidth - 20;
    introduce.frame = introFrame;
    [scroll setContentSize:CGSizeMake(ScreenWidth, introduce.frame.size.height+20)];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]){
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }
            break;
        }
        case 2:{
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
