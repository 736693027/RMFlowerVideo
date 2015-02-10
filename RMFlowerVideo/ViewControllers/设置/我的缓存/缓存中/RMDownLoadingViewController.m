//
//  RMDownLoadingViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-6.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMDownLoadingViewController.h"
#import "RMMyCacheViewController.h"
#import "RMDownLoadingTableViewCell.h"
#import "UIButton+EnlargeEdge.h"
#import "Reachability.h"
#import "Database.h"
#import "AppDelegate.h"

@interface RMDownLoadingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    BOOL isBeginDownLoadAllTask;            //是否全部开始/暂停
    BOOL isStartEditing;                    //是否开始编辑
    NSMutableArray *cellEditingImageArray;  //cell对应的每个右滑露出的编辑按钮的状态
    NSMutableArray *selectCellArray;        //将要删除的cell位置
    NSTimer *time;                          //每个一秒取一下任务的下载情况
    Reachability * reach;
}

@end

@implementation RMDownLoadingViewController

#pragma mark 下载类实现单例的方法
static id _instance;

+ (id) alloc{
    return [super alloc];
}
+ (id) allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+(id)copyWithZone:(struct _NSZone *)zone{
    return _instance;
}

- (id)init {
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if((obj=[super init]) != nil){
            if(self.dataArray==nil){
                self.dataArray = [[NSMutableArray alloc] init];
                self.downLoadIDArray = [[NSMutableArray alloc] init];
                self.pauseLoadingArray = [[NSMutableArray alloc] init];
                self.session = [self backgroundSession];
                //用于显示下载流量
                time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showDownLoadIngSpeed) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop]addTimer:time forMode:NSDefaultRunLoopMode];
                [time setFireDate:[NSDate distantFuture]];
                cellEditingImageArray = [[NSMutableArray alloc] init];
                selectCellArray = [[NSMutableArray alloc] init];
                if(self.mainTableView==nil){
                    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, ScreenWidth, ScreenHeight-64-46-43-25) style:UITableViewStylePlain];
                    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    self.mainTableView.delegate = self;
                    self.mainTableView.dataSource = self;
                    [self.view addSubview:self.mainTableView];
                }
               
                NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:DownLoadDataArray_KEY];
                NSArray * SavedownLoad = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if(SavedownLoad==nil){
                    self.mainTableView.hidden = YES;
                }else{
                    NSLog(@"成功取值");
                    for(RMPublicModel *model in SavedownLoad){
                        [self.dataArray addObject:model];
                        [cellEditingImageArray addObject:@"cell_no_select"];
                    }
                    self.mainTableView.hidden = NO;
                    [self.mainTableView reloadData];
                }
                if(self.dataArray.count==0){
                    isBeginDownLoadAllTask = YES;
                    [self.startOrPauseBtn setImage:[UIImage imageNamed:@"setup_downLoad_start"] forState:UIControlStateNormal];
                    [self.startOrPauseBtn setTitle:@"全部开始" forState:UIControlStateNormal];
                    
                }else{
                    isBeginDownLoadAllTask = NO;
                    [self.startOrPauseBtn setImage:[UIImage imageNamed:@"setup_downLoad_pause"] forState:UIControlStateNormal];
                    [self.startOrPauseBtn setTitle:@"全部暂停" forState:UIControlStateNormal];
                }
            }
        }
    });
    self = obj;
    return self;
}
+(instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}
#pragma mark 创建下载类
- (NSURLSession *)backgroundSession {
    static NSURLSession *backgroundSess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"abcdefghigk"];
        backgroundSess = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    });
    return backgroundSess;
}

