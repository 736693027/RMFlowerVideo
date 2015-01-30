//
//  RMPlayCreatorViewController.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-5.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMPlayCreatorViewController : RMBaseViewController
@property (nonatomic, assign) id videoPlaybackDetailsDelegate;

- (void)reloadDataWithModel:(RMPublicModel *)model;

@end
