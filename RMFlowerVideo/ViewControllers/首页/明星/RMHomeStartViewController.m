//
//  RMHomeStartViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 14-12-30.
//  Copyright (c) 2014年 润滑联动. All rights reserved.
//

#import "RMHomeStartViewController.h"
#import "RMHomestartCell.h"
#import "RMStarDetailsViewController.h"     //明星详情
#import "RMHomeViewController.h"
#import "RMSearchViewController.h"

@interface RMHomeStartViewController ()<RMHomeStartCellDelegate,RMAFNRequestManagerDelegate>{
    UIView *searchView;
    float lastContentOffset;
    BOOL isAlreadDownLoad; //是否已经下载过数据了
    RMAFNRequestManager *requestManeger;
    NSInteger pageCount;
    BOOL isPullToRefresh;
    int searchViewHeight,rollBtnHeight,originY,margin;
}

@end

@implementation RMHomeStartViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageCount = 1;
    isPullToRefresh = YES;
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    searchViewHeight = 43,rollBtnHeight = 31,originY = 11,margin = 6;
    if(IS_IPHONE_6_SCREEN){
        searchViewHeight = 47,rollBtnHeight = 35,originY = 14,margin = 12;
    }else if(IS_IPHONE_6p_SCREEN){
        searchViewHeight = 47,rollBtnHeight = 35,originY = 15,margin = 8;
    }
    //随tableview 滚动时候显示的搜索view
    searchView = [[UIView alloc] initWithFrame:CGRectMake(originY, -searchViewHeight, ScreenWidth-originY*2, searchViewHeight)];
    searchView.backgroundColor = [UIColor whiteColor];
    UIButton *rollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rollBtn.frame = CGRectMake(0, 6, ScreenWidth-originY*2, rollBtnHeight);
    if(IS_IPHONE_6_SCREEN){
        [rollBtn setBackgroundImage:LOADIMAGE(@"home_search_btn_6") forState:UIControlStateNormal];
    }else if (IS_IPHONE_6p_SCREEN){
        [rollBtn setBackgroundImage:LOADIMAGE(@"home_search_btn_6p") forState:UIControlStateNormal];
    }else{
        [rollBtn setBackgroundImage:LOADIMAGE(@"home_search_btn") forState:UIControlStateNormal];
    }
    [rollBtn addTarget:self action:@selector(beginSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:rollBtn];
    [self.view addSubview:searchView];
    
    self.dataArray = [[NSMutableArray alloc] init];
    //table view 的 headView
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, searchViewHeight-margin)];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(originY, 6, ScreenWidth-originY*2, rollBtnHeight);
    if(IS_IPHONE_6_SCREEN){
        [searchBtn setBackgroundImage:LOADIMAGE(@"home_search_btn_6") forState:UIControlStateNormal];
    }else if (IS_IPHONE_6p_SCREEN){
        [searchBtn setBackgroundImage:LOADIMAGE(@"home_search_btn_6p") forState:UIControlStateNormal];
    }else{
        [searchBtn setBackgroundImage:LOADIMAGE(@"home_search_btn") forState:UIControlStateNormal];
    }
    [searchBtn addTarget:self action:@selector(beginSearch) forControlEvents:UIControlEventTouchUpInside];
    [tableHeadView addSubview:searchBtn];
    [self.mainTableView setTableHeaderView:tableHeadView];
    
    self.mainTableView.separatorInset = UIEdgeInsetsMake(0, -5, 0, 15);
    self.refreshControl=[[RefreshControl alloc] initWithScrollView:self.mainTableView delegate:self];
    self.refreshControl.topEnabled=YES;
    self.refreshControl.bottomEnabled=YES;
    [self.refreshControl registerClassForTopView:[CustomRefreshView class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(IS_IPHONE_6_SCREEN){
        return 204;
    }
    else if (IS_IPHONE_6p_SCREEN){
        return 224;
    }
    return 184;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dataArray.count%3==0)
        return self.dataArray.count/3;
    else
        return self.dataArray.count/3+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"homeTableViewCellIdentifier";
    RMHomeStartCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil){
        if(IS_IPHONE_6_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMHomeStartCell_6" owner:self options:nil] lastObject];
        }else if (IS_IPHONE_6p_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMHomeStartCell_6p" owner:self options:nil] lastObject];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMHomeStartCell" owner:self options:nil] lastObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
    }
    if(indexPath.row*3<self.dataArray.count){
        RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row*3];
        [cell.fristHeadImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.fristHeadImage.identifierString = model.tag_id;
        cell.fristTitle.text = model.name;
    }
    if(indexPath.row*3+1<self.dataArray.count){
        RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row*3+1];
        [cell.secondHeadImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.secondHeadImage.identifierString = model.tag_id;
        cell.secondTitle.text = model.name;
    }
    if(indexPath.row*3+2<self.dataArray.count){
        RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row*3+2];
        [cell.thirdHeadImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.thirdHeadImage.identifierString = model.tag_id;
        cell.thirdTitle.text = model.name;
    }
    return cell;
}

