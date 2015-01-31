//
//  DOPScrollableActionSheet.m
//  DOPScrollableActionSheet
//
//  Created by weizhou on 12/27/14.
//  Copyright (c) 2014 fengweizhou. All rights reserved.
//

#import "DOPScrollableActionSheet.h"
#import "UMSocial.h"
#import "CONST.h"
#import "RMVideoPlaybackDetailsViewController.h"

@interface DOPScrollableActionSheet ()<UMSocialUIDelegate>

@property (nonatomic, assign) CGRect         screenRect;
@property (nonatomic, strong) UIWindow       *window;
@property (nonatomic, strong) UIView         *dimBackground;

@end

@implementation DOPScrollableActionSheet

- (instancetype)initWithPlatformHeadImageArray:(NSArray *)images{
    self = [super init];
    if (self) {
        _screenRect = [UIScreen mainScreen].bounds;
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.5 &&
            UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            _screenRect = CGRectMake(0, 0, _screenRect.size.height, _screenRect.size.width);
        }
        _dimBackground = [[UIView alloc] initWithFrame:_screenRect];
        _dimBackground.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_dimBackground addGestureRecognizer:gr];
        self.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:1];
        float height = 144, lineOriginY = 37,cancleBtnOriginY = 13,shareBtnWidth = 36,shareBtnStartPoint = 25,spacing = 22.5,font = 10;
        if(IS_IPHONE_6_SCREEN){
            height = 170,lineOriginY = 44,cancleBtnOriginY = 15,shareBtnWidth = 45,shareBtnStartPoint = spacing = 25,font = 11;
        }else if (IS_IPHONE_6p_SCREEN){
            height = 187,lineOriginY = 48,cancleBtnOriginY = 15,shareBtnWidth = 50,shareBtnStartPoint = spacing = 27,font = 12;
        }
        self.frame = CGRectMake(0, _screenRect.size.height, _screenRect.size.width,  height );
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, lineOriginY, _screenRect.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:1];
        [self addSubview:line];
        
        UILabel *shareLable = [[UILabel alloc] initWithFrame:CGRectMake(14, cancleBtnOriginY, 80, 14)];
        shareLable.text = @"分享至";
        [shareLable setFont:[UIFont systemFontOfSize:14]];
        shareLable.backgroundColor = [UIColor clearColor];
        shareLable.textColor = [UIColor whiteColor];
        [self addSubview:shareLable];
        
        UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancle setTitle:@"取消" forState:UIControlStateNormal];
        [cancle.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [cancle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancle.frame = CGRectMake(_screenRect.size.width-50-15, cancleBtnOriginY, 50, 14);
        [cancle setBackgroundColor:[UIColor clearColor]];
        [cancle addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancle];
        
        NSArray *nameArray = [NSArray arrayWithObjects:@"新浪微博",@"微信",@"QQ",@"QQ空间",@"朋友圈", nil];
        for(int i=0;i<5;i++){
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            shareBtn.frame = CGRectMake(i*shareBtnWidth+shareBtnStartPoint+i*spacing, spacing+lineOriginY, shareBtnWidth, shareBtnWidth);
            [shareBtn setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(beginShareContent:) forControlEvents:UIControlEventTouchUpInside];
            shareBtn.tag = i;
            [self addSubview:shareBtn];
            
            UILabel *lable = [[UILabel alloc] init];
            lable.text = [nameArray objectAtIndex:i];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.font = [UIFont systemFontOfSize:font];
            lable.textColor = [UIColor whiteColor];
            float x = (shareBtnStartPoint-spacing+spacing/2)+i*(shareBtnWidth+spacing);
            float w = shareBtnWidth+spacing;
            lable.frame = CGRectMake(x, spacing+lineOriginY+shareBtnWidth, w, shareBtnWidth);
            [self addSubview:lable];
        }
    }
    return self;
}
- (void)beginShareContent:(UIButton *)btn{
    /*
     NSArray *shareArray = [UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray;
     sina,
     tencent,
     wxsession,
     wxtimeline,
     wxfavorite,
     qzone,
     qq,
     renren,
     douban,
     email,
     sms,
     facebook,
     twitter
     */
    
    RMVideoPlaybackDetailsViewController * videoPlaybackDetails = self.VideoPlaybackDetailsDelegate;
    
    [self dismiss];
    NSString *shareString = [NSString stringWithFormat:@"我正在看《%@》,精彩内容,精准推荐,尽在小花视频 %@",self.videoName,kAppAddress];
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[[self getSocialSnsPlatformNameWithType:btn.tag]] content:shareString image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.video_pic]]] location:nil urlResource:nil presentedController:videoPlaybackDetails completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];
    switch (btn.tag) {
        case 0:
        {
            [[UMSocialControllerService defaultControllerService] setShareText:shareString shareImage:nil socialUIDelegate:self];
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            snsPlatform.snsClickHandler(videoPlaybackDetails,[UMSocialControllerService defaultControllerService],YES);
            
        }
            break;
        default:{
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[[self getSocialSnsPlatformNameWithType:btn.tag]] content:shareString image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.video_pic]]] location:nil urlResource:nil presentedController:videoPlaybackDetails completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }
            break;
    }
}

- (void)show {
    self.window = [[UIWindow alloc] initWithFrame:self.screenRect];
    self.window.windowLevel = UIWindowLevelAlert;
    self.window.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = [UIViewController new];
    self.window.rootViewController.view.backgroundColor = [UIColor clearColor];
    
    [self.window.rootViewController.view addSubview:self.dimBackground];
    [self.window.rootViewController.view addSubview:self];
    
    self.window.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.dimBackground.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        self.frame = CGRectMake(0, self.screenRect.size.height-self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.dimBackground.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, self.screenRect.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.window = nil;
    }];
}

- (NSString *)getSocialSnsPlatformNameWithType:(NSInteger)type {
    switch (type) {
        case 0:{
            return @"sina";
            break;
        }
        case 1:{
            return @"wxsession";
            break;
        }
        case 2:{
            return @"qq";
            break;
        }
        case 3:{
            return @"qzone";
            break;
        }
        case 4:{
            return @"wxtimeline";
            break;
        }
            
        default:
            return nil;
            break;
    }
}

@end
