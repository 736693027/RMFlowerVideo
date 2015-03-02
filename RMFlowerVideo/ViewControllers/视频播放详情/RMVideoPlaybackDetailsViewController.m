//
//  RMVideoPlaybackDetailsViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-5.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMVideoPlaybackDetailsViewController.h"
#import "RMDetailsBottomView.h"
#import "RMSegmentedController.h"
#import "RMPlayRelatedViewController.h"
#import "RMPlayDetailsViewController.h"
#import "RMPlayCreatorViewController.h"
#import "DOPScrollableActionSheet.h"
#import "RMPlayTVEpisodeViewController.h"
#import "RMSourceTypeView.h"
#import "RMTopJumpWebView.h"
#import "RMLoadingWebViewController.h"
#import "RMLoginViewController.h"

#import "UMSocial.h"
#import "RMTickerView.h"
#import "RMTouchVIew.h"
#import "RMCustomVideoPlayerView.h"
#import "RMLoadingView.h"
#import "RMCustomVideoPlayerView.h"
#import "RMCustomSVProgressHUD.h"
#import "UIButton+EnlargeEdge.h"
#import "RMEpisodeView.h"
#import "RMDownLoadingViewController.h"
#import "RMTVDownLoadViewController.h"
#import "RMCustomPresentNavViewController.h"
#import "Flurry.h"

typedef enum{
    requestAddFavoriteType = 1,
    requestDeleteFavoriteType,
    requestVideoDetailsType
}RequestType;

@interface RMVideoPlaybackDetailsViewController ()<BottomBtnDelegate,SwitchSelectedMethodDelegate,RMAFNRequestManagerDelegate,TouchViewDelegate,UIScrollViewDelegate,SourceTypeDelegate,TVEpisodeDelegate,RefreshPlayAddressDelegate,UMSocialUIDelegate>{
    RMSegmentedController * segmentedCtl;
    RMPlayRelatedViewController * playRelatedCtl;
    RMPlayDetailsViewController * playDetailsCtl;
    RMPlayCreatorViewController * playCreatorCtl;
    RMPlayTVEpisodeViewController *playEpisodeCtl;
    RMSourceTypeView * sourceTypeView;
    RMTopJumpWebView * topJumpWebView;
    
    NSArray * nameArr;                      //segmentedCtl 上面的选项
    BOOL isFirstViewAppear;                 //是否第一次加载
    BOOL isDeviceRotating;                  //设备是否旋转
    id playbackObserver;
    RequestType requestType;
    
    RMDownLoadingViewController *rmDownLoading;//下载视图
    
    NSTimer *upadtePlayMovieTime;
}
@property (nonatomic, copy) NSString *goneTimeString;
@property (nonatomic, copy) NSString *totalTimeString;
@property (nonatomic, copy) NSString *HUDTotalTimeString;
@property (nonatomic, copy) NSString *detailTimeString;
@property (nonatomic, assign) float progressValue;

@property (nonatomic, strong) UIImageView * topView;                //上工具条
@property (nonatomic, strong) UIView * selectEpisodeView;           //选集视图
@property (nonatomic, strong) UIScrollView * selectEpisodeScr;      //选集视图中的ScrView

@property (nonatomic, strong) UIButton * playBtn;                   //播放 暂停
@property (nonatomic, strong) UISlider * progressBar;               //播放进度条
@property (nonatomic, strong) UIProgressView * cacheProgress;       //已缓存进度条
@property (nonatomic, strong) UIImageView * belowView;              //下工具条
@property (nonatomic, assign) NSInteger currentPlayOrder;           //电视剧当前播放的集数

@property (nonatomic, strong) RMTouchVIew * touchView;              //添加手势
@property (nonatomic, strong) UIButton * nextBtn;                   //下一个视频
@property (nonatomic, strong) UIButton *selectEpisodeBtn;           //选集按钮
@property (nonatomic, strong) RMTickerView * videoTitleCycle;       //视频滚动标题
@property (nonatomic, strong) UILabel * videoTitle;                 //视频不滚动标题
@property (nonatomic, strong) UIButton * zoomBtn;                   //视频放大缩小

@property (nonatomic, strong) RMLoadingView * loadingView;          //HUD
@property (nonatomic, strong) RMCustomSVProgressHUD * customHUD;    //HUD

@property (nonatomic, strong) UILabel * goneTime;                   //视频已播放时间
@property (nonatomic, strong) UILabel * totalTime;                  //视频总共时间
@property (nonatomic, strong) UILabel * detailTime;                 //小屏幕时候 视频播放时间

@property (nonatomic, assign) BOOL isPop;                           //选集view 是否弹出 YES 弹出  NO 隐藏
@property (nonatomic, assign) BOOL isCycle;                         //标题是否循环滚动
@property (nonatomic, assign) BOOL isHidenToolView;                 //上下工具条是否隐藏 YES 隐藏  NO 显示

@property (nonatomic, assign) CGFloat noOperationSecond;            //用户在播放器界面没有任何操作的持续时间，发生任何操作刷新此时间为0 单位：秒

@property (nonatomic, copy) NSString *positionIdentifier;           //判断当前是否是左右滑动
@property (nonatomic, assign) int fastForwardOrRetreatQuickly;      //视频若快进和快退时，标记当前的位置

@property (nonatomic, strong) RMCustomVideoPlayerView * player;
@property (nonatomic, strong) RMDetailsBottomView * detailsBottomView;      //底部选择项

@property (nonatomic, strong) RMPublicModel * dataModel;            //视频数据

@property (nonatomic, copy) NSString * currentSelectType;           //当前选择播放源类型
@property (nonatomic, assign) NSInteger currentPlayVideoOrder;      //当前播放视频的集数

@property (nonatomic, assign) BOOL isCollection;                    //当前是否已经收藏
@property (nonatomic, assign) NSInteger currentWatchVideo;          //当前观看电视剧的集数
@property (nonatomic, assign) NSInteger currentPlayState;           //1为mp4地址正在加载   2为mp4地址加载失败   3为mp4地址加载成功

@end

@implementation RMVideoPlaybackDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Flurry logEvent:@"VIEW_VideoPlayDetail" timed:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUIWhenPlayerFailed) name:@"refreshUIWhenPlayerFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kDeviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"VIEW_VideoPlayDetail" withParameters:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayJumpWeb) object:nil];
    [self hideLoading];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstViewAppear){
        [self stratRequestWithVideo_id:self.video_id];
        //???: 创建播放器
        [self loadMediaPlayerView];
        //???: 创建播放器相关的控件
        [self loadPlayView];
        //???: 创建播放器手势
        [self loadTouchView];
        [self StartTimerWithAutomaticHidenToolView];
        [self loadHUD];
        isFirstViewAppear = NO;
        upadtePlayMovieTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateMovieLoadTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:upadtePlayMovieTime forMode:NSDefaultRunLoopMode];
        [upadtePlayMovieTime setFireDate:[NSDate distantFuture]];
    }
    [self kDeviceOrientationDidChangeNotification:0];
    
    //统计视频播放次数
    RMAFNRequestManager * requestManager = [[RMAFNRequestManager alloc] init];
    [requestManager getDeviceHitsWithVideo_id:self.video_id Device:@"iPhone"];
    requestManager.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideLoading];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshUIWhenPlayerFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kDeviceOrientationDidChangeNotification" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];

    leftBarButton.hidden = YES;
    rightBarButton.hidden = YES;
    if (IS_IPHONE_6p_SCREEN | IS_IPHONE_6_SCREEN){
        self.detailsBottomView = [[RMDetailsBottomView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49)];
    }else{
        self.detailsBottomView = [[RMDetailsBottomView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
    }
    self.detailsBottomView.backgroundColor = [UIColor blackColor];
    self.detailsBottomView.delegate = self;
    [self.detailsBottomView initDetailsBottomView];
    [self.view addSubview:self.detailsBottomView];
    
    if ([self.segVideoType isEqualToString:@"电影"]){
        nameArr = [NSArray arrayWithObjects:@"详情", @"主创", @"相关", nil];
    }else{
        nameArr = [NSArray arrayWithObjects:@"剧集", @"详情", @"主创", nil];
    }

    segmentedCtl = [[RMSegmentedController alloc] initWithFrame:CGRectMake(0, 226, [UIScreen mainScreen].bounds.size.width, 35) withSectionTitles:@[[nameArr objectAtIndex:0], [nameArr objectAtIndex:1], [nameArr objectAtIndex:2]] withIdentifierType:@"视频播放详情" withLineEdge:0 withAddLine:YES];
    segmentedCtl.delegate = self;
    [segmentedCtl setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]];
    [segmentedCtl setTextColor:[UIColor clearColor]];
    [segmentedCtl setSelectionIndicatorColor:[UIColor clearColor]];
    [self.view addSubview:segmentedCtl];

    isFirstViewAppear = YES;
    self.currentWatchVideo = 0;
}

