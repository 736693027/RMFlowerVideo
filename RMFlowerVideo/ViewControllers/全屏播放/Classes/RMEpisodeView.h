//
//  EpisodeView.h
//  RMCustomPlayer
//
//  Created by runmobile on 14-12-12.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMEpisodeView : UIView {
    id _target;
    SEL _sel;
}
@property (nonatomic, assign) int currentNum;

- (void)addTarget:(id)target WithSelector:(SEL)sel;

- (void)loadEpisodeViewWithNumber:(NSString *)num;

@end
