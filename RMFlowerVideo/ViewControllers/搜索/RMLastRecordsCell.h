//
//  RMLastRecordsCell.h
//  RMVideo
//
//  Created by runmobile on 14-12-15.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LastRecordsDelegate <NSObject>

- (void)moreRecordsMethod;

@end

@interface RMLastRecordsCell : UITableViewCell
@property (assign ,nonatomic) id<LastRecordsDelegate> delegate;

- (IBAction)lastClickMethod:(UIButton *)sender;

@end