/*
 *  ???:选集 刷新视频
 */
- (void)videoEpisodeWithOrder:(NSInteger)order {
    [upadtePlayMovieTime setFireDate:[NSDate distantFuture]];
    if (self.dataModel.video_type.integerValue == 2){   //电视剧
        self.currentWatchVideo = order;
        for (NSInteger i=0; i<[self.dataModel.playurls count]; i++) {
            if ([self.currentSelectType isEqualToString:[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"source_type"]]){
                [self replaceAVPlayer];
                [self playerWithURL:[[[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"urls"] objectAtIndex:(order)] objectForKey:@"m_down_url"]];
                break;
            }
        }
    }else{  //综艺
        self.currentWatchVideo = order-1;
        for (NSInteger i=0; i<[self.dataModel.playurls count]; i++) {
            if ([self.currentSelectType isEqualToString:[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"source_type"]]){
                [self replaceAVPlayer];
                [self playerWithURL:[[[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"urls"] objectAtIndex:(order-1)] objectForKey:@"m_down_url"]];
                break;
            }
        }
    }
    [self hideHUD];
}

/*
 *  重新加载界面
 */
- (void)reloadViewDidLoadWithVideo_id:(NSString *)video_id {
    [upadtePlayMovieTime setFireDate:[NSDate distantFuture]];
    if (self.dataModel.video_type.integerValue == 2){   //电视剧
        self.currentWatchVideo = 0;
    }else if (self.dataModel.video_type.integerValue == 3){  //综艺
        self.currentWatchVideo = [[[self.dataModel.playurls objectAtIndex:0] objectForKey:@"urls"] count] - 1;
    }else{
    }
    [self stratRequestWithVideo_id:video_id];
}

/*
 *  ???:点击 重新刷新播放当前类型下的视频资源
 */
- (void)refreshPlayAddressMethod {
    [self replaceAVPlayer];
    topJumpWebView.hidden = YES;
    if (self.dataModel.video_type.integerValue == 1){
        if ([self.dataModel.playurl count] == 0){
            [self refreshUIWhenPlayerFailed];
        }else{
            for (NSInteger i=0; i<[self.dataModel.playurl count]; i++){
                if ([[[self.dataModel.playurl objectAtIndex:i] objectForKey:@"source_type"] isEqualToString:self.currentSelectType]){
                    [self playerWithURL:[[self.dataModel.playurl objectAtIndex:i] objectForKey:@"m_down_url"]];
                    break;
                }else{
                }
            }
        }
    }else{
        if ([self.dataModel.playurls count] == 0){
            [self refreshUIWhenPlayerFailed];
        }else{
            if (self.dataModel.video_type.integerValue == 2){   //电视剧
                self.currentWatchVideo = 0;
                if ([[[self.dataModel.playurls objectAtIndex:0] objectForKey:@"urls"] count] == 0){
                    [self refreshUIWhenPlayerFailed];
                }else{
                    for (NSInteger i=0; i<[self.dataModel.playurls count]; i++) {
                        if ([[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"source_type"] isEqualToString:self.currentSelectType]){
                            [self playerWithURL:[[[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"urls"] objectAtIndex:0] objectForKey:@"m_down_url"]];
                            break;
                        }else{
                            
                        }
                    }
                }
            }else{  //综艺
                if ([[[self.dataModel.playurls objectAtIndex:0] objectForKey:@"urls"] count] == 0){
                    [self refreshUIWhenPlayerFailed];
                }else{
                    for (NSInteger i=0; i<[self.dataModel.playurls count]; i++) {
                        if ([[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"source_type"] isEqualToString:self.currentSelectType]){
                            self.currentWatchVideo = [[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"urls"] count] - 1;
                            [self playerWithURL:[[[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"urls"] objectAtIndex:0] objectForKey:@"m_down_url"]];
                            break;
                        }else{
                            
                        }
                    }
                }
            }
        }
    }
    [self hideHUD];
}

/*
 *  默认加载Player内容 type 1 为电影  2为电视剧 综艺
*/
- (void)reloadFirstPlayerContent {
    [self replaceAVPlayer];
    if (self.dataModel.video_type.integerValue == 2){   //电视剧
        self.currentWatchVideo = 0;
    }else if (self.dataModel.video_type.integerValue == 3){  //综艺
        self.currentWatchVideo = [[[self.dataModel.playurls objectAtIndex:0] objectForKey:@"urls"] count] - 1;
    }else{
        
    }
    //???:播放电影
    if (self.dataModel.video_type.integerValue == 1){
        if ([self.dataModel.playurl count] == 0){
            //???:没有地址，跳web
            [self refreshUIWhenPlayerFailed];
        }else{
            [self playerWithURL:[[self.dataModel.playurl objectAtIndex:0] objectForKey:@"m_down_url"]];
        }
    }else{
        //???:播放电视剧
        if ([self.dataModel.playurls count] == 0){
            //???:没有地址，跳web
            [self refreshUIWhenPlayerFailed];
        }else{
            if ([[[self.dataModel.playurls objectAtIndex:0] objectForKey:@"urls"] count] == 0){
                //???:没有地址，跳web
                [self refreshUIWhenPlayerFailed];
            }else{
                [self playerWithURL:[[[[self.dataModel.playurls objectAtIndex:0] objectForKey:@"urls"] objectAtIndex:0] objectForKey:@"m_down_url"]];
            }
        }
    }
    [self hideHUD];
}
//???:播放失败
- (void)refreshUIWhenPlayerFailed {
    [self replaceAVPlayer];
    [self hideHUD];
    self.currentPlayState = 2;
    isDeviceRotating = YES;
    [self loadTopJumpWebUI];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        self.player.isFullScreenMode = NO;
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)loadTopJumpWebUI {
    if (!topJumpWebView){
        topJumpWebView = [[RMTopJumpWebView alloc] init];
        topJumpWebView.delegate = self;
        topJumpWebView.frame = CGRectMake(0, 0, ScreenWidth, 180);
        topJumpWebView.backgroundColor = [UIColor blackColor];
        [topJumpWebView initTopJumpWebView];
        [self.view addSubview:topJumpWebView];
    }
    topJumpWebView.hidden = NO;
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
    [self performSelector:@selector(delayJumpWeb) withObject:nil afterDelay:1.0];
}
//???:跳转web
- (void)delayJumpWeb {
    isDeviceRotating = NO;
    NSLog(@"跳web");
    if ([self.dataModel.video_type isEqualToString:@"1"]){   //电影
        if (self.dataModel.playurl.count == 0){
            [self hideLoading];
            [self showHUDWithImage:@"videoIsNotAddress" imageFrame:CGRectMake(0, 0, 160, 40) duration:1.5 userInteractionEnabled:YES];
        }else{
            for (NSInteger i=0; i<[self.dataModel.playurl count]; i++){
                if ([[[self.dataModel.playurl objectAtIndex:i] objectForKey:@"source_type"] isEqualToString:self.currentSelectType]){
                    RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
                    loadingWebCtl.loadingUrl = [[self.dataModel.playurl objectAtIndex:i] objectForKey:@"jumpurl"];
                    loadingWebCtl.name = self.dataModel.name;
                    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
                    [self presentViewController:loadingWebCtl animated:YES completion:^{
                    }];
                    break;
                }else{
                }
            }
        }
    }else{  //电视剧 综艺
        if (self.dataModel.playurls.count == 0){
            [self hideLoading];
            [self showHUDWithImage:@"videoIsNotAddress" imageFrame:CGRectMake(0, 0, 160, 40) duration:1.5 userInteractionEnabled:YES];
        }else{
            if (self.dataModel.video_type.integerValue == 2){   //电视剧
                for (NSInteger i=0; i<[self.dataModel.playurls count]; i++){
                    if ([[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"source_type"] isEqualToString:self.currentSelectType]){
                        if ([[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"urls"] count] == 0){
                        }else{
                            RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
                            loadingWebCtl.loadingUrl = [[[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"urls"] objectAtIndex:self.currentWatchVideo] objectForKey:@"jumpurl"];
                            loadingWebCtl.name = self.dataModel.name;
                            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
                            [self presentViewController:loadingWebCtl animated:YES completion:^{
                            }];
                        }
                        break;
                    }else{
                    }
                }
            }else{  //综艺
                for (NSInteger i=0; i<[self.dataModel.playurls count]; i++){
                    if ([[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"source_type"] isEqualToString:self.currentSelectType]){
                        if ([[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"urls"] count] == 0){
                        }else{
                            RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
                            loadingWebCtl.loadingUrl = [[[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"urls"] objectAtIndex:self.currentWatchVideo] objectForKey:@"jumpurl"];
                            loadingWebCtl.name = self.dataModel.name;
                            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
                            [self presentViewController:loadingWebCtl animated:YES completion:^{
                            }];
                        }
                        break;
                    }else{
                    }
                }
            }

        }
    }
    [self hideLoading];
}

