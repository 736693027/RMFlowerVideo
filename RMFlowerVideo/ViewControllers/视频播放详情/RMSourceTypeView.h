//
//  RMSourceTypeView.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-23.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SourceTypeDelegate <NSObject>

- (void)switchVideoSourceToCurrentType:(NSInteger)type;

@end

@interface RMSourceTypeView : UIView
@property (nonatomic, assign) id<SourceTypeDelegate>delegate;
@property (nonatomic, assign) NSInteger currentType;

- (void)loadSourceTypeViewWithTotal:(NSMutableArray *)total;

@end
