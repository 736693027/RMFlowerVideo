//
//  CONST.h
//  RMVideo
//
//  Created by runmobile on 14-9-28.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//


//系统框架
/*
 
 HUD 选项
 
 1.Reachability
 需要  SystemConfiguration框架
 
 2.UIImage-Helpers
 需要  Accelerate框架
 
 3.AFNetworking
 需要  MobileCoreServices框架 Security框架 SystemConfiguration框架 CoreLocation框架
 
 4.FMDB
 需要  libsqlite3框架
 
 5.EGOTableViewPullRefresh
 需要  QuartzCore框架
 
 6.HMSegmentedControl
 需要  QuartzCore框架
 
 7.UMeng需要的框架
 Security.framework,libiconv.dylib,SystemConfiguration.framework,CoreGraphics.framework，libsqlite3.dylib，CoreTelephony.framework,libstdc++.dylib,libz.dylib。
 8.Flurry 需要的框架
 Security.framework
 SystemConfiguration.framework
 
 
 
 svn://172.16.2.204/rmdom //文档
 svn://172.16.2.204/rmandroid //Android源码
 svn://172.16.2.204/rmios  //ios源码
 svn://172.16.2.204/rmweb  //api，pc，后台源码
 
 账号目前都是自己姓名全称 如：刘涛 密码 为rm+名字首字母+123 如：rmlt123
 
 */
#import "CONSTURL.h"

#define kYES                                    @"YES"
#define kNO                                     @"NO"

//观看记录和我的收藏 cell开始编辑
#define kBeginEdingtingTableViewCell @"kBeginEdingtingTableViewCell"
//观看记录和我的收藏 cell结束编辑
#define kEndEditingTableViewCell @"kEndEditingTableViewCell"

//缓存中 cell开始编辑
#define kDownLoadingControStartEditing          @"downLoadingCellBeginAimation"
//缓存中 cell结束编辑
#define kDownLoadingControEndEditing            @"downLoadingCellEndAimation"

//已缓存 cell开始编辑
#define kFinishDownLoadControStartEditing          @"FinishdownLoadCellBeginAimation"
//已缓存 cell结束编辑
#define kFinishDownLoadControEndEditing            @"FinishdownLoadCellEndAimation"


//电视剧下载详情删除结束
#define kTVSeriesDetailDeleteFinish             @"TVSeriesDetailDeleteFinish"

#define IS_IPHONE_4_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_5_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_6_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_6p_SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO) //1242, 2208   1080, 1920

#define FONT(_size) [UIFont fontWithName:@"Heiti TC" size:(_size)]  //HelveticaNeue-CondensedBlack

#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

//颜色转换
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define NavBarHeight                44.f
#define TabBarHeight                49.f

//图片加载
#define kImageTypePNG @"png"
//#define LOADIMAGE(file,ext)   [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
#define LOADIMAGE(file)   [UIImage imageNamed:[NSString stringWithFormat:@"%@",file]]

//字符串nil转成@""
#ifndef nilToEmpty
#define nilToEmpty(object) (object!=nil)?object:@""
#endif

//屏幕宽度 高度
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height

//  网络指示
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x

//Storage
#define CURRENTENCRYPTFILE                          @"PersonalInformationFile"
#define PASSWORD                                    @"password"

#define LoginStatus_KEY                             @"loginstatus_KEY"
#define UserLoginInformation_KEY                    @"userLoginInformation_KEY"
#define UserSearchRecordData_KEY                    @"userSearchRecordData_KEY"
#define UserSearchStarRecordData_KEY                @"userSearchSatrRecordData_KEY"
#define DownLoadDataArray_KEY                       @"downLoadDataArray_KEY"
#define Downloadstatus_KEY                          @"downloadstatus"
#define DownLoadSuccess_KEY                         @"downLoadSuccess_KEY"

/*
 loginStatus  value为:islogin  表示登录    value为:notlogin  表示未登录
*/

//提示
#define kShowConnectionAvailableError               @"没有网络，请检查网络连接"

//APP 相关信息
#define kAppName                            @"小花视频"
#define kAppleId                            @"944155902"
#define kAppAddress                         @"https://itunes.apple.com/cn/app/r-evolve/id944155902?mt=8"

#define UMengAppKey                         @"546f02cefd98c5c6a60041bb"
#define AppVersionNumber                    @"1.0"

/*
JPush 证书的密码：dev:123456abcd  dis:123456abcd
 */

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#if __has_feature(objc_arc)
// ARC
#else
// MRC
#endif


