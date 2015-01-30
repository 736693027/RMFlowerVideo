//
//  RMSpecialEditionDetailViewController.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-15.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMSpecialEditionDetailViewController : RMBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, copy) NSString * customTitle;
@property (nonatomic, copy) NSString * tag_id;
@end
