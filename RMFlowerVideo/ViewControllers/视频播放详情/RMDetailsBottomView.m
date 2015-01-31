//
//  RMDetailsBottomView.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-5.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMDetailsBottomView.h"
#import "CONST.h"

@implementation RMDetailsBottomView

- (void)initDetailsBottomView {
    NSArray * imageNames;
    if (IS_IPHONE_6_SCREEN){
       imageNames = [NSArray arrayWithObjects:@"details_backup_6", @"details_download_6", @"details_collection_6", @"details_share_6", nil];
    }else if (IS_IPHONE_6p_SCREEN){
        imageNames = [NSArray arrayWithObjects:@"details_backup_6p", @"details_download_6p", @"details_collection_6p", @"details_share_6p", nil];
    }else{
        imageNames = [NSArray arrayWithObjects:@"details_backup", @"details_download", @"details_collection", @"details_share", nil];
    }
    
    for (int i=0; i<imageNames.count; i++){
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (IS_IPHONE_6_SCREEN | IS_IPHONE_6p_SCREEN){
            button.frame = CGRectMake(0 + i * ScreenWidth/imageNames.count, 0, ScreenWidth/imageNames.count, 49);
        }else{
            button.frame = CGRectMake(0 + i * ScreenWidth/imageNames.count, 0, ScreenWidth/imageNames.count, 40);
        }
        button.tag = i+1;
        NSString * image = [imageNames objectAtIndex:i];
        [button setBackgroundImage:LOADIMAGE(image) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)bottomBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bottomBtnActionMethodWithSender:)]){
        [self.delegate bottomBtnActionMethodWithSender:sender.tag];
    }
}

- (void)switchCollectionState:(BOOL)isCollection {
    UIButton * button = (UIButton *)[self viewWithTag:3];
    NSString * imageName;
    NSString * imageNamed;
    if (IS_IPHONE_6_SCREEN){
        imageName = @"details_collection_6";
        imageNamed = @"details_collectioned_6";
    }else if (IS_IPHONE_6p_SCREEN){
        imageName = @"details_collection_6p";
        imageNamed = @"details_collectioned_6";
    }else{
        imageName = @"details_collection";
        imageNamed = @"details_collectioned";
    }
    if (isCollection){
        [button setBackgroundImage:LOADIMAGE(imageNamed) forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:LOADIMAGE(imageName) forState:UIControlStateNormal];
    }
}

- (void)switchDownLoadState:(BOOL)isdownload {
    UIButton * button = (UIButton *)[self viewWithTag:2];
    NSString * imageName;
    NSString * imageNamed;
    
    if (IS_IPHONE_6_SCREEN){
        imageName = @"details_download_6";
        imageNamed = @"details_downloaded_6";
    }else if (IS_IPHONE_6p_SCREEN){
        imageName = @"details_download_6p";
        imageNamed = @"details_downloaded_6p";
    }else{
        imageName = @"details_download";
        imageNamed = @"details_downloaded";
    }
    
    if (isdownload){
        [button setBackgroundImage:LOADIMAGE(imageName) forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:LOADIMAGE(imageNamed) forState:UIControlStateNormal];
    }
}

@end
                            
