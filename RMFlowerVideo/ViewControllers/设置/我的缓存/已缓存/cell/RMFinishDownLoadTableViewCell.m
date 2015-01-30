//
//  RMFinishDownLoadTableViewCell.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-6.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMFinishDownLoadTableViewCell.h"

@implementation RMFinishDownLoadTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginAnimation) name:@"FinishdownLoadCellBeginAimation" object:nil];
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(endAnimation) name:@"FinishdownLoadCellEndAimation" object:nil];
}

- (void)setCellViewFrame{
    self.headImage.frame = CGRectMake(self.headImage.frame.origin.x+30, self.headImage.frame.origin.y, self.headImage.frame.size.width, self.headImage.frame.size.height);
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x+30, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width-30, self.titleLabel.frame.size.height);
    self.starringTitle.frame = CGRectMake(self.starringTitle.frame.origin.x+30, self.starringTitle.frame.origin.y, self.starringTitle.frame.size.width, self.starringTitle.frame.size.height);
    self.starringLable.frame = CGRectMake(self.starringLable.frame.origin.x+30, self.starringLable.frame.origin.y, self.starringLable.frame.size.width-30, self.starringLable.frame.size.height);
    self.directorTitle.frame = CGRectMake(self.directorTitle.frame.origin.x+30, self.directorTitle.frame.origin.y, self.directorTitle.frame.size.width, self.directorTitle.frame.size.height);
    self.directorLable.frame = CGRectMake(self.directorLable.frame.origin.x+30, self.directorLable.frame.origin.y, self.directorLable.frame.size.width-30, self.directorLable.frame.size.height);
    self.playCount.frame = CGRectMake(self.playCount.frame.origin.x+30, self.playCount.frame.origin.y, self.playCount.frame.size.width-30, self.playCount.frame.size.height);
    self.playCountTitle.frame = CGRectMake(self.playCountTitle.frame.origin.x+30, self.playCountTitle.frame.origin.y, self.playCountTitle.frame.size.width, self.playCountTitle.frame.size.height);
    self.editingImage.frame = CGRectMake(self.editingImage.frame.origin.x+30, self.editingImage.frame.origin.y, self.editingImage.frame.size.width, self.editingImage.frame.size.height);
    
}
- (void)beginAnimation{
    [UIView animateWithDuration:.3f animations:^{
        //动画飘出来
        self.headImage.frame = CGRectMake(self.headImage.frame.origin.x+30, self.headImage.frame.origin.y, self.headImage.frame.size.width, self.headImage.frame.size.height);
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x+30, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width-30, self.titleLabel.frame.size.height);
        self.starringTitle.frame = CGRectMake(self.starringTitle.frame.origin.x+30, self.starringTitle.frame.origin.y, self.starringTitle.frame.size.width, self.starringTitle.frame.size.height);
        self.starringLable.frame = CGRectMake(self.starringLable.frame.origin.x+30, self.starringLable.frame.origin.y, self.starringLable.frame.size.width-30, self.starringLable.frame.size.height);
        self.directorTitle.frame = CGRectMake(self.directorTitle.frame.origin.x+30, self.directorTitle.frame.origin.y, self.directorTitle.frame.size.width, self.directorTitle.frame.size.height);
        self.directorLable.frame = CGRectMake(self.directorLable.frame.origin.x+30, self.directorLable.frame.origin.y, self.directorLable.frame.size.width-30, self.directorLable.frame.size.height);
        self.playCount.frame = CGRectMake(self.playCount.frame.origin.x+30, self.playCount.frame.origin.y, self.playCount.frame.size.width-30, self.playCount.frame.size.height);
        self.playCountTitle.frame = CGRectMake(self.playCountTitle.frame.origin.x+30, self.playCountTitle.frame.origin.y, self.playCountTitle.frame.size.width, self.playCountTitle.frame.size.height);
        self.editingImage.frame = CGRectMake(self.editingImage.frame.origin.x+30, self.editingImage.frame.origin.y, self.editingImage.frame.size.width, self.editingImage.frame.size.height);
    }];
}

- (void)endAnimation{
    [UIView animateWithDuration:.3f animations:^{
        self.headImage.frame = CGRectMake(self.headImage.frame.origin.x-30, self.headImage.frame.origin.y, self.headImage.frame.size.width, self.headImage.frame.size.height);
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x-30, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width+30, self.titleLabel.frame.size.height);
        self.starringTitle.frame = CGRectMake(self.starringTitle.frame.origin.x-30, self.starringTitle.frame.origin.y, self.starringTitle.frame.size.width, self.starringTitle.frame.size.height);
        self.starringLable.frame = CGRectMake(self.starringLable.frame.origin.x-30, self.starringLable.frame.origin.y, self.starringLable.frame.size.width+30, self.starringLable.frame.size.height);
        self.directorTitle.frame = CGRectMake(self.directorTitle.frame.origin.x-30, self.directorTitle.frame.origin.y, self.directorTitle.frame.size.width, self.directorTitle.frame.size.height);
        self.directorLable.frame = CGRectMake(self.directorLable.frame.origin.x-30, self.directorLable.frame.origin.y, self.directorLable.frame.size.width+30, self.directorLable.frame.size.height);
        self.playCount.frame = CGRectMake(self.playCount.frame.origin.x-30, self.playCount.frame.origin.y, self.playCount.frame.size.width-30, self.playCount.frame.size.height);
        self.playCountTitle.frame = CGRectMake(self.playCountTitle.frame.origin.x-30, self.playCountTitle.frame.origin.y, self.playCountTitle.frame.size.width, self.playCountTitle.frame.size.height);
        self.editingImage.frame = CGRectMake(self.editingImage.frame.origin.x-30, self.editingImage.frame.origin.y, self.editingImage.frame.size.width, self.editingImage.frame.size.height);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
