//
//  RMHomeTableViewCell.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMHomeTableViewCell.h"
#import "CONST.h"

@implementation RMHomeTableViewCell

- (void)awakeFromNib {
    [self.fristHeadImage addTarget:self WithSelector:@selector(cellImageClick:)];
    [self.secondHeadImage addTarget:self WithSelector:@selector(cellImageClick:)];
    [self.thridHeadImage addTarget:self WithSelector:@selector(cellImageClick:)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellImageClick:(RMImageView *)image {
    if([self.delegate respondsToSelector:@selector(homeTableViewCellDidSelectWithImage:)]){
        [self.delegate homeTableViewCellDidSelectWithImage:image];
    }
}

- (IBAction)playBntClick:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(playBtnWithVideo_id:)]){
        [self.delegate playBtnWithVideo_id:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    }
}

- (void) setFristScoreWithTitle:(NSString *)title{
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:FONT(12), NSFontAttributeName, nil];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(500, 17)
                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                  attributes:attrs
                                     context:nil];
    if(rect.size.width<self.fristHeadImage.frame.size.width){
        self.fristScore.frame = CGRectMake((self.fristHeadImage.frame.size.width+self.fristHeadImage.frame.origin.x)-rect.size.width-2, self.fristScore.frame.origin.y, rect.size.width+2, self.fristScore.frame.size.height);
    }else{
        self.fristScore.frame = CGRectMake(self.fristHeadImage.frame.origin.x, self.fristScore.frame.origin.y, self.fristHeadImage.frame.size.width, self.fristScore.frame.size.height);
    }
    if([title isEqualToString:@"暂无评分"]){
        self.fristScore.font = [UIFont systemFontOfSize:11];
    }else{
         self.fristScore.font = [UIFont systemFontOfSize:12];
    }
    self.fristScore.text = title;
}

- (void) setSecondScoreWithTitle:(NSString *)title{
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:FONT(12), NSFontAttributeName, nil];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(500, 17)
                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   attributes:attrs
                                      context:nil];
    if(rect.size.width<self.secondHeadImage.frame.size.width){
        self.secondScore.frame = CGRectMake((self.secondHeadImage.frame.size.width+self.secondHeadImage.frame.origin.x)-rect.size.width-2, self.secondScore.frame.origin.y, rect.size.width+2, self.secondScore.frame.size.height);
    }else{
        self.secondScore.frame = CGRectMake(self.secondHeadImage.frame.origin.x, self.secondScore.frame.origin.y, self.secondHeadImage.frame.size.width, self.secondScore.frame.size.height);
    }
    if([title isEqualToString:@"暂无评分"]){
        self.secondScore.font = [UIFont systemFontOfSize:11];
    }else{
        self.secondScore.font = [UIFont systemFontOfSize:12];
    }
    self.secondScore.text = title;
}

- (void)setThirdScoreWithTitle:(NSString *)title{
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:FONT(12), NSFontAttributeName, nil];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(500, 17)
                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   attributes:attrs
                                      context:nil];
    if(rect.size.width<self.thridHeadImage.frame.size.width){
        self.thridScore.frame = CGRectMake((self.thridHeadImage.frame.size.width+self.thridHeadImage.frame.origin.x)-rect.size.width-2, self.thridScore.frame.origin.y, rect.size.width+2, self.thridScore.frame.size.height);
    }else{
        self.thridScore.frame = CGRectMake(self.thridHeadImage.frame.origin.x, self.thridScore.frame.origin.y, self.thridHeadImage.frame.size.width, self.thridScore.frame.size.height);
    }
    if([title isEqualToString:@"暂无评分"]){
        self.thridScore.font = [UIFont systemFontOfSize:11];
    }else{
        self.thridScore.font = [UIFont systemFontOfSize:12];
    }
    self.thridScore.text = title;
}

@end
