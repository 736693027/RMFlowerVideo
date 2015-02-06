//
//  RMAFNRequestManager.m
//  RMVideo
//
//  Created by 润华联动 on 14-10-29.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMAFNRequestManager.h"
#import "CONST.h"
#import "AFNetworking.h"
#import "AESCrypt.h"
#import "CommonFunc.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

#define CENTER 1
#define TOP 2
#define BOTTOM 3


#define baseUrl         @"http://vodapi.runmobile.cn/version2_00/api.php/vod/"

#define kPassWord       @"yu32uzy4"                 //接口密匙
@interface RMAFNRequestManager (){
    UIImageView * HUDImage;
}

@end

@implementation RMAFNRequestManager

- (AFHTTPRequestOperationManager *)creatAFNNetworkRequestManager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;//超时
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    return manager;
}

- (NSString *)urlPathadress:(NSInteger)tag{
    NSString *strUrl;
    switch (tag) {
        case Http_getSlideList:{
            strUrl = [NSString stringWithFormat:@"%@getSlideList?",baseUrl];
            break;
        }
        case Http_getIndexVideoList:{
            strUrl = [NSString stringWithFormat:@"%@getIndexVideoList?",baseUrl];
            break;
        }
        case Http_getStarList:{
             strUrl = [NSString stringWithFormat:@"%@getStarList?",baseUrl];
            break;
        }case Http_getTopList:{
            strUrl = [NSString stringWithFormat:@"%@getTopList?",baseUrl];
            break;
        }case Http_search:{
            strUrl = [NSString stringWithFormat:@"%@search?",baseUrl];
            break;
        }
        case Http_getSearchTips:{
            strUrl = [NSString stringWithFormat:@"%@getSearchTips?",baseUrl];
            break;
        }
        case Http_getSearchRecommend:{
            strUrl = [NSString stringWithFormat:@"%@getSearchRecommend",baseUrl];
            break;
        }
        case Http_getStarDetail:{
            strUrl = [NSString stringWithFormat:@"%@getStarDetail?",baseUrl];
            break;
        }
        case Http_getVideoDetailById:{
            strUrl = [NSString stringWithFormat:@"%@getVideoDetailById?",baseUrl];
            break;
        }
        case Http_addFavorite:{
            strUrl = [NSString stringWithFormat:@"%@addFavorite?",baseUrl];
            break;
        }
        case Http_getDownloadUrlById:{
            strUrl = [NSString stringWithFormat:@"%@getDownloadUrlById?",baseUrl];
            break;
        }
        case Http_getSpecialTag:{
            strUrl = [NSString stringWithFormat:@"%@getSpecialTag?",baseUrl];
            break;
        }
        case Http_getSpecialTagDetail:{
            strUrl = [NSString stringWithFormat:@"%@getSpecialTagDetail?",baseUrl];
            break;
        }
        case Http_getVideoListByTagId:{
            strUrl = [NSString stringWithFormat:@"%@getVideoListByTagId?",baseUrl];
            break;
        }
        case Http_getVideoNumByTagId:{
            strUrl = [NSString stringWithFormat:@"%@getVideoNumByTagId?",baseUrl];
            break;
        }
        case Http_login:{
            strUrl = [NSString stringWithFormat:@"%@login?",baseUrl];
            break;
        }
        case Http_setInfo:{
            strUrl = [NSString stringWithFormat:@"%@setInfo?",baseUrl];
            break;
        }
        case Http_getFavoriteVideoList:{
            strUrl = [NSString stringWithFormat:@"%@getFavoriteVideoList?",baseUrl];
            break;
        }
        case Http_deleteFavoriteVideo:{
            strUrl = [NSString stringWithFormat:@"%@deleteFavoriteVideo?",baseUrl];
            break;
        }
        case Http_getDeviceHits:{
            strUrl = [NSString stringWithFormat:@"%@getDeviceHits?",baseUrl];
            break;
        }
        case Http_getMoreApp:{
            strUrl = [NSString stringWithFormat:@"%@getMoreApp",baseUrl];
            break;
        }
        case Http_about:{
            strUrl = [NSString stringWithFormat:@"%@about?",baseUrl];
            break;
        }
        case Http_userFeedback:{
            strUrl = [NSString stringWithFormat:@"%@userFeedback?",baseUrl];
            break;
        }
        case Http_loading:{
            strUrl = [NSString stringWithFormat:@"%@loading?",baseUrl];
            break;
        }
        default:{
            strUrl = nil;
        }
            break;
    }
    return strUrl;
}