#pragma mark 计时器会每秒调用该方法，更新当前下载数据
- (void)showDownLoadIngSpeed{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:downLoadIndex inSection:0];
    RMDownLoadingTableViewCell *cell = (RMDownLoadingTableViewCell *)[self.mainTableView cellForRowAtIndexPath:indexPath];
    if(indexPath.row>=self.dataArray.count) return;
    RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.progressLable.text = [NSString stringWithFormat:@"%.1fkb/s",self.downLoadSpeed/1024.0];
    //第一次下载的时候
    if([model.totalMemory isEqualToString:@"0M"]){
        cell.progressView.progress = 0;
        cell.tatleProgressLable.text = [NSString stringWithFormat:@"%lldM/%lldM",self.haveReadTheSchedule/1024/1024,self.totalDownLoad/1024/1024];
        model.totalMemory = [NSString stringWithFormat:@"%lldM",self.totalDownLoad/1024/1024];
        model.alreadyCasheMemory = [NSString stringWithFormat:@"%lldM",self.haveReadTheSchedule/1024/1024];
    }
    
    //暂停之后，或者继续下载之后
    else{
        cell.progressLable.text = [NSString stringWithFormat:@"%.1fkb/s",self.downLoadSpeed/1024.0];
        double progress = (double)self.haveReadTheSchedule/(double)self.totalDownLoad;
        if(self.haveReadTheSchedule==0){
            cell.progressView.progress = [model.cacheProgress floatValue];
        }else{
            cell.progressView.progress = progress;
        }
        model.alreadyCasheMemory = [NSString stringWithFormat:@"%lldM",self.haveReadTheSchedule/1024/1024];
        model.cacheProgress = [NSString stringWithFormat:@"%f",progress];
        cell.tatleProgressLable.text = [NSString stringWithFormat:@"%@/%@",model.alreadyCasheMemory,model.totalMemory];
    }
    self.downLoadSpeed = 0;
}

#pragma mark 全部开始/暂停
- (IBAction)beginAllDownLoadTask:(UIButton *)sender {
    if(self.dataArray.count==0||self.dataArray==nil) return;
    
    if(isBeginDownLoadAllTask){
        [sender setImage:[UIImage imageNamed:@"setup_downLoad_pause"] forState:UIControlStateNormal];
        [sender setTitle:@"全部暂停" forState:UIControlStateNormal];
        for(int i=0;i<self.dataArray.count;i++){
            RMPublicModel *tmpModel = [self.dataArray objectAtIndex:i];
            tmpModel.downLoadState = @"等待缓存";
            [self.downLoadIDArray addObject:tmpModel];
        }
        [self.mainTableView reloadData];
        if(!self.isDownLoadNow){
            RMPublicModel *model = [self.downLoadIDArray objectAtIndex:0];
            for (RMPublicModel *tmpmodel in self.dataArray) {
                if([tmpmodel.name isEqualToString:model.name]){
                    downLoadIndex = [self.dataArray indexOfObject:tmpmodel];
                    break;
                }
            }
            [time setFireDate:[NSDate date]];
            [self startDownloadWithMovieName:model];
        }
    }
    else{
        [sender setImage:[UIImage imageNamed:@"setup_downLoad_start"] forState:UIControlStateNormal];
        [sender setTitle:@"全部开始" forState:UIControlStateNormal];
        [self.pauseLoadingArray removeAllObjects];
        self.isDownLoadNow = NO;
        [time setFireDate:[NSDate distantFuture]];
        RMPublicModel *model = [self.dataArray objectAtIndex:downLoadIndex];
        [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            NSLog(@"赋值");
            model.cashData = resumeData;
        }];
        self.downloadTask = nil;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:downLoadIndex inSection:0];
        RMDownLoadingTableViewCell *cell = (RMDownLoadingTableViewCell *)[self.mainTableView cellForRowAtIndexPath:indexPath];
        
        model.downLoadState = @"暂停缓存";
        model.cacheProgress = [NSString stringWithFormat:@"%f",cell.progressView.progress];
        NSString *memory = cell.tatleProgressLable.text;
        NSRange range = [memory rangeOfString:@"/"];
        if(range.location != NSNotFound){
            model.totalMemory = [memory substringFromIndex:range.location+1];
            model.alreadyCasheMemory = [memory substringToIndex:range.location];
        }
        else{
            model.totalMemory = @"0M";
            model.alreadyCasheMemory = @"0M";
        }
        [self.downLoadIDArray removeAllObjects];
        for(int i=0;i<self.dataArray.count;i++){
            RMPublicModel *tmpModel = [self.dataArray objectAtIndex:i];
            tmpModel.downLoadState = @"暂停缓存";
            [self.pauseLoadingArray addObject:tmpModel];
        }
        [self.mainTableView reloadData];
        self.haveReadTheSchedule = 0;
        self.downLoadSpeed = 0;
        self.totalDownLoad = 0;
    }
    isBeginDownLoadAllTask = !isBeginDownLoadAllTask;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    [self.startOrPauseBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.mainTableView setTableFooterView:view];
    [self.mainTableView setTableHeaderView:view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name: kReachabilityChangedNotification_One object:nil];
    // 获取访问指定站点的Reachability对象
    reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    // 让Reachability对象开启被监听状态
    [reach startNotifier];
}
#pragma mark 检查网络
- (void)reachabilityChanged:(NSNotification *)note {
    
    // 通过通知对象获取被监听的Reachability对象
    Reachability *curReach = [note object];
    // 获取Reachability对象的网络状态
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable&&self.downLoadIDArray.count>0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"没有网络连接" delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:nil];
        [alert show];
    }
    else if(status != ReachableViaWiFi&&self.downLoadIDArray.count>0){
        [self.downloadTask cancel];
        self.downloadTask = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"当前不是wifi连接，是否继续下载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        [self.downloadTask cancel];
        self.downloadTask = nil;
    }
}

