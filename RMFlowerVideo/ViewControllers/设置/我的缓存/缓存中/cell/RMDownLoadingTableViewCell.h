//
//  RMDownLoadingTableViewCell.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-6.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"

@interface RMDownLoadingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet LDProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLable;
@property (weak, nonatomic) IBOutlet UILabel *tatleProgressLable;
@property (weak, nonatomic) IBOutlet UIImageView *editingImage;
- (void)setCellViewFrame;
@end
