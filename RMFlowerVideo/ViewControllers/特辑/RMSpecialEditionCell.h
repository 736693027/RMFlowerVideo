//
//  RMSpecialEditionCell.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMImageView.h"

@protocol SpecialEditionCellDelegate <NSObject>

@required
- (void)specialEditionCellMethodWithImage:(RMImageView *)image;
@end

@interface RMSpecialEditionCell : UITableViewCell
@property (nonatomic, assign) id<SpecialEditionCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet RMImageView *firstImage;
@property (weak, nonatomic) IBOutlet RMImageView *secondImage;
@property (weak, nonatomic) IBOutlet RMImageView *thirdImage;

@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *secondName;
@property (weak, nonatomic) IBOutlet UILabel *thirdName;

@property (weak, nonatomic) IBOutlet UILabel *firstScore;
@property (weak, nonatomic) IBOutlet UILabel *secondScore;
@property (weak, nonatomic) IBOutlet UILabel *thirdScore;


@end
