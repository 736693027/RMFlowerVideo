//
//  DWTagList.h
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagListDelegate <NSObject>

- (void)clickTagWithTitle:(NSString *)title;

- (void)refreshTagListViewHeight:(float)height;

@end

@interface RMTagList : UIView {
    UIView *view;
    NSArray *textArray;
    CGSize sizeFit;
    UIColor *lblBackgroundColor;
}
@property (assign ,nonatomic) id<TagListDelegate> delegate;

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSArray *textArray;

- (void)setLabelBackgroundColor:(UIColor *)color;
- (void)setTags:(NSArray *)array;
- (void)display;
- (CGSize)fittedSize;

@end
