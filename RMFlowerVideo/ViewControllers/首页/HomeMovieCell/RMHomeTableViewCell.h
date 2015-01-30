//
//  RMHomeTableViewCell.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMImageView.h"

@protocol RMHomeTableViewCellDelegate <NSObject>

- (void)homeTableViewCellDidSelectWithImage:(RMImageView *)imageView;

- (void)playBtnWithVideo_id:(NSString *)video_id;

@end
@interface RMHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RMImageView *fristHeadImage;
@property (weak, nonatomic) IBOutlet RMImageView *secondHeadImage;
@property (weak, nonatomic) IBOutlet RMImageView *thridHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *fristLable;
@property (weak, nonatomic) IBOutlet UILabel *secondLable;
@property (weak, nonatomic) IBOutlet UILabel *thridLable;
@property (weak, nonatomic) IBOutlet UILabel *fristScore;
@property (weak, nonatomic) IBOutlet UILabel *secondScore;
@property (weak, nonatomic) IBOutlet UILabel *thridScore;
@property (weak, nonatomic) IBOutlet UIButton *fristPlayBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondPlayBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdPlayBtn;
@property (assign, nonatomic) id<RMHomeTableViewCellDelegate> delegate;

- (void) setFristScoreWithTitle:(NSString *)title;
- (void) setSecondScoreWithTitle:(NSString *)title;
- (void) setThirdScoreWithTitle:(NSString *)title;

@end
