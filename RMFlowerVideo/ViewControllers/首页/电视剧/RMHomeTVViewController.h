//
//  RMHomeTVViewController.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 14-12-30.
//  Copyright (c) 2014年 润滑联动. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMSearchBaseViewController.h"

@interface RMHomeTVViewController :RMSearchBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,assign) id delegate;
@property (nonatomic ,strong) NSMutableArray *tableViewDataArray;

- (void) requestData;
@end
