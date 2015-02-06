//
//  RMTeleplayViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMChannelTeleplayViewController.h"
#import "RMVideoOrStarCell.h"
#import "RMVideoPlaybackDetailsViewController.h"
#import "RefreshControl.h"
#import "CustomRefreshView.h"
#import "RMModel.h"
#import "RMLoadingWebViewController.h"
#import "RMPlayer.h"
#import "RMStarDetailsViewController.h"
#import "RMSearchViewController.h"

@interface RMChannelTeleplayViewController ()<UITableViewDataSource,UITableViewDelegate,VideoOrStarCellDelegate,RMAFNRequestManagerDelegate,RefreshControlDelegate>{
    UITableView * mTableView;
    NSMutableArray * dataArr;
    NSInteger pageCount;
    BOOL isRefresh;
    BOOL isFirstViewAppear;
    BOOL isLoadComplete;
    RMAFNRequestManager * manager;
}
@property (nonatomic, strong) RefreshControl * refreshControl;

@end

@implementation RMChannelTeleplayViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstViewAppear){
        [self startRequest];
        isFirstViewAppear = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    manager = [[RMAFNRequestManager alloc] init];
    dataArr = [[NSMutableArray alloc] init];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 274) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
    
    self.refreshControl=[[RefreshControl alloc] initWithScrollView:mTableView delegate:self];
    self.refreshControl.topEnabled=YES;
    self.refreshControl.bottomEnabled=YES;
    [self.refreshControl registerClassForTopView:[CustomRefreshView class]];
    
    pageCount = 1;
    isFirstViewAppear = YES;
    isRefresh = YES;
}

