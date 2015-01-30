//
//  RMHomeStartCell.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMImageView.h"

@protocol RMHomeStartCellDelegate <NSObject>

-(void)homeTableViewCellDidSelectWithImage:(RMImageView *)imageView;

@end

@interface RMHomeStartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RMImageView *fristHeadImage;
@property (weak, nonatomic) IBOutlet RMImageView *secondHeadImage;
@property (weak, nonatomic) IBOutlet RMImageView *thirdHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *fristTitle;
@property (weak, nonatomic) IBOutlet UILabel *secondTitle;
@property (weak, nonatomic) IBOutlet UILabel *thirdTitle;
@property (weak, nonatomic) IBOutlet UIButton *firstFocusBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondFocusBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdFocusBtn;
@property (assign,nonatomic) id<RMHomeStartCellDelegate> delegate;

@end
