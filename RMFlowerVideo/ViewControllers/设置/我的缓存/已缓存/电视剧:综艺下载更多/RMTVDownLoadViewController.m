//
//  RMTVDownLoadViewController.m
//  RMVideo
//
//  Created by 润华联动 on 14-10-15.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMTVDownLoadViewController.h"
#import "RMTVDownView.h"
#import "RMDownLoadingViewController.h"
#import "RMMyCacheViewController.h"

@interface RMTVDownLoadViewController ()<RMAFNRequestManagerDelegate>{
    RMAFNRequestManager *requestManager;
    NSInteger downLoadingCount;
}

@end

@implementation RMTVDownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     //传值的时候，self.title必须是电视剧名称。
     //self.dataArray 里面装的是RMPublicModel 其中publicModel.name 和下载是的名称要一致，即**第*集   model.downLoadURL为下载地址
     //tv_downLoading  缓存中的
     //tv_have_cashe   已缓存的
     */
    self.TVdataArray = [[NSMutableArray alloc] init];
    [self setCustomNavTitle:@"缓存剧集"];
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    rightBarButton.hidden = YES;
    
    RMDownLoadingViewController *downLoad = [RMDownLoadingViewController shared];
    downLoadingCount = 0;
    for(RMPublicModel *model in downLoad.dataArray){
        if([model.name rangeOfString:self.videoName].location != NSNotFound){
            downLoadingCount++;
        }
    }
    //显示正在下载的数量
    [self.showDownLoadTVCountBtn setTitle:[NSString stringWithFormat:@"%ld",(long)downLoadingCount] forState:UIControlStateNormal];
    
    requestManager = [[RMAFNRequestManager alloc] init];
    requestManager.delegate = self;
    [requestManager getDownloadUrlWithVideo_id:self.video_id];

}

//添加集数的按钮
- (void)addShowAllEpisodeNumberBtnWidth:(CGFloat)width{
//    [Flurry logEvent:@"Click_VideoDownloadViewAddEpisode_Btn"];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    NSString *titelStr = [NSString stringWithFormat:@"1-%d集",(int)self.TVdataArray.count];
    [button setTitle:titelStr forState:UIControlStateNormal];
    button.frame = CGRectMake(12, (self.headScrollView.frame.size.height-30)/2, width, 30);
    [self.contentScrollView addSubview:button];
    
}