- (void)switchSelectedMethodWithValue:(int)value withTitle:(NSString *)title {
    //电影：详情 主创 相关     电视剧： 剧集  详情 主创
    switch (value) {
        case 0:{
            if (self.dataModel.video_type.integerValue == 1){
                if (! playDetailsCtl){              //详情
                    playDetailsCtl = [[RMPlayDetailsViewController alloc] init];
                }
                if (IS_IPHONE_6_SCREEN | IS_IPHONE_6p_SCREEN){
                    playDetailsCtl.view.frame = CGRectMake(0, 261, ScreenWidth, ScreenHeight - 261 - 49);
                }else{
                    playDetailsCtl.view.frame = CGRectMake(0, 261, ScreenWidth, ScreenHeight - 261 - 40);
                }
                playDetailsCtl.videoPlaybackDetailsDelegate = self;
                [playDetailsCtl reloadDataWithModel:self.dataModel];
                [self.view addSubview:playDetailsCtl.view];
            }else{
                if (! playEpisodeCtl){              //剧集
                    playEpisodeCtl = [[RMPlayTVEpisodeViewController alloc] init];
                }
                if (IS_IPHONE_6p_SCREEN | IS_IPHONE_6_SCREEN){
                    playEpisodeCtl.view.frame = CGRectMake(0, 261, ScreenWidth, ScreenHeight - 261 - 49);
                }else{
                    playEpisodeCtl.view.frame = CGRectMake(0, 261, ScreenWidth, ScreenHeight - 261 - 40);
                }
                playEpisodeCtl.videoPlaybackDetailsDelegate = self;
                playEpisodeCtl.delegate = self;
                [playEpisodeCtl reloadDataWithModel:self.dataModel withVideoSourceType:self.currentSelectType];
                [self.view addSubview:playEpisodeCtl.view];
            }
            break;
        }
        case 1:{
            if (self.dataModel.video_type.integerValue == 1){
                if (! playCreatorCtl){              //主创
                    playCreatorCtl = [[RMPlayCreatorViewController alloc] init];
                }
                if (IS_IPHONE_6_SCREEN | IS_IPHONE_6p_SCREEN){
                    playCreatorCtl.view.frame = CGRectMake(0, 261, ScreenWidth, ScreenHeight - 261 - 49);
                }else{
                    playCreatorCtl.view.frame = CGRectMake(0, 261, ScreenWidth, ScreenHeight - 261 - 40);
                }
                playCreatorCtl.videoPlaybackDetailsDelegate = self;
                [playCreatorCtl reloadDataWithModel:self.dataModel];
                [self.view addSubview:playCreatorCtl.view];
            }else{
                if (! playDetailsCtl){              //详情
                    playDetailsCtl = [[RMPlayDetailsViewController alloc] init];
                }
                if (IS_IPHONE_6p_SCREEN | IS_IPHONE_6_SCREEN){
                    playDetailsCtl.view.frame = CGRectMake(0, 261, ScreenWidth, ScreenHeight - 261 - 49);
                }else{
                    playDetailsCtl.view.frame = CGRectMake(0, 261, ScreenWidth, ScreenHeight - 261 - 40);
                }
                playDetailsCtl.videoPlaybackDetailsDelegate = self;
                [playDetailsCtl reloadDataWithModel:self.dataModel];
                [self.view addSubview:playDetailsCtl.view];
                
            }
            break;
        }
        case 2:{
            if (self.dataModel.video_type.integerValue == 1){
                if (! playRelatedCtl){              //相关
                    playRelatedCtl = [[RMPlayRelatedViewController alloc] init];
                }
                if (IS_IPHONE_6_SCREEN | IS_IPHONE_6p_SCREEN){
                    playRelatedCtl.view.frame = CGRectMake(0, 261, ScreenWidth, ScreenHeight - 261 - 49);
                }else{
                    playRelatedCtl.view.frame = CGRectMake(0, 261, ScreenWidth, ScreenHeight - 261 - 40);
                }
                playRelatedCtl.videoPlaybackDetailsDelegate = self;
                [playRelatedCtl reloadDataWithModel:self.dataModel];
                [self.view addSubview:playRelatedCtl.view];
            }else{
                if (! playCreatorCtl){              //主创
                    playCreatorCtl = [[RMPlayCreatorViewController alloc] init];
                }
                if (IS_IPHONE_6p_SCREEN | IS_IPHONE_6_SCREEN){
                    playCreatorCtl.view.frame = CGRectMake(0, 261, ScreenWidth, ScreenHeight - 261 - 49);
                }else{
                    playCreatorCtl.view.frame = CGRectMake(0, 261, ScreenWidth, ScreenHeight - 261 - 40);
                }
                playCreatorCtl.videoPlaybackDetailsDelegate = self;
                [playCreatorCtl reloadDataWithModel:self.dataModel];
                [self.view addSubview:playCreatorCtl.view];
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)bottomBtnActionMethodWithSender:(NSInteger)sender {
    switch (sender) {
        case 1:{    //返回
            [self replaceAVPlayer];
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            [self dismissViewControllerAnimated:YES completion:^{
            }];
            break;
        }
        case 2:{//下载
            [Flurry logEvent:@"Click_DownLoad"];
            if ([self.dataModel.is_download isEqualToString:@"0"]){
                [self showHUDWithImage:@"videoIsNotDownload" imageFrame:CGRectMake(0, 0, 160, 40) duration:1.5 userInteractionEnabled:YES];
                return;
            }
            rmDownLoading = [RMDownLoadingViewController shared];
            if (self.dataModel.video_type.integerValue == 1){   //电影]
                for(NSDictionary *dict in self.dataModel.playurl){
                    if([[dict objectForKey:@"source_type"] isEqualToString:self.currentSelectType]){
                        if([dict objectForKey:@"m_down_url"]==nil||![[[dict objectForKey:@"m_down_url"] pathExtension] isEqualToString:@"mp4"]){
                            [self showHUDWithImage:@"videoIsNotDownload" imageFrame:CGRectMake(0, 0, 160, 40) duration:1.5 userInteractionEnabled:YES];
                        }
                        else if([[Database sharedDatabase] isDownLoadMovieWith:self.dataModel]){
                            [self showHUDWithImage:@"videoIsDownloaded" imageFrame:CGRectMake(0, 0, 160, 40) duration:1.5 userInteractionEnabled:YES];
                        }
                        else if( [self isContainsModel:rmDownLoading.dataArray modelName:self.dataModel.name]){
                            [self showHUDWithImage:@"videoIsQueue" imageFrame:CGRectMake(0, 0, 160, 40) duration:1.5 userInteractionEnabled:YES];
                        }
                        else{
                            RMPublicModel *model = [[RMPublicModel alloc] init];
                            model.downLoadURL = [dict objectForKey:@"m_down_url"];
                            model.name = self.dataModel.name;
                            model.downLoadState = @"等待缓存";
                            model.actors = self.dataModel.actor;
                            model.directors = self.dataModel.director;
                            model.hits = self.dataModel.hits;
                            model.totalMemory = @"0M";
                            model.alreadyCasheMemory = @"0M";
                            model.cacheProgress = @"0.0";
                            model.pic = self.dataModel.pic;
                            model.video_id = self.dataModel.video_id;
                            model.isTVModel = NO;
                            [rmDownLoading.dataArray addObject:model];
                            [rmDownLoading.downLoadIDArray addObject:model];
                            [rmDownLoading BeginDownLoad];
                            [self showHUDWithImage:@"videoAddSucess" imageFrame:CGRectMake(0, 0, 160, 40) duration:1.5 userInteractionEnabled:YES];
                            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:rmDownLoading.dataArray];
                            [[NSUserDefaults standardUserDefaults] setObject:data forKey:DownLoadDataArray_KEY];
                        }
                    }
                }
            }else{  //电视剧
                RMTVDownLoadViewController *tvDownLoadMoreViewControl = [[RMTVDownLoadViewController alloc] init];
                tvDownLoadMoreViewControl.videoName = self.dataModel.name;
                tvDownLoadMoreViewControl.actors = self.dataModel.actors;
                tvDownLoadMoreViewControl.director = self.dataModel.directors;
                tvDownLoadMoreViewControl.PlayCount = self.dataModel.hits;
                tvDownLoadMoreViewControl.videoHeadImage = self.dataModel.pic;
                tvDownLoadMoreViewControl.video_id = self.dataModel.video_id;
                RMCustomPresentNavViewController *nav = [[RMCustomPresentNavViewController alloc] initWithRootViewController:tvDownLoadMoreViewControl];
                nav.navigationBar.hidden = YES;
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
                [self presentViewController:nav animated:YES completion:nil];
            }
            break;
        }
        case 3:{    //添加收藏   删除收藏
            [Flurry logEvent:@"Click_Collection"];
            if ([self.dataModel.video_id isEqualToString:@""] || self.dataModel.video_id.integerValue == 0){
                return;
            }
            //判断登录
            CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
            if (![[AESCrypt decrypt:[storage objectForKey:LoginStatus_KEY] password:PASSWORD] isEqualToString:@"islogin"]){
                RMLoginViewController * loginCtl = [[RMLoginViewController alloc] init];
                RMCustomPresentNavViewController *loginNav = [[RMCustomPresentNavViewController alloc] initWithRootViewController:loginCtl];
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
                [self presentViewController:loginNav animated:YES completion:^{
                }];
                return;
            }
            NSDictionary *dict = [storage objectForKey:UserLoginInformation_KEY];
            NSString * token = [NSString stringWithFormat:@"%@",[dict objectForKey:@"token"]];
            nilToEmpty(token);
            RMAFNRequestManager * request = [[RMAFNRequestManager alloc] init];
            request.delegate = self;
            
            if (self.isCollection){
                requestType = requestDeleteFavoriteType;
                [request deleteFavoriteWithVideo_id:self.dataModel.video_id andToken:token];
            }else{
                requestType = requestAddFavoriteType;
                [request addFavoriteWithVideo_id:self.dataModel.video_id andToken:token];
            }
            
            break;
        }
        case 4:{    //分享
            [Flurry logEvent:@"Click_Share"];
            NSArray *imageName;
            if(IS_IPHONE_6_SCREEN){
                imageName = [NSArray arrayWithObjects:@"share_sina_6",@"share_wechat_6",@"share_qq_6",@"share_QQZore_6",@"share_friends_6", nil];
            }else if (IS_IPHONE_6p_SCREEN){
                imageName = [NSArray arrayWithObjects:@"share_sina_6p",@"share_wechat_6p",@"share_qq_6p",@"share_QQZore_6p",@"share_friends_6p", nil];
            }else{
                imageName = [NSArray arrayWithObjects:@"share_sina",@"share_wechat",@"share_qq",@"share_QQZore",@"share_friends", nil];
            }
            DOPScrollableActionSheet *action = [[DOPScrollableActionSheet alloc] init];
            action.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            action.backgroundColor = [UIColor clearColor];
            [action initWithPlatformHeadImageArray:imageName];                                    
            action.VideoPlaybackDetailsDelegate = self;
            action.videoName = self.dataModel.name;
            action.video_pic = self.dataModel.pic;
            [self.view addSubview:action];
            [action show];
            [action shareSuccess:^{
                [self showMessage:@"分享成功" duration:1 withUserInteractionEnabled:YES];
            }];
            [action shareError:^{
                [self showMessage:@"分享失败" duration:1 withUserInteractionEnabled:YES];
            }];
            [action shareBtnSelectIndex:^(NSInteger Index) {
                
                NSString *shareString = [NSString stringWithFormat:@"我正在看《%@》,精彩内容,精准推荐,尽在小花视频 %@",self.dataModel.name,kAppAddress];
                UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.dataModel.pic]]];
                if(Index==0){
                    [[UMSocialControllerService defaultControllerService] setShareText:shareString shareImage:shareImage socialUIDelegate:self];
                    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
                    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
                }else{
                    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[[self getSocialSnsPlatformNameWithType:Index]]
                                                                        content:shareString
                                                                          image:shareImage
                                                                       location:nil urlResource:nil
                                                            presentedController:self
                                                                     completion:^(UMSocialResponseEntity *response){
                                                                         if (response.responseCode == UMSResponseCodeSuccess) {
                                                                             NSLog(@"分享成功!");
                                                                         }
                                                                     }];
                }
                
            }];
            break;
        }
            
        default:
            break;
    }
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

