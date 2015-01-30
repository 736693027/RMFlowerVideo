//
//  RMRankMovieCell.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RankMovieCellDelegate <NSObject>

- (void)playBtnMethodWithOrder:(NSInteger)order;

@end

@interface RMRankMovieCell : UITableViewCell
@property (nonatomic, assign) id<RankMovieCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *directorLable;
@property (weak, nonatomic) IBOutlet UILabel *scoreLable;
@property (weak, nonatomic) IBOutlet UILabel *starringLable;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UIButton *playBnt;
@property (weak, nonatomic) IBOutlet UIImageView *promoteImage; 
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UILabel *topNumberLable;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;

- (void)setTitleLableWithString:(NSString *)title;
- (void)setTextViewColor;
@end
