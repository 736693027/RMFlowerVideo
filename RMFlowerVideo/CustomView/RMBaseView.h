//
//  RMBaseView.h
//  RMVideo
//
//  Created by runmobile on 14-10-17.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMBaseView : UIView {
    id _target;
    SEL _sel;
}
- (void)addTarget:(id)target WithSelector:(SEL)sel;


- (void)loadSearchViewWithTitle:(NSString *)str;

@end