- (void)replaceAVPlayer {
    [self.player replaceCurrentItem];
//    if (playbackObserver) {
//        [self.player.moviePlayer removeTimeObserver:playbackObserver];
//        playbackObserver = nil;
//    }
}

/**
 *  ???:type 1为电影   2为电视剧 或者 综艺
 */
- (void)loadSourceTypeUIWithType:(NSInteger)type {
    switch (type) {
        case 1:{
            NSMutableArray * totalArr = [[NSMutableArray alloc] init];
            for (NSInteger i=0; i<[self.dataModel.playurl count]; i++){
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.jumpurl = [[self.dataModel.playurl objectAtIndex:i] objectForKey:@"jumpurl"];
                model.m_down_url = [[self.dataModel.playurl objectAtIndex:i] objectForKey:@"m_down_url"];
                model.source_type = [[self.dataModel.playurl objectAtIndex:i] objectForKey:@"source_type"];
                [totalArr addObject:model];
                self.currentSelectType = [[self.dataModel.playurl objectAtIndex:0] objectForKey:@"source_type"];
            }
            if (!sourceTypeView){
                sourceTypeView = [[RMSourceTypeView alloc] init];
            }
            sourceTypeView.frame = CGRectMake(0, 180, ScreenWidth, 45);
            sourceTypeView.delegate = self;
            sourceTypeView.backgroundColor = [UIColor clearColor];
            [sourceTypeView loadSourceTypeViewWithTotal:totalArr];
            [self.view addSubview:sourceTypeView];
            break;
        }
        case 2:{
            NSMutableArray * totalArr = [[NSMutableArray alloc] init];
            for (NSInteger i=0; i<[self.dataModel.playurls count]; i++){
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.source_type = [[self.dataModel.playurls objectAtIndex:i] objectForKey:@"source_type"];
                model.urls = [[self.dataModel.playurls objectAtIndex:i] objectForKey:@"urls"];
                [totalArr addObject:model];
                self.currentSelectType = [[self.dataModel.playurls objectAtIndex:0] objectForKey:@"source_type"];
            }
            if (!sourceTypeView){
                sourceTypeView = [[RMSourceTypeView alloc] init];
            }
            sourceTypeView.frame = CGRectMake(0, 180, ScreenWidth, 45);
            sourceTypeView.delegate = self;
            sourceTypeView.backgroundColor = [UIColor clearColor];
            [sourceTypeView loadSourceTypeViewWithTotal:totalArr];
            [self.view addSubview:sourceTypeView];
            break;
        }
            
        default:
            break;
    }
}

/**
 *  ???:切换视频播放源  刷新当前播放资源
 *  ???:0:默认 1:优酷 2:迅雷 3:腾讯 4:乐视 5:pptv 6:爱奇艺 7:土豆 8:1905 9:华数 10.搜狐
 */
