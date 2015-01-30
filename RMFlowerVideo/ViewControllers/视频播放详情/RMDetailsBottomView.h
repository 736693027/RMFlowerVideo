//
//  RMDetailsBottomView.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-5.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomBtnDelegate <NSObject>

- (void)bottomBtnActionMethodWithSender:(NSInteger)sender;

@end

@interface RMDetailsBottomView : UIView
@property (nonatomic, assign) id<BottomBtnDelegate>delegate;

- (void)initDetailsBottomView;

- (void)switchCollectionState:(BOOL)isCollection;

@end