- (NSString *)setOffsetWith:(NSString *)page andCount:(NSString *)count{
    return [NSString stringWithFormat:@"%d",([page intValue] -1)*[count intValue]];
}

#pragma mark - 接口 加密

- (NSString *)encryptUrl:(NSString *)url {
#if 1
    NSRange range = [url rangeOfString:@"php/vod/"];
    NSString * newUrl = [url substringFromIndex:range.location + 8];
    newUrl = [AESCrypt encrypt:newUrl password:kPassWord];
    /*
     转义
     NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes
     (NULL, (CFStringRef)newUrl, NULL,
     (CFStringRef)@"!*’();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
     */
    newUrl = [NSString stringWithFormat:@"%@decode?data=%@",baseUrl,[CommonFunc base64StringFromText:newUrl]];
    return newUrl;
#else
    return url;
#endif

}

- (void)checkTheNetworkConnectionWithTitle:(NSString *)title {
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:{
            [self showMessage:@"网络连接失败，请检查网络连接" duration:1.0 position:1 withUserInteractionEnabled:NO];
            break;
        }
        default:{
            [self showMessage:title duration:1.0 position:1 withUserInteractionEnabled:NO];
            break;
        }
    }
}

#pragma mark - 首页循坏滚动电影、电视剧、综艺

- (void)getSlideListWithVideo_type:(NSString *)video_type {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    self.downLoadType = Http_getSlideList;
    NSString *url = [self urlPathadress:Http_getSlideList];
    url = [NSString stringWithFormat:@"%@video_type=%@",url,video_type];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if([[responseObject objectForKey:@"code"] intValue] == 4001){
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dict in [responseObject objectForKey:@"data"]){
                RMPublicModel *model = [[RMPublicModel alloc] init];
                model.name = [dict objectForKey:@"name"];
                model.pic = [dict objectForKey:@"pic"];
                model.source_url = [dict objectForKey:@"source_url"];
                model.urls = [dict objectForKey:@"urls"];
                model.video_id = [dict objectForKey:@"video_id"];
                model.videoDescription = [dict objectForKey:@"description"];
                [dataArray addObject:model];
            }
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
                [self.delegate requestFinishiDownLoadWith:dataArray];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"下载失败"];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 首页视频电影、电视剧、综艺

- (void)getIndexVideoListWithVideoTpye:(NSString *)videoType searchPageNumber:(NSString *)page andLimit:(NSString *)limit {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
     self.downLoadType = Http_getIndexVideoList;
    NSString *url = [self urlPathadress:Http_getIndexVideoList];
    url = [NSString stringWithFormat:@"%@video_type=%@&page=%@&limit=%@",url,videoType,page,limit];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if([[responseObject objectForKey:@"code"] intValue] == 4001){
            NSMutableArray *dataArray = [NSMutableArray array];
            for(NSDictionary *dict in [responseObject objectForKey:@"data"]){
                RMPublicModel *model = [[RMPublicModel alloc] init];
                model.name = [dict objectForKey:@"name"];
                model.pic = [dict objectForKey:@"pic"];
                if ([videoType isEqualToString:@"1"]){
                    model.urls = [dict objectForKey:@"urls"];
                }else{
                    model.urls_arr = [dict objectForKey:@"urls"];
                }
                model.status = [dict objectForKey:@"status"];
                model.video_id = [dict objectForKey:@"video_id"];
                [dataArray addObject:model];
            }
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
                [self.delegate requestFinishiDownLoadWith:dataArray];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"下载失败"];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 首页明星

- (void)getStarListWithPage:(NSString *)page andLimit:(NSString *)limit {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_getStarList];
    url = [NSString stringWithFormat:@"%@page=%@&limit=%@",url,page,limit];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *dataArray = [NSMutableArray array];
        for(NSDictionary *dict in [responseObject objectForKey:@"data"]){
            RMPublicModel *model = [[RMPublicModel alloc] init];
            model.name = [dict objectForKey:@"name"];
            model.pic = [dict objectForKey:@"pic"];
            model.tag_id = [dict objectForKey:@"tag_id"];
            [dataArray addObject:model];
        }
        if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
            [self.delegate requestFinishiDownLoadWith:dataArray];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"下载失败"];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 排行榜

