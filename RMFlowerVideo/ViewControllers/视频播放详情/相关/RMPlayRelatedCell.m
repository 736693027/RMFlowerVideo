//
//  RMPlayRelatedCell.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-6.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMPlayRelatedCell.h"

@implementation RMPlayRelatedCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.directBroadcast addTarget:self WithSelector:@selector(directBroadcastClick:)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)directBroadcastClick:(RMImageView *)image {
    if ([self.delegate respondsToSelector:@selector(directBroadcastMethodWithImage:)]){
        [self.delegate directBroadcastMethodWithImage:image];
    }
}

- (void)setTitleLableWithString:(NSString *)title {
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0], NSFontAttributeName, nil];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(200, 21)
                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   attributes:attrs
                                      context:nil];
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    if(rect.size.width>(screenWidth-120-32)){
        self.videoName.frame = CGRectMake(self.videoName.frame.origin.x, self.videoName.frame.origin.y, screenWidth-120-32, self.videoName.frame.size.height);
        self.videoScore.frame = CGRectMake(self.videoName.frame.origin.x+screenWidth-120-32, 15, self.videoScore.frame.size.width, self.videoScore.frame.size.height);
    }else{
        self.videoName.frame = CGRectMake(self.videoName.frame.origin.x, self.videoName.frame.origin.y, rect.size.width, 21);
        self.videoScore.frame = CGRectMake(self.videoName.frame.origin.x+rect.size.width+10, 15, self.videoScore.frame.size.width, self.videoScore.frame.size.height);
    }
    self.videoName.text = title;
}

@end
