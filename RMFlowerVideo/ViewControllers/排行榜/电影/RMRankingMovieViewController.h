//
//  RMRankingMovieViewController.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-1.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMBaseViewController.h"
#import "RefreshControl.h"
#import "CustomRefreshView.h"

@interface RMRankingMovieViewController : RMBaseViewController<RefreshControlDelegate>
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) RefreshControl * refreshControl;
- (void)startRequest;

@end
