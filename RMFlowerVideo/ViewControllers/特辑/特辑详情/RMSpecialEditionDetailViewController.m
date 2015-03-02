//
//  RMSpecialEditionDetailViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-15.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMSpecialEditionDetailViewController.h"
#import "RefreshControl.h"
#import "CustomRefreshView.h"
#import "RMHomeTableViewCell.h"
#import "RMVideoPlaybackDetailsViewController.h"
#import "RMPlayer.h"
#import "RMModel.h"
#import "RMLoadingWebViewController.h"
#import "Flurry.h"

@interface RMSpecialEditionDetailViewController ()<RMAFNRequestManagerDelegate,UITableViewDataSource,UITableViewDelegate,RefreshControlDelegate,RMHomeTableViewCellDelegate>{
    NSInteger pageCount;
    BOOL isRefresh;
    BOOL isFirstViewAppear;
    BOOL isLoadComplete;
    RMAFNRequestManager * manager;
    NSMutableArray * dataArr;
}
@property (nonatomic, strong) RefreshControl * refreshControl;

@end

@implementation RMSpecialEditionDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Flurry logEvent:@"VIEW_SpecialEditionDetail" timed:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"VIEW_SpecialEditionDetail" withParameters:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstViewAppear){
        [self startRequest];
        isFirstViewAppear = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideLoading];
    [manager cancelRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomNavTitle:self.customTitle];
    
    dataArr = [[NSMutableArray alloc] init];
    manager = [[RMAFNRequestManager alloc] init];
    
    rightBarButton.hidden = YES;
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    
    self.refreshControl=[[RefreshControl alloc] initWithScrollView:self.mainTableView delegate:self];
    self.refreshControl.topEnabled=YES;
    self.refreshControl.bottomEnabled=YES;
    [self.refreshControl registerClassForTopView:[CustomRefreshView class]];
    
    pageCount = 1;
    isFirstViewAppear = YES;
    isRefresh = YES;
}

