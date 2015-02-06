//
//  RMHomeTVViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 14-12-30.
//  Copyright (c) 2014年 润滑联动. All rights reserved.
//

#import "RMHomeTVViewController.h"
#import "RMVideoPlaybackDetailsViewController.h"
#import "RMModel.h"
#import "RMPlayer.h"
#import "RMLoadingWebViewController.h"
#import "RMRankRecommendedViewController.h"

@interface RMHomeTVViewController ()<RMHomeTableViewCellDelegate,RMAFNRequestManagerDelegate>{
    RMAFNRequestManager *requestManeger;
    BOOL isAlreadDownLoad; //是否已经下载过数据了
    NSInteger pageCount;
    BOOL isPullToRefresh;
}
@property (nonatomic,strong) NSMutableArray *scrollViewDataArray;
@end

@implementation RMHomeTVViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageCount = 1;
    isPullToRefresh = YES;
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    _tableViewDataArray = [[NSMutableArray alloc] init];
    _scrollViewDataArray = [[NSMutableArray alloc] init];
}

#pragma mark table veie dateSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.tableViewDataArray.count%3==0)
        return self.tableViewDataArray.count/3;
    else
        return self.tableViewDataArray.count/3+1;
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
    if(indexPath.row*3<self.tableViewDataArray.count){
        RMPublicModel *model = [self.tableViewDataArray objectAtIndex:indexPath.row*3];
        [cell.fristHeadImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.fristHeadImage.identifierString = model.video_id;
        cell.fristLable.text = model.name;
        cell.fristPlayBtn.tag = model.video_id.integerValue;
        [cell.fristPlayBtn setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
        [cell.fristPlayBtn setTitle:@"播放" forState:UIControlStateNormal];
        cell.fristScore.hidden = NO;
        [cell setFristScoreWithTitle:model.status];
    }
    if(indexPath.row*3+1<self.tableViewDataArray.count){
        RMPublicModel *model = [self.tableViewDataArray objectAtIndex:indexPath.row*3+1];
        [cell.secondHeadImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.secondHeadImage.identifierString = model.video_id;
        cell.secondLable.text = model.name;
        cell.secondPlayBtn.tag = model.video_id.integerValue;
        [cell.secondPlayBtn setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
        [cell.secondPlayBtn setTitle:@"播放" forState:UIControlStateNormal];
        cell.secondScore.hidden = NO;
        [cell setSecondScoreWithTitle:model.status];
    }
    if(indexPath.row*3+2<self.tableViewDataArray.count){
        RMPublicModel *model = [self.tableViewDataArray objectAtIndex:indexPath.row*3+2];
        [cell.thridHeadImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.thridHeadImage.identifierString = model.video_id;
        cell.thridLable.text = model.name;
        cell.thirdPlayBtn.tag = model.video_id.integerValue;
        [cell.thirdPlayBtn setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
        [cell.thirdPlayBtn setTitle:@"播放" forState:UIControlStateNormal];
        cell.thridScore.hidden = NO;
        [cell setThirdScoreWithTitle:model.status];
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
    if (![imageView.identifierString isEqualToString:@""]){
        RMHomeViewController * homeCtl = self.delegate;
        RMVideoPlaybackDetailsViewController * videoPlaybackDetailsCtl = [[RMVideoPlaybackDetailsViewController alloc] init];
        videoPlaybackDetailsCtl.video_id = imageView.identifierString;
        videoPlaybackDetailsCtl.segVideoType = @"电视剧";
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        [homeCtl presentViewController:videoPlaybackDetailsCtl animated:YES completion:^{
        }];
    }
}

/**
 *  直接播放
 */
- (void)playBtnWithVideo_id:(NSString *)video_id {
    RMHomeViewController * homeCtl = self.delegate;
    for (NSInteger i=0; i<[self.tableViewDataArray count]; i++){
        RMPublicModel * model = [self.tableViewDataArray objectAtIndex:i];
        if ([model.video_id isEqualToString:video_id]){
            NSString* pathExtention = [[[model.urls_arr objectAtIndex:0] objectForKey:@"m_down_url"] pathExtension];
            if([pathExtention isEqualToString:@"mp4"]) {
                RMModel *_model = [[RMModel alloc] init];
                _model.url = [[model.urls_arr objectAtIndex:0] objectForKey:@"m_down_url"];
                _model.title = model.name;
                [RMPlayer presentVideoPlayerWithPlayModel:_model withUIViewController:homeCtl withVideoType:1 withIsLocationVideo:NO];
            }else{
                RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
                loadingWebCtl.name = model.name;
                loadingWebCtl.loadingUrl = [[model.urls_arr objectAtIndex:0] objectForKey:@"jumpurl"];
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
                [homeCtl presentViewController:loadingWebCtl animated:YES completion:^{
                }];
            }
            break;
        }
    }
}

/**
 *  开始搜索
 */
- (void)beginSearch{
    RMHomeViewController * homeCtl = self.delegate;
    RMSearchViewController * searchCtl = [[RMSearchViewController alloc] init];
    [homeCtl.navigationController pushViewController:searchCtl animated:YES];
}

#pragma mark 上拉加载和下拉刷新
- (void)refreshControlBeginPullToRefresh{
    isPullToRefresh = YES;
    pageCount = 1;
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
    [requestManeger getSlideListWithVideo_type:@"2"];
}

- (void)refreshControlBeginDropDownLoad{
    isPullToRefresh = NO;
    pageCount++;
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
    [requestManeger getIndexVideoListWithVideoTpye:@"2" searchPageNumber:[NSString stringWithFormat:@"%ld",(long)pageCount] andLimit:@""];
}

- (void)requestFinishiDownLoadWith:(NSMutableArray *)data{
    if(requestManeger.downLoadType == Http_getSlideList){
        self.scrollViewDataArray = data;
         __block RMHomeTVViewController *blockSelf = self;
        self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            if(pageIndex<0||pageIndex>data.count){
                return nil;
            }
            RMPublicModel *model = [data objectAtIndex:pageIndex];
            RMImageView *showImage = [[RMImageView alloc] initWithFrame:CGRectMake(0, 0, blockSelf.mainScorllView.frame.size.width, blockSelf.mainScorllView.frame.size.height)];
            if (IS_IPHONE_6_SCREEN){
                [showImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"347_200")];
            }else if (IS_IPHONE_6p_SCREEN){
                [showImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"384_220")];
            }else{
                [showImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"298_180")];
            }
            return showImage;
        };
        self.mainScorllView.totalPagesCount = ^NSInteger(void){
            return data.count;
        };
        self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
            RMPublicModel *model = [data objectAtIndex:pageIndex];
            RMHomeViewController * homeCtl = blockSelf.delegate;
            if([model.video_id isEqualToString:@"0"]){
                RMRankRecommendedViewController *rankRecommendedCtl = [[RMRankRecommendedViewController alloc] init];
                rankRecommendedCtl.webUrl = model.source_url;
                rankRecommendedCtl.titleString = model.name;
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
                [homeCtl.navigationController pushViewController:rankRecommendedCtl animated:YES];
            }else{
                RMVideoPlaybackDetailsViewController * videoPlaybackDetailsCtl = [[RMVideoPlaybackDetailsViewController alloc] init];
                videoPlaybackDetailsCtl.video_id = model.video_id;
                videoPlaybackDetailsCtl.segVideoType = @"电视剧";
                [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
                [homeCtl presentViewController:videoPlaybackDetailsCtl animated:YES completion:^{
                }];
            }
        };
        [requestManeger getIndexVideoListWithVideoTpye:@"2" searchPageNumber:@"1" andLimit:@""];
    }else{
        if(isPullToRefresh){
            [self.tableViewDataArray removeAllObjects];
            self.tableViewDataArray = data;
            [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
        }
        else{
            if(data.count==0){
                [self showMessage:@"没有更多数据加载了" duration:1 withUserInteractionEnabled:YES];
                return;
            }
            for (RMPublicModel *model in data) {
                [self.tableViewDataArray addObject:model];
            }
            [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
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

- (void) requestData{
    if(!isAlreadDownLoad){
        [self showLoadingSimpleWithUserInteractionEnabled:YES];
        requestManeger = [[RMAFNRequestManager alloc] init];
        requestManeger.delegate = self;
        [requestManeger getSlideListWithVideo_type:@"2"];
        isAlreadDownLoad = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
