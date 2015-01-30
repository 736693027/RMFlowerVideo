//
//  RMSpecialEditionCell.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMImageView.h"

@protocol VideoOrStarCellDelegate <NSObject>

@required
- (void)videoOrStarCellMethodWithVideo_id:(NSString *)video_id;
- (void)videoOrStarCellMethodWithImage:(RMImageView *)image;

@end

@interface RMVideoOrStarCell : UITableViewCell
@property (nonatomic, assign) id<VideoOrStarCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet RMImageView *firstImage;
@property (weak, nonatomic) IBOutlet RMImageView *secondImage;
@property (weak, nonatomic) IBOutlet RMImageView *thirdImage;

@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *secondName;
@property (weak, nonatomic) IBOutlet UILabel *thirdName;

@property (weak, nonatomic) IBOutlet UILabel *firstScore;
@property (weak, nonatomic) IBOutlet UILabel *secondScore;
@property (weak, nonatomic) IBOutlet UILabel *thirdScore;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

- (IBAction)myChannelCellBtnClick:(UIButton *)sender;




@end
