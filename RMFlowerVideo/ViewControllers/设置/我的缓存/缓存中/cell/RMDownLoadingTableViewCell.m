//
//  RMDownLoadingTableViewCell.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-6.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMDownLoadingTableViewCell.h"

@implementation RMDownLoadingTableViewCell

- (void)awakeFromNib {
    self.progressView.color = [UIColor cyanColor];
    self.progressView.showText = @NO;
    self.progressView.borderRadius = @5;
    self.progressView.animate = @NO;
    self.progressView.type = LDProgressSolid;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginAnimation) name:@"downLoadingCellBeginAimation" object:nil];
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(endAnimation) name:@"downLoadingCellEndAimation" object:nil];
}

- (void)setCellViewFrame{
    self.headImage.frame = CGRectMake(self.headImage.frame.origin.x+30, self.headImage.frame.origin.y, self.headImage.frame.size.width, self.headImage.frame.size.height);
    self.titleLable.frame = CGRectMake(self.titleLable.frame.origin.x+30, self.titleLable.frame.origin.y, self.titleLable.frame.size.width, self.titleLable.frame.size.height);
    self.progressView.frame = CGRectMake(self.progressView.frame.origin.x+30, self.progressView.frame.origin.y, self.progressView.frame.size.width-30, self.progressView.frame.size.height);
    self.progressLable.frame = CGRectMake(self.progressLable.frame.origin.x+30, self.progressLable.frame.origin.y, self.progressLable.frame.size.width, self.progressLable.frame.size.height);
    self.editingImage.frame = CGRectMake(self.editingImage.frame.origin.x+30, self.editingImage.frame.origin.y, self.editingImage.frame.size.width, self.editingImage.frame.size.height);
}
- (void)beginAnimation{
    [UIView animateWithDuration:.3f animations:^{
        //动画飘出来
        self.headImage.frame = CGRectMake(self.headImage.frame.origin.x+30, self.headImage.frame.origin.y, self.headImage.frame.size.width, self.headImage.frame.size.height);
        self.titleLable.frame = CGRectMake(self.titleLable.frame.origin.x+30, self.titleLable.frame.origin.y, self.titleLable.frame.size.width, self.titleLable.frame.size.height);
        self.progressView.frame = CGRectMake(self.progressView.frame.origin.x+30, self.progressView.frame.origin.y, self.progressView.frame.size.width-30, self.progressView.frame.size.height);
        self.progressLable.frame = CGRectMake(self.progressLable.frame.origin.x+30, self.progressLable.frame.origin.y, self.progressLable.frame.size.width, self.progressLable.frame.size.height);
        self.editingImage.frame = CGRectMake(self.editingImage.frame.origin.x+30, self.editingImage.frame.origin.y, self.editingImage.frame.size.width, self.editingImage.frame.size.height);
        
    }];
}

- (void)endAnimation{
    [UIView animateWithDuration:.3f animations:^{
        self.headImage.frame = CGRectMake(self.headImage.frame.origin.x-30, self.headImage.frame.origin.y, self.headImage.frame.size.width, self.headImage.frame.size.height);
        self.titleLable.frame = CGRectMake(self.titleLable.frame.origin.x-30, self.titleLable.frame.origin.y, self.titleLable.frame.size.width, self.titleLable.frame.size.height);
        self.progressView.frame = CGRectMake(self.progressView.frame.origin.x-30, self.progressView.frame.origin.y, self.progressView.frame.size.width+30, self.progressView.frame.size.height);
        self.progressLable.frame = CGRectMake(self.progressLable.frame.origin.x-30, self.progressLable.frame.origin.y, self.progressLable.frame.size.width, self.progressLable.frame.size.height);
        self.editingImage.frame = CGRectMake(self.editingImage.frame.origin.x-30, self.editingImage.frame.origin.y, self.editingImage.frame.size.width, self.editingImage.frame.size.height);
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
