//
//  RMMoreViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 14-12-30.
//  Copyright (c) 2014年 润滑联动. All rights reserved.
//

#import "RMSetViewController.h"
#import "RMSetUpCell.h"
#import "UIButton+EnlargeEdge.h"
#import "SDImageCache.h"
#import "UMSocial.h"
#import "RMLoginViewController.h"
#import "RMCustomPresentNavViewController.h"

typedef enum{
    kRMDefault = 100,
    kRMMyCache = 0,
    kRMMyCollection = 1,
    kRMWatchRecord = 2,
    kRMFeedBack = 5,
    kRMAbout = 6,
    kRMMoreApp = 7,
}GotoViewControllerName;

@interface RMSetViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView * mTableView;
    NSArray * imageArr;
    NSArray * nameArr;
    UILabel * userName;
    UIButton *exitBtn;
    UIImageView * userHeader;
}

@end

@implementation RMSetViewController

- (void)viewDidAppear:(BOOL)animated{
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
    NSString * loginStatus = [AESCrypt decrypt:[storage objectForKey:LoginStatus_KEY] password:PASSWORD];
    if([loginStatus isEqualToString:@"islogin"]){
        NSDictionary *userIofn = [storage objectForKey:UserLoginInformation_KEY];
        userName.text = [userIofn objectForKey:@"userName"];
        [userHeader sd_setImageWithURL:[NSURL URLWithString:[userIofn objectForKey:@"userIconUrl"]] placeholderImage:LOADIMAGE(@"setup_head")];
        userName.textColor = [UIColor blackColor];
        [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    }else{
        userName.text = @"小花视频";
        userName.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        [exitBtn setTitle:@"登录" forState:UIControlStateNormal];
        userHeader.image = LOADIMAGE(@"setup_head");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomNavTitle:@"设置"];
    
    leftBarButton.hidden = YES;
    rightBarButton.hidden = YES;
    
    imageArr = [[NSArray alloc] initWithObjects:@"setup_cache", @"setup_collection", @"setup_record", @"setup_clearCache", @"setup_score", @"setup_feedback", @"setup_about", @"setup_moreApp", nil];
    nameArr = [[NSArray alloc] initWithObjects:@"我的缓存", @"我的收藏", @"观看记录", @"清理缓存", @"给小花视频评分", @"用户反馈", @"关于", @"更多应用", nil];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64-49) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
    
    [self initUserView];
}

