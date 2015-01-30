//
//  RMTopJumpWebView.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-26.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefreshPlayAddressDelegate <NSObject>

- (void)refreshPlayAddressMethod;

@end

@interface RMTopJumpWebView : UIView
@property (nonatomic, assign) id<RefreshPlayAddressDelegate>delegate;

- (void)initTopJumpWebView;

@end
