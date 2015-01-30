//
//  RMPlayRelatedCell.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-6.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMImageView.h"

@protocol PlayRelatedDelegate <NSObject>

- (void)directBroadcastMethodWithImage:(RMImageView *)image;

@end

@interface RMPlayRelatedCell : UITableViewCell
@property (nonatomic, assign) id<PlayRelatedDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UILabel *videoName;
@property (weak, nonatomic) IBOutlet UILabel *videoScore;
@property (weak, nonatomic) IBOutlet UILabel *videoPlayNum;
@property (weak, nonatomic) IBOutlet RMImageView *directBroadcast;

- (void)setTitleLableWithString:(NSString *)title;

@end