- (void)switchVideoSourceToCurrentType:(NSInteger)type {
    [upadtePlayMovieTime setFireDate:[NSDate distantFuture]];
    [self.player replaceCurrentItem];
//    if (playbackObserver) {
//        [self.player.moviePlayer removeTimeObserver:playbackObserver];
//        playbackObserver = nil;
//    }

    self.currentSelectType = [NSString stringWithFormat:@"%ld",(long)type];
    
    if (self.dataModel.video_type.integerValue == 1){
        for (NSInteger i=0; i<[self.dataModel.playurl count]; i++){
            if ([[[self.dataModel.playurl objectAtIndex:i] objectForKey:@"source_type"] integerValue] == type){
//                [self replaceAVPlayer];
                [self playerWithURL:[[self.dataModel.playurl objectAtIndex:i] objectForKey:@"m_down_url"]];
                break;
            }
        }
    }else{
        for (NSInteger i=0; i<[self.dataModel.playurls count]; i++) {
            if ([[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"source_type"] integerValue] == type){
                if ([[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"urls"] count] == 0){
                    [self showHUDWithImage:@"videoIsNotAddress" imageFrame:CGRectMake(0, 0, 160, 40) duration:1.5 userInteractionEnabled:YES];
                }else{
//                    [self replaceAVPlayer];
                    [self playerWithURL:[[[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"urls"] objectAtIndex:0] objectForKey:@"m_down_url"]];
                }
                break;
            }
        }
    }
    [self hideHUD];
}

#pragma mark - 请求

- (void)stratRequestWithVideo_id:(NSString *)video_id {
    requestType = requestVideoDetailsType;
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
    NSDictionary *dict = [storage objectForKey:UserLoginInformation_KEY];
    NSString * token = [NSString stringWithFormat:@"%@",[dict objectForKey:@"token"]];
    nilToEmpty(token);
    RMAFNRequestManager * request = [[RMAFNRequestManager alloc] init];
    request.delegate = self;
    [request getVideoDetailWithVideo_id:video_id Token:token];
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
}
//???: 收藏功能操作的网络请求回调
- (void)requestFinishiDownLoadWithResults:(NSString *)results {
    if (requestType == requestAddFavoriteType){ //添加收藏
        if ([results isEqualToString:@"success"]){
            [self showHUDWithImage:@"addColSucess" imageFrame:CGRectMake(0, 0, 130, 40) duration:2 userInteractionEnabled:YES];
            self.isCollection = YES;
            [self.detailsBottomView switchCollectionState:self.isCollection];
        }else{
            [self showHUDWithImage:@"addColFailed" imageFrame:CGRectMake(0, 0, 130, 40) duration:2 userInteractionEnabled:YES];
            self.isCollection = NO;
            [self.detailsBottomView switchCollectionState:self.isCollection];
        }
    }else{  //删除收藏
        if ([results isEqualToString:@"success"]){
            [self showHUDWithImage:@"deleteColSucess" imageFrame:CGRectMake(0, 0, 130, 40) duration:2 userInteractionEnabled:YES];
            self.isCollection = NO;
            [self.detailsBottomView switchCollectionState:self.isCollection];
        }else{
            [self showHUDWithImage:@"deleteColFailed" imageFrame:CGRectMake(0, 0, 130, 40) duration:2 userInteractionEnabled:YES];
            self.isCollection = NO;
            [self.detailsBottomView switchCollectionState:self.isCollection];
        }
    }
    [self hideLoading];
}
//???: 电影、电视剧、综艺数据下载回调
- (void)requestFinishiDownLoadWithModel:(RMPublicModel *)model {
    self.dataModel = model;
    NSString *jumpString = @"",*m_down_url = @"",*videoName = @"";
    RMPublicModel *historyModel = [[RMPublicModel alloc] init];
    if (model.video_type.integerValue == 1){    //电影
        [segmentedCtl setSelectedIndex:2];
        [self switchSelectedMethodWithValue:2 withTitle:nil];
        [self loadSourceTypeUIWithType:1];
        for(NSDictionary *dict in self.dataModel.playurl){
            if([[dict objectForKey:@"source_type"] isEqualToString:self.currentSelectType]){
                jumpString = [dict objectForKey:@"jumpurl"];
                m_down_url = [dict objectForKey:@"m_down_url"];
                videoName = self.dataModel.name;
                break;
            }
        }
        historyModel.actors = self.dataModel.actor;
    }else{  //电视剧   综艺
        [segmentedCtl setSelectedIndex:0];
        [self switchSelectedMethodWithValue:0 withTitle:nil];
        [self loadSourceTypeUIWithType:2];
        if(self.dataModel.playurls.count>0){
            NSDictionary *dict = [self.dataModel.playurls objectAtIndex:0];
            jumpString = [dict objectForKey:@"jumpurl"];
            m_down_url = [dict objectForKey:@"m_down_url"];
            if([self.dataModel.video_type isEqualToString:@"2"]){
                videoName = [NSString stringWithFormat:@"电视剧_%@",self.dataModel.name];
                historyModel.actors = self.dataModel.actor;
            }
            else{
                videoName = [NSString stringWithFormat:@"综艺_%@",self.dataModel.name];
                historyModel.actors = self.dataModel.presenters;
            }
        }
    }
    historyModel.pic = self.dataModel.pic;
    historyModel.name = videoName;
    historyModel.directors = self.dataModel.director;
    historyModel.hits = self.dataModel.hits;
    historyModel.m_down_url = m_down_url;
    historyModel.playTime = @"0";
    historyModel.video_id = self.dataModel.video_id;
    historyModel.jumpurl =jumpString;
    [[Database sharedDatabase] insertHistoryMovieItem:historyModel];
    
    if (self.dataModel.is_favorite.integerValue == 1){
        self.isCollection = YES;
    }else{
        self.isCollection = NO;
    }
    [self.detailsBottomView switchCollectionState:self.isCollection];
    
    if ([self.dataModel.is_download isEqualToString:@"1"]){
        [self.detailsBottomView switchDownLoadState:YES];
    }else{
        [self.detailsBottomView switchDownLoadState:NO];
    }
    
    if (self.dataModel.video_type.integerValue == 1){
        self.nextBtn.enabled = NO;
    }else{
        self.nextBtn.enabled = YES;
        self.currentPlayVideoOrder = 1;
    }
    
    if (!self.videoTitleCycle){
        self.videoTitleCycle = [[RMTickerView alloc] init];
        [self.topView addSubview:self.videoTitleCycle];

    }
    if (!self.videoTitle){
        self.videoTitle = [[UILabel alloc] init];
        [self.topView addSubview:self.videoTitle];
    }
    
    NSArray *tickerStrings;
    CGSize  titleSize;
    if (self.dataModel.video_type.integerValue == 1) {
        tickerStrings = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",self.dataModel.name], nil];
        titleSize = [UtilityFunc boundingRectWithSize:CGSizeMake(100000, 100000) font:[UIFont systemFontOfSize:16.0] text:self.dataModel.name];
        self.videoTitle.text = self.dataModel.name;
    }else{
        tickerStrings = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",self.dataModel.name], nil];
        titleSize = [UtilityFunc boundingRectWithSize:CGSizeMake(100000, 100000) font:[UIFont systemFontOfSize:16.0] text:self.dataModel.name];
        self.videoTitle.text = self.dataModel.name;
    }
    
    if (titleSize.width > ScreenHeight - 10){
        self.videoTitleCycle.frame = CGRectMake(10, 0, titleSize.width, 36);
        [self.videoTitleCycle setDirection:JHTickerDirectionLTR];
        [self.videoTitleCycle setTickerStrings:tickerStrings];
        [self.videoTitleCycle setTickerSpeed:30.0f];
        [self.videoTitleCycle start];
        self.videoTitle.hidden = YES;
        self.videoTitleCycle.hidden = NO;
        self.isCycle = YES;
    }else{
        self.videoTitle.frame = CGRectMake(10, 0, ScreenHeight - 10, 36);
        self.videoTitle.font = FONT(16.0);
        self.videoTitle.backgroundColor = [UIColor clearColor];
        self.videoTitle.textColor = [UIColor whiteColor];
        self.videoTitle.hidden = NO;
        self.videoTitleCycle.hidden = YES;
        self.isCycle = NO;
    }
    
    [self reloadFirstPlayerContent];
    [self hideLoading];
}

