//
//  DOPScrollableActionSheet.h
//  DOPScrollableActionSheet
//
//  Created by weizhou on 12/27/14.
//  Copyright (c) 2014 fengweizhou. All rights reserved.
//

/*
 用法： 
 各个分享平台的图片
 NSArray *Image = [NSArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
 DOPScrollableActionSheet *as = [[DOPScrollableActionSheet alloc] initWithActionArray:actions];
 [as show];
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DOPScrollableActionSheet : UIView
@property (nonatomic, assign) id VideoPlaybackDetailsDelegate;

@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *video_pic;
- (instancetype)initWithPlatformHeadImageArray:(NSArray *)images;

- (void)show;

- (void)dismiss;

@end