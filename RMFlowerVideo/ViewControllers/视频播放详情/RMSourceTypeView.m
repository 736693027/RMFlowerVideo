//
//  RMSourceTypeView.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-23.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMSourceTypeView.h"
#import "CONST.h"
#import "UIButton+EnlargeEdge.h"
#import "RMPublicModel.h"

@interface RMSourceTypeView (){
    NSDictionary * sourceBigDic;
    NSDictionary * sourceSmallDic;
    UILabel * name;
}

@end

@implementation RMSourceTypeView

- (void)loadSourceTypeViewWithTotal:(NSMutableArray *)total {
    /*
     0:默认 1:优酷 2:迅雷 3:腾讯 4:乐视 5:pptv 6:爱奇艺 7:土豆 8:1905 9:华数 10.搜狐
     */
    if (!name){
        name = [[UILabel alloc] init];
    }
    name.frame = CGRectMake(0, 0, 80, 45);
    name.text = @"   播放源:";
    name.font = FONT(16.0);
    name.textAlignment = NSTextAlignmentLeft;
    name.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
    name.backgroundColor = [UIColor clearColor];
    [self addSubview:name];
    
    sourceBigDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"source_default_big", @"0",
                                   @"source_youku_big", @"1",
                                   @"source_xunlei_big", @"2",
                                   @"source_tengxun_big", @"3",
                                   @"source_leshi_big", @"4",
                                   @"source_pptv_big", @"5",
                                   @"source_iqiyi_big", @"6",
                                   @"source_tudou_big", @"7",
                                   @"source_1905_big", @"8",
                                   @"source_huashu_big", @"9",
                                   @"source_souhu_big", @"10",
                                   nil];
    
    sourceSmallDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"source_default_small", @"0",
                                     @"source_youku_small", @"1",
                                     @"source_xunlei_small", @"2",
                                     @"source_tengxun_small", @"3",
                                     @"source_leshi_small", @"4",
                                     @"source_pptv_small", @"5",
                                     @"source_iqiyi_small", @"6",
                                     @"source_tudou_small", @"7",
                                     @"source_1905_small", @"8",
                                     @"source_huashu_small", @"9",
                                     @"source_souhu_small", @"10",
                                     nil];
    
    for (id sender in [self subviews]){
        if ([sender isKindOfClass:[UIButton class]]){
            [sender removeFromSuperview];
        }
    }

    for (NSInteger i=0; i<[total count]; i++){
        RMPublicModel * model = [total objectAtIndex:i];

        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setEnlargeEdgeWithTop:2 right:2 bottom:2 left:2];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = model.source_type.integerValue;
        [self addSubview:button];
        
        if (i==0){
            button.frame = CGRectMake(75, 9, 30, 30);
            [button.layer setCornerRadius:12.5];
            NSString * pic = [sourceBigDic objectForKey:model.source_type];
            [button setBackgroundImage:LOADIMAGE(pic) forState:UIControlStateNormal];
            self.currentType = model.source_type.integerValue;
        }else{
            button.frame = CGRectMake(80 + i*32, 10, 27, 27);
            [button.layer setCornerRadius:11.0];
            NSString * pic = [sourceSmallDic objectForKey:model.source_type];
            [button setBackgroundImage:LOADIMAGE(pic) forState:UIControlStateNormal];
        }
    }
}

- (void)buttonClick:(UIButton *)sender {
    if (sender.tag == self.currentType) {
        NSLog(@"选中当前，不用置换");
    }else{
        UIButton * endBtn = (UIButton *)[self viewWithTag:self.currentType];
        CGRect transFrame = sender.frame;
        [UIView animateWithDuration:0.4 animations:^{
            NSString * senderPic = [sourceBigDic objectForKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
            NSString * endPic = [sourceSmallDic objectForKey:[NSString stringWithFormat:@"%ld",(long)self.currentType]];
            sender.frame = CGRectMake(endBtn.frame.origin.x, endBtn.frame.origin.y, 30, 30);
            [sender setBackgroundImage:LOADIMAGE(senderPic) forState:UIControlStateNormal];
            [endBtn setBackgroundImage:LOADIMAGE(endPic) forState:UIControlStateNormal];

            endBtn.frame = CGRectMake(transFrame.origin.x, transFrame.origin.y, 27, 27);
        } completion:^(BOOL finished) {
            self.currentType = sender.tag;
        }];
        if ([self.delegate respondsToSelector:@selector(switchVideoSourceToCurrentType:)]){
            [self.delegate switchVideoSourceToCurrentType:sender.tag];
        }
    }
}

@end