- (void)getTopListWithVideo_type:(NSString *)video_type {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_getTopList];
    url = [NSString stringWithFormat:@"%@video_type=%@",url,video_type];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if([[responseObject objectForKey:@"code"] intValue] == 4001){
            NSMutableArray *dataArray = [NSMutableArray array];
            for(NSDictionary *dict in [responseObject objectForKey:@"data"]){
                RMPublicModel *model = [[RMPublicModel alloc] init];
                model.actors = [dict objectForKey:@"actors"];
                model.videoDescription = [dict objectForKey:@"description"];
                model.directors = [dict objectForKey:@"directors"];
                model.gold = [dict objectForKey:@"gold"];
                model.hits = [dict objectForKey:@"hits"];
                model.name = [dict objectForKey:@"name"];
                model.pic = [dict objectForKey:@"pic"];
                model.presenters = [dict objectForKey:@"presenters"];
                model.source_url = [dict objectForKey:@"source_url"];
                if ([video_type isEqualToString:@"1"]){
                    model.urls = [dict objectForKey:@"urls"];
                }else{
                    model.urls_arr = [dict objectForKey:@"urls"];
                }
                model.video_id = [dict objectForKey:@"video_id"];
                model.video_type = [dict objectForKey:@"video_type"];
                model.order = [dict objectForKey:@"order"];
                [dataArray addObject:model];
            }
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
                [self.delegate requestFinishiDownLoadWith:dataArray];
            }
        }
        else{
            [self checkTheNetworkConnectionWithTitle:@"下载失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"下载失败"];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 搜索

- (void)searchWithKeyword:(NSString *)keyword Page:(NSString *)page {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_search];
    url = [NSString stringWithFormat:@"%@keyword=%@&page=%@",url,keyword,page];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 4001){
            RMPublicModel * model = [[RMPublicModel alloc] init];
            model.keyword = [[responseObject objectForKey:@"data"] objectForKey:@"keyword"];
            model.star_list = [[responseObject objectForKey:@"data"] objectForKey:@"star_list"];
            model.tv_list = [[responseObject objectForKey:@"data"] objectForKey:@"tv_list"];
            model.variety_list = [[responseObject objectForKey:@"data"] objectForKey:@"variety_list"];
            model.video_list = [[responseObject objectForKey:@"data"] objectForKey:@"video_list"];
            model.vod_list = [[responseObject objectForKey:@"data"] objectForKey:@"vod_list"];
            if ([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWithModel:)]){
                [self.delegate requestFinishiDownLoadWithModel:model];
            }
        }else{
            [self checkTheNetworkConnectionWithTitle:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"搜索失败"];
        if ([self.delegate respondsToSelector:@selector(requestError:)]) {
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 搜索提示

- (void)getSearchTipsWithWork:(NSString *)word {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_getSearchTips];
    url = [NSString stringWithFormat:@"%@word=%@",url,word];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {        
        if ([[responseObject objectForKey:@"code"] integerValue] == 4001){
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSInteger i=0; i<[[responseObject objectForKey:@"data"] count]; i++) {
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.name = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"name"];
                [dataArray addObject:model];
            }
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
                [self.delegate requestFinishiDownLoadWith:dataArray];
            }
        }else{
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 搜索推荐

- (void)getSearchRecommend {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_getSearchRecommend];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 4001){
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSInteger i=0; i<[[responseObject objectForKey:@"data"] count]; i++){
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.name = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"name"];
                model.source_url = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"source_url"];
                model.type = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"type"];
                model.video_id = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"video_id"];
                [dataArray addObject:model];
            }
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
                [self.delegate requestFinishiDownLoadWith:dataArray];
            }
        }else{
            [self checkTheNetworkConnectionWithTitle:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 明星详情

- (void)getStarDetailWithTag_id:(NSString *)tag_id {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_getStarDetail];
    url = [NSString stringWithFormat:@"%@tag_id=%@",url,tag_id];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 4001){
            RMPublicModel * model = [[RMPublicModel alloc] init];
            model.detail = [[responseObject objectForKey:@"data"]objectForKey:@"detail"];
            model.name = [[responseObject objectForKey:@"data"] objectForKey:@"name"];
            model.pic = [[responseObject objectForKey:@"data"] objectForKey:@"pic"];
            model.tag_id = [[responseObject objectForKey:@"data"] objectForKey:@"tag_id"];
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWithModel:)]){
                [self.delegate requestFinishiDownLoadWithModel:model];
            }
        }else{
            [self checkTheNetworkConnectionWithTitle:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"获取明星详情失败"];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 视频详情

- (void)getVideoDetailWithVideo_id:(NSString *)video_id Token:(NSString *)token {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_getVideoDetailById];
    url = [NSString stringWithFormat:@"%@video_id=%@&token=%@",url,video_id,token];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 4001){
            RMPublicModel * model = [[RMPublicModel alloc] init];
            model.content = [[responseObject objectForKey:@"data"] objectForKey:@"content"];
            model.creator = [[responseObject objectForKey:@"data"] objectForKey:@"creator"];
            model.gold = [[responseObject objectForKey:@"data"] objectForKey:@"gold"];
            model.is_download = [[responseObject objectForKey:@"data"] objectForKey:@"is_download"];
            model.is_favorite = [[responseObject objectForKey:@"data"] objectForKey:@"is_favorite"];
            model.name = [[responseObject objectForKey:@"data"] objectForKey:@"name"];
            model.pic = [[responseObject objectForKey:@"data"] objectForKey:@"pic"];
            model.playurl = [[responseObject objectForKey:@"data"] objectForKey:@"playurl"];
            model.playurls = [[responseObject objectForKey:@"data"] objectForKey:@"playurls"];
            model.relevant = [[responseObject objectForKey:@"data"] objectForKey:@"relevant"];
            model.video_id = [[responseObject objectForKey:@"data"] objectForKey:@"video_id"];
            model.video_type = [[responseObject objectForKey:@"data"] objectForKey:@"video_type"];
            model.actor = [[responseObject objectForKey:@"data"] objectForKey:@"actor"];
            model.director = [[responseObject objectForKey:@"data"] objectForKey:@"director"];
            model.presenters = [[responseObject objectForKey:@"data"] objectForKey:@"presenters"];
            model.hits = [[responseObject objectForKey:@"data"] objectForKey:@"hits"];
            if ([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWithModel:)]) {
                [self.delegate requestFinishiDownLoadWithModel:model];
            }
        }else{
            [self checkTheNetworkConnectionWithTitle:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"获取视频资源失败"];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 添加收藏

- (void)addFavoriteWithVideo_id:(NSString *)video_id andToken:(NSString *)token {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_addFavorite];
    url = [NSString stringWithFormat:@"%@token=%@&video_id=%@",url,token,video_id];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"code"] intValue]==4001){
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWithResults:)]){
                [self.delegate requestFinishiDownLoadWithResults:@"success"];
            }
        }else{
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWithResults:)]){
                [self.delegate requestFinishiDownLoadWithResults:@"failure"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 分集下载

- (void)getDownloadUrlWithVideo_id:(NSString *)video_id {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_getDownloadUrlById];
    url = [NSString stringWithFormat:@"%@video_id=%@",url,video_id];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"code"] intValue]==4001){
            NSMutableArray *dataArray = [NSMutableArray array];
            for(NSDictionary *dict in [responseObject objectForKey:@"data"]){
                RMPublicModel *model = [[RMPublicModel alloc] init];
                model.m_down_url = [dict objectForKey:@"m_down_url"];
                model.order = [dict objectForKey:@"order"];
                [dataArray addObject:model];
            }
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
                [self.delegate requestFinishiDownLoadWith:dataArray];
            }
        }
        else{
            [self checkTheNetworkConnectionWithTitle:@"下载失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"下载失败"];
        if ([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 特辑

- (void)getSpecialTagWithPage:(NSString *)page {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_getSpecialTag];
    url = [NSString stringWithFormat:@"%@page=%@",url,page];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 4001){
            NSMutableArray * dataArray = [NSMutableArray array];
            for (NSInteger i=0; i<[[responseObject objectForKey:@"data"] count]; i++){
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.name = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"name"];
                model.pic = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"pic"];
                model.tag_id = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"tag_id"];
                [dataArray addObject:model];
            }
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
                [self.delegate requestFinishiDownLoadWith:dataArray];
            }
        }else{
            [self checkTheNetworkConnectionWithTitle:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"获取特辑失败"];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 特辑详情

- (void)getSpecialTagDetailWithTag_id:(NSString *)tag_id andPage:(NSString *)page {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_getSpecialTagDetail];
    url = [NSString stringWithFormat:@"%@tag_id=%@&page=%@",url,tag_id,page];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 4001){
            NSMutableArray * dataArray = [NSMutableArray array];
            for (NSInteger i=0; i<[[responseObject objectForKey:@"data"] count]; i++){
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.name = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"name"];
                model.pic = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"pic"];
                model.gold = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"gold"];
                model.video_type = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"video_type"];
                if ([model.video_type isEqualToString:@"1"]){
                    model.urls = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"urls"];
                }else{
                    model.urls_arr = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"urls"];
                }
                model.video_id = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"video_id"];
                [dataArray addObject:model];
            }
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
                [self.delegate requestFinishiDownLoadWith:dataArray];
            }
        }else{
            [self checkTheNetworkConnectionWithTitle:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"获取特辑详情失败"];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 明星视频列表

- (void)getVideoListWithTagId:(NSString *)tag_id Video_type:(NSString *)video_type Page:(NSString *)page {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_getVideoListByTagId];
    url = [NSString stringWithFormat:@"%@tag_id=%@&video_type=%@&page=%@",url,tag_id,video_type,page];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 4001){
            NSMutableArray * array = [NSMutableArray array];
            for (NSInteger i=0; i<[[responseObject objectForKey:@"data"] count]; i++){
                RMPublicModel * model = [[RMPublicModel alloc] init];
                model.gold = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"gold"];
                model.name = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"name"];
                model.pic = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"pic"];
                if ([video_type isEqualToString:@"1"]){
                    model.urls = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"urls"];
                }else{
                    model.urls_arr = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"urls"];
                }
                model.video_id = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"video_id"];
                model.video_type = [[[responseObject objectForKey:@"data"] objectAtIndex:i] objectForKey:@"video_type"];
                [array addObject:model];
            }
            if ([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
                [self.delegate requestFinishiDownLoadWith:array];
            }
        }else{
            [self checkTheNetworkConnectionWithTitle:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"下载失败"];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 标签视频数量

- (void)getVideoNumWithTag_id:(NSString *)tag_id {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_getVideoNumByTagId];
    url = [NSString stringWithFormat:@"%@tag_id=%@",url,tag_id];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 4001){
            RMPublicModel * model = [[RMPublicModel alloc] init];
            model.tv_num = [[responseObject objectForKey:@"data"] objectForKey:@"tv_num"];
            model.variety_num = [[responseObject objectForKey:@"data"] objectForKey:@"variety_num"];
            model.vod_num = [[responseObject objectForKey:@"data"] objectForKey:@"vod_num"];
            if ([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWithModel:)]){
                [self.delegate requestFinishiDownLoadWithModel:model];
            }
        }else{
            [self checkTheNetworkConnectionWithTitle:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 登录

- (void)loginWithSource_type:(NSString *)source_type Source_id:(NSString *)source_id Username:(NSString *)username Face:(NSString *)face {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_login];
    NSDictionary * parameter = @{
                                 @"source_id": [NSString stringWithFormat:@"%@",source_id],
                                 @"source_type": [NSString stringWithFormat:@"%@",source_type],
                                 @"username": [NSString stringWithFormat:@"%@",username],
                                 @"face": [NSString stringWithFormat:@"%@",face]
                                 };
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if([[responseObject objectForKey:@"code"] intValue]==4001){
            NSString *token = [[responseObject objectForKey:@"data"] objectForKey:@"token"];
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWithToken:)]){
                [self.delegate requestFinishiDownLoadWithToken:token];
            }
        }else{
            [self showMessage:@"提交失败" duration:1.0 position:1 withUserInteractionEnabled:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"提交失败"];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 设置基本信息

- (void)setInfoWithToken:(NSString *)token Gender:(NSString *)gender Age:(NSString *)age Preferences:(NSString *)preferences Constellation:(NSString *)constellation {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_setInfo];
    url = [NSString stringWithFormat:@"%@token=%@&gender=%@&age=%@&preferences=%@&constellation=%@",url,token,gender,age,preferences,constellation];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"code"] intValue]==4001){
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWithResults:)]){
                [self.delegate requestFinishiDownLoadWithResults:@"success"];
            }
        }
        else{
            [self checkTheNetworkConnectionWithTitle:@"信息提交失败"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"信息提交失败"];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 我的收藏

- (void)getFavoriteVideoListWithToken:(NSString *)token Page:(NSString *)page {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    self.downLoadType = Http_getFavoriteVideoList;
    NSString *url = [self urlPathadress:Http_getFavoriteVideoList];
    url = [NSString stringWithFormat:@"%@token=%@&page=%@",url,token,page];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"code"] intValue] == 4001){
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dict in [responseObject objectForKey:@"data"]){
                RMPublicModel *model = [[RMPublicModel alloc] init];
                model.name = [dict objectForKey:@"name"];
                model.pic = [dict objectForKey:@"pic"];
                model.actors = [dict objectForKey:@"actors"];
                model.directors = [dict objectForKey:@"directors"];
                model.gold = [dict objectForKey:@"gold"];
                model.hits = [dict objectForKey:@"hits"];
                model.star = [dict objectForKey:@"star"];
                model.presenters = [dict objectForKey:@"presenters"];
                if([[dict objectForKey:@"urls"] isKindOfClass:[NSDictionary class]]){
                    model.urls = [dict objectForKey:@"urls"];
                }else{
                    model.urls_arr = [dict objectForKey:@"urls"];
                }
                model.video_id = [dict objectForKey:@"video_id"];
                model.video_type = [dict objectForKey:@"video_type"];
                [dataArray addObject:model];
            }
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
                [self.delegate requestFinishiDownLoadWith:dataArray];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"下载失败"];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 删除收藏

