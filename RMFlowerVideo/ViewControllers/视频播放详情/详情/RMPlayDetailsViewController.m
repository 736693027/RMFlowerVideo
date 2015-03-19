//
//  RMPlayDetailsViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-5.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMPlayDetailsViewController.h"
#import "RatingView.h"

@interface RMPlayDetailsViewController ()<UIScrollViewDelegate>{
    UIScrollView * scrView;
    UILabel * introduce;
}

@property (nonatomic, copy) NSString * content;
@end

@implementation RMPlayDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];

    scrView = [[UIScrollView alloc] init];
    scrView.backgroundColor = [UIColor clearColor];
    if (IS_IPHONE_6_SCREEN | IS_IPHONE_6p_SCREEN){
        scrView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 205 - 75);
    }else{
        scrView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 205 - 84);
    }
    scrView.showsVerticalScrollIndicator = YES;
    scrView.showsHorizontalScrollIndicator = YES;
    scrView.delegate = self;
    [self.view addSubview:scrView];
    
    introduce = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, ScreenWidth - 20, 0)];
    introduce.numberOfLines = 0;
    introduce.font = [UIFont systemFontOfSize:14.0];
    introduce.backgroundColor = [UIColor clearColor];
    [scrView addSubview:introduce];
}

- (void)refreshViewWithContent:(NSString *)content {
    if(content==nil)
        content = @"暂无简介";
    // 设置字体间每行的间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.lineHeightMultiple = 15.0f;
    //    paragraphStyle.maximumLineHeight = 15.0f;
    //    paragraphStyle.minimumLineHeight = 15.0f;
    paragraphStyle.lineSpacing = 10.0f;// 行间距
    NSDictionary *ats = @{
                          NSParagraphStyleAttributeName : paragraphStyle,
                          };
    introduce.attributedText = [[NSAttributedString alloc] initWithString:content attributes:ats];
    
    [introduce sizeToFit];
    
    CGRect introFrame = introduce.frame;
    introFrame.size.width = ScreenWidth - 20;
    introduce.frame = introFrame;
    [scrView setContentSize:CGSizeMake(ScreenWidth, introduce.frame.size.height + 150)];
}

- (void)reloadDataWithModel:(RMPublicModel *)model {
    
    [self refreshViewWithContent:model.content];
    
    UILabel * videoName = [[UILabel alloc] init];
    videoName.frame = CGRectMake(15, 15, ScreenWidth - 30, 30);
    videoName.text = model.name;
    videoName.font = FONT(20.0);
    videoName.backgroundColor = [UIColor clearColor];
    videoName.textColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1];
    [scrView addSubview:videoName];
    
    RatingView * rate = [[RatingView alloc] init];
    rate.frame = CGRectMake(15, 55, 100, 20);
    [rate setImagesDeselected:@"rateEmpty" partlySelected:@"rateEmpty" fullSelected:@"rateFull" andDelegate:nil];
    [rate displayRating:model.gold.integerValue];
    [scrView addSubview:rate];
    
    NSString * countStr = [NSString stringWithFormat:@"播放%@次",model.hits];
    CGSize countFrame = [UtilityFunc boundingRectWithSize:CGSizeMake(0, 20) font:[UIFont systemFontOfSize:12.0] text:countStr];
    
    UIView * videoCountView = [[UIView alloc] init];
    [videoCountView.layer setCornerRadius:8];
    videoCountView.backgroundColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1];
    videoCountView.frame = CGRectMake(140, 50, countFrame.width + 25, 18);
    [scrView addSubview:videoCountView];
    
    UIImageView * countImg = [[UIImageView alloc] init];
    countImg.image = LOADIMAGE(@"playCount_frame");
    countImg.frame = CGRectMake(2, 2, 14, 14);
    countImg.backgroundColor = [UIColor clearColor];
    [videoCountView addSubview:countImg];
    
    UILabel * count = [[UILabel alloc] init];
    count.textColor = [UIColor whiteColor];
    count.frame = CGRectMake(160, 52, countFrame.width + 20, 14);
    count.text = [NSString stringWithFormat:@"播放%@次",model.hits];
    count.font = FONT(12.0);
    count.backgroundColor = [UIColor clearColor];
    [scrView addSubview:count];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(10, 90, ScreenWidth - 20, 1);
    lineView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [scrView addSubview:lineView];
}

@end