- (void)requestError:(NSError *)error {
    if (requestType == requestAddFavoriteType){ //添加收藏
        [self showHUDWithImage:@"addColFailed" imageFrame:CGRectMake(0, 0, 130, 40) duration:2 userInteractionEnabled:YES];
    }else if (requestType == requestDeleteFavoriteType){  //删除收藏
        [self showHUDWithImage:@"deleteColFailed" imageFrame:CGRectMake(0, 0, 130, 40) duration:2 userInteractionEnabled:YES];
    }else{
        
    }
    [self hideLoading];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self RefreshTimerWithAutomaticHidenToolView];
}

/***********************************************播放器的创建和使用****************************************************/

/**
 *  创建播放器UI
 */
- (void)loadPlayView {
    
    if (!self.topView){
        self.topView = [[UIImageView alloc] init];
    }
    self.topView.frame = CGRectMake(0, 0, ScreenHeight, 44);
    self.topView.alpha = 0.7;
    self.topView.userInteractionEnabled = YES;
    self.topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.topView];
    
    if (!self.belowView){
        self.belowView = [[UIImageView alloc] init];
    }
    self.belowView.userInteractionEnabled = YES;
    self.belowView.alpha = 0.7;
    self.belowView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.belowView];
    
    if (!self.playBtn){
        self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    self.playBtn.frame = CGRectMake(4, 2, 40, 40);
    [self.playBtn setEnlargeEdgeWithTop:10 right:5 bottom:10 left:5];
    [self.playBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.tag = 102;
    [self.playBtn setImage:[UIImage imageNamed:@"rm_play_btn"] forState:UIControlStateNormal];
    [self.belowView addSubview:self.playBtn];
    
    
    if (!self.nextBtn){
        self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    self.nextBtn.frame = CGRectMake(60, 2, 40, 40);
    [self.nextBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn setImage:[UIImage imageNamed:@"rm_next_btn"] forState:UIControlStateNormal];
    self.nextBtn.tag = 103;
    [self.belowView addSubview:self.nextBtn];
    
    if (!self.goneTime){
        self.goneTime = [[UILabel alloc] init];
    }
    self.goneTime.frame = CGRectMake(120, 14, 70, 30);
    self.goneTime.textColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.95 alpha:1];
    self.goneTime.text = @"00:00";
    self.goneTime.font = [UIFont systemFontOfSize:13.0];
    [self.goneTime sizeToFit];
    self.goneTime.backgroundColor = [UIColor clearColor];
    [self.belowView addSubview:self.goneTime];
    
    if (!self.totalTime){
        self.totalTime = [[UILabel alloc] init];
    }
    self.totalTime.frame = CGRectMake(ScreenHeight - 120, 14, 70, 30);
    self.totalTime.textColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.95 alpha:1];
    self.totalTime.font = [UIFont systemFontOfSize:13.0];
    self.totalTime.text = @"00:00";
    [self.totalTime sizeToFit];
    self.totalTime.backgroundColor = [UIColor clearColor];
    [self.belowView addSubview:self.totalTime];
    
    if (!self.detailTime){
        self.detailTime = [[UILabel alloc] init];
    }
    self.detailTime.frame = CGRectMake(ScreenWidth - 127, 5, 90, 30);
    self.detailTime.text = @"";
    self.detailTime.font = [UIFont systemFontOfSize:12.0];
    self.detailTime.textColor = [UIColor whiteColor];
    self.detailTime.textAlignment = NSTextAlignmentCenter;
    self.detailTime.backgroundColor = [UIColor clearColor];
    [self.belowView addSubview:self.detailTime];
    self.detailTime.hidden = YES;
        
    if (!self.progressBar){
        self.progressBar = [[UISlider alloc] init];
    }
    //滑条
    self.progressBar.minimumTrackTintColor = [UIColor redColor];
    self.progressBar.maximumTrackTintColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    //滑块图片
    UIImage * thumbImage = [UIImage imageNamed:@"rm_sliderdot"];
    [self.progressBar setThumbImage:thumbImage forState:UIControlStateNormal];
    [self.progressBar setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self.progressBar addTarget:self action:@selector(progressBarChanged:) forControlEvents:UIControlEventValueChanged];
    [self.belowView addSubview:self.progressBar];
    
    if (!self.zoomBtn){
        self.zoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    self.zoomBtn.frame = CGRectMake(ScreenHeight - 35, 13, 15, 15);
    [self.zoomBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    [self.zoomBtn setBackgroundImage:[UIImage imageNamed:@"narrow"] forState:UIControlStateNormal];
    self.zoomBtn.tag = 105;
    [self.zoomBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.belowView addSubview:self.zoomBtn];
}

/**
 *  添加手势
 */
- (void)loadTouchView {
    if (!self.touchView){
        self.touchView = [[RMTouchVIew alloc] init];
    }
    self.touchView.backgroundColor = [UIColor clearColor];
    self.touchView.delegate = self;
    [self.view addSubview:self.touchView];
}

#pragma mark - 创建 AVPlayer UI
- (void)loadHUD {
    if (!self.loadingView){
        self.loadingView = [[RMLoadingView alloc] init];
    }
    self.loadingView.frame = CGRectMake(ScreenHeight/2-20, ScreenWidth/2-20, 40, 40);
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    if (!self.customHUD){
        self.customHUD = [[NSBundle mainBundle] loadNibNamed:@"RMCustomSVProgressHUD" owner:self options:nil].lastObject;
    }
    self.customHUD.hidden = YES;
    [self.view addSubview:self.customHUD];
}
- (void)showHUD {
    self.loadingView.hidden = NO;
    [self.loadingView startAnimation];
}

- (void)hideHUD {
    self.loadingView.hidden = YES;
    [self.loadingView stopAnimation];
}

#pragma mark - 自动隐藏工具条操作
/**
 *  开始记时
 */
- (void)StartTimerWithAutomaticHidenToolView {
    [self performSelector:@selector(automaticHidenToolView) withObject:nil afterDelay:3.0];
}
- (void)loadMediaPlayerView {
    if (!self.player) {
        self.player = [[RMCustomVideoPlayerView alloc] init];
        self.player.RMCustomVideoplayerDeleagte = self;
        self.player.backgroundColor = [UIColor blackColor];
        [self.view addSubview:self.player];
    }
}

//???:使用播放器播放视频
- (void)playerWithURL:(NSString *)url {
    [upadtePlayMovieTime setFireDate:[NSDate date]];
    [self.player pause];
    //    NSString* pathExtention = [url pathExtension];
    //    if([pathExtention isEqualToString:@"mp4"]) {
    isDeviceRotating = YES;
    self.currentPlayState = 1;
    
    NSURL * _URL = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.player contentURL:_URL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.player play];
            [self showHUD];
            CMTime interval = CMTimeMake(33, 1000);
            __weak __typeof(self) weakself = self;
            //    if (playbackObserver) {
            //        [self.player.moviePlayer removeTimeObserver:playbackObserver];
            //        playbackObserver = nil;
            //    }
            playbackObserver = [self.player.moviePlayer addPeriodicTimeObserverForInterval:interval queue:dispatch_get_global_queue(0,0) usingBlock: ^(CMTime time) {

                CMTime endTime = CMTimeConvertScale (weakself.player.moviePlayer.currentItem.asset.duration, weakself.player.moviePlayer.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
                if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
                    double normalizedTime = (double) weakself.player.moviePlayer.currentTime.value / (double) endTime.value;
                    weakself.progressValue = normalizedTime;
                }
                weakself.goneTimeString = [weakself getStringFromCMTime:weakself.player.moviePlayer.currentTime];
                weakself.totalTimeString = [weakself getStringFromCMTime:weakself.player.moviePlayer.currentItem.asset.duration];
                weakself.HUDTotalTimeString = weakself.totalTime.text;
                weakself.detailTimeString = [NSString stringWithFormat:@"%@/%@",weakself.goneTime.text,weakself.totalTime.text];
            }];
        });
    });
   
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
        [self.playBtn setImage:[UIImage imageNamed:@"rm_playzoom_btn"] forState:UIControlStateNormal];
    }else{
        [self.playBtn setImage:[UIImage imageNamed:@"rm_play_btn"] forState:UIControlStateNormal];
    }
    
}
- (void)updateMovieLoadTime{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.goneTimeString){
            self.goneTime .text = self.goneTimeString;
            [self.goneTime sizeToFit];
            self.totalTime.text = self.totalTimeString;
            [self.totalTime sizeToFit];
            self.customHUD.totalTimeString = self.HUDTotalTimeString;
            self.detailTime.text = self.detailTimeString;
            self.progressBar.value = self.progressValue;
        }
    });
}

