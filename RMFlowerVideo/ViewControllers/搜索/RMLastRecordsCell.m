//
//  RMLastRecordsCell.m
//  RMVideo
//
//  Created by runmobile on 14-12-15.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMLastRecordsCell.h"

@implementation RMLastRecordsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)lastClickMethod:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(moreRecordsMethod)]) {
        [self.delegate moreRecordsMethod];
    }
}
@end
