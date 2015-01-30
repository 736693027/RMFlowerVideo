//
//  RMHomeStartCell.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMHomeStartCell.h"

@implementation RMHomeStartCell

- (void)awakeFromNib {
    // Initialization code
    [self.fristHeadImage addTarget:self WithSelector:@selector(cellImageClick:)];
    [self.secondHeadImage addTarget:self WithSelector:@selector(cellImageClick:)];
    [self.thirdHeadImage addTarget:self WithSelector:@selector(cellImageClick:)];
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

@end
