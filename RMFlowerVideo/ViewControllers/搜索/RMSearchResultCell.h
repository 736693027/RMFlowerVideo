//
//  RMSearchCell.h
//  RMVideo
//
//  Created by runmobile on 14-10-13.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchResultDelegate <NSObject>

- (void)DirectBroadcastMethodWithValue:(NSInteger)value;

@end
@interface RMSearchResultCell : UITableViewCell

@property (assign ,nonatomic) id<SearchResultDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *hits;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *scoreName;
@property (weak, nonatomic) IBOutlet UILabel *mainActor;
@property (weak, nonatomic) IBOutlet UILabel *director;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIButton *DirectBroadcastBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (IBAction)DirectBroadcastClick:(UIButton *)sender;

- (void)setNameWithString:(NSString *)title;

- (void)setOtherAutomaticAdaptation;

- (void)setOtherVarietyAutomaticAdaptation;

@end
