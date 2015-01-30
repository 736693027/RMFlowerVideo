//
//  RMSearchRecordsCell.m
//  RMVideo
//
//  Created by runmobile on 14-11-3.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMSearchRecordsCell.h"

@implementation RMSearchRecordsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonRecordsClickMethod:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteSearchRecordsMethod:)]) {
        [self.delegate deleteSearchRecordsMethod:sender.tag];
    }
}
@end
