//
//  RMSearchCell.m
//  RMVideo
//
//  Created by runmobile on 14-10-13.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMSearchResultCell.h"

@implementation RMSearchResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)DirectBroadcastClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(DirectBroadcastMethodWithValue:)]){
        [self.delegate DirectBroadcastMethodWithValue:sender.tag];
    }
}

- (void)setNameWithString:(NSString *)title {
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0], NSFontAttributeName, nil];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(500, 20)
                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   attributes:attrs
                                      context:nil];
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    if(rect.size.width > (screenWidth - 120 - 32)){
        self.name.frame = CGRectMake(self.name.frame.origin.x, self.name.frame.origin.y, screenWidth-120-32, self.name.frame.size.height);
        self.scoreName.frame = CGRectMake(self.name.frame.origin.x+screenWidth-120-32, 20, self.scoreName.frame.size.width, self.scoreName.frame.size.height);
    }else{
        self.name.frame = CGRectMake(self.name.frame.origin.x, self.name.frame.origin.y, rect.size.width, 21);
        self.scoreName.frame = CGRectMake(self.name.frame.origin.x+rect.size.width+10, 20, self.scoreName.frame.size.width, self.scoreName.frame.size.height);
    }
    self.name.text = title;
}

- (void)setOtherAutomaticAdaptation {
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.name.frame = CGRectMake(113, 17, screenWidth - 113 - 10, 21);
    self.mainActor.frame = CGRectMake(113, 43, screenWidth - 113 - 10, 20);
    self.director.frame = CGRectMake(113, 65, screenWidth - 113 - 10, 20);
    self.lineView.frame = CGRectMake(10, 154, screenWidth - 20, 1);
}

- (void)setOtherVarietyAutomaticAdaptation {
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.name.frame = CGRectMake(113, 17, screenWidth - 113 - 10, 21);
    self.director.frame = CGRectMake(113, 55, screenWidth - 113 - 10, 20);
    self.lineView.frame = CGRectMake(10, 154, screenWidth - 20, 1);
}

@end