/**
 * 视频播放完成
 */
- (void)playerFinishedPlay {
    if (playbackObserver) {
        [self.player.moviePlayer removeTimeObserver:playbackObserver];
        playbackObserver = nil;
    }
    [self.player removeObserver];
}


/**
 *  刷新时间
 */
- (void)RefreshTimerWithAutomaticHidenToolView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(automaticHidenToolView) object:nil];
    [self performSelector:@selector(automaticHidenToolView) withObject:nil afterDelay:3.0];
}

#pragma mark - TouchViewDelegate

- (void)touchInViewOfLocation:(float)space andDirection:(NSString *)direction slidingPosition:(NSString *)position {
    if([direction isEqualToString:@"right"]){
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
            return ;
        }
        self.positionIdentifier = direction;
        if(self.player.isPlaying){
            [self.player pause];
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
                [self.playBtn setImage:[UIImage imageNamed:@"rm_pausezoom_btn"] forState:UIControlStateNormal];
            }else{
                [self.playBtn setImage:[UIImage imageNamed:@"rm_pause_btn"] forState:UIControlStateNormal];
            }
        }
        BOOL isfastForward = NO;
        if(space>0){
            isfastForward = YES;
        }
        [self.customHUD showWithState:isfastForward andNowTime:self.fastForwardOrRetreatQuickly];
        self.fastForwardOrRetreatQuickly = self.fastForwardOrRetreatQuickly - space;
    }else if([direction isEqualToString:@"left"]){
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
            return ;
        }
        self.positionIdentifier = direction;
        if(self.player.isPlaying){
            [self.player pause];
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
                [self.playBtn setImage:[UIImage imageNamed:@"rm_pausezoom_btn"] forState:UIControlStateNormal];
            }else{
                [self.playBtn setImage:[UIImage imageNamed:@"rm_pause_btn"] forState:UIControlStateNormal];
            }
        }
        BOOL isfastForward = NO;
        if(space>0){
            isfastForward = YES;
        }
        [self.customHUD showWithState:isfastForward andNowTime:self.fastForwardOrRetreatQuickly];
        self.fastForwardOrRetreatQuickly = self.fastForwardOrRetreatQuickly -  space;
    }
    else if ([direction isEqualToString:@"down"]){
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
            return ;
        }
        if([position isEqualToString:@"left"]){//控制声音
            MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
            float num = mpc.volume;
            num += space/100;
            mpc.volume = num;  //0.0~1.0
        }else if([position isEqualToString:@"right"]){//控制屏幕亮度
            float num =[UIScreen mainScreen].brightness;
            num += space/100;
            [UIScreen mainScreen].brightness = num;
        }
    }
    else if ([direction isEqualToString:@"up"]){
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
            return ;
        }
        if([position isEqualToString:@"left"]){//控制声音
            MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
            float num  = mpc.volume;
            num += space/100;
            mpc.volume = num;  //0.0~1.0
        }else if([position isEqualToString:@"right"]){//控制屏幕亮度
            float num =[UIScreen mainScreen].brightness;
            num += space/100;
            [UIScreen mainScreen].brightness = num;
        }
    }
    [self RefreshTimerWithAutomaticHidenToolView];
}

- (void)gestureRecognizerStateEnded {
    if([self.positionIdentifier isEqualToString:@"right"]||[self.positionIdentifier isEqualToString:@"left"]){
        CMTime seekTime = CMTimeMakeWithSeconds(self.fastForwardOrRetreatQuickly, self.player.moviePlayer.currentTime.timescale);
        [self.player.moviePlayer seekToTime:seekTime];
        [self.player play];
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
            [self.playBtn setImage:[UIImage imageNamed:@"rm_playzoom_btn"] forState:UIControlStateNormal];
        }else{
            [self.playBtn setImage:[UIImage imageNamed:@"rm_play_btn"] forState:UIControlStateNormal];
        }
    }
    [self RefreshTimerWithAutomaticHidenToolView];
}

- (void)gestureRecognizerStateBegan {
    self.positionIdentifier = @"none";
    dispatch_async(dispatch_get_main_queue(), ^{
        self.fastForwardOrRetreatQuickly = self.progressBar.value * (double)self.player.moviePlayer.currentItem.asset.duration.value/(double)self.player.moviePlayer.currentItem.asset.duration.timescale;
    });
    [self RefreshTimerWithAutomaticHidenToolView];
}

/**
 *  隐藏工具条
 */
- (void)gestureRecognizerOneTapMetohd {
    if (self.isHidenToolView){
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            self.topView.alpha = 0.7f;
            self.belowView.alpha = 0.7f;
        } completion:^(BOOL finished) {
            self.isHidenToolView = NO;
        }];
    }else{
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            self.topView.alpha = 0.f;
            self.belowView.alpha = 0.f;
        } completion:^(BOOL finished) {
            self.isHidenToolView = YES;
        }];
    }
    if (self.isPop){
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            self.selectEpisodeView.alpha = 0.f;
        } completion:^(BOOL finished) {
            self.isPop = NO;
            self.selectEpisodeView.hidden = YES;
        }];
    }
    [self RefreshTimerWithAutomaticHidenToolView];
}

/**
 * 双击暂停播放 或者 开始播放
 */
- (void)gestureRecognizerTwoTapMetohd {
    if (self.player.isPlaying) {
        [self.player pause];
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
            [self.playBtn setImage:[UIImage imageNamed:@"rm_pausezoom_btn"] forState:UIControlStateNormal];
        }else{
            [self.playBtn setImage:[UIImage imageNamed:@"rm_pause_btn"] forState:UIControlStateNormal];
        }
    } else {
        [self.player play];
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
            [self.playBtn setImage:[UIImage imageNamed:@"rm_playzoom_btn"] forState:UIControlStateNormal];
        }else{
            [self.playBtn setImage:[UIImage imageNamed:@"rm_play_btn"] forState:UIControlStateNormal];
        }
    }
    [self RefreshTimerWithAutomaticHidenToolView];
}

#pragma mark -

- (void)buttonClick:(UIButton *)sender {
    switch (sender.tag) {
        case 101:{//全屏幕切换成小屏幕

            break;
        }
        case 102:{//播放 或者 暂停
            if (self.player.isPlaying) {
                [self.player pause];
                if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
                    [self.playBtn setImage:[UIImage imageNamed:@"rm_pausezoom_btn"] forState:UIControlStateNormal];
                }else{
                    [self.playBtn setImage:[UIImage imageNamed:@"rm_pause_btn"] forState:UIControlStateNormal];
                }
            } else {
                [self.player play];
                if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
                    [self.playBtn setImage:[UIImage imageNamed:@"rm_playzoom_btn"] forState:UIControlStateNormal];
                }else{
                    [self.playBtn setImage:[UIImage imageNamed:@"rm_play_btn"] forState:UIControlStateNormal];
                }
            }
            [self RefreshTimerWithAutomaticHidenToolView];
            break;
        }
        case 103:{//下一集
            [self replaceAVPlayer];
            for (NSInteger i=0; i<[self.dataModel.playurls count]; i++){
                if ([[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"source_type"] isEqualToString:self.currentSelectType]){
                    if (self.currentPlayVideoOrder > [[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"urls"] count]){
                        [self showHUDWithImage:@"videoIsAllPlayed" imageFrame:CGRectMake(0, 0, 160, 40) duration:1.5 userInteractionEnabled:YES];
                    }else{
                        [self replaceAVPlayer];
                        [self playerWithURL:[[[[self.dataModel.playurls objectAtIndex:i] objectForKey:@"urls"] objectAtIndex:self.currentPlayVideoOrder] objectForKey:@"m_down_url"]];
                    }
                    break;
                }
            }
            
            [self hideHUD];
            [self RefreshTimerWithAutomaticHidenToolView];
            break;
        }
        case 104:{//弹出选集 或者 隐藏选集
            if (self.isPop){
                [UIView animateWithDuration:0.3 animations:^{
                    self.selectEpisodeView.frame = CGRectMake(ScreenHeight, 44, 240, ScreenWidth - 104);
                } completion:^(BOOL finished) {
                    self.isPop = NO;
                    self.selectEpisodeView.hidden = YES;
                }];
            }else{
                self.selectEpisodeView.hidden = NO;
                [UIView animateWithDuration:0.3 animations:^{
                    self.selectEpisodeView.frame = CGRectMake(ScreenHeight - 240, 44, 240, ScreenWidth - 104);
                } completion:^(BOOL finished) {
                    self.isPop = YES;
                }];
            }
            [self RefreshTimerWithAutomaticHidenToolView];
            break;
        }
        case 105:{
            if (self.player.isFullScreenMode){ //缩小
                if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
                    SEL selector = NSSelectorFromString(@"setOrientation:");
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:[UIDevice currentDevice]];
                    self.player.isFullScreenMode = NO;
                    int val = UIInterfaceOrientationPortrait;
                    [invocation setArgument:&val atIndex:2];
                    [invocation invoke];
                }
            }else{ //放大
                if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
                    SEL selector = NSSelectorFromString(@"setOrientation:");
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
                    [invocation setSelector:selector];
                    [invocation setTarget:[UIDevice currentDevice]];
                    
                    self.player.isFullScreenMode = YES;
                    int val = UIInterfaceOrientationLandscapeRight;
                    [invocation setArgument:&val atIndex:2];
                    [invocation invoke];
                }
            }
            break;
        }
            
        default:
            break;
    }
}

