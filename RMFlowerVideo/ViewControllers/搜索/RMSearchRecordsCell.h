//
//  RMSearchRecordsCell.h
//  RMVideo
//
//  Created by runmobile on 14-11-3.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMImageView.h"

@protocol SearchRecordsDelegate <NSObject>

- (void)deleteSearchRecordsMethod:(NSInteger)value;

@end

@interface RMSearchRecordsCell : UITableViewCell
@property (assign ,nonatomic) id<SearchRecordsDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *recordsName;
@property (weak, nonatomic) IBOutlet RMImageView *recordsImg;
- (IBAction)buttonRecordsClickMethod:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *clickbtn;

@end