#pragma mark - delegate

- (void)homeTableViewCellDidSelectWithImage:(RMImageView *)imageView {
    RMHomeViewController * homeCtl = self.delegate;
    RMStarDetailsViewController * starDetailsCtl = [[RMStarDetailsViewController alloc] init];
    starDetailsCtl.tag_id = imageView.identifierString;
    [homeCtl.navigationController pushViewController:starDetailsCtl animated:YES];
}

//滚动的搜索栏
- (void)showSearchView {
    [UIView animateWithDuration:0.3 animations:^{
        searchView.frame = CGRectMake(originY, 0, ScreenWidth-originY*2, searchViewHeight);
    }];
}

- (void)hideSearchViewWithDuration:(NSTimeInterval)time {
    [UIView animateWithDuration:time animations:^{
        searchView.frame = CGRectMake(originY, -searchViewHeight, ScreenWidth-originY*2, searchViewHeight);
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y==0||scrollView.contentOffset.y<0){
        searchView.hidden = YES;
        [self hideSearchViewWithDuration:0.1];
    }
    else if (lastContentOffset < scrollView.contentOffset.y) {
        
        [self hideSearchViewWithDuration:0.3];
    }else{
        searchView.hidden = NO;
        [self showSearchView];
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

- (void) requestData{
    if(!isAlreadDownLoad){
        [self showLoadingSimpleWithUserInteractionEnabled:YES];
        requestManeger = [[RMAFNRequestManager alloc] init];
        requestManeger.delegate = self;
        [requestManeger getStarListWithPage:@"1" andLimit:@""];
        isAlreadDownLoad = YES;
    }
}
#pragma mark 上拉刷新和下拉加载
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        isPullToRefresh = YES;
        pageCount = 1;
        [self showLoadingSimpleWithUserInteractionEnabled:YES];
        [requestManeger getStarListWithPage:@"1" andLimit:@""];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        isPullToRefresh = NO;
        pageCount++;
        [self showLoadingSimpleWithUserInteractionEnabled:YES];
        [requestManeger getStarListWithPage:[NSString stringWithFormat:@"%ld",(long)pageCount] andLimit:@""];
    }
}

#pragma mark 下载成功
- (void)requestFinishiDownLoadWith:(NSMutableArray *)data{
    if(isPullToRefresh){
        [self.dataArray removeAllObjects];
        self.dataArray = data;
        [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }else{
        if(data.count==0){
            [self showMessage:@"没有更多数据加载了" duration:1 withUserInteractionEnabled:YES];
            return;
        }
        for(RMPublicModel *model in data){
            [self.dataArray addObject:model];
        }
        [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    }
    [self.mainTableView reloadData];
    [self hideLoading];
}

- (void)requestError:(NSError *)error {
    [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
    [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    [self hideLoading];
}

@end
