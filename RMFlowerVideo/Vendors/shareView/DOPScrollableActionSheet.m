//
//  DOPScrollableActionSheet.m
//  RMFlowerVideo
//
//  Created by runmobile on 14-9-28.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "DOPScrollableActionSheet.h"
#import "UMSocial.h"
#import "CONST.h"
#import "RMVideoPlaybackDetailsViewController.h"
#import "UIButton+EnlargeEdge.h"
#import "UtilityFunc.h"

@interface DOPScrollableActionSheet ()<UMSocialUIDelegate,UIGestureRecognizerDelegate>{
    float height;
}
@property (nonatomic, strong) UIView * subView;
@end

@implementation DOPScrollableActionSheet

- (void)initWithPlatformHeadImageArray:(NSArray *)images{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:gesture];
    
    height = 144;
    float lineOriginY = 37,cancleBtnOriginY = 13,shareBtnWidth = 36,shareBtnStartPoint = 25,spacing = 22.5,font = 10;
    if(IS_IPHONE_6_SCREEN){
        height = 170,lineOriginY = 44,cancleBtnOriginY = 15,shareBtnWidth = 45,shareBtnStartPoint = spacing = 25,font = 11;
    }else if (IS_IPHONE_6p_SCREEN){
        height = 187,lineOriginY = 48,cancleBtnOriginY = 15,shareBtnWidth = 50,shareBtnStartPoint = spacing = 27,font = 12;
    }
    
    self.subView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, height)];
    self.subView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.subView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, lineOriginY, ScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:1];
    [self.subView addSubview:line];
    
    UILabel *shareLable = [[UILabel alloc] initWithFrame:CGRectMake(14, cancleBtnOriginY, 80, 14)];
    shareLable.text = @"分享至";
    [shareLable setFont:[UIFont systemFontOfSize:14]];
    shareLable.backgroundColor = [UIColor clearColor];
    shareLable.textColor = [UIColor whiteColor];
    [self.subView addSubview:shareLable];
    
    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancle.frame = CGRectMake(ScreenWidth-50-15, cancleBtnOriginY, 50, 14);
    [cancle setBackgroundColor:[UIColor clearColor]];
    [cancle setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [cancle addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.subView addSubview:cancle];
    
    NSArray *nameArray = [NSArray arrayWithObjects:@"新浪微博",@"微信",@"QQ",@"QQ空间",@"朋友圈", nil];
    for(int i=0;i<5;i++){
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(i*shareBtnWidth+shareBtnStartPoint+i*spacing, spacing+lineOriginY, shareBtnWidth, shareBtnWidth);
        [shareBtn setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(beginShareContent:) forControlEvents:UIControlEventTouchUpInside];
        shareBtn.tag = i;
        [self.subView addSubview:shareBtn];
        
        UILabel *lable = [[UILabel alloc] init];
        lable.text = [nameArray objectAtIndex:i];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:font];
        lable.textColor = [UIColor whiteColor];
        float x = (shareBtnStartPoint-spacing+spacing/2)+i*(shareBtnWidth+spacing);
        float w = shareBtnWidth+spacing;
        lable.frame = CGRectMake(x, spacing+lineOriginY+shareBtnWidth, w, shareBtnWidth);
        [self.subView addSubview:lable];
    }
}

- (void)beginShareContent:(UIButton *)btn{
    [self dismiss];
    selectIndex(btn.tag);

//    /*
//     NSArray *shareArray = [UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray;
//     sina,
//     tencent,
//     wxsession,
//     wxtimeline,
//     wxfavorite,
//     qzone,
//     qq,
//     renren,
//     douban,
//     email,
//     sms,
//     facebook,
//     twitter
//     */
//    
//    RMVideoPlaybackDetailsViewController * videoPlaybackDetails = self.VideoPlaybackDetailsDelegate;
//    NSString *shareString = [NSString stringWithFormat:@"我正在看《%@》,精彩内容,精准推荐,尽在小花视频 %@",self.videoName,kAppAddress];
////    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[[self getSocialSnsPlatformNameWithType:btn.tag]] content:shareString image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.video_pic]]] location:nil urlResource:nil presentedController:videoPlaybackDetails completion:^(UMSocialResponseEntity *response){
////        if (response.responseCode == UMSResponseCodeSuccess) {
////            NSLog(@"分享成功！");
////        }
////    }];
//    switch (btn.tag) {
//        case 0:{
////            [[UMSocialControllerService defaultControllerService] setShareText:shareString shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.video_pic]]] socialUIDelegate:self];
////            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
////            snsPlatform.snsClickHandler(videoPlaybackDetails,[UMSocialControllerService defaultControllerService],YES);
//            
//            [[UMSocialControllerService defaultControllerService] setShareText:shareString shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.video_pic]]] socialUIDelegate:self];
//            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//            snsPlatform.snsClickHandler(videoPlaybackDetails,[UMSocialControllerService defaultControllerService],YES);
//            
////            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina]
////                                                                content:shareString
////                                                                  image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.video_pic]]]
////                                                               location:nil
////                                                            urlResource:nil
////                                                    presentedController:videoPlaybackDetails
////                                                             completion:^(UMSocialResponseEntity *shareResponse){
////                                                                 if (shareResponse.responseCode == UMSResponseCodeSuccess) {
////                                                                     NSLog(@"分享成功！");
////                                                                     shareSuccess();
////                                                                 }
////                                                                 else{
////                                                                     shareError();
////                                                                 }
////                                                             }];
//        }
//            break;
//        default:{
//            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[[self getSocialSnsPlatformNameWithType:btn.tag]]
//                                                                content:shareString
//                                                                  image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.video_pic]]]
//                                                               location:nil urlResource:nil
//                                                    presentedController:videoPlaybackDetails
//                                                             completion:^(UMSocialResponseEntity *response){
//                if (response.responseCode == UMSResponseCodeSuccess) {
//                    NSLog(@"分享成功！");
//                }
//            }];
//        }
//            break;
//    }
}
- (void)shareBtnSelectIndex:(void (^)(NSInteger))block{
    selectIndex = block;
}
- (void)shareSuccess:(void(^)())block{
    shareSuccess = block;
}
- (void)shareError:(void(^)())block{
    shareError = block;
}
- (void)show {
    self.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:0.4];
    [UIView animateWithDuration:0.2 animations:^{
        self.subView.frame = CGRectMake(0, ScreenHeight-height, ScreenWidth, height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.subView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, height);
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
}

//- (NSString *)getSocialSnsPlatformNameWithType:(NSInteger)type {
//    switch (type) {
//        case 0:{
//            return @"sina";
//            break;
//        }
//        case 1:{
//            return @"wxsession";
//            break;
//        }
//        case 2:{
//            return @"qq";
//            break;
//        }
//        case 3:{
//            return @"qzone";
//            break;
//        }
//        case 4:{
//            return @"wxtimeline";
//            break;
//        }
//            
//        default:
//            return nil;
//            break;
//    }
//}

@end
