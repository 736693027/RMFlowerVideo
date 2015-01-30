//
//  RMSpecialEditionCell.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMVideoOrStarCell.h"

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

@end
