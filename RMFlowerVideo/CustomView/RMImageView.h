//
//  RMImageView.h
//  RMVideo
//
//  Created by runmobile on 14-10-13.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMImageView : UIImageView {
    id _target;
    SEL _sel;
}
@property (nonatomic, strong) NSString *identifierString;
@property (nonatomic, strong) NSIndexPath * indexPath;              //我的明星  获取点击加入我的频道当前的cell
@property (nonatomic, assign) NSInteger isAttentionStarState;       //我的明星  获取当前用户是否已经关注该明星


- (void)addTopNumber:(int)num;
- (void)addRotatingViewWithName:(NSString *)str;
- (void)setFileShowImageView:(NSString *)imageUrl;

- (void)addTarget:(id)target WithSelector:(SEL)sel;

@end
