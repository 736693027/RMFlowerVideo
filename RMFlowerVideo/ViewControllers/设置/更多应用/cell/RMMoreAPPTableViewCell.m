//
//  RMMoreAPPTableViewCell.m
//  RMVideo
//
//  Created by 润华联动 on 14-10-22.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMMoreAPPTableViewCell.h"
#import <QuickLook/QuickLook.h>

@implementation RMMoreAPPTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)openBtn:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(cellBtnSelectWithIndex:)]){
        [self.delegate cellBtnSelectWithIndex:sender.tag];
    }
}
@end
