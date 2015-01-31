//
//  RMRankingVarietyViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-1.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMRankingVarietyViewController.h"
#import "RMRankTableViewHeadView.h"
#import "RMRankMovieCell.h"
#import "RMRankingViewController.h"
#import "RMVideoPlaybackDetailsViewController.h"
#import "RMRankRecommendedViewController.h"
#import "RMModel.h"
#import "RMPlayer.h"
#import "RMLoadingWebViewController.h"

@interface RMRankingVarietyViewController ()<UITableViewDelegate,UITableViewDataSource,RankMovieCellDelegate,RMAFNRequestManagerDelegate>{
    RMAFNRequestManager *requestManager;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation RMRankingVarietyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    self.refreshControl=[[RefreshControl alloc] initWithScrollView:self.mainTableView delegate:self];
    self.refreshControl.topEnabled=YES;
    self.refreshControl.bottomEnabled=NO;
    [self.refreshControl registerClassForTopView:[CustomRefreshView class]];
}
#pragma mark tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"RankTableViewCell111";
    RMRankMovieCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:identifier];
    RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row+1];
    if(cell == nil){
        if([model.video_id isEqualToString:@"0"]){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMRankMovieCell_promote" owner:self options:nil] lastObject];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMRankVarietyCell" owner:self options:nil] lastObject];
            cell.delegate = self;
        }
    }
    
    if([model.video_id isEqualToString:@"0"]){
        //推荐
        cell.promoteImage.image = [UIImage imageNamed:@"rank_promote_image"];
        cell.detailTextView.text = model.videoDescription;
        [cell setTextViewColor];
    }
    else{
        if([model.order isEqualToString:@"2"])
            cell.topImage.image = [UIImage imageNamed:@"rank_top_2"];
        else if([model.order isEqualToString:@"3"]){
            cell.topImage.image = [UIImage imageNamed:@"rank_top_3"];
        }else if([model.order isEqualToString:@"4"]){
            cell.topImage.image = [UIImage imageNamed:@"rank_top_4"];
        }else{
            cell.topImage.image = [UIImage imageNamed:@"rank_top_5"];
        }
        cell.topNumberLable.text = model.order;
        cell.playBnt.tag = model.video_id.integerValue;
        cell.starringLable.text = model.presenters;
        cell.playCount.text = model.hits;
    }
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
    [cell setTitleLableWithString:model.name];
    cell.scoreLable.text = model.gold;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 161.f;
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RMRankingViewController * rankingCtl = self.delegate;
    RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row+1];
    
    if([model.video_id isEqualToString:@"0"]){
        RMRankRecommendedViewController *viewControl = [[RMRankRecommendedViewController alloc] init];
        viewControl.titleString = model.name;
        viewControl.webUrl = model.source_url;
        [rankingCtl.navigationController pushViewController:viewControl animated:YES];
    }else{
        RMVideoPlaybackDetailsViewController * videoPlaybackDetailsCtl = [[RMVideoPlaybackDetailsViewController alloc] init];
        videoPlaybackDetailsCtl.video_id = model.video_id;
        videoPlaybackDetailsCtl.segVideoType = @"综艺";
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        [rankingCtl presentViewController:videoPlaybackDetailsCtl animated:YES completion:^{
        }];
    }
}

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        [requestManager getTopListWithVideo_type:@"3"];
    }
}

/**
 *  直接播放
 */
- (void)playBtnMethodWithOrder:(NSInteger)order {
    RMRankingViewController * rankingCtl = self.delegate;
    if (order != 0){
        for (NSInteger i=0; i<[self.dataArray count]; i++){
            RMPublicModel * model = [self.dataArray objectAtIndex:i];
            if (model.video_id.integerValue == order){
                NSString* pathExtention = [[[model.urls_arr objectAtIndex:0] objectForKey:@"m_down_url"] pathExtension];
                if([pathExtention isEqualToString:@"mp4"]) {
                    RMModel *_model = [[RMModel alloc] init];
                    _model.url = [[model.urls_arr objectAtIndex:0] objectForKey:@"m_down_url"];
                    _model.title = model.name;
                    [RMPlayer presentVideoPlayerWithPlayModel:_model withUIViewController:rankingCtl withVideoType:1 withIsLocationVideo:NO];
                }else{
                    RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
                    loadingWebCtl.name = model.name;
                    loadingWebCtl.loadingUrl = [[model.urls_arr objectAtIndex:0] objectForKey:@"jumpurl"];
                    [rankingCtl presentViewController:loadingWebCtl animated:YES completion:^{
                    }];
                }
                break;
            }
        }
    }
}

/**
 *  top 进入播放详情
 */
- (void)topPlayMethod:(RMImageView *)image {
    RMPublicModel *model = [self.dataArray objectAtIndex:0];
    RMRankingViewController * rankingCtl = self.delegate;
    RMVideoPlaybackDetailsViewController * videoPlaybackDetailsCtl = [[RMVideoPlaybackDetailsViewController alloc] init];
    videoPlaybackDetailsCtl.video_id = model.video_id;
    videoPlaybackDetailsCtl.segVideoType = @"综艺";
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [rankingCtl presentViewController:videoPlaybackDetailsCtl animated:YES completion:^{
    }];
}

- (void)requestData{
    self.dataArray = [[NSMutableArray alloc] init];
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
    requestManager = [[RMAFNRequestManager alloc] init];
    requestManager.delegate = self;
    [requestManager getTopListWithVideo_type:@"3"];
}

- (void)requestFinishiDownLoadWith:(NSMutableArray *)data{
    [self.dataArray removeAllObjects];
    self.dataArray = data;
    RMRankTableViewHeadView *headView = [[[NSBundle mainBundle] loadNibNamed:@"RMRankTableViewHeadView" owner:self options:nil] lastObject];
    RMPublicModel *model = [self.dataArray objectAtIndex:0];
    [headView.headImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
    headView.titleLable.text = model.name;
    headView.playcount.text = [NSString stringWithFormat:@"点播数:%@",model.hits];
    [headView.headImage addTarget:self WithSelector:@selector(topPlayMethod:)];
    self.mainTableView.tableHeaderView = headView;
    [self.mainTableView reloadData];
    [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
    [self hideLoading];
}

- (void)requestError:(NSError *)error{
    [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
    [self hideLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
