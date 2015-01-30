//
//  RMPublicModel.h
//  RMVideo
//
//  Created by 润华联动 on 14-10-30.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMPublicModel : NSObject

@property (nonatomic, assign) NSInteger downLoadType;       //下载方式
@property (nonatomic, copy) NSString *code;                 //状态
@property (nonatomic, copy) NSString *pic;                  //头像
@property (nonatomic, copy) NSString *name;                 //标题
@property (nonatomic, copy) NSString *videoDescription;     //描述
@property (nonatomic, copy) NSString *video_id;             //视频ID
@property (nonatomic, strong) NSMutableDictionary *urls;    //跳转地址 包含MP4地址和网页跳转地址
@property (nonatomic, strong) NSMutableArray *urls_arr;     //urls 在首页可能是数组 也可能是字典
@property (nonatomic, copy) NSString *source_url;           //链接地址
@property (nonatomic, copy) NSString *jumpurl;              //跳web播放视频
@property (nonatomic, copy) NSString *m_down_url;           //mp4播放地址
@property (nonatomic, copy) NSString *status;               //状态
@property (nonatomic, copy) NSString *tag_id;               //标签tag
@property (nonatomic, copy) NSString *gold;                 //评分
@property (nonatomic, copy) NSString *video_type;           //视频类型
@property (nonatomic, copy) NSString *type;                 //类型
@property (nonatomic, copy) NSString *detail;               //详情
@property (nonatomic, copy) NSString *app_name;             //app名称
@property (nonatomic, copy) NSString *app_pic;              //app_icon
@property (nonatomic, copy) NSString *ios;                  //itunes地址
@property (nonatomic, copy) NSString *tv_num;               //电视剧的数量
@property (nonatomic, copy) NSString *variety_num;          //综艺的数量
@property (nonatomic, copy) NSString *vod_num;              //电影的数量
@property (nonatomic, copy) NSString *loading_version;      //启动页版本
@property (nonatomic, copy) NSString *device;               //设备
@property (nonatomic, copy) NSString *tpl;                  //启动页模版
@property (nonatomic, copy) NSString *is_jump;              //启动页是否跳转
@property (nonatomic, copy) NSString *actors;               //演员
@property (nonatomic, copy) NSString *directors;            //导演
@property (nonatomic, copy) NSString *hits;                 //点击数
@property (nonatomic, copy) NSString *presenters;           //主持人
@property (nonatomic, copy) NSString *order;                //排名
@property (nonatomic, copy) NSString *star;                 //星数(0,1,2,3,4,5)
@property (nonatomic, copy) NSString *content;              //视频播放详情
@property (nonatomic, copy) NSMutableArray *creator;        //主创人员
@property (nonatomic, copy) NSString *is_download;          //是否可下载
@property (nonatomic, copy) NSString *is_favorite;          //是否已经收藏
@property (nonatomic, copy) NSMutableArray *playurl;        //视频播放详情－电影集合
@property (nonatomic, copy) NSMutableArray *playurls;       //视频播放详情－电视剧、综艺集合
@property (nonatomic, copy) NSMutableArray *relevant;       //视频播放详情－相关集合
@property (nonatomic, copy) NSString *source_type;          //视频资源类型
@property (nonatomic, copy) NSString *keyword;              //搜索关键字
@property (nonatomic, copy) NSMutableArray *star_list;      //明星列表
@property (nonatomic, copy) NSMutableArray *tv_list;        //电视剧列表
@property (nonatomic, copy) NSMutableArray *variety_list;   //综艺列表
@property (nonatomic, copy) NSMutableArray *video_list;     //视频列表
@property (nonatomic, copy) NSMutableArray *vod_list;       //电影列表
@property (nonatomic, copy) NSString *actor;                //主演
@property (nonatomic, copy) NSString *director;             //导演





/*下载专用*/
@property (nonatomic)BOOL isTVModel;
@property (nonatomic, copy) NSString *downLoadURL;          //下载链接
@property (nonatomic, copy) NSString *downLoadState;        //当前下载状态（等待下载，暂停）
@property (nonatomic ,copy) NSString *cacheProgress;        //缓存进度，用在下载过程中
@property (nonatomic ,copy) NSString *totalMemory;          //总下载量
@property (nonatomic, copy) NSString *alreadyCasheMemory;   //已经缓存的量
@property (nonatomic, copy) NSData *cashData;
@property (nonatomic, copy) NSString *playTime;             //从那个时间点开始播放

@end