#pragma mark tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 139;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"DOWNLOADCELL";
    RMDownLoadingTableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMDownLoadingTableViewCell" owner:self options:nil] lastObject];
        if(isStartEditing) [cell setCellViewFrame];
    }
    [cell.editingImage setImage:[UIImage imageNamed:[cellEditingImageArray objectAtIndex:indexPath.row]]];
    RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if([model.name rangeOfString:@"电视剧"].location == NSNotFound){
        cell.titleLable.text = model.name;
    }else{
        NSString *titel = [model.name substringFromIndex:[model.name rangeOfString:@"_"].location+1];
        cell.titleLable.text = titel;
    }
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
    
    cell.progressLable.text = model.downLoadState;
    if([[self setMemoryString:model.totalMemory] floatValue]==0){
        cell.tatleProgressLable.text = @"";
        cell.progressView.progress = 0;
    }
    else{
        cell.progressView.progress = [model.cacheProgress floatValue];
        cell.tatleProgressLable.text = [NSString stringWithFormat:@"%@/%@",model.alreadyCasheMemory,model.totalMemory];
    }

    return cell;
}
#pragma mark tableView delegate
//指定行是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//设置tableview是否可编辑
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //这里是关键：这样写才能实现既能禁止滑动删除Cell，又允许在编辑状态下进行删除
    if (isStartEditing)
        return UITableViewCellEditingStyleNone;
    else {
        return UITableViewCellEditingStyleDelete;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if([self.downLoadIDArray containsObject:model]&&indexPath.row==downLoadIndex){
            [self.downLoadIDArray removeObject:model];
            [self.downloadTask cancel];
        }else if([self.downLoadIDArray containsObject:model]&&indexPath.row!=downLoadIndex){
            [self.downLoadIDArray removeObject:model];
        }
        if([self.pauseLoadingArray containsObject:model]){
            [self.pauseLoadingArray removeObject:model];
        }
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        commitEditings(self.dataArray);
        if(self.dataArray.count==0){
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:DownLoadDataArray_KEY];
            self.mainTableView.hidden = YES;
        }else{
            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.dataArray];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:DownLoadDataArray_KEY];
            self.mainTableView.hidden = NO;
        }
    }
}
- (void)tableViewcommitEditing:(void (^)(NSMutableArray *))block{
    commitEditings = block;
}

