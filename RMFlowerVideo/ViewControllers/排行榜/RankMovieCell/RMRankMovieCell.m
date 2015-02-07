//
//  RMRankMovieCell.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMRankMovieCell.h"
#import "CONST.h"

@implementation RMRankMovieCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)playBntClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(playBtnMethodWithOrder:)]){
        [self.delegate playBtnMethodWithOrder:sender.tag];
    }
}

- (void)setTitleLableWithString:(NSString *)title{
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0], NSFontAttributeName, nil];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(500, 21)
                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   attributes:attrs
                                      context:nil];
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    if(rect.size.width>(screenWidth-120-32)){
        self.titleLable.frame = CGRectMake(self.titleLable.frame.origin.x, self.titleLable.frame.origin.y, screenWidth-120-32, self.titleLable.frame.size.height);
        self.scoreLable.frame = CGRectMake(self.titleLable.frame.origin.x+screenWidth-120-32, 23, self.scoreLable.frame.size.width, self.scoreLable.frame.size.height);
    }else{
        self.titleLable.frame = CGRectMake(self.titleLable.frame.origin.x, self.titleLable.frame.origin.y, rect.size.width+2, 21);
        self.scoreLable.frame = CGRectMake(self.titleLable.frame.origin.x+rect.size.width+10, 23, self.scoreLable.frame.size.width, self.scoreLable.frame.size.height);
    }
    self.titleLable.text = title;
}

- (void)setTextViewColor {
    self.detailTextView.editable = NO;
    self.detailTextView.font = [UIFont systemFontOfSize:14];
    self.detailTextView.textColor = [UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1];
}

@end