- (void)initUserView {
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 95)];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.userInteractionEnabled = YES;
    headerView.multipleTouchEnabled = YES;
    
    UIView *clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 20, 10)];
    clearView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:clearView];
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 85)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    bgView.multipleTouchEnabled = YES;
    [headerView addSubview:bgView];
    
    userHeader = [[UIImageView alloc] initWithFrame:CGRectMake(11, 22, 45, 45)];
    userHeader.layer.masksToBounds = YES;
    userHeader.layer.cornerRadius = 22.5;
    userHeader.userInteractionEnabled = YES;
    [bgView addSubview:userHeader];
    
    userName = [[UILabel alloc] initWithFrame:CGRectMake(67, 30, 150, 30)];
    userName.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [bgView addSubview:userName];
    
    exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(ScreenWidth - 71, 30, 40, 30);
    [exitBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [exitBtn setTitleColor:[UIColor colorWithRed:0.88 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(loginOrExitMethod) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:exitBtn];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(10, 84, ScreenWidth - 40, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    [bgView addSubview:line];
    
    mTableView.tableHeaderView = headerView;
}

- (void)loginOrExitMethod {
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
    NSString * loginStatus = [AESCrypt decrypt:[storage objectForKey:LoginStatus_KEY] password:PASSWORD];
    if([loginStatus isEqualToString:@"islogin"]){
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
            NSLog(@"response is %@",response);
        }];
        [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToTencent completion:^(UMSocialResponseEntity *respose){
            NSLog(@"get openid  response is %@",respose);
        }];
        [storage beginUpdates];
        NSString * loginStatus = [AESCrypt encrypt:@"notlogin" password:PASSWORD];
        [storage setObject:loginStatus forKey:LoginStatus_KEY];
        [storage endUpdates];
        userName.text = @"小花视频";
        userName.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        [exitBtn setTitle:@"登录" forState:UIControlStateNormal];
        userHeader.image = LOADIMAGE(@"setup_head");
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:nil forKey:@"userName"];
        [dict setValue:nil forKey:@"userIconUrl"];
        [dict setValue:nil forKey:@"token"];
        CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
        [storage setObject:dict forKey:UserLoginInformation_KEY];
        
    }else{
        RMLoginViewController *loginCtl = [[RMLoginViewController alloc] init];
        RMCustomPresentNavViewController *loginNav = [[RMCustomPresentNavViewController alloc] initWithRootViewController:loginCtl];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        [self presentViewController:loginNav animated:YES completion:^{
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [nameArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"RMSetUpCellIdentifier";
    RMSetUpCell * cell = (RMSetUpCell *)[mTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        NSArray *array;
        array = [[NSBundle mainBundle] loadNibNamed:@"RMSetUpCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row != 3){
        cell.cacheTitle.hidden = YES;
    }else{
        cell.arrow.hidden = YES;
        float tmpSize = [[SDImageCache sharedImageCache] getSize];
        NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize/1024.0/1024.0] : [NSString stringWithFormat:@"0.0M"];
        cell.cacheTitle.text = clearCacheName;
    }
    if(indexPath.row == nameArr.count-1)
        cell.line.hidden = YES;
    NSString * image = [NSString stringWithFormat:@"%@",[imageArr objectAtIndex:indexPath.row]];
    cell.head.image = LOADIMAGE(image);
    cell.setupTitle.text = [nameArr objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3){
        [self showMessage:@"清理中..." duration:2 withUserInteractionEnabled:YES];
        [self performSelector:@selector(clearImageMemory) withObject:nil afterDelay:1];
    }else if (indexPath.row == 4){
        NSString *evaluateString = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/r-evolve/id%@?mt=8",kAppleId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
    }else {
        id controller = nil;
        NSString* className = [self getModuleClassNameWithIndexRow:indexPath.row];
        if (className && className.length > 0) {
            Class class = NSClassFromString(className);
            controller = [[class alloc] init];
        }
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)clearImageMemory {
    NSLog(@"清理之前个数----%lu",(unsigned long)[[SDImageCache sharedImageCache] getDiskCount]);
    [[SDImageCache sharedImageCache] clearDisk];
    NSLog(@"清理之后个数----%lu",(unsigned long)[[SDImageCache sharedImageCache] getDiskCount]);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    RMSetUpCell *cell = (RMSetUpCell *)[mTableView cellForRowAtIndexPath:indexPath];
    float tmpSize = [[SDImageCache sharedImageCache] getSize];
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize/1024.0/1024.0] : [NSString stringWithFormat:@"0.0M"];
    cell.cacheTitle.text = clearCacheName;
}

- (NSString *)getModuleClassNameWithIndexRow:(NSInteger)row {
    NSString* viewControllerName = nil;
    switch (row) {
        case kRMDefault:
        case kRMMyCache:
            viewControllerName = @"RMMyCacheViewController";
            break;
        case kRMMyCollection:
            viewControllerName = @"RMMyCollectionViewController";
            break;
        case kRMWatchRecord:
            viewControllerName = @"RMWatchRecordViewController";
            break;
        case kRMFeedBack:
            viewControllerName = @"RMFeedBackViewController";
            break;
        case kRMAbout:
            viewControllerName = @"RMAboutViewController";
            break;
        case kRMMoreApp:
            viewControllerName = @"RMMoreAppViewController";
            break;

        default:
            break;
    }
    return viewControllerName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
