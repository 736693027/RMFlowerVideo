//
//  RMStarDetailsViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-6.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMStarDetailsViewController.h"
#import "RMStarIntroViewController.h"
#import "RMChannelMoviesViewController.h"
#import "RMChannelTeleplayViewController.h"
#import "RMChannelVarietyViewController.h"
#import "RMSegmentedMultiSelectController.h"

typedef enum{
    requestStarType = 1,
    requestVideoNumType,
}LoadType;

@interface RMStarDetailsViewController ()<SwitchSelectedMethodDelegate,RMAFNRequestManagerDelegate>{
    RMSegmentedMultiSelectController * segmentedCtl;
    RMChannelMoviesViewController * channelMoviesCtl;       //电影
    RMChannelTeleplayViewController * channelTeleplayCtl;   //电视剧
    RMChannelVarietyViewController * channelVarietyCtl;     //综艺
    RMAFNRequestManager * manager;
    UIImageView * starHead;                 //明星头像
    UILabel * starIntrodue;                 //明星详情
    LoadType loadType;                      //请求类型
    
    BOOL isFirstViewAppear;                 //第一次进viewDidLoad
    BOOL isStarWorks;                       //判断明星有无作品
    
    
}
@property (nonatomic, copy) RMPublicModel * publicModel;    //明星数据
@end

@implementation RMStarDetailsViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstViewAppear){
        [self startStarRequest];
        isFirstViewAppear = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setCustomNavTitle:@""];
    manager = [[RMAFNRequestManager alloc] init];
    
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    rightBarButton.hidden = YES;
    
    [self loadStarView];
    isFirstViewAppear = YES;
    isStarWorks = YES;
}

- (void)switchSelectedMethodWithValue:(NSInteger)value withTitle:(NSString *)title {
    switch (value) {
        case 0:{
            if ([title isEqualToString:@"电影"]){
                if (! channelMoviesCtl){
                    channelMoviesCtl = [[RMChannelMoviesViewController alloc] init];
                }
                channelMoviesCtl.view.frame = CGRectMake(0, 274, ScreenWidth, ScreenHeight - 274);
                channelMoviesCtl.MyChannelDetailsDelegate = self;
                channelMoviesCtl.ctlType = @"明星";
                channelMoviesCtl.tag_id = self.tag_id;
                [self.view addSubview:channelMoviesCtl.view];
            }else if ([title isEqualToString:@"电视剧"]){
                if (! channelTeleplayCtl){
                    channelTeleplayCtl = [[RMChannelTeleplayViewController alloc] init];
                }
                channelTeleplayCtl.view.frame = CGRectMake(0, 274, ScreenWidth, ScreenHeight - 274);
                channelTeleplayCtl.MyChannelDetailsDelegate = self;
                channelTeleplayCtl.tag_id = self.tag_id;
                channelTeleplayCtl.ctlType = @"明星";
                [self.view addSubview:channelTeleplayCtl.view];
            }else{
                if (! channelVarietyCtl){
                    channelVarietyCtl = [[RMChannelVarietyViewController alloc] init];
                }
                channelVarietyCtl.view.frame = CGRectMake(0, 274, ScreenWidth, ScreenHeight - 274);
                channelVarietyCtl.MyChannelDetailsDelegate = self;
                channelVarietyCtl.tag_id = self.tag_id;
                channelVarietyCtl.ctlType = @"明星";
                [self.view addSubview:channelVarietyCtl.view];
            }
            break;
        }
        case 1:{
            if ([title isEqualToString:@"电视剧"]){
                if (! channelTeleplayCtl){
                    channelTeleplayCtl = [[RMChannelTeleplayViewController alloc] init];
                }
                channelTeleplayCtl.view.frame = CGRectMake(0, 274, ScreenWidth, ScreenHeight - 274);
                channelTeleplayCtl.MyChannelDetailsDelegate = self;
                channelTeleplayCtl.tag_id = self.tag_id;
                channelTeleplayCtl.ctlType = @"明星";
                [self.view addSubview:channelTeleplayCtl.view];
            }else if ([title isEqualToString:@"综艺"]){
                if (! channelVarietyCtl){
                    channelVarietyCtl = [[RMChannelVarietyViewController alloc] init];
                }
                channelVarietyCtl.view.frame = CGRectMake(0, 274, ScreenWidth, ScreenHeight - 274);
                channelVarietyCtl.MyChannelDetailsDelegate = self;
                channelVarietyCtl.tag_id = self.tag_id;
                channelVarietyCtl.ctlType = @"明星";
                [self.view addSubview:channelVarietyCtl.view];
            }
            break;
        }
        case 2:{
            if (! channelVarietyCtl){
                channelVarietyCtl = [[RMChannelVarietyViewController alloc] init];
            }
            channelVarietyCtl.view.frame = CGRectMake(0, 274, ScreenWidth, ScreenHeight - 274);
            channelVarietyCtl.MyChannelDetailsDelegate = self;
            channelVarietyCtl.tag_id = self.tag_id;
            channelVarietyCtl.ctlType = @"明星";
            [self.view addSubview:channelVarietyCtl.view];
            break;
        }
            
        default:
            break;
    }
}

