//
//  RMSpecialEditionCell.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMVideoOrStarCell.h"
#import "CONST.h"

@implementation RMVideoOrStarCell

- (void)awakeFromNib {
    // Initialization code
    [self.firstImage addTarget:self WithSelector:@selector(myChannelCellImage:)];
    [self.secondImage addTarget:self WithSelector:@selector(myChannelCellImage:)];
    [self.thirdImage addTarget:self WithSelector:@selector(myChannelCellImage:)];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)myChannelCellBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(videoOrStarCellMethodWithVideo_id:)]){
        [self.delegate videoOrStarCellMethodWithVideo_id:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    }
}

- (void)myChannelCellImage:(RMImageView *)image {
    if ([self.delegate respondsToSelector:@selector(videoOrStarCellMethodWithImage:)]){
        [self.delegate videoOrStarCellMethodWithImage:image];
    }
}

- (void) setFristScoreWithTitle:(NSString *)title{
    if([title isEqualToString:@"暂无评分"]||[title isEqualToString:@"0"]||[title isEqualToString:@"0.0"]){
        title = @"暂无评分";
    }
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:FONT(12), NSFontAttributeName, nil];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(500, 17)
                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   attributes:attrs
                                      context:nil];
    if(rect.size.width<self.firstImage.frame.size.width){
        self.firstScore.frame = CGRectMake((self.firstImage.frame.size.width+self.firstImage.frame.origin.x)-rect.size.width-2, self.firstScore.frame.origin.y, rect.size.width+2, self.firstScore.frame.size.height);
    }else{
        self.firstScore.frame = CGRectMake(self.firstImage.frame.origin.x, self.firstScore.frame.origin.y, self.firstImage.frame.size.width, self.firstScore.frame.size.height);
    }
    if([title isEqualToString:@"暂无评分"]){
        self.firstScore.font = [UIFont systemFontOfSize:11];
    }else{
        self.firstScore.font = [UIFont systemFontOfSize:12];
    }
    self.firstScore.text = title;
}

- (void) setSecondScoreWithTitle:(NSString *)title{
    if([title isEqualToString:@"暂无评分"]||[title isEqualToString:@"0"]||[title isEqualToString:@"0.0"]){
        title = @"暂无评分";
    }
        
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:FONT(12), NSFontAttributeName, nil];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(500, 17)
                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   attributes:attrs
                                      context:nil];
    if(rect.size.width<self.secondImage.frame.size.width){
        self.secondScore.frame = CGRectMake((self.secondImage.frame.size.width+self.secondImage.frame.origin.x)-rect.size.width-2, self.secondScore.frame.origin.y, rect.size.width+2, self.secondScore.frame.size.height);
    }else{
        self.secondScore.frame = CGRectMake(self.secondImage.frame.origin.x, self.secondScore.frame.origin.y, self.secondImage.frame.size.width, self.secondScore.frame.size.height);
    }
    if([title isEqualToString:@"暂无评分"]){
        self.secondScore.font = [UIFont systemFontOfSize:11];
    }else{
        self.secondScore.font = [UIFont systemFontOfSize:12];
    }
    self.secondScore.text = title;
}

- (void)setThirdScoreWithTitle:(NSString *)title{
    if([title isEqualToString:@"暂无评分"]||[title isEqualToString:@"0"]||[title isEqualToString:@"0.0"]){
        title = @"暂无评分";
    }
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:FONT(12), NSFontAttributeName, nil];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(500, 17)
                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   attributes:attrs
                                      context:nil];
    if(rect.size.width<self.thirdImage.frame.size.width){
        self.thirdScore.frame = CGRectMake((self.thirdImage.frame.size.width+self.thirdImage.frame.origin.x)-rect.size.width-2, self.thirdScore.frame.origin.y, rect.size.width+2, self.thirdScore.frame.size.height);
    }else{
        self.thirdScore.frame = CGRectMake(self.thirdImage.frame.origin.x, self.thirdScore.frame.origin.y, self.thirdImage.frame.size.width, self.thirdScore.frame.size.height);
    }
    if([title isEqualToString:@"暂无评分"]){
        self.thirdScore.font = [UIFont systemFontOfSize:11];
        self.thirdScore.text = @"暂无评分";
    }else{
        self.thirdScore.font = [UIFont systemFontOfSize:12];
        self.thirdScore.text = title;
    }
    
}

@end