#pragma mark - table veie dateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(dataArr.count%3==0)
        return dataArr.count/3;
    else
        return dataArr.count/3+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"homeTableViewCellIdentifier";
    RMHomeTableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil){
        if(IS_IPHONE_6_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMHomeTableViewCell_6" owner:self options:nil] lastObject];
        }else if (IS_IPHONE_6p_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMHomeTableViewCell_6p" owner:self options:nil] lastObject];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMHomeTableViewCell" owner:self options:nil] lastObject];
        }
        cell.delegate = self;
    }
    
    if(indexPath.row*3<dataArr.count){
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3];
        [cell.fristHeadImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.fristHeadImage.identifierString = model.video_id;
        cell.fristLable.text = model.name;
        cell.fristPlayBtn.tag = model.video_id.integerValue;
        [cell.fristPlayBtn setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
        [cell.fristPlayBtn setTitle:@"播放" forState:UIControlStateNormal];
        cell.fristScore.hidden = NO;
        cell.fristScore.text = model.gold;
    }
    if(indexPath.row*3+1<dataArr.count){
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3+1];
        [cell.secondHeadImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.secondHeadImage.identifierString = model.video_id;
        cell.secondLable.text = model.name;
        cell.secondPlayBtn.tag = model.video_id.integerValue;
        [cell.secondPlayBtn setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
        [cell.secondPlayBtn setTitle:@"播放" forState:UIControlStateNormal];
        cell.secondScore.hidden = NO;
        cell.secondScore.text = model.gold;
    }
    if(indexPath.row*3+2<dataArr.count){
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3+2];
        [cell.thridHeadImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.thridHeadImage.identifierString = model.video_id;
        cell.thridLable.text = model.name;
        cell.thirdPlayBtn.tag = model.video_id.integerValue;
        [cell.thirdPlayBtn setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
        [cell.thirdPlayBtn setTitle:@"播放" forState:UIControlStateNormal];
        cell.thridScore.hidden = NO;
        cell.thridScore.text = model.gold;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(IS_IPHONE_6_SCREEN){
        return 240;
    }else if (IS_IPHONE_6p_SCREEN){
        return 256;
    }
    return 209;
}

#pragma mark - RMHomeTableViewCell delegate

- (void)homeTableViewCellDidSelectWithImage:(RMImageView *)imageView{
    for (NSInteger i=0; i<[dataArr count]; i++){
        RMPublicModel * model = [dataArr objectAtIndex:i];
        if ([model.video_id isEqualToString:imageView.identifierString]){
            RMVideoPlaybackDetailsViewController * videoPlaybackDetailsCtl = [[RMVideoPlaybackDetailsViewController alloc] init];
            videoPlaybackDetailsCtl.video_id = imageView.identifierString;
            if (model.video_type.integerValue == 1){
                videoPlaybackDetailsCtl.segVideoType = @"电影";
            }else if (model.video_type.integerValue == 2){
                videoPlaybackDetailsCtl.segVideoType = @"电视剧";
            }else{
                videoPlaybackDetailsCtl.segVideoType = @"综艺";
            }
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            [self presentViewController:videoPlaybackDetailsCtl animated:YES completion:^{
            }];
        }
    }
}

/**
 *  直接播放
 */
- (void)playBtnWithVideo_id:(NSString *)video_id {
    for (NSInteger i=0; i<[dataArr count]; i++){
        RMPublicModel * model = [dataArr objectAtIndex:i];
        if ([model.video_id isEqualToString:video_id]){
            if ([model.video_type isEqualToString:@"1"]){
                NSString* pathExtention = [[model.urls objectForKey:@"m_down_url"] pathExtension];
                if([pathExtention isEqualToString:@"mp4"]) {
                    RMModel *_model = [[RMModel alloc] init];
                    _model.url = [model.urls objectForKey:@"m_down_url"];
                    _model.title = model.name;
                    [RMPlayer presentVideoPlayerWithPlayModel:_model withUIViewController:self withVideoType:1 withIsLocationVideo:NO];
                }else{
                    RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
                    loadingWebCtl.name = model.name;
                    loadingWebCtl.loadingUrl = [model.urls objectForKey:@"jumpurl"];
                    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
                    [self presentViewController:loadingWebCtl animated:YES completion:^{
                    }];
                }
                break;
            }else{
                NSString* pathExtention = [[[model.urls_arr objectAtIndex:i] objectForKey:@"m_down_url"] pathExtension];
                if([pathExtention isEqualToString:@"mp4"]) {
                    RMModel *_model = [[RMModel alloc] init];
                    _model.url = [[model.urls_arr objectAtIndex:0] objectForKey:@"m_down_url"];
                    _model.title = model.name;
                    [RMPlayer presentVideoPlayerWithPlayModel:_model withUIViewController:self withVideoType:1 withIsLocationVideo:NO];
                }else{
                    RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
                    loadingWebCtl.name = model.name;
                    loadingWebCtl.loadingUrl = [[model.urls_arr objectAtIndex:0] objectForKey:@"jumpurl"];
                    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
                    [self presentViewController:loadingWebCtl animated:YES completion:^{
                    }];
                }
                break;
            }
        }
    }
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    switch (sender.tag) {
        case 1:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 2:{
            
            break;
        }
            
        default:
            break;
    }
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

#pragma mark - 请求

- (void)startRequest {
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
    manager.delegate = self;
    [manager getSpecialTagDetailWithTag_id:self.tag_id andPage:[NSString stringWithFormat:@"%ld",(long)pageCount]];
}

- (void)requestFinishiDownLoadWith:(NSMutableArray *)data {
    if (self.refreshControl.refreshingDirection==RefreshingDirectionTop) {
        [dataArr removeAllObjects];
        for (NSInteger i=0; i<data.count; i++) {
            RMPublicModel * model = [data objectAtIndex:i];
            [dataArr addObject:model];
        }
        [self.mainTableView reloadData];
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
        [self.mainTableView reloadData];
        [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    }
    
    if (isRefresh){
        [dataArr removeAllObjects];
        for (NSInteger i=0; i<data.count; i++) {
            RMPublicModel * model = [data objectAtIndex:i];
            [dataArr addObject:model];
        }
        [self.mainTableView reloadData];
    }
    [self hideLoading];
}

- (void)requestError:(NSError *)error {
    [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
    [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    [self hideLoading];
}

@end
