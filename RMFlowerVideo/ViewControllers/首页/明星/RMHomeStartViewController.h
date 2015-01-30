//
//  RMHomeStartViewController.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 14-12-30.
//  Copyright (c) 2014年 润滑联动. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RefreshControl.h"
#import "CustomRefreshView.h"

@interface RMHomeStartViewController : RMBaseViewController<RefreshControlDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic ,assign) id delegate;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) RefreshControl * refreshControl;

- (void) requestData;

@end
