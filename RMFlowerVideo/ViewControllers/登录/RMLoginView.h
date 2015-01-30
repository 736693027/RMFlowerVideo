//
//  RMLoginView.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginDelegate <NSObject>

- (void)loginMethodWithSender:(NSInteger)sender;

@end

@interface RMLoginView : UIView
@property (nonatomic, assign) id<LoginDelegate>delegate;

- (void)initLoginView;

@end