- (void)deleteFavoriteWithVideo_id:(NSString *)video_id andToken:(NSString *)token {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    self.downLoadType = Http_deleteFavoriteVideo;
    NSString *url = [self urlPathadress:Http_deleteFavoriteVideo];
    url = [NSString stringWithFormat:@"%@token=%@&video_ids=%@",url,token,video_id];
    NSDictionary * parameter = @{
                                 @"token": [NSString stringWithFormat:@"%@",token],
                                 @"video_ids": [NSString stringWithFormat:@"%@",video_id],
                                 };
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if([[responseObject objectForKey:@"code"] intValue] == 4001){
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWithResults:)]){
                [self.delegate requestFinishiDownLoadWithResults:@"success"];
            }
        }else{
            [self showMessage:@"删除失败" duration:1.0 position:1 withUserInteractionEnabled:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"删除失败"];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 统计点击次数

- (void)getDeviceHitsWithVideo_id:(NSString *)video_id Device:(NSString *)device {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_getDeviceHits];
    url = [NSString stringWithFormat:@"%@video_id=%@&device=%@",url,video_id,device];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

#pragma mark - 更多应用

- (void)getMoreApp {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_getMoreApp];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if([[responseObject objectForKey:@"code"] intValue] == 4001){
            NSMutableArray *dataArray = [NSMutableArray array];
            for(NSDictionary *dict in [responseObject objectForKey:@"data"]){
                RMPublicModel *appModel = [[RMPublicModel alloc] init];
                appModel.app_name = [dict objectForKey:@"app_name"];
                appModel.app_pic = [dict objectForKey:@"app_pic"];
                appModel.ios = [dict objectForKey:@"ios"];
                [dataArray addObject:appModel];
            }
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWith:)]){
                [self.delegate requestFinishiDownLoadWith:dataArray];
            }
        }else{
            [self showMessage:@"获取失败" duration:1.0 position:1 withUserInteractionEnabled:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self checkTheNetworkConnectionWithTitle:@"获取失败"];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 关于

- (void)aboutWithVersionNumber:(NSString *)versionNumber Os:(NSString *)os {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_about];
    url = [NSString stringWithFormat:@"%@versionNumber=%@&os=%@",url,versionNumber,os];
    url = [self encryptUrl:url];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if([[responseObject objectForKey:@"code"] intValue] == 4001){
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWithResults:)]){
                [self.delegate requestFinishiDownLoadWithResults:[dict objectForKey:@"url"]];
            }
        }else{
            [self showMessage:@"获取失败" duration:1.0 position:1 withUserInteractionEnabled:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMessage:@"获取失败" duration:1.0 position:1 withUserInteractionEnabled:NO];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - 用户反馈

- (void)userFeedbackWithToken:(NSString *)token Text:(NSString *)text {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_userFeedback];
    url = [NSString stringWithFormat:@"%@token=%@&text=%@",url,token,text];
    url = [self encryptUrl:url];
    NSDictionary * parameter = @{
                                 @"token": token,
                                 @"text": text
                                 };
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if([[responseObject objectForKey:@"code"] intValue] == 4001){
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWithResults:)]){
                [self.delegate requestFinishiDownLoadWithResults:@"success"];
            }
        }else{
            [self showHUDWithImage:@"submitMessagefailed" imageFrame:CGRectMake(0, 0, 130, 40) duration:1.5 userInteractionEnabled:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showHUDWithImage:@"submitMessagefailed" imageFrame:CGRectMake(0, 0, 130, 40) duration:1.5 userInteractionEnabled:YES];
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

#pragma mark - loading页

- (void)getLoadingWithDevice:(NSString *)device {
    AFHTTPRequestOperationManager *manager = [self creatAFNNetworkRequestManager];
    NSString *url = [self urlPathadress:Http_loading];
    url = [NSString stringWithFormat:@"%@device=%@",url,device];
    url = [self encryptUrl:url];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 4001){
            RMPublicModel * model = [[RMPublicModel alloc] init];
            model.loading_version = [[responseObject objectForKey:@"data"] objectForKey:@"loading_version"];
            model.device = [[responseObject objectForKey:@"data"] objectForKey:@"device"];
            model.pic = [[responseObject objectForKey:@"data"] objectForKey:@"pic"];
            model.tpl = [[responseObject objectForKey:@"data"] objectForKey:@"tpl"];
            model.video_id = [[responseObject objectForKey:@"data"] objectForKey:@"video_id"];
            model.video_type = [[responseObject objectForKey:@"data"] objectForKey:@"video_type"];
            model.source_url = [[responseObject objectForKey:@"data"] objectForKey:@"source_url"];
            model.is_jump = [[responseObject objectForKey:@"data"] objectForKey:@"is_jump"];
            if([self.delegate respondsToSelector:@selector(requestFinishiDownLoadWithModel:)]){
                [self.delegate requestFinishiDownLoadWithModel:model];
            }
        }else{
            if([self.delegate respondsToSelector:@selector(requestError:)]){
                [self.delegate requestError:nil];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([self.delegate respondsToSelector:@selector(requestError:)]){
            [self.delegate requestError:error];
        }
    }];
}

