//
//  RMWatchRecordTableViewCell.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-5.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CONST.h"

@protocol RMWatchRecordTableViewCellDelegate <NSObject>

-(void)palyMovieWithIndex:(NSInteger)index;

@end

@interface RMWatchRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *starringLable;
@property (weak, nonatomic) IBOutlet UILabel *directorLable;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *editingImage;
@property (weak, nonatomic) IBOutlet UILabel *starringTitle;
@property (weak, nonatomic) IBOutlet UILabel *directorTitle;
@property (weak, nonatomic) IBOutlet UILabel *playCountTitle;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (assign, nonatomic) id<RMWatchRecordTableViewCellDelegate> delegate;

- (void)setCellViewFrame;

@end