#pragma mark cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(isStartEditing){
        NSString *cellIamge = [cellEditingImageArray objectAtIndex:indexPath.row];
        if([cellIamge isEqualToString:@"cell_no_select"]){
            [cellEditingImageArray replaceObjectAtIndex:indexPath.row withObject:@"cell_selected"];
        }else{
            [cellEditingImageArray replaceObjectAtIndex:indexPath.row withObject:@"cell_no_select"];
        }
        if([selectCellArray containsObject:[NSNumber numberWithInteger:indexPath.row]]){
            [selectCellArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
        }
        else{
            [selectCellArray addObject:[NSNumber numberWithInteger:indexPath.row]];
        }
        didSelectCells(selectCellArray);
        [self.mainTableView reloadData];

    }else{
//                RMMyCacheViewController *mainCasheViewContro = self.delegete;
        RMDownLoadingTableViewCell *cell = (RMDownLoadingTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        if([cell.progressLable.text isEqualToString:@"暂停缓存"]){
            RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row];
            model.downLoadState =@"等待缓存";
            [self.downLoadIDArray addObject:model];
            //            self.isDownLoadNow = NO;
            [self.pauseLoadingArray removeObject:model];
            cell.progressLable.text = model.downLoadState;
            if(!self.isDownLoadNow){
                [self performSelector:@selector(BeginDownLoad) withObject:nil afterDelay:1];
            }
        }
        else if([cell.progressLable.text isEqualToString:@"等待缓存"]){
            RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row];
            model.downLoadState = @"暂停缓存";
            [self.pauseLoadingArray addObject:model];
            [self.downLoadIDArray removeObject:model];
            cell.progressLable.text = model.downLoadState;
        }
        else if ([cell.progressLable.text isEqualToString:@"下载失败"]){
            RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row];
            model.downLoadState =@"等待缓存";
            cell.progressLable.text = model.downLoadState;
            [self.downLoadIDArray addObject:model];
            [self performSelector:@selector(BeginDownLoad) withObject:nil afterDelay:1];
        }
        else {
            [time setFireDate:[NSDate distantFuture]];
            RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row];
            [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
                NSLog(@"赋值");
                model.cashData = resumeData;
            }];
            self.downloadTask = nil;
            
            model.downLoadState = @"暂停缓存";
            model.cacheProgress = [NSString stringWithFormat:@"%f",cell.progressView.progress];
            NSString *memory = cell.tatleProgressLable.text;
            NSRange range = [memory rangeOfString:@"/"];
            model.totalMemory = [memory substringFromIndex:range.location+1];
            model.alreadyCasheMemory = [memory substringToIndex:range.location];
            [self.pauseLoadingArray addObject:model];
            [self.downLoadIDArray removeObject:model];
            cell.progressLable.text = model.downLoadState;
            self.isDownLoadNow = NO; //表示暂停之后当前没有下载任务。
