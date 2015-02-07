 //
//  RMPlayTVEpisodeViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15/1/15.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMPlayTVEpisodeViewController.h"
#import "RMTVDownView.h"

@interface RMPlayTVEpisodeViewController (){
    NSInteger selectEpisodeNum;
}

@end

@implementation RMPlayTVEpisodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
}

- (void)addTVDetailEveryEpisodeViewFromArray:(NSArray *)dataArray andEveryTVViewWidth:(CGFloat)width andEveryRowHaveTVViewCount:(int)count{
    
    float column = 0;
    if(dataArray.count%count==0){
        column = dataArray.count/count;
    }else{
        column = dataArray.count/count+1;
    }
    float spacing = (ScreenWidth-count*width)/(count+1);
    
    float value;
    if (IS_IPHONE_6p_SCREEN | IS_IPHONE_6_SCREEN){
        value = self.view.frame.size.height - 261 - 49;
    }else{
        value = self.view.frame.size.height - 261 - 40;
    }
    
    if ((column*width+(column+1)*spacing) > value) {
        self.contentScrollView.contentSize = CGSizeMake(ScreenWidth, (column*width+(column+1)*spacing));
    }
    for(int i=0;i<dataArray.count;i++){
        RMTVDownView *downView = [[[NSBundle mainBundle] loadNibNamed:@"RMTVDownView" owner:self options:nil] lastObject];
        downView.frame = CGRectMake((i%count+1)*spacing+i%count*width, (i/count+1)*spacing+i/count*width, width, width);
        downView.TVEpisodeButton.tag = i+1;
        downView.tag = i+1000;
        if(i==0){
            [downView.TVEpisodeButton setBackgroundImage:[UIImage imageNamed:@"episode_bg_select_image"] forState:UIControlStateNormal];
            [downView.TVEpisodeButton setTitleColor:[UIColor colorWithRed:0.86 green:0.15 blue:0.18 alpha:1] forState:UIControlStateNormal];
        }
        [downView.TVEpisodeButton setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [downView.TVEpisodeButton addTarget:self action:@selector(TVEpisodeButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentScrollView addSubview:downView];
    }
}

- (void)TVEpisodeButtonCLick:(UIButton *)sender{
    if(sender.tag == selectEpisodeNum) {
        return;
    }else{
        RMTVDownView *beforeTvView = (RMTVDownView *)[self.contentScrollView viewWithTag:selectEpisodeNum-1+1000];
        [beforeTvView.TVEpisodeButton setBackgroundImage:[UIImage imageNamed:@"episode_bg_image"] forState:UIControlStateNormal];
        [beforeTvView.TVEpisodeButton setTitleColor:[UIColor colorWithRed:0.37 green:0.37 blue:0.37 alpha:1] forState:UIControlStateNormal];
        
        RMTVDownView *selectTvView = (RMTVDownView *)[self.contentScrollView viewWithTag:sender.tag-1+1000];
        [selectTvView.TVEpisodeButton setBackgroundImage:[UIImage imageNamed:@"episode_bg_select_image"] forState:UIControlStateNormal];
        [selectTvView.TVEpisodeButton setTitleColor:[UIColor colorWithRed:0.86 green:0.15 blue:0.18 alpha:1] forState:UIControlStateNormal];
        
        selectEpisodeNum = sender.tag;
        
        if ([self.delegate respondsToSelector:@selector(videoEpisodeWithOrder:)]){
            [self.delegate videoEpisodeWithOrder:sender.tag];
        }
    }
}

- (void)reloadDataWithModel:(RMPublicModel *)model withVideoSourceType:(NSString *)type {
    for (NSInteger i=0; i<[model.playurls count]; i++){
        selectEpisodeNum = 1;
        if (type == nil){
            NSMutableArray * dataArr = [NSMutableArray arrayWithArray:[[model.playurls objectAtIndex:0] objectForKey:@"urls"]];
            [self addTVDetailEveryEpisodeViewFromArray:dataArr andEveryTVViewWidth:40 andEveryRowHaveTVViewCount:6];
            break;
        }
        
        if ([[[model.playurls objectAtIndex:i] objectForKey:@"source_type"] isEqualToString:type]){
            break;
        }
    }
}

@end
