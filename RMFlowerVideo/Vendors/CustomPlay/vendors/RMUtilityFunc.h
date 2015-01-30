//
//  UtilityFunc.h
//  RMVideo
//
//  Created by runmobile on 14-9-29.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface RMUtilityFunc : NSObject{
    
}
@property (nonatomic, assign) float globleWidth;
@property (nonatomic, assign) float globleHeight;
@property (nonatomic, assign) float globleAllHeight;

+ (RMUtilityFunc *)shareInstance;

+ (NSInteger)isConnectionAvailable;

+ (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font text:(NSString*)text;

@end