- (void)showMessage:(NSString *)message duration:(NSTimeInterval)interval position:(NSInteger)position withUserInteractionEnabled:(BOOL)enabled {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.userInteractionEnabled  = !enabled;
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.labelFont = FONT(12.0);
    hud.margin = 10.f;
    
    switch (position) {
        case CENTER:{
            hud.yOffset = 0;
        }
            break;
        case TOP:{
            hud.yOffset = 110 - CGRectGetHeight(window.frame)/2;
        }
            break;
        case BOTTOM:{
            hud.yOffset = CGRectGetHeight(window.frame)/2 - 40;
        }
            break;
            
        default:
            break;
    }
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2.0];
}

- (void)showHUDWithImage:(NSString *)imageName imageFrame:(CGRect)frame duration:(NSTimeInterval)interval userInteractionEnabled:(BOOL)enabled {
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = enabled;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    if (!HUDImage){
        HUDImage = [[UIImageView alloc] init];
    }
    HUDImage.frame = frame;
    HUDImage.center = CGPointMake(width/2, height/2);
    HUDImage.backgroundColor = [UIColor clearColor];
    HUDImage.image = [UIImage imageNamed:imageName];
    HUDImage.alpha = 0.f;
    [[UIApplication sharedApplication].keyWindow addSubview:HUDImage];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        HUDImage.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    
    [self hideHUDImageWithAnimation:YES afterDelay:interval];
}

- (void)hideHUDImageWithAnimation:(BOOL)animation afterDelay:(NSTimeInterval)interval {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            HUDImage.alpha = 0.f;
        } completion:^(BOOL finished) {
            [HUDImage removeFromSuperview];
            HUDImage = nil;
        }];
    });
}

@end
