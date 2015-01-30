//
//  RMRankTableViewHeadView.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMImageView.h"

@interface RMRankTableViewHeadView : UIView
@property (weak, nonatomic) IBOutlet RMImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *playcount;

@end