- (void)addTVDetailEveryEpisodeViewFromArray:(NSArray *)dataArray andEveryTVViewWidth:(CGFloat)width andEveryRowHaveTVViewCount:(int)count{
    
    float column = 0;
    if(dataArray.count%count==0)
        column = dataArray.count/count;
    else
        column = dataArray.count/count+1;
    float spacing = (ScreenWidth-count*width)/(count+1);
    
    if ((column*width+(column+1)*spacing)>self.contentScrollView.frame.size.height) {
        self.contentScrollView.contentSize = CGSizeMake(ScreenWidth, (column*width+(column+1)*spacing));
    }
    RMDownLoadingViewController *downLoad = [RMDownLoadingViewController shared];
    for(int i=0;i<dataArray.count;i++){
        RMTVDownView *downView = [[[NSBundle mainBundle] loadNibNamed:@"RMTVDownView" owner:self options:nil] lastObject];
        downView.frame = CGRectMake((i%count+1)*spacing+i%count*width, (i/count+1)*spacing+i/count*width+42, width, width);
        downView.TVEpisodeButton.tag = i+1;
        downView.tag = i+1000;
        [downView.TVEpisodeButton setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        RMPublicModel *model = [self.TVdataArray objectAtIndex:i];
        NSString *tvString = [NSString stringWithFormat:@"电视剧_%@_%@",self.videoName,model.order];
        
        //判断改电视剧是否已经下载成功
        if([[Database sharedDatabase] isDownLoadMovieWithModelName:tvString]){
            downView.TVStateImageView.image = [UIImage imageNamed:@"tv_have_cashe"];
        }
        else if([self isContainsModel:downLoad.dataArray modelName:tvString]){
            downView.TVStateImageView.image = [UIImage imageNamed:@"tv_downLoading"];
        }
        [downView.TVEpisodeButton addTarget:self action:@selector(TVEpisodeButtonCLick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentScrollView addSubview:downView];
    }
}

//点击下载某一个集
- (void)TVEpisodeButtonCLick:(UIButton*)sender{
    
    RMPublicModel *model = [self.TVdataArray objectAtIndex:sender.tag-1];
    RMDownLoadingViewController *rmDownLoading = [RMDownLoadingViewController shared];
    NSString *tvString = [NSString stringWithFormat:@"电视剧_%@_%@",self.videoName,model.order];

    //判断改电视剧是否已经下载成功
    if([[Database sharedDatabase] isDownLoadMovieWithModelName:tvString]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"已经下载成功了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    else if([self isContainsModel:rmDownLoading.dataArray modelName:tvString]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"已在下载队列中" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if (model.m_down_url==nil||![[model.m_down_url pathExtension] isEqualToString:@"mp4"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"该剧集暂时不能下载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    RMTVDownView *downView = (RMTVDownView *)[self.contentScrollView viewWithTag:sender.tag-1+1000];
    downView.TVStateImageView.image = [UIImage imageNamed:@"tv_downLoading"];
    model.downLoadURL = model.m_down_url;
    model.name = [NSString stringWithFormat:@"电视剧_%@_%@",self.videoName,model.order];
    model.downLoadState = @"等待缓存";
    model.actors = self.actors;
    model.directors = self.director;
    model.hits = self.PlayCount;
    model.totalMemory = @"0M";
    model.alreadyCasheMemory = @"0M";
    model.cacheProgress = @"0.0";
    model.pic = self.videoHeadImage;
    model.video_id = self.video_id;
    model.isTVModel = YES;
    [rmDownLoading.dataArray addObject:model];
    [rmDownLoading.downLoadIDArray addObject:model];
    [rmDownLoading BeginDownLoad];
    downLoadingCount++;
    [self.showDownLoadTVCountBtn setTitle:[NSString stringWithFormat:@"%ld",(long)downLoadingCount] forState:UIControlStateNormal];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showDownLoadDetailClick:(UIButton *)sender {
    RMMyCacheViewController *casheViewContro = [[RMMyCacheViewController alloc] init];
    casheViewContro.selectIndex = 1;
    [self.navigationController pushViewController:casheViewContro animated:YES];
}
//下载所有的电视剧
- (IBAction)downAllTVEpisode:(UIButton *)sender {
    //    [Flurry logEvent:@"Click_VideoDownloadViewAllEpisode_Btn"];
    
    RMDownLoadingViewController *rmDownLoading = [RMDownLoadingViewController shared];
    for (int i=0;i<self.TVdataArray.count;i++){
        RMPublicModel *model = [self.TVdataArray objectAtIndex:i];
        NSString *tvString = [NSString stringWithFormat:@"电视剧_%@_%@",self.videoName,model.order];
        if([[Database sharedDatabase] isDownLoadMovieWithModelName:tvString]){
            continue;
        }
        else if( [self isContainsModel:rmDownLoading.dataArray modelName:tvString]){
            continue;
        }
        else if (model.m_down_url==nil||![[model.m_down_url pathExtension] isEqualToString:@"mp4"]){
            continue;
        }
        else{
            RMTVDownView *downView = (RMTVDownView *)[self.contentScrollView viewWithTag:i+1000];
            downView.TVStateImageView.image = [UIImage imageNamed:@"tv_downLoading"];
            model.downLoadURL = model.m_down_url;
            model.name = [NSString stringWithFormat:@"电视剧_%@_%@",self.videoName,model.order];
            model.downLoadState = @"等待缓存";
            model.actors = self.actors;
            model.directors = self.director;
            model.hits = self.PlayCount;
            model.totalMemory = @"0M";
            model.alreadyCasheMemory = @"0M";
            model.cacheProgress = @"0.0";
            model.pic = self.videoHeadImage;
            model.video_id = self.video_id;
            model.isTVModel = YES;
            [rmDownLoading.dataArray addObject:model];
            [rmDownLoading.downLoadIDArray addObject:model];
            downLoadingCount++;
        }
    }
    if(rmDownLoading.downLoadIDArray.count>0)
        [rmDownLoading BeginDownLoad];
    [self.showDownLoadTVCountBtn setTitle:[NSString stringWithFormat:@"%ld",(long)downLoadingCount] forState:UIControlStateNormal];
}

#pragma mark - Base Method

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    if (self.isNavPushViewController){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma request finish
- (void)requestFinishiDownLoadWith:(NSMutableArray *)data{
    if(data.count>0){
        
        self.TVdataArray = data;
        [self addShowAllEpisodeNumberBtnWidth:69];
        [self addTVDetailEveryEpisodeViewFromArray:self.TVdataArray andEveryTVViewWidth:40 andEveryRowHaveTVViewCount:6];
    }
    else{
    }

}
- (void)requestError:(NSError *)error{
    NSLog(@"error:%@",error);
}

- (BOOL)isContainsModel:(NSMutableArray *)dataArray modelName:(NSString *)string{
    for(RMPublicModel *tmpModel in dataArray){
        if([tmpModel.name isEqualToString:string]){
            return YES;
        }
    }
   return NO;
}
@end