-(void)progressBarChanged:(UISlider*)sender {
    [self showHUD];
    if (self.player.isPlaying) {
        [self.player.moviePlayer pause];
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
            [self.playBtn setImage:[UIImage imageNamed:@"rm_pausezoom_btn"] forState:UIControlStateNormal];
        }else{
            [self.playBtn setImage:[UIImage imageNamed:@"rm_pause_btn"] forState:UIControlStateNormal];
        }
    }
    CMTime seekTime = CMTimeMakeWithSeconds(sender.value * (double)self.player.moviePlayer.currentItem.asset.duration.value/(double)self.player.moviePlayer.currentItem.asset.duration.timescale, self.player.moviePlayer.currentTime.timescale);
    [self.player.moviePlayer seekToTime:seekTime];
    [self.player play];
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait){
        [self.playBtn setImage:[UIImage imageNamed:@"rm_playzoom_btn"] forState:UIControlStateNormal];
    }else{
        [self.playBtn setImage:[UIImage imageNamed:@"rm_play_btn"] forState:UIControlStateNormal];
    }
    [self hideHUD];
    [self RefreshTimerWithAutomaticHidenToolView];
}

#pragma mark - 工具

-(NSString*)getStringFromCMTime:(CMTime)time {
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int secs = fmodf(currentSeconds, 60.0);
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}

/**
 *  自动隐藏工具条
 */
- (void)automaticHidenToolView {
    if (!self.isHidenToolView){
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            self.topView.alpha = 0.f;
            self.belowView.alpha = 0.f;
            
        } completion:^(BOOL finished) {
            self.isHidenToolView = YES;
        }];
    }
    
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        self.selectEpisodeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.isPop = NO;
        self.selectEpisodeView.hidden = YES;
    }];
}

#pragma mark - 设备方向

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIDeviceOrientationIsLandscape(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate {
    if (isDeviceRotating){
        NSLog(@"可旋转");
        return YES;
    }else{
        NSLog(@"不可旋转");
        return NO;
    }
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationMaskPortrait;
}

- (void)kDeviceOrientationDidChangeNotification:(CGFloat)duration {
    UIInterfaceOrientation toInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)){
        //横屏
        self.customHUD.frame = CGRectMake((ScreenWidth-193)/2, (ScreenHeight-133)/2, 193, 133);
        if (self.player.isPlaying) {
            [self.playBtn setImage:[UIImage imageNamed:@"rm_play_btn"] forState:UIControlStateNormal];
        }else{
            [self.playBtn setImage:[UIImage imageNamed:@"rm_pause_btn"] forState:UIControlStateNormal];
        }
        playRelatedCtl.view.hidden = YES;
        playDetailsCtl.view.hidden = YES;
        playCreatorCtl.view.hidden = YES;
        playEpisodeCtl.view.hidden = YES;
        sourceTypeView.hidden = YES;
    }else{
        //竖屏
        self.customHUD.frame = CGRectMake(0, 0, 0, 0);
        if (self.player.isPlaying) {
            [self.playBtn setImage:[UIImage imageNamed:@"rm_playzoom_btn"] forState:UIControlStateNormal];
        }else{
            [self.playBtn setImage:[UIImage imageNamed:@"rm_pausezoom_btn"] forState:UIControlStateNormal];
        }
        playRelatedCtl.view.hidden = NO;
        playDetailsCtl.view.hidden = NO;
        playCreatorCtl.view.hidden = NO;
        playEpisodeCtl.view.hidden = NO;
        sourceTypeView.hidden = NO;
    }
    [UIView animateWithDuration:duration animations:^{
        if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
            //横屏
            NSLog(@"横屏");
            if (self.currentPlayState == 1){    //正在加载
                topJumpWebView.hidden = YES;
            }else if (self.currentPlayState == 2){      //加载失败
            }
            self.player.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            self.topView.frame = CGRectMake(0, 0, ScreenWidth, 36);
            self.belowView.frame = CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40);
//            self.cacheProgress.Frame = CGRectMake(182, 21, ScreenHeight - 324, 30);
            self.progressBar.frame = CGRectMake(180, 7, ScreenWidth - 320, 30);
            self.nextBtn.hidden = NO;
            self.goneTime.hidden = NO;
            self.totalTime.hidden = NO;
            self.touchView.Frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 40);
            self.loadingView.frame = CGRectMake(ScreenWidth/2-20, ScreenHeight/2-20, 40, 40);
            self.detailTime.hidden = YES;
            self.zoomBtn.frame = CGRectMake(ScreenWidth - 35, 13, 15, 15);
            [self.zoomBtn setBackgroundImage:[UIImage imageNamed:@"narrow"] forState:UIControlStateNormal];
            self.player.playerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            [self.player setIsFullScreenMode:YES];
        }else{
            //竖屏
            NSLog(@"竖屏");
            if (self.currentPlayState == 1){    //正在加载
            }else if (self.currentPlayState == 2){      //加载失败
                topJumpWebView.hidden = NO;
                topJumpWebView.frame = CGRectMake(0, 0, ScreenWidth, 180);
            }
            self.player.frame = CGRectMake(0, 0, ScreenWidth, 180);
            self.topView.frame = CGRectMake(0, 0, ScreenWidth, 36);
            self.belowView.frame = CGRectMake(0, 140, ScreenWidth, 40);
//            self.cacheProgress.frame = CGRectMake(50, 21, ScreenWidth - 180, 30);
            self.progressBar.frame = CGRectMake(50, 7, ScreenWidth - 180, 30);
            self.nextBtn.hidden = YES;
            self.goneTime.hidden = YES;
            self.totalTime.hidden = YES;
            self.touchView.Frame = CGRectMake(0, 0, ScreenWidth, 140);
            self.loadingView.frame = CGRectMake(ScreenWidth/2 - 20, 65, 40, 40);
            self.detailTime.hidden = NO;
            self.detailTime.text = [NSString stringWithFormat:@"%@/%@",self.goneTime.text,self.totalTime.text];
            self.zoomBtn.frame = CGRectMake(ScreenWidth - 30, 12, 15, 15);
            [self.zoomBtn setBackgroundImage:[UIImage imageNamed:@"amplification"] forState:UIControlStateNormal];
            self.player.playerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180);
            [self.player setIsFullScreenMode:NO];
        }
    } completion:^(BOOL finished) {
    }];
}

/*********************************************以上均为播放器内容**********************************************************/

- (BOOL)isContainsModel:(NSMutableArray *)dataArray modelName:(NSString *)string{
    for(RMPublicModel *tmpModel in dataArray){
        if([tmpModel.name isEqualToString:string]){
            return YES;
        }
    }
    return NO;
}
@end
