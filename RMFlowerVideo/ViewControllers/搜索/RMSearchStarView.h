//
//  RMSearchStarView.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-27.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMPublicModel.h"

@interface RMSearchStarView : UIView

@property (nonatomic, strong) RMPublicModel * dataModel;
@property (nonatomic, assign) id jumpDelegate;

- (void)initSearchStarView;

@end