- (void)loadStarView {
    starHead = [[UIImageView alloc] initWithFrame:CGRectMake(12, 76, 92, 138)];
    starHead.backgroundColor = [UIColor clearColor];
    [self.view addSubview:starHead];
    
    starIntrodue = [[UILabel alloc] initWithFrame:CGRectMake(110, 75, ScreenWidth - 120, 120)];
    starIntrodue.numberOfLines = 0;
    starIntrodue.font = FONT(14.0);
    [self.view addSubview:starIntrodue];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            [self hideLoading];
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
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

#pragma mark - 请求


/**
 *  请求明星详情内容
 */
- (void)startStarRequest {
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
    loadType = requestStarType;
    manager.delegate = self;
    [manager getStarDetailWithTag_id:self.tag_id];
}

/**
 *  请求明星对应的资源种类及数量
 */
- (void)startVideoNumRequest {
    loadType = requestVideoNumType;
    manager.delegate = self;
    [manager getVideoNumWithTag_id:self.tag_id];
}

/**
 *  跳明星介绍
 */
- (void)jumpIntrodueMethod {
    RMStarIntroViewController * starIntroCtl = [[RMStarIntroViewController alloc] init];
    starIntroCtl.starName = self.publicModel.name;
    starIntroCtl.starIntrodue = self.publicModel.detail;
    [self.navigationController pushViewController:starIntroCtl animated:YES];
}

- (void)requestFinishiDownLoadWithModel:(RMPublicModel *)model {
    switch (loadType) {
        case requestStarType:{
            self.publicModel = [[RMPublicModel alloc] init];
            self.publicModel.name = model.name;
            self.publicModel.detail = model.detail;
            self.publicModel.tag_id = model.tag_id;
            
            [self setCustomNavTitle:model.name];
            [starHead sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
            // 设置字体间每行的间距
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            //    paragraphStyle.lineHeightMultiple = 15.0f;
            //    paragraphStyle.maximumLineHeight = 15.0f;
            //    paragraphStyle.minimumLineHeight = 15.0f;
            paragraphStyle.lineSpacing = 5.0f;// 行间距
            NSDictionary *ats = @{
                                  NSParagraphStyleAttributeName : paragraphStyle,
                                  };
            starIntrodue.attributedText = [[NSAttributedString alloc] initWithString:model.detail attributes:ats];
            
            UIImageView * jumpIntrodueImg;
            UIButton * jumpBtn;
            
            if (model.detail.length != 0){
                jumpIntrodueImg = [[UIImageView alloc] init];
                jumpIntrodueImg.frame = CGRectMake(ScreenWidth-50, 200, 36, 13);
                jumpIntrodueImg.image = LOADIMAGE(@"starDetails_show");
                [self.view addSubview:jumpIntrodueImg];
                
                jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                jumpBtn.frame = CGRectMake(110, 75, ScreenWidth - 120, 140);
                jumpBtn.backgroundColor = [UIColor clearColor];
                [jumpBtn addTarget:self action:@selector(jumpIntrodueMethod) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:jumpBtn];
            }else{
                jumpBtn.enabled = NO;
                starIntrodue.text = @"暂无介绍";
            }
            
            if ([model.detail isEqualToString:@"暂无"]){
                starIntrodue.text = @"暂无介绍";
                jumpBtn.enabled = NO;
                jumpIntrodueImg.hidden = YES;
            }
            
            [self startVideoNumRequest];
            [self hideLoading];
            break;
        }
        case requestVideoNumType:{
            if (model.vod_num.integerValue == 0 && model.tv_num.integerValue == 0 && model.variety_num.integerValue == 0){
                isStarWorks = NO;
                NSLog(@"该明星无相关作品");
            }else{
                NSArray * nameArr = [self getNameArrWithTVNum:model.tv_num withVarietyNum:model.variety_num withVodNum:model.vod_num];
                segmentedCtl = [[RMSegmentedMultiSelectController alloc] initWithSectionTitles:@[[nameArr objectAtIndex:0], [nameArr objectAtIndex:1], [nameArr objectAtIndex:2]] withIdentifierType:@"明星详情" withAddLine:YES];
                segmentedCtl.delegate = self;
                segmentedCtl.frame = CGRectMake(0, 224, ScreenWidth, 50);
                [segmentedCtl setSelectedIndex:0];
                [segmentedCtl setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]];
                [segmentedCtl setTextColor:[UIColor clearColor]];
                [segmentedCtl setSelectionIndicatorColor:[UIColor clearColor]];
                [self.view addSubview:segmentedCtl];
                NSString * firstName;
                for (NSInteger i=0; i<[nameArr count]; i++){
                    if (![[nameArr objectAtIndex:i] isEqualToString:@""]){
                        firstName = [nameArr objectAtIndex:i];
                        break;
                    }
                }
                [self switchSelectedMethodWithValue:0 withTitle:firstName];
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)requestError:(NSError *)error {
    switch (loadType) {
        case requestStarType:{
            //To ignore this method
            [self hideLoading];
            break;
        }
        case requestVideoNumType:{
            NSLog(@"获取明星作品error");
            break;
        }
            
        default:
            break;
    }
}

- (NSArray *)getNameArrWithTVNum:(NSString *)tv withVarietyNum:(NSString *)variety withVodNum:(NSString *)vod {
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    if (vod.integerValue == 0){
        [arr addObject:@""];
    }else{
        [arr addObject:@"电影"];
    }
    
    if (tv.integerValue == 0){
        [arr addObject:@""];
    }else{
        [arr addObject:@"电视剧"];
    }
    
    if (variety.integerValue == 0){
        [arr addObject:@""];
    }else{
        [arr addObject:@"综艺"];
    }
    return arr;
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