//            if(self.downLoadIDArray.count>0){
//                [self performSelector:@selector(BeginDownLoad) withObject:nil afterDelay:1];
//            }
        }
        [self setPauseAllOrStartAllBtnState];
    }
}
#pragma mark 开始编辑
- (void)beginEditingTableViewCell{
    self.mainTableView.frame = CGRectMake(0, 46, ScreenWidth, ScreenHeight-64-46-43-49);
    [self.mainTableView setEditing:NO animated:YES];
    isStartEditing = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownLoadingControStartEditing object:nil];
}
#pragma mark 结束编辑
- (void)endEditingTableViewCell{
    self.mainTableView.frame = CGRectMake(0, 46, ScreenWidth, ScreenHeight-64-46-43-25);
    isStartEditing = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownLoadingControEndEditing object:nil];
    for(int i=0;i<selectCellArray.count;i++){
        NSNumber *number = [selectCellArray objectAtIndex:i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:number.integerValue inSection:0];
        RMDownLoadingTableViewCell *cell = (RMDownLoadingTableViewCell*)[self.mainTableView cellForRowAtIndexPath:indexPath];
        cell.editingImage.image = [UIImage imageNamed:@"cell_no_select"];
        [cellEditingImageArray replaceObjectAtIndex:number.integerValue withObject:@"cell_no_select"];
    }
    [selectCellArray removeAllObjects];
}
#pragma mark 全选
- (void)selectAllTableViewWithState:(BOOL)state{
    [selectCellArray removeAllObjects];
    if(state){
        for(int i=0; i<self.dataArray.count;i++){
            [cellEditingImageArray replaceObjectAtIndex:i withObject:@"cell_selected"];
            [selectCellArray addObject:[NSNumber numberWithInt:i]];
        }
        
    }else{
        for(int i=0; i<self.dataArray.count;i++){
            [cellEditingImageArray replaceObjectAtIndex:i withObject:@"cell_no_select"];
        }
    }
    [self.mainTableView reloadData];
}
#pragma mark 删除
- (void)deleteDidSelectCell{
    NSArray *sort = [selectCellArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return obj1.integerValue < obj2.integerValue;
    }];
    
    for(int i=0;i<sort.count;i++){
        NSNumber *number = [sort objectAtIndex:i];
        RMPublicModel *model = [self.dataArray objectAtIndex:number.integerValue];
        if([self.downLoadIDArray containsObject:model]&&number.intValue==downLoadIndex){
            [self.downLoadIDArray removeObject:model];
            [self.downloadTask cancel];
        }else if([self.downLoadIDArray containsObject:model]&&number.intValue!=downLoadIndex){
            [self.downLoadIDArray removeObject:model];
        }
        if([self.pauseLoadingArray containsObject:model]){
            [self.pauseLoadingArray removeObject:model];
        }
        [self.dataArray removeObjectAtIndex:number.integerValue];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:number.integerValue inSection:0];
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [self.mainTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [cellEditingImageArray removeObjectAtIndex:number.integerValue];
    }
    commitEditings(self.dataArray);
    [selectCellArray removeAllObjects];
    isStartEditing = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDownLoadingControEndEditing object:nil];
    
    if(self.dataArray.count==0){
        self.mainTableView.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:DownLoadDataArray_KEY];
    }else{
        self.mainTableView.hidden = NO;
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.dataArray];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:DownLoadDataArray_KEY];
    }

}
- (void)didSelectTableViewCell:(void(^)(NSMutableArray *selectArray))block{
    didSelectCells = block;
}

#pragma mark 准备下载，没添加一个新的下载任务或者已经下载完成一个任务的时候会调用
- (void) BeginDownLoad{
    [self.mainTableView reloadData];
    if(self.mainTableView.hidden==YES){
        self.mainTableView.hidden = NO;
    }
    if(cellEditingImageArray.count<self.dataArray.count){
        if(cellEditingImageArray==nil){
            cellEditingImageArray = [[NSMutableArray alloc] init];
        }
        NSInteger cellImageCount = cellEditingImageArray.count;
        for(int i=0;i<(self.dataArray.count-cellImageCount);i++){
            [cellEditingImageArray addObject:@"cell_no_select"];
        }
    }
    if(!self.isDownLoadNow&&self.downLoadIDArray.count>0){
        RMPublicModel *model = [self.downLoadIDArray objectAtIndex:0];
        for (RMPublicModel *tmpmodel in self.dataArray) {
            if([tmpmodel.name isEqualToString:model.name]){
                downLoadIndex = [self.dataArray indexOfObject:tmpmodel];
                break;
            }
        }
        [self.startOrPauseBtn setImage:[UIImage imageNamed:@"setup_downLoad_pause"] forState:UIControlStateNormal];
        [self.startOrPauseBtn setTitle:@"全部暂停" forState:UIControlStateNormal];
        isBeginDownLoadAllTask = NO;
        [time setFireDate:[NSDate date]];
        [self startDownloadWithMovieName:model];
    }else{
        self.isDownLoadNow = NO;
    }
}

