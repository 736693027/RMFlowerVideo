//
//  RMMoreAPPTableViewCell.h
//  RMVideo
//
//  Created by 润华联动 on 14-10-22.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RMMoreAPPTableViewCellDelegate <NSObject>

- (void) cellBtnSelectWithIndex:(NSInteger)index;

@end
@interface RMMoreAPPTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (assign, nonatomic) id<RMMoreAPPTableViewCellDelegate> delegate;
- (IBAction)openBtn:(UIButton *)sender;

@end
