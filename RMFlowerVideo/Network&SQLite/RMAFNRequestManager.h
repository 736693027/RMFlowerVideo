//
//  RMAFNRequestManager.h
//  RMVideo
//
//  Created by 润华联动 on 14-10-29.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMPublicModel.h"

typedef enum{
    requestReturnStatusNormalType = 4001,                           //正常
    requestReturnStatusNoVideosFoundType,                           //没有找到该视频
    requestReturnStatusUserIdentityExpiredType,                     //未找到该用户，请重新登录
    requestReturnStatusSystemErrorType,                             //系统错误，稍后再试
    requestReturnStatusNoStarFoundType,                             //没有找到该明星
    requestReturnStatusHasBeenAddedToMyChannelType,                 //明星已经添加到我的频道
    requestReturnStatusInputDoesNotMeetSpecificationsType,          //输入不符合规范
    requestReturnStatusDataEnteredIsIncompleteType,                 //输入的数据不完整
    requestReturnStatusContentsOfTheInputCanNotBeEmptyType,         //输入的内容不能为空
    requestReturnStatusUnKnownDevice = 4011                         //未知设备
}kCodeReturnStatusType;

@protocol RMAFNRequestManagerDelegate <NSObject>

@optional
- (void)requestFinishiDownLoadWith:(NSMutableArray *)data;
- (void)requestFinishiDownLoadWithModel:(RMPublicModel *)model;
- (void)requestFinishiDownLoadWithToken:(NSString *)token;
- (void) requestFinishiDownLoadWithResults:(NSString *)results;

- (void)requestError:(NSError *)error;

@end

@interface RMAFNRequestManager : NSObject

@property(assign,nonatomic)id<RMAFNRequestManagerDelegate> delegate;
@property(assign,nonatomic)NSInteger downLoadType;
/**
 *  首页幻灯
 *
 *  @param video_type        视频类型 1--电影，2---电视剧，3---综艺
 */
- (void)getSlideListWithVideo_type:(NSString *)video_type;
/**
 *  首页视频
 *
 *  @param videoType    视频类型（1：电影 2：电视剧 3：综艺）
 *  @param Page         页数
 *  @param limit        可选，每页条数
 */
- (void)getIndexVideoListWithVideoTpye:(NSString *)videoType searchPageNumber:(NSString *)page andLimit:(NSString *)limit;

/**
 *  首页明星
 *
 *  @param page          页数
 *  @param Limit         可选，每页条数
 */
- (void)getStarListWithPage:(NSString *)page andLimit:(NSString *)limit;

/**
 *  排行榜
 *
 *  @param video_type    1电影、2电视剧、3综艺
 */
- (void)getTopListWithVideo_type:(NSString *)video_type;

/**
 *  搜索
 *
 *  @param keyword      关键词
 *  @param page         页码
 */
- (void)searchWithKeyword:(NSString *)keyword Page:(NSString *)page;

/**
 *  搜索提示
 *
 *  @param work         输入的内容
 */
- (void)getSearchTipsWithWork:(NSString *)word;

/**
 *  搜索推荐
 *
 *  @param *
 */
- (void)getSearchRecommend;

/**
 *  明星详情
 *
 *  @param tag_id         标签ID
 */
- (void)getStarDetailWithTag_id:(NSString *)tag_id;

/**
 *  视频详情
 *
 *  @param video_id        视频ID
 *  @param token           用户令牌
 */
- (void)getVideoDetailWithVideo_id:(NSString *)video_id Token:(NSString *)token;

/**
 *  添加收藏
 *
 *  @param token           用户令牌
 *  @param video_id        视频ID
 */
- (void)addFavoriteWithVideo_id:(NSString *)video_id andToken:(NSString *)token;

/**
 *  分集下载
 *
 *  @param video_id         视频ID
 */
- (void)getDownloadUrlWithVideo_id:(NSString *)video_id;

/**
 *  特辑
 *
 *  @param page           页数
 */
- (void)getSpecialTagWithPage:(NSString *)page;

/**
 *  特辑详情
 *
 *  @param tag_id       标签ID
 *  @param page         页码
 */
- (void)getSpecialTagDetailWithTag_id:(NSString *)tag_id andPage:(NSString *)page;

/**
 *  明星视频列表
 *
 *  @param tag_id       标签ID
 *  @param video_type   视频类型 1：电影 2：电视剧 3：综艺
 *  @param page         页码
 */
- (void)getVideoListWithTagId:(NSString *)tag_id Video_type:(NSString *)video_type Page:(NSString *)page;

/**
 *  标签视频数量
 *
 *  @param tag_id       标签ID
 */
- (void)getVideoNumWithTag_id:(NSString *)tag_id;

/**
 *  登录
 *
 *  @param source_type    第三方来源：1:注册 2:腾讯微博 3:QQ 4:新浪微博
 *  @param source_id      第三方ID
 *  @param username       用户名
 *  @param face           头像地址
 */
- (void)loginWithSource_type:(NSString *)source_type Source_id:(NSString *)source_id Username:(NSString *)username Face:(NSString *)face;

/**
 *  设置基本信息
 *
 *  @param token            用户令牌
 *  @param gender           性别 1：男  2：女
 *  @param age              年龄
 *  @param preferences      偏好 1：重口味  2：小清新
 *  @param constellation    星座
 */
- (void)setInfoWithToken:(NSString *)token Gender:(NSString *)gender Age:(NSString *)age Preferences:(NSString *)preferences Constellation:(NSString *)constellation;

/**
 *  我收藏的视频列表
 *
 *  @param token        用户令牌
 *  @param Page         页码
 *
 */
- (void)getFavoriteVideoListWithToken:(NSString *)token Page:(NSString *)page;

/**
 *  删除收藏
 *
 *  @param token        用户令牌
 *  @param video_ids    视频ID集合，多个ID用，连接
 */
- (void)deleteFavoriteWithVideo_id:(NSString *)video_id andToken:(NSString *)token;

/**
 *  统计点击次数
 *
 *  @param video_id     视频ID
 *  @param device       设备名  iPhone，iPad，android，pc
 *
 */
- (void)getDeviceHitsWithVideo_id:(NSString *)video_id Device:(NSString *)device;

/**
 *  更多应用
 */
- (void)getMoreApp;

/**
 *  关于
 *  
 *  @param versionNumber    当前版本
 *  @param os               系统：iPhone  Android
 */
- (void)aboutWithVersionNumber:(NSString *)versionNumber Os:(NSString *)os;

/**
 *  用户反馈
 *  @param token         用户令牌
 *  @param text          内容
 */
- (void)userFeedbackWithToken:(NSString *)token Text:(NSString *)text;

/**
 *  Loading页
 *  @param device       设备
 */
- (void)getLoadingWithDevice:(NSString *)device;

- (void)cancelRequest;

@end
