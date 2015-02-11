//
//  CustomSVProgressHUD.m
//  RMCustomPlay
//
//  Created by 润华联动 on 14-11-5.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMCustomSVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@implementation RMCustomSVProgressHUD

- (void)showWithState:(BOOL)isFastForward andNowTime:(int)time{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    self.hidden = NO;
    self.alpha=0.8;
    if(!isFastForward){
        [self.headImage setImage:[UIImage imageNamed:@"rm_speed"]];
    }else{
        [self.headImage setImage:[UIImage imageNamed:@"rm_back"]];
    }
    int minutes = time/60;
    int seconds = time%60;
    if (minutes<=0) {
        minutes = 0;
    }if (seconds<=0) {
        seconds = 0;
    }
    int totla = [self timeStringChangeToInt:self.totalTimeString];
    if(time<totla){
        if(minutes>0&&minutes<10){
            if(seconds>0&&seconds<10){
                self.beginLable.text = [NSString stringWithFormat:@"0%d:0%d",minutes,seconds];
            }
            else{
                self.beginLable.text = [NSString stringWithFormat:@"0%d:%d",minutes,seconds];
            }
        }else{
            if(seconds>0&&seconds<10){
                self.beginLable.text = [NSString stringWithFormat:@"%d:0%d",minutes,seconds];
            }
            else{
                self.beginLable.text = [NSString stringWithFormat:@"%d:%d",minutes,seconds];
            }
        }
    }else{
        self.beginLable.text = [NSString stringWithFormat:@"%@",self.totalTimeString];
    }
    
    self.totalLable.text = [NSString stringWithFormat:@"%@",self.totalTimeString];
    
    [self performSelector:@selector(hideCustomHUD) withObject:nil afterDelay:2.0];
}

- (void)hideCustomHUD {
    self.alpha=0.8;
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha=0.0;
        [self setNeedsLayout];
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 0.8;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideCustomHUD) object:nil];
    }];
}
- (int)timeStringChangeToInt:(NSString *)timeString{
    NSString *mm = [timeString substringToIndex:[timeString rangeOfString:@":"].location];
    int minutes = [mm intValue]*60;
    NSString *ss = [timeString substringFromIndex:[timeString rangeOfString:@":"].location+1];
    int seconds = [ss intValue];
    return minutes+seconds;
}
@end