#pragma mark 开始下载
- (void)startDownloadWithMovieName:(RMPublicModel *)model {
    self.isDownLoadNow = YES;
    NSString *downloadUrl = model.downLoadURL;
    [self.downloadTask cancel];
    self.downloadTask = nil;
    NSURL *downloadURL = [NSURL URLWithString:downloadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    if (model.cashData) {
        self.downloadTask = [self.session downloadTaskWithResumeData:model.cashData];
    }else{
        self.downloadTask = [self.session downloadTaskWithRequest:request];
    }
    [self.downloadTask resume];
}

#pragma mark 下载流量显示
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    self.downLoadSpeed += bytesWritten;
    self.haveReadTheSchedule = totalBytesWritten;
    self.totalDownLoad = totalBytesExpectedToWrite;
    
}
#pragma mark 下载成功
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)downloadURL {
    
    if(self.dataArray.count==0) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:DownLoadDataArray_KEY];
        return;
    }
    [time setFireDate:[NSDate distantFuture]];
    RMPublicModel *model = [self.dataArray objectAtIndex:downLoadIndex];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [URLs objectAtIndex:0];
    NSURL *destinationURL = [documentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",model.name]];
    NSError *errorCopy;
    // For the purposes of testing, remove any esisting file at the destination.
    [fileManager removeItemAtURL:destinationURL error:NULL];
    BOOL success = [fileManager copyItemAtURL:downloadURL toURL:destinationURL error:&errorCopy];
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //第一次下载的时候
            if([model.totalMemory isEqualToString:@"0M"]){
                model.totalMemory = [NSString stringWithFormat:@"%lldM",self.totalDownLoad/1024/1024];
            }
            [[Database sharedDatabase] insertDownLoadMovieItem:model];
//            RMMyCacheViewController * myDownLoadCtl = self.myDownLoadDelegate;
//            [myDownLoadCtl setRightBarBtnItemState];
            [self.downLoadIDArray removeObject:model];
            [self.dataArray removeObject:model];
            [self.mainTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownLoadSuccess" object:nil];
            commitEditings(self.dataArray);
            self.isDownLoadNow = NO;
            if (self.dataArray.count==0) {
                self.mainTableView.hidden = YES;
                [self.downloadTask cancel];
                self.downloadTask = nil;
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:DownLoadDataArray_KEY];
                
            }else{
                NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self.dataArray];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:DownLoadDataArray_KEY];
                self.mainTableView.hidden = NO;
                if(self.downLoadIDArray.count>0){
                    [self performSelector:@selector(BeginDownLoad) withObject:nil afterDelay:1];
                }
            }
            
        });
    }
}

#pragma mark 下载失败
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"下载失败");
    if (error == nil) {
        NSLog(@"Task: %@ completed successfully", task);
    } else {
        NSLog(@"Task: %@ completed with error: %@", task, [error localizedDescription]);
        //暂停读取网速的定时器
        [time setFireDate:[NSDate distantFuture]];
        if([[error localizedDescription] isEqualToString:@"cancelled"]){
            [self.downloadTask cancel];
        }
        else{
            if(self.dataArray.count==0||self.dataArray==nil) return;
            //其他的，目前测试的只有，URL失效的时候，其余的有待验证
            RMPublicModel *model = [self.dataArray objectAtIndex:downLoadIndex];
            if(!isBeginDownLoadAllTask){
                model.downLoadState = @"下载失败";
            }
            [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
                model.cashData = resumeData;
            }];
            [self.downLoadIDArray removeObject:model];
            [self.mainTableView reloadData];
        }
        self.isDownLoadNow = NO;
        if(self.downLoadIDArray.count>0){
            [self performSelector:@selector(BeginDownLoad) withObject:self afterDelay:1];
            self.downLoadSpeed = 0;
            self.haveReadTheSchedule = 0;
            self.totalDownLoad = 0;
        }
        else{
            [self.downloadTask cancel];
            self.downloadTask = nil;
        }
    }
}

