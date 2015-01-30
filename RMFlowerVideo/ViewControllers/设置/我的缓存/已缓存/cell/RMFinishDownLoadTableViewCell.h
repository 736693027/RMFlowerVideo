//
//  RMFinishDownLoadTableViewCell.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-6.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMFinishDownLoadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *starringTitle;
@property (weak, nonatomic) IBOutlet UILabel *directorTitle;
@property (weak, nonatomic) IBOutlet UILabel *playCountTitle;
@property (weak, nonatomic) IBOutlet UIImageView *editingImage;
@property (weak, nonatomic) IBOutlet UILabel *casheLable;
@property (weak, nonatomic) IBOutlet UILabel *starringLable;
@property (weak, nonatomic) IBOutlet UILabel *directorLable;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
- (void)setCellViewFrame;
@end
