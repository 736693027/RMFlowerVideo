//
//  RMSearchBaseViewController.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMBaseViewController.h"
#import "RMHomeTableViewCell.h"
#import "RMHomeViewController.h"
#import "RMSearchViewController.h"
#import "CycleScrollView.h"
#import "RefreshControl.h"
#import "CustomRefreshView.h"

@interface RMSearchBaseViewController : RMBaseViewController
@property (nonatomic , retain) CycleScrollView *mainScorllView;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) RefreshControl * refreshControl;
@property (nonatomic, strong) UIView *tableHeadView;

@property (strong,nonatomic) UIView *searchView;

- (void)showSearchView;
- (void)hideSearchViewWithDuration:(NSTimeInterval)time;
- (void)beginSearch;
//- (void)directlyPlayMovieBtn:(UIButton *)btn;

//上拉刷新
- (void)refreshControlBeginPullToRefresh;
//下拉加载
- (void)refreshControlBeginDropDownLoad;

//创建滚动视图
- (void)creatTableViewheadScrollView;

/**
 *  设置tableView的 headView
 *
 *  @param state YES 表示有滚动的scrollview NO 表示只有搜索栏
 */
- (void)setTabelViewHeadViewWith:(BOOL)state;

@end