#pragma mark 下载完成做一下文件操作，转换为MP4文件，保存在document目录下
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.backgroundSessionCompletionHandler) {
        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
        appDelegate.backgroundSessionCompletionHandler = nil;
        completionHandler();
    }
    //    NSLog(@"下载完成第%ld个",(long)selectIndex);  //做一些文件处理
    if(downLoadIndex<self.dataArray.count){
        RMPublicModel *model = [self.dataArray objectAtIndex:downLoadIndex];
        model.downLoadState = @"下载完成";
        [self.mainTableView reloadData];
        if(self.downLoadIDArray.count<=0){
            [self.session invalidateAndCancel];
        }
    }
}

- (void)saveData{
    
    [time setFireDate:[NSDate distantFuture]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:downLoadIndex inSection:0];
    RMDownLoadingTableViewCell *cell = (RMDownLoadingTableViewCell *)[self.mainTableView cellForRowAtIndexPath:indexPath];
    RMPublicModel *model = [self.dataArray objectAtIndex:downLoadIndex];
    [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        NSLog(@"赋值");
        model.cashData = resumeData;
    }];
    self.downloadTask = nil;
    
    model.cacheProgress = [NSString stringWithFormat:@"%f",cell.progressView.progress];
    NSString *memory = cell.tatleProgressLable.text;
    if(![memory isEqualToString:@""]){
        NSRange range = [memory rangeOfString:@"/"];
        model.totalMemory = [memory substringFromIndex:range.location+1];
        model.alreadyCasheMemory = [memory substringToIndex:range.location];
    }else{
        model.totalMemory = @"0M";
        model.alreadyCasheMemory = @"0M";
        
    }
    for(int i=0;i<self.dataArray.count;i++){
        RMPublicModel *tmpModel = [self.dataArray objectAtIndex:i];
        tmpModel.downLoadState = @"暂停缓存";
    }
}

- (NSString *)setMemoryString:(NSString *)string{
    NSRange range = [string rangeOfString:@"M"];
    return [string substringToIndex:range.location];
}
//判断在dataArray中是否存在这个model
- (BOOL)dataArrayContainsModel:(RMPublicModel *)model{
    if(self.dataArray.count==0){
        NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:DownLoadDataArray_KEY];
        if(data==nil){
            return NO;
        }
        NSArray * SavedownLoad = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(SavedownLoad==nil){
            NSFileManager *fileManeger = [NSFileManager defaultManager];
            NSError *error ;
            NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSArray *array = [fileManeger contentsOfDirectoryAtPath:document error:&error];
            for(NSString *movieString in array){
                if([movieString rangeOfString:@".mp4"].location != NSNotFound){
                    NSLog(@"movieString:%@",movieString);
                    NSString *removePath = [NSString stringWithFormat:@"%@/%@",document,movieString];
                    NSError *removeError;
                    if([fileManeger removeItemAtPath:removePath error:&removeError]){
                        NSLog(@"删除成功");
                    }
                }
            }
        }
        for(RMPublicModel *model in SavedownLoad){
            [self.dataArray addObject:model];
        }
    }
    for (RMPublicModel *tmpModel in self.dataArray){
        if([tmpModel.name isEqualToString:model.name]){
            return YES;
        }
    }
    return NO;
}

- (void) setPauseAllOrStartAllBtnState{
    NSMutableArray *statusArr = [NSMutableArray array];
    for(RMPublicModel *model in self.dataArray){
        if([model.downLoadState isEqualToString:@"暂停缓存"]){
            [statusArr addObject:model];
        }
    }
    if(statusArr.count==self.dataArray.count){
        //全部开始
        [self.startOrPauseBtn setImage:[UIImage imageNamed:@"setup_downLoad_start"] forState:UIControlStateNormal];
        [self.startOrPauseBtn setTitle:@"全部开始" forState:UIControlStateNormal];
        isBeginDownLoadAllTask = YES;
    }
    else{
        //全部暂停
        [self.startOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"pause_all_downLoad_Image"] forState:UIControlStateNormal];
        [self.startOrPauseBtn setTitle:@"全部暂停" forState:UIControlStateNormal];
        isBeginDownLoadAllTask = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
