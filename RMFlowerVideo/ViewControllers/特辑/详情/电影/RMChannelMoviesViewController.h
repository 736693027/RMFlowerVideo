//
//  RMMoviesViewController.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMChannelMoviesViewController : RMBaseViewController
@property (nonatomic, copy) NSString * ctlType;

@property (nonatomic, assign) id MyChannelDetailsDelegate;
@property (nonatomic, copy) NSString * tag_id;

@end
