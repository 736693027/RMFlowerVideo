//
//  RMDownLoadingViewController.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-6.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMDownLoadingViewController : RMBaseViewController< NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>{
    void(^didSelectCells)(NSMutableArray *selectArray);
    void(^commitEditings)(NSMutableArray *selectArray);
    NSInteger downLoadIndex; //标记当前下载位置。即那个电影正在下载
}

@property (nonatomic,assign) id delegete;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *downLoadIDArray;      //正在下载的数组
@property (strong, nonatomic) NSMutableArray *pauseLoadingArray;    //暂停中的数组
@property (nonatomic)BOOL isDownLoadNow;                            //判断当前是否有下载任务
@property (nonatomic)int64_t downLoadSpeed;                         //下载速度
@property (nonatomic)int64_t haveReadTheSchedule;                   //已缓存大小
@property (nonatomic)int64_t totalDownLoad;                         //总共需要缓存的大小
@property (nonatomic, assign) id myDownLoadDelegate;                //主控制器
@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;

@property (weak, nonatomic) IBOutlet UIButton *startOrPauseBtn;
@property (strong, nonatomic) UITableView *mainTableView;

+(instancetype)shared;

//将选择删除的cell的数组传递给主控制器，全选和删除做出相应的状态
- (void)didSelectTableViewCell:(void(^)(NSMutableArray *selectArray))block;

//tableviewcell 右滑删除的时候，将dataArray的数量传递给主控制器，从而判定是否需要隐藏或者现实导航右边按钮
- (void)tableViewcommitEditing:(void(^)(NSMutableArray *commitArray))block;

//开始编辑
- (void)beginEditingTableViewCell;

//结束编辑
- (void)endEditingTableViewCell;

//全选
- (void)selectAllTableViewWithState:(BOOL)state;

//删除
- (void)deleteDidSelectCell;

//开始下载
- (void)BeginDownLoad;

//程序退出是 保存一下数据
- (void)saveData;

//添加下载的时候，判断否在下载队列中
- (BOOL)dataArrayContainsModel:(RMPublicModel *)model;


@end
