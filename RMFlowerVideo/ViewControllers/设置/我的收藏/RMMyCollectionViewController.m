//
//  RMMyCollectionViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMMyCollectionViewController.h"
#import "RMWatchRecordTableViewCell.h"
#import "RMVideoPlaybackDetailsViewController.h"
#import "RMModel.h"
#import "RMLoadingWebViewController.h"
#import "RMPlayer.h"
@interface RMMyCollectionViewController ()<RMWatchRecordTableViewCellDelegate>
{
    RMAFNRequestManager *requestManager;
    NSString *token;
    BOOL isFirstViewAppear;
    NSInteger pageCount;
    BOOL isPullToRefresh;
}
@property (nonatomic, strong) RefreshControl * refreshControl;
@end

@implementation RMMyCollectionViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self hideLoading];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (isFirstViewAppear){
        requestManager = [[RMAFNRequestManager alloc] init];
        requestManager.delegate = self;
        CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
        NSDictionary *userInfo = [storage objectForKey:UserLoginInformation_KEY];
        token = [userInfo objectForKey:@"token"];
        if(token==nil){
            [self showEmptyWithImage:@"error" withImageSize:CGSizeMake(55, 55) withTitle:@"您还没有登录"];
            rightBarButton.hidden = YES;
            return;
        }
        [self showLoadingSimpleWithUserInteractionEnabled:YES];
        [requestManager getFavoriteVideoListWithToken:token Page:[NSString stringWithFormat:@"%ld",(long)pageCount]];
        isFirstViewAppear = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    [rightBarButton setBackgroundImage:LOADIMAGE(@"nav_editing_btn") forState:UIControlStateNormal];
    [self setCustomNavTitle:@"我的收藏"];
    
    [showMemoryView removeFromSuperview];
    pageCount = 1;
 
    self.refreshControl=[[RefreshControl alloc] initWithScrollView:self.mainTableView delegate:self];
    self.refreshControl.topEnabled=YES;
    self.refreshControl.bottomEnabled=YES;
    [self.refreshControl registerClassForTopView:[CustomRefreshView class]];
    
    isPullToRefresh = YES;
    isFirstViewAppear = YES;
}
#pragma mark tableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cellIIdentifier11";
    RMWatchRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if(cell==nil){
        if([model.video_type isEqualToString:@"3"]){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMWatchRecordTableViewVarietyCell" owner:self options:nil] lastObject];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMWatchRecordTableViewCell" owner:self options:nil] lastObject];
        }
        if(isEditing)
            [cell setCellViewFrame];
    }
    [cell.editingImage setImage:[UIImage imageNamed:[cellEditingImageArray objectAtIndex:indexPath.row]]];
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
    cell.titleLable.text = model.name;
    cell.starringLable.text = model.actors;
    cell.playCount.text = model.hits;
    cell.delegate = self;
    cell.playBtn.tag = indexPath.row;
    return cell;
    
}
#pragma mark tableView delegale
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(isEditing){
        RMWatchRecordTableViewCell *cell = (RMWatchRecordTableViewCell *)[self.mainTableView cellForRowAtIndexPath:indexPath];
        if([[cellEditingImageArray objectAtIndex:indexPath.row] isEqualToString:@"cell_no_select"]){
            [cell.editingImage setImage:LOADIMAGE(@"cell_selected")];
            [cellEditingImageArray replaceObjectAtIndex:indexPath.row withObject:@"cell_selected"];
            [selectCellArray addObject:[NSNumber numberWithInteger:indexPath.row]];
            [deleteBtn setTitle:[NSString stringWithFormat:@"删除（%d）",(int)selectCellArray.count] forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
        }
        else{
            [cell.editingImage setImage:LOADIMAGE(@"cell_no_select")];
            [cellEditingImageArray replaceObjectAtIndex:indexPath.row withObject:@"cell_no_select"];
            [selectCellArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
            if(selectCellArray.count==0){
                [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
                [deleteBtn setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1] forState:UIControlStateNormal];
            }else{
                [deleteBtn setTitle:[NSString stringWithFormat:@"删除（%d）",(int)selectCellArray.count] forState:UIControlStateNormal];
                [deleteBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
            }
        }
        if(selectCellArray.count==self.dataArray.count){
            isSeleltAllCell = YES;
            [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        }else{
            isSeleltAllCell = NO;
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
    }else{
        RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row];
        RMVideoPlaybackDetailsViewController * videoPlaybackDetailsCtl = [[RMVideoPlaybackDetailsViewController alloc] init];
        videoPlaybackDetailsCtl.video_id = model.video_id;
        if([model.video_type isEqualToString:@"1"])
            videoPlaybackDetailsCtl.segVideoType = @"电影";
        else
            videoPlaybackDetailsCtl.segVideoType = @"电视剧";
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        [self presentViewController:videoPlaybackDetailsCtl animated:YES completion:^{
        }];
    }
}
#pragma mark tableView delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(isEditing){
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSUInteger row = [indexPath row];
        RMPublicModel *model = [self.dataArray objectAtIndex:row];
        [self showLoadingSimpleWithUserInteractionEnabled:YES];
        [requestManager deleteFavoriteWithVideo_id:model.video_id andToken:token];
        [self.dataArray removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if(self.dataArray.count==0){
            rightBarButton.hidden = YES;
        }
    }
}

- (void)EditingViewBtnClick:(UIButton *)sender{
    if(sender==selectAllBtn){
        [selectCellArray removeAllObjects];
        if(!isSeleltAllCell){
            for(int i=0; i<self.dataArray.count;i++){
                [cellEditingImageArray replaceObjectAtIndex:i withObject:@"cell_selected"];
                [selectCellArray addObject:[NSNumber numberWithInt:i]];
            }
            [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
            [deleteBtn setTitle:[NSString stringWithFormat:@"删除（%d）",(int)selectCellArray.count] forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
        }
        else{
            for(int i=0; i<self.dataArray.count;i++){
                [cellEditingImageArray replaceObjectAtIndex:i withObject:@"cell_no_select"];
            }
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1] forState:UIControlStateNormal];
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
        isSeleltAllCell = !isSeleltAllCell;
        [self.mainTableView reloadData];
    }else{
        NSArray *sort = [selectCellArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
            return obj1.integerValue<obj2.integerValue;
        }];
        NSString *deleteMovieID = @"";
        for (NSNumber *number in sort){
            RMPublicModel *model = [self.dataArray objectAtIndex:number.integerValue];
            if([deleteMovieID isEqualToString:@""]){
                deleteMovieID = model.video_id;
            }else{
                deleteMovieID = [NSString stringWithFormat:@"%@,%@",deleteMovieID,model.video_id];
            }
        }
        [self showLoadingSimpleWithUserInteractionEnabled:YES];
        [requestManager deleteFavoriteWithVideo_id:deleteMovieID andToken:token];
        for(int i=0;i<sort.count;i++){
            NSNumber *number = [sort objectAtIndex:i];
            [cellEditingImageArray removeObjectAtIndex:number.integerValue];
            [self.dataArray removeObjectAtIndex:number.integerValue];
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:number.integerValue inSection:0];
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.mainTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
        [selectCellArray removeAllObjects];
        [UIView animateWithDuration:0.5 animations:^{
            btnView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
            self.mainTableView.frame = CGRectMake(self.mainTableView.frame.origin.x, self.mainTableView.frame.origin.y, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height+49);
        }];
        [self setRightBarBtnItemImageWith:YES];
        [[NSNotificationCenter defaultCenter ] postNotificationName:kEndEditingTableViewCell object:nil];
        isEditing = NO;
        if(self.dataArray.count==0){
            rightBarButton.hidden = YES;
        }
    }
}

- (void)palyMovieWithIndex:(NSInteger)index{
    RMPublicModel *model = [self.dataArray objectAtIndex:index];
    if ([model.video_type isEqualToString:@"1"]){
        NSString *mp4Url = [model.urls objectForKey:@"m_down_url"];
        NSString* pathExtention = [mp4Url pathExtension];
        if([pathExtention isEqualToString:@"mp4"]) {
            RMModel *_model = [[RMModel alloc] init];
            _model.url = mp4Url;
            _model.title = model.name;
            [RMPlayer presentVideoPlayerWithPlayModel:_model withUIViewController:self withVideoType:1 withIsLocationVideo:NO];
        }else{
            RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
            loadingWebCtl.name = model.name;
            loadingWebCtl.loadingUrl = [model.urls objectForKey:@"jumpurl"];;
            [self presentViewController:loadingWebCtl animated:YES completion:^{
            }];
        }
    }else{
        if(model.urls_arr.count==0){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无播放地址" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        NSString* pathExtention = [[[model.urls_arr objectAtIndex:0] objectForKey:@"m_down_url"] pathExtension];
        if([pathExtention isEqualToString:@"mp4"]) {
            RMModel *_model = [[RMModel alloc] init];
            _model.url = [[model.urls_arr objectAtIndex:0] objectForKey:@"m_down_url"];
            _model.title = model.name;
            [RMPlayer presentVideoPlayerWithPlayModel:_model withUIViewController:self withVideoType:1 withIsLocationVideo:NO];
        }else{
            RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
            loadingWebCtl.name = model.name;
            loadingWebCtl.loadingUrl = [[model.urls_arr objectAtIndex:0] objectForKey:@"jumpurl"];
            [self presentViewController:loadingWebCtl animated:YES completion:^{
            }];
        }
    }
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    [self setRightBarBtnItemImageWith:isEditing];
    [self.mainTableView setEditing:NO animated:YES];
    switch (sender.tag) {
        case 1:{
            if(isEditing){
                [[NSNotificationCenter defaultCenter] postNotificationName:kEndEditingTableViewCell object:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 2:{
            if(!isEditing){
                [UIView animateWithDuration:0.5 animations:^{
                    btnView.frame = CGRectMake(0, ScreenHeight-49, ScreenWidth, 49);
                    self.mainTableView.frame = CGRectMake(self.mainTableView.frame.origin.x, self.mainTableView.frame.origin.y, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height-49);
                }];
                [[NSNotificationCenter defaultCenter] postNotificationName:kBeginEdingtingTableViewCell object:nil];
                
            }
            else{
                [UIView animateWithDuration:0.5 animations:^{
                    btnView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
                    self.mainTableView.frame = CGRectMake(self.mainTableView.frame.origin.x, self.mainTableView.frame.origin.y, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height+49);
                }];
                [[NSNotificationCenter defaultCenter ] postNotificationName:kEndEditingTableViewCell object:nil];
                for(int i=0;i<selectCellArray.count;i++){
                    NSNumber *number = [selectCellArray objectAtIndex:i];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:number.integerValue inSection:0];
                    RMWatchRecordTableViewCell *cell = (RMWatchRecordTableViewCell*)[self.mainTableView cellForRowAtIndexPath:indexPath];
                    cell.editingImage.image = [UIImage imageNamed:@"cell_no_select"];
                    [cellEditingImageArray replaceObjectAtIndex:number.integerValue withObject:@"cell_no_select"];
                }
                [selectCellArray removeAllObjects];
            }
            isEditing = !isEditing;
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1] forState:UIControlStateNormal];
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            break;
        }
            
        default:
            break;
    }
}

- (void)requestFinishiDownLoadWith:(NSMutableArray *)data{
    if(requestManager.downLoadType == Http_getFavoriteVideoList){
        if(isPullToRefresh){
            if (data.count == 0){
                [self showEmptyWithImage:@"empty" withImageSize:CGSizeMake(55, 55) withTitle:@"您还没有添加收藏记录"];
            }
            [self.dataArray removeAllObjects];
            self.dataArray = data;
            [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
        }
        else{
            if(data.count==0){
                [self showMessage:@"没有更多数据加载" duration:1 withUserInteractionEnabled:YES];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
                [self hideLoading];
                return;
            }
            for(RMPublicModel *model in data){
                [self.dataArray addObject:model];
            }
            [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        }
        [cellEditingImageArray removeAllObjects];
        for(int i=0;i<self.dataArray.count;i++){
            [cellEditingImageArray addObject:@"cell_no_select"];
        }
        if(self.dataArray.count>0){
            rightBarButton.hidden = NO;
        }else{
            rightBarButton.hidden = YES;
        }
        [self.mainTableView reloadData];
        [self hideLoading];
    }
}

- (void)requestFinishiDownLoadWithResults:(NSString *)results {
    if(requestManager.downLoadType == Http_deleteFavoriteVideo){
        if([results isEqualToString:@"success"]){
            NSLog(@"操作成功");
        }else{
            NSLog(@"删除失败");
        }
        [self hideLoading];
    }
}

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
    NSDictionary *userInfo = [storage objectForKey:UserLoginInformation_KEY];
    token = [userInfo objectForKey:@"token"];
    if(token==nil){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录到小花视频" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [self showEmptyWithImage:@"error" withImageSize:CGSizeMake(55, 55) withTitle:@"您还没有登录"];
        [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
        return;
    }
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
    if (direction == RefreshDirectionTop) { //下拉刷新
        pageCount = 1;
        isPullToRefresh = YES;
        [requestManager getFavoriteVideoListWithToken:token Page:[NSString stringWithFormat:@"%ld",(long)pageCount]];
        
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        isPullToRefresh = NO;
        pageCount ++;
        [requestManager getFavoriteVideoListWithToken:token Page:[NSString stringWithFormat:@"%ld",(long)pageCount]];
    }
}

- (void)requestError:(NSError *)error{
    if(isPullToRefresh){
        [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }
    else{
        [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    }
    [self hideLoading];
    rightBarButton.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
