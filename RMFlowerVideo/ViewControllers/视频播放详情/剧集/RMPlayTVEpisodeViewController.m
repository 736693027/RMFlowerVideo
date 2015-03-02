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
    NSInteger vCount;
    NSInteger videoType;        //1为电视剧  2为综艺
}

@end

@implementation RMPlayTVEpisodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
}

- (void)addTVDetailEveryEpisodeViewFromArray:(NSArray *)dataArray andEveryTVViewWidth:(CGFloat)width andEveryRowHaveTVViewCount:(int)count withAdditive:(BOOL)additive {
    
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
    
    for(NSInteger i=0; i<dataArray.count; i++){
        RMTVDownView *downView = [[[NSBundle mainBundle] loadNibNamed:@"RMTVDownView" owner:self options:nil] lastObject];
        downView.frame = CGRectMake((i%count+1)*spacing+i%count*width, (i/count+1)*spacing+i/count*width, width, width);
        downView.TVEpisodeButton.tag = 1001+i;
        downView.tag = 2001+i;
        if(i==0){
            [downView.TVEpisodeButton setBackgroundImage:[UIImage imageNamed:@"episode_bg_select_image"] forState:UIControlStateNormal];
            [downView.TVEpisodeButton setTitleColor:[UIColor colorWithRed:0.9 green:0.26 blue:0.18 alpha:1] forState:UIControlStateNormal];
        }else{
            [downView.TVEpisodeButton setBackgroundImage:[UIImage imageNamed:@"episode_bg_image"] forState:UIControlStateNormal];
            [downView.TVEpisodeButton setTitleColor:[UIColor colorWithRed:0.37 green:0.37 blue:0.37 alpha:1] forState:UIControlStateNormal];
        }
        if (additive){  //电视剧
            [downView.TVEpisodeButton setTitle:[NSString stringWithFormat:@"%ld",i+1] forState:UIControlStateNormal];
        }else{  //综艺
            [downView.TVEpisodeButton setTitle:[NSString stringWithFormat:@"%ld",[dataArray count] - i] forState:UIControlStateNormal];
        }
        [downView.TVEpisodeButton addTarget:self action:@selector(TVEpisodeButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentScrollView addSubview:downView];
    }
}

- (void)TVEpisodeButtonCLick:(UIButton *)sender{
    if(sender.tag == selectEpisodeNum) {
        return;
    }else{
        for (NSInteger i=0; i<vCount; i++) {
            RMTVDownView * view = (RMTVDownView *)[self.view viewWithTag:2001+i];
            [view.TVEpisodeButton setBackgroundImage:[UIImage imageNamed:@"episode_bg_image"] forState:UIControlStateNormal];
            [view.TVEpisodeButton setTitleColor:[UIColor colorWithRed:0.37 green:0.37 blue:0.37 alpha:1] forState:UIControlStateNormal];
        }
        
        [sender setBackgroundImage:[UIImage imageNamed:@"episode_bg_select_image"] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor colorWithRed:0.86 green:0.15 blue:0.18 alpha:1] forState:UIControlStateNormal];

        selectEpisodeNum = sender.tag;
        if ([self.delegate respondsToSelector:@selector(videoEpisodeWithOrder:)]){
            if (videoType == 1){    //电视剧
                [self.delegate videoEpisodeWithOrder:sender.tag - 1001];
            }else{  //综艺
                [self.delegate videoEpisodeWithOrder:vCount - (sender.tag - 1001)];
            }
        }
    }
}

- (void)reloadDataWithModel:(RMPublicModel *)model withVideoSourceType:(NSString *)type {
    if (model.video_type.integerValue == 2){    //电视剧
        videoType = 1;
        for (NSInteger i=0; i<[model.playurls count]; i++){
            selectEpisodeNum = 1;
            if (type == nil){
                NSMutableArray * dataArr = [NSMutableArray arrayWithArray:[[model.playurls objectAtIndex:0] objectForKey:@"urls"]];
                vCount = [dataArr count];
                [self addTVDetailEveryEpisodeViewFromArray:dataArr andEveryTVViewWidth:40 andEveryRowHaveTVViewCount:6 withAdditive:YES];
                break;
            }
            if ([[[model.playurls objectAtIndex:i] objectForKey:@"source_type"] isEqualToString:type]){
                break;
            }
        }
    }else{  //综艺
        videoType = 2;
        for (NSInteger i=[model.playurls count]-1; i>=0; i--){
            selectEpisodeNum = [model.playurls count];
            if (type == nil){
                NSMutableArray * dataArr = [NSMutableArray arrayWithArray:[[model.playurls objectAtIndex:selectEpisodeNum-1] objectForKey:@"urls"]];
                vCount = [dataArr count];
                [self addTVDetailEveryEpisodeViewFromArray:dataArr andEveryTVViewWidth:40 andEveryRowHaveTVViewCount:6 withAdditive:NO];
                break;
            }
            if ([[[model.playurls objectAtIndex:i] objectForKey:@"source_type"] isEqualToString:type]){
                break;
            }
        }
    }
}

@end