#pragma mark 刷新代理

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        pageCount = 1;
        isRefresh = YES;
        isLoadComplete = NO;
        [self startRequest];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        if (isLoadComplete){
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.44 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self showMessage:@"没有内容加载了" duration:1.0 position:1 withUserInteractionEnabled:YES];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            });
        }else{
            pageCount ++;
            isRefresh = NO;
            [self startRequest];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([dataArr count]%3 == 0){
        return [dataArr count] / 3;
    }else if ([dataArr count]%3 == 1){
        return ([dataArr count] + 2) / 3;
    }else {
        return ([dataArr count] + 1) / 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * CellIdentifier = [NSString stringWithFormat:@"MyAttentionLabelCellIdentifier%ld",(long)indexPath.row];
    RMVideoOrStarCell * cell = (RMVideoOrStarCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        NSArray *array;
        if (IS_IPHONE_6_SCREEN){
            array = [[NSBundle mainBundle] loadNibNamed:@"RMVideoOrStarCell_6" owner:self options:nil];
        }else if (IS_IPHONE_6p_SCREEN){
            array = [[NSBundle mainBundle] loadNibNamed:@"RMVideoOrStarCell_6p" owner:self options:nil];
        }else {
            array = [[NSBundle mainBundle] loadNibNamed:@"RMVideoOrStarCell" owner:self options:nil];
        }
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    RMPublicModel *model_left;
    RMPublicModel *model_center;
    RMPublicModel *model_right;
    
    model_left = [dataArr objectAtIndex:indexPath.row*3];
    cell.firstName.text = model_left.name;
    cell.firstScore.text = model_left.gold;
    [cell.firstImage sd_setImageWithURL:[NSURL URLWithString:model_left.pic] placeholderImage:LOADIMAGE(@"92_138")];
    cell.firstImage.identifierString = model_left.video_id;
    cell.firstBtn.tag = model_left.video_id.integerValue;
    [cell.firstBtn setBackgroundImage:LOADIMAGE(@"home_movie_palyBtn") forState:UIControlStateNormal];
    
    if (indexPath.row * 3 + 1 >= [dataArr count]){
        cell.secondScore.hidden = YES;
    }else{
        model_center = [dataArr objectAtIndex:indexPath.row*3 + 1];
        cell.secondName.text = model_center.name;
        cell.secondScore.text = model_center.gold;
        [cell.secondImage sd_setImageWithURL:[NSURL URLWithString:model_center.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.secondImage.identifierString = model_center.video_id;
        cell.secondBtn.tag = model_center.video_id.integerValue;
        [cell.secondBtn setBackgroundImage:LOADIMAGE(@"home_movie_palyBtn") forState:UIControlStateNormal];
    }
    
    if (indexPath.row * 3 + 2 >= [dataArr count]){
        cell.thirdScore.hidden = YES;
    }else{
        model_right = [dataArr objectAtIndex:indexPath.row*3 + 2];
        cell.thirdName.text = model_right.name;
        cell.thirdScore.text = model_right.gold;
        [cell.thirdImage sd_setImageWithURL:[NSURL URLWithString:model_right.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.thirdImage.identifierString = model_right.video_id;
        cell.thirdBtn.tag = model_right.video_id.integerValue;
        [cell.thirdBtn setBackgroundImage:LOADIMAGE(@"home_movie_palyBtn") forState:UIControlStateNormal];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IPHONE_6_SCREEN){
        return 240.0;
    }else if(IS_IPHONE_6p_SCREEN){
        return 255;
    }
    return 210.0;
}

- (void)videoOrStarCellMethodWithVideo_id:(NSString *)video_id {
    if ([self.ctlType isEqualToString:@"明星"]){
        RMStarDetailsViewController * sender = self.MyChannelDetailsDelegate;
        for (NSInteger i=0; i<[dataArr count]; i++){
            RMPublicModel * model = [dataArr objectAtIndex:i];
            if ([model.video_id isEqualToString:video_id]){
                NSString* pathExtention = [[[model.urls_arr objectAtIndex:i] objectForKey:@"m_down_url"] pathExtension];
                if([pathExtention isEqualToString:@"mp4"]) {
                    RMModel *_model = [[RMModel alloc] init];
                    _model.url = [[model.urls_arr objectAtIndex:0] objectForKey:@"m_down_url"];
                    _model.title = model.name;
                    [RMPlayer presentVideoPlayerWithPlayModel:_model withUIViewController:sender withVideoType:1 withIsLocationVideo:NO];
                }else{
                    RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
                    loadingWebCtl.name = model.name;
                    loadingWebCtl.loadingUrl = [[model.urls_arr objectAtIndex:0] objectForKey:@"jumpurl"];
                    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
                    [sender presentViewController:loadingWebCtl animated:YES completion:^{
                    }];
                }
                break;
            }
        }
    }else{
        RMSearchViewController * sender = self.MyChannelDetailsDelegate;
        for (NSInteger i=0; i<[dataArr count]; i++){
            RMPublicModel * model = [dataArr objectAtIndex:i];
            if ([model.video_id isEqualToString:video_id]){
                NSString* pathExtention = [[[model.urls_arr objectAtIndex:i] objectForKey:@"m_down_url"] pathExtension];
                if([pathExtention isEqualToString:@"mp4"]) {
                    RMModel *_model = [[RMModel alloc] init];
                    _model.url = [[model.urls_arr objectAtIndex:0] objectForKey:@"m_down_url"];
                    _model.title = model.name;
                    [RMPlayer presentVideoPlayerWithPlayModel:_model withUIViewController:sender withVideoType:1 withIsLocationVideo:NO];
                }else{
                    RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
                    loadingWebCtl.name = model.name;
                    loadingWebCtl.loadingUrl = [[model.urls_arr objectAtIndex:0] objectForKey:@"jumpurl"];
                    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
                    [sender presentViewController:loadingWebCtl animated:YES completion:^{
                    }];
                }
                break;
            }
        }
    }
}

- (void)videoOrStarCellMethodWithImage:(RMImageView *)image {
    if ([self.ctlType isEqualToString:@"明星"]){
        if (![image.identifierString isEqualToString:@""]){
            RMStarDetailsViewController * sender = self.MyChannelDetailsDelegate;
            RMVideoPlaybackDetailsViewController * videoPlaybackDetailsCtl = [[RMVideoPlaybackDetailsViewController alloc] init];
            videoPlaybackDetailsCtl.video_id = image.identifierString;
            videoPlaybackDetailsCtl.segVideoType = @"电视剧";
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            [sender presentViewController:videoPlaybackDetailsCtl animated:YES completion:^{
            }];
        }
    }else{
        if (![image.identifierString isEqualToString:@""]){
            RMSearchViewController * sender = self.MyChannelDetailsDelegate;
            RMVideoPlaybackDetailsViewController * videoPlaybackDetailsCtl = [[RMVideoPlaybackDetailsViewController alloc] init];
            videoPlaybackDetailsCtl.video_id = image.identifierString;
            videoPlaybackDetailsCtl.segVideoType = @"电视剧";
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            [sender presentViewController:videoPlaybackDetailsCtl animated:YES completion:^{
            }];
        }
    }
}

- (void)startRequest {
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
    manager.delegate = self;
    [manager getVideoListWithTagId:self.tag_id Video_type:@"2" Page:[NSString stringWithFormat:@"%ld",(long)pageCount]];
}

- (void)requestFinishiDownLoadWith:(NSMutableArray *)data {
    if (self.refreshControl.refreshingDirection==RefreshingDirectionTop) {
        [dataArr removeAllObjects];
        for (NSInteger i=0; i<data.count; i++) {
            RMPublicModel * model = [data objectAtIndex:i];
            [dataArr addObject:model];
        }
        [mTableView reloadData];
        [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }else if(self.refreshControl.refreshingDirection==RefreshingDirectionBottom) {
        if (data.count == 0){
            [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            isLoadComplete = YES;
            [self hideLoading];
            return;
        }
        for (NSInteger i=0; i<data.count; i++) {
            RMPublicModel * model = [data objectAtIndex:i];
            [dataArr addObject:model];
        }
        [mTableView reloadData];
        [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    }
    
    if (isRefresh){
        [dataArr removeAllObjects];
        for (NSInteger i=0; i<[data count]; i++){
            RMPublicModel * model = [data objectAtIndex:i];
            [dataArr addObject:model];
        }
        [mTableView reloadData];
    }
    [self hideLoading];
}

- (void)requestError:(NSError *)error {
    [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
    [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    [self hideLoading];
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
