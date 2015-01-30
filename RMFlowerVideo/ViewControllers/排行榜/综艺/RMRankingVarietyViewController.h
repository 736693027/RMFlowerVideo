//
//  RMRankingVarietyViewController.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-1.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMRankTableViewHeadView.h"
#import "RefreshControl.h"
#import "CustomRefreshView.h"

@interface RMRankingVarietyViewController : RMBaseViewController<RefreshControlDelegate>

@property (nonatomic, assign) id delegate;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) RefreshControl * refreshControl;

- (void)requestData;

@end
