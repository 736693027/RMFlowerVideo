//
//  RMSearchViewController.m
//  RMVideo
//
//  Created by runmobile on 14-10-13.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMSearchViewController.h"
#import "RMImageView.h"
#import "RMBaseTextField.h"
#import "RMSearchRecordsCell.h"
#import "RMCustomPresentNavViewController.h"
#import "RMTagList.h"
#import "RMLastRecordsCell.h"
#import "RefreshControl.h"
#import "CustomRefreshView.h"
#import "RMSearchResultCell.h"
#import "UIButton+EnlargeEdge.h"
#import "RMVideoPlaybackDetailsViewController.h"
#import "UITextField+LimitLength.h"
#import "RMRemoveAllObjectsCell.h"
#import "RMSearchStarView.h"
#import "RMPlayer.h"
#import "RMModel.h"
#import "RMLoadingWebViewController.h"

#define kMaxLength 20

typedef enum{
    requestSearchType = 1,                  //搜索
    requestDynamicAssociativeSearchType,    //动态联想搜索
    requestSearchRecommend                  //搜索推荐标签
}RequestManagerType;

@interface RMSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,SearchRecordsDelegate,LastRecordsDelegate,TagListDelegate,RefreshControlDelegate,SearchResultDelegate,RMAFNRequestManagerDelegate>{
    
    NSMutableArray * recordsDataArr;            //搜索记录的Arr
    NSMutableArray * resultDataArr;             //搜索结果的Arr
    NSMutableArray * searchRecommendArr;        //搜索推荐标签
    RequestManagerType requestManagerType;      //请求类型
    NSInteger pageCount;                        //分页
    BOOL isRefresh;                             //是否刷新
    BOOL isFirstAppearView;                     //判断是否第一次进入
}
@property (nonatomic, strong) UITableView * searchTableView;                        //默认搜索的tableView
@property (nonatomic, strong) UITableView * displayResultTableView;                 //搜索结果的tableView
@property (nonatomic, strong) RMSearchStarView * searchStarView;

@property (nonatomic, strong) RMBaseTextField * searchTextField;
@property (nonatomic, strong) RefreshControl * refreshControl;
@property (nonatomic, strong) RMAFNRequestManager * manager;

@property (nonatomic)         BOOL        isDisplayMoreRecords;         //是否显示 展开更多搜索记录
@property (nonatomic, strong) UIView      * footView;                   //tableView 的 footView
@property (nonatomic, strong) RMTagList   * tagList;                    //全网热榜推荐list
@property (nonatomic, strong) RMPublicModel *dataModel;

@end

@implementation RMSearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.searchTextField];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFirstAppearView){
        CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
        NSMutableArray * arr = [[NSMutableArray alloc] initWithArray:[storage objectForKey:UserSearchRecordData_KEY]];
        recordsDataArr = arr;
        if (recordsDataArr.count > 2){
            self.isDisplayMoreRecords = YES;
        }else{
            self.isDisplayMoreRecords = NO;
        }
        [self.searchTableView reloadData];
        [self.searchTextField becomeFirstResponder];
        isFirstAppearView = NO;
        [self startRequestSearchRecommend];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    
    recordsDataArr = [[NSMutableArray alloc] init];
    resultDataArr = [[NSMutableArray alloc] init];
    searchRecommendArr = [[NSMutableArray alloc] init];
    self.dataModel = [[RMPublicModel alloc] init];
    
    pageCount = 1;
    isRefresh = YES;
    self.manager = [[RMAFNRequestManager alloc] init];

    leftBarButton.hidden = YES;
    rightBarButton.hidden = YES;
    
    [self loadCustomNav];
    [self loadDefaultView];
    [self loadResultView];
    [self laodSearchStarView];
    isFirstAppearView = YES;
}

- (void)loadCustomNav {
    UIView * CustomNav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    CustomNav.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:CustomNav];
    
    UIView *roundBgView =[[UIView alloc] initWithFrame:CGRectMake(10, 24, ScreenWidth - 20 - 40, 32)];
    [[roundBgView layer] setBorderWidth:1.0];//画线的宽度
    [[roundBgView layer] setBorderColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor];//颜色
    roundBgView.userInteractionEnabled = YES;
    roundBgView.multipleTouchEnabled = YES;
    [[roundBgView layer]setCornerRadius:8.0];//圆角
    roundBgView.backgroundColor = [UIColor clearColor];
    [CustomNav addSubview:roundBgView];
    
    UIImageView * searchLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake(19, 33, 15, 15)];
    searchLeftImg.image = LOADIMAGE(@"search_userSearch");
    [CustomNav addSubview:searchLeftImg];
    
    UIButton * cleanSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cleanSearchBtn.frame = CGRectMake(ScreenWidth - 75, 33, 15, 15);
    [cleanSearchBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [cleanSearchBtn addTarget:self action:@selector(cleanSearchMethod) forControlEvents:UIControlEventTouchUpInside];
    [cleanSearchBtn setBackgroundImage:LOADIMAGE(@"search_userCancel") forState:UIControlStateNormal];
    [CustomNav addSubview:cleanSearchBtn];
    
    self.searchTextField = [[RMBaseTextField alloc] init];
    self.searchTextField.delegate = self;
    [self.searchTextField limitTextLength:kMaxLength];
    [[RMBaseTextField appearance] setTintColor:[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1]];
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    self.searchTextField.frame = CGRectMake(31, 16, ScreenWidth - 110, 50);
    self.searchTextField.placeholder = @"搜索你喜欢的视频或明星";
    [self.searchTextField setValue:[UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    self.searchTextField.font = FONT(16.0);
    self.searchTextField.backgroundColor = [UIColor clearColor];
    [CustomNav addSubview:self.searchTextField];
    
    UIButton * backupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backupBtn.frame = CGRectMake(ScreenWidth - 40, 32, 27, 15);
    [backupBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [backupBtn addTarget:self action:@selector(backupMethod) forControlEvents:UIControlEventTouchUpInside];
    [backupBtn setBackgroundImage:LOADIMAGE(@"search_cancel") forState:UIControlStateNormal];
    [CustomNav addSubview:backupBtn];
}

- (void)textFiledEditChanged:(NSNotification *)obj {
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    if (toBeString.length == 0){ //显示默认搜索界面
        self.searchTableView.hidden = NO;
        self.displayResultTableView.hidden = YES;
        self.searchStarView.hidden = YES;
    }else{ //显示搜索结果界面 启动联想搜索接口
        [self startDynamicAssociativeSearchRequest:textField.text];
    }
}

- (void)laodSearchStarView {
    if (!self.searchStarView){
        self.searchStarView = [[RMSearchStarView alloc] init];
        [self.view addSubview:self.searchStarView];
    }
    self.searchStarView.hidden = YES;
}

/**
 *  返回上一级
 */
- (void)backupMethod {
    [self.searchTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadResultView {
    self.displayResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.displayResultTableView.hidden = YES;
    self.searchStarView.hidden = YES;
    self.displayResultTableView.delegate = self;
    self.displayResultTableView.dataSource = self;
    self.displayResultTableView.backgroundColor = [UIColor clearColor];
    self.displayResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.displayResultTableView];
    
    self.refreshControl=[[RefreshControl alloc] initWithScrollView:self.displayResultTableView delegate:self];
    self.refreshControl.topEnabled=YES;
    self.refreshControl.bottomEnabled=YES;
    [self.refreshControl registerClassForTopView:[CustomRefreshView class]];
}

#pragma mark 刷新代理

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        isRefresh = YES;
        pageCount = 1;
        [self startSearchRequest:self.searchTextField.text];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        isRefresh = NO;
        pageCount ++;
        [self startSearchRequest:self.searchTextField.text];
    }
}

/**
 *  默认搜索界面
 */
- (void)loadDefaultView {
    self.searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.backgroundColor = [UIColor clearColor];
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.searchTableView];
}

/**
 *  默认搜索界面的FootView UI
 */
- (void)DefaultSearchFootViewWithRecommendArr:(NSMutableArray *)arr {
    self.footView = [[UIView alloc] init];
    self.footView.backgroundColor = [UIColor clearColor];
    self.footView.frame = CGRectMake(0, 0, ScreenWidth, 255); //176
    self.footView.userInteractionEnabled = YES;
    self.footView.multipleTouchEnabled = YES;
    
    UILabel * footTitle = [[UILabel alloc] init];
    footTitle.backgroundColor = [UIColor clearColor];
    footTitle.frame = CGRectMake(10, 10, 100, 30);
    footTitle.text = @"全网热榜";
    footTitle.textColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1];
    footTitle.font = FONT(20.0);
    [self.footView addSubview:footTitle];
    
    self.tagList = [[RMTagList alloc] initWithFrame:CGRectMake(10, 50.0f, ScreenWidth - 20, 176)];
    self.tagList.delegate = self;
    [self.tagList setTags:arr];
    [self.footView addSubview:self.tagList];
    self.searchTableView.tableFooterView = self.footView;
}

/**
 *  清空搜索内容
 */
- (void)cleanSearchMethod {
    self.searchTextField.text = @"";
    if (self.searchTextField.text.length == 0){ //显示默认搜索界面
        self.searchTableView.hidden = NO;
        self.displayResultTableView.hidden = YES;
        self.searchStarView.hidden = YES;
    }else{ //显示搜索结果界面 启动联想搜索接口
        [self startDynamicAssociativeSearchRequest:self.searchTextField.text];
    }
}

/**
 * 更新用户查询记录  并持久化数据
 */
- (void)updateUserSearchRecord:(NSString *)SearchRecord {
    if (SearchRecord.length == 0) {
        return;
    }
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
    [storage beginUpdates];
    NSString * userSearchRecord = [AESCrypt encrypt:SearchRecord password:PASSWORD];
    [recordsDataArr addObject:userSearchRecord];
    NSInteger i=0;
    NSInteger j=0;
    for(i=0; i<[recordsDataArr count]-1; i++){ //循环开始元素
        for(j=i+1;j <[recordsDataArr count]; j++){ //循环后续所有元素
            //如果相等，则重复
            if([[recordsDataArr objectAtIndex:i] isEqualToString:[recordsDataArr objectAtIndex:j]]){
                [recordsDataArr removeObjectAtIndex:i];
                i=0;
            }
        }
    }
    [storage setObject:recordsDataArr forKey:UserSearchRecordData_KEY];
    [storage endUpdates];
    
    NSArray* reversedArray = [[recordsDataArr reverseObjectEnumerator] allObjects];
    [recordsDataArr removeAllObjects];
    recordsDataArr = [NSMutableArray arrayWithArray:reversedArray];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchTextField resignFirstResponder];
}

/**
 *  点击键盘上的搜索按钮开始搜索
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([UtilityFunc isConnectionAvailable] == 0){
        [self showLoadingSimpleWithUserInteractionEnabled:YES];
        return NO;
    }else{
        if (self.searchTextField.text.length == 0){
            [self showMessage:@"搜索内容为空" duration:1.0 position:1 withUserInteractionEnabled:YES];
            return NO;
        }
        [self updateUserSearchRecord:textField.text];
        [self.searchTableView reloadData];
        [self startSearchRequest:textField.text];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchTextField resignFirstResponder];
}

/**
 *  点击全网热榜推荐标签的事件
 */
- (void)clickTagWithTitle:(NSString *)title {
    for (int i=0; i<[searchRecommendArr count]; i++){
        RMPublicModel * model = [searchRecommendArr objectAtIndex:i];
        if ([title isEqualToString:model.name]){
                if ([UtilityFunc isConnectionAvailable] == 0){
                    [self showMessage:@"当前网络信号不好" duration:1 position:1 withUserInteractionEnabled:YES];
            }else{
                self.searchTextField.text = title;
                [self updateUserSearchRecord:title];
                [self.searchTableView reloadData];
                [self startSearchRequest:title];
            }
        }
    }
}

/**
 *  根据标签刷新全网热榜界面的高度
 */
- (void)refreshTagListViewHeight:(float)height {
    [UIView animateWithDuration:0.2 animations:^{
        self.footView.frame = CGRectMake(0, 0, ScreenWidth, height + 85);
        self.searchTableView.tableFooterView = self.footView;
        self.tagList.frame = CGRectMake(10, 50.0f, ScreenWidth - 20, height + 20);
    }];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchTableView){
        if (recordsDataArr.count > 2){
            if (self.isDisplayMoreRecords){
                return 3;
            }else{
                return [recordsDataArr count] + 1;
            }
        }else{
            return [recordsDataArr count];
        }
    }else{
        return [resultDataArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchTableView){//默认搜索界面
        if (self.isDisplayMoreRecords){
            if (indexPath.row == 2){
                static NSString * CellIdentifier = @"RMLastSearchCellIdentifier";
                RMLastRecordsCell * cell = (RMLastRecordsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (! cell) {
                    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RMLastRecordsCell" owner:self options:nil];
                    cell = [array objectAtIndex:0];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.delegate = self;
                }
                return cell;
            }else{
                static NSString * CellIdentifier = @"RMSearchCellIdentifier";
                RMSearchRecordsCell * cell = (RMSearchRecordsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (! cell) {
                    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RMSearchRecordsCell" owner:self options:nil];
                    cell = [array objectAtIndex:0];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.delegate = self;
                }
                cell.clickbtn.tag = indexPath.row;
                cell.recordsName.text = [NSString stringWithFormat:@"%@",[AESCrypt decrypt:[recordsDataArr objectAtIndex:indexPath.row] password:PASSWORD]];
                return cell;
            }
        }else{
            if (indexPath.row == [recordsDataArr count]){
                static NSString * cellIdentifier = @"removeAllObjectsCellIdentifier";
                RMRemoveAllObjectsCell * cell = (RMRemoveAllObjectsCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (! cell) {
                    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RMRemoveAllObjectsCell" owner:self options:nil];
                    cell = [array objectAtIndex:0];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    cell.backgroundColor = [UIColor whiteColor];
                }
                return cell;
            }else{
                static NSString * CellIdentifier = @"RMSearchCellIdentifier";
                RMSearchRecordsCell * cell = (RMSearchRecordsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (! cell) {
                    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RMSearchRecordsCell" owner:self options:nil];
                    cell = [array objectAtIndex:0];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.delegate = self;
                }
                cell.clickbtn.tag = indexPath.row;
                cell.recordsName.text = [NSString stringWithFormat:@"%@",[AESCrypt decrypt:[recordsDataArr objectAtIndex:indexPath.row] password:PASSWORD]];
                return cell;
            }
        }
    }else{//显示搜索结果   或者  显示动态搜索结果
        if (requestManagerType == requestSearchType){
            static NSString * CellIdentifier = @"RMSearchResultCellIdentifier";
            RMSearchResultCell * cell = (RMSearchResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (! cell) {
                NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RMSearchResultCell" owner:self options:nil];
                cell = [array objectAtIndex:0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.backgroundColor = [UIColor clearColor];
                cell.delegate = self;
            }
            cell.DirectBroadcastBtn.tag = [[[resultDataArr objectAtIndex:indexPath.row] objectForKey:@"video_id"] integerValue];
            [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[[resultDataArr objectAtIndex:indexPath.row] objectForKey:@"pic"]] placeholderImage:LOADIMAGE(@"92_138")];
            cell.name.text = [[resultDataArr objectAtIndex:indexPath.row] objectForKey:@"name"];
            [cell setNameWithString:[[resultDataArr objectAtIndex:indexPath.row] objectForKey:@"name"]];
            cell.scoreName.text = [[resultDataArr objectAtIndex:indexPath.row] objectForKey:@"gold"];
            cell.hits.text = [NSString stringWithFormat:@"点播放:%@",[[resultDataArr objectAtIndex:indexPath.row] objectForKey:@"hits"]];

            if ([[[resultDataArr objectAtIndex:indexPath.row] objectForKey:@"video_type"] integerValue] == 3){//综艺
                cell.mainActor.hidden = YES;
                cell.director.text = [NSString stringWithFormat:@"主持人:%@",[[resultDataArr objectAtIndex:indexPath.row] objectForKey:@"presenters"]];
                [cell setOtherVarietyAutomaticAdaptation];
            }else{//电影 电视剧
                cell.mainActor.text = [NSString stringWithFormat:@"主演:%@",[[resultDataArr objectAtIndex:indexPath.row] objectForKey:@"actors"]];
                cell.director.text = [NSString stringWithFormat:@"导演:%@",[[resultDataArr objectAtIndex:indexPath.row] objectForKey:@"directors"]];
                [cell setOtherAutomaticAdaptation];
            }
            return cell;
        }else{
            static NSString * CellIdentifier = @"RMDynamicAssociativeCellIdentifier";
            UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (! cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.backgroundColor = [UIColor clearColor];
            }
            RMPublicModel * model = [resultDataArr objectAtIndex:indexPath.row];
            cell.textLabel.text = model.name;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchTableView){
        return 44;
    }else{
        if (requestManagerType == requestSearchType){
            return 155;
        }else{
            return 44;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchTableView){
        if ([UtilityFunc isConnectionAvailable] == 0){
            return ;
        }
        if (indexPath.row == [recordsDataArr count]){
            [self deleteAllSearchRecordsMethod];
        }else{
            NSString * str = [NSString stringWithFormat:@"%@",[AESCrypt decrypt:[recordsDataArr objectAtIndex:indexPath.row] password:PASSWORD]];
            [self updateUserSearchRecord:str];
            [self.searchTableView reloadData];
            self.searchTextField.text = str;
            [self startSearchRequest:str];
        }
    }else{
        if (requestManagerType == requestSearchType){ //目标搜索
            RMVideoPlaybackDetailsViewController * videoPlaybackDetailsCtl = [[RMVideoPlaybackDetailsViewController alloc] init];
            if ([[[resultDataArr objectAtIndex:indexPath.row] objectForKey:@"video_type"] isEqualToString:@"1"]){
                videoPlaybackDetailsCtl.segVideoType = @"电影";
            }else{
                videoPlaybackDetailsCtl.segVideoType = @"电视剧";
            }
            videoPlaybackDetailsCtl.video_id = [[resultDataArr objectAtIndex:indexPath.row] objectForKey:@"video_id"];
            [self presentViewController:videoPlaybackDetailsCtl animated:YES completion:^{
            }];
        }else{ //联想搜索
            RMPublicModel * model = [resultDataArr objectAtIndex:indexPath.row];
            [self updateUserSearchRecord:model.name];
            [self.searchTableView reloadData];
            [self startSearchRequest:model.name];
        }
    }
}

/**
 *  直接播放 事件
 */
- (void)DirectBroadcastMethodWithValue:(NSInteger)value {
    for (NSInteger i=0; i<[resultDataArr count]; i++){
        if ([[[resultDataArr objectAtIndex:i] objectForKey:@"video_id"] integerValue] == value){
            if ([[[resultDataArr objectAtIndex:i] objectForKey:@"video_type"] isEqualToString:@"1"]){
                NSString* pathExtention = [[[[resultDataArr objectAtIndex:i] objectForKey:@"urls"] objectForKey:@"m_down_url"] pathExtension];
                if([pathExtention isEqualToString:@"mp4"]) {
                    RMModel *_model = [[RMModel alloc] init];
                    _model.url = [[[resultDataArr objectAtIndex:i] objectForKey:@"urls"] objectForKey:@"m_down_url"];
                    _model.title = [[resultDataArr objectAtIndex:i] objectForKey:@"name"];
                    [RMPlayer presentVideoPlayerWithPlayModel:_model withUIViewController:self withVideoType:1 withIsLocationVideo:NO];
                }else{
                    RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
                    loadingWebCtl.name = [[resultDataArr objectAtIndex:i] objectForKey:@"name"];
                    loadingWebCtl.loadingUrl = [[[resultDataArr objectAtIndex:i] objectForKey:@"urls"] objectForKey:@"jumpurl"];
                    [self presentViewController:loadingWebCtl animated:YES completion:^{
                    }];
                }
                break;
            }else{
                NSString* pathExtention = [[[[[resultDataArr objectAtIndex:i] objectForKey:@"urls"] objectAtIndex:0] objectForKey:@"m_down_url"] pathExtension];
                if([pathExtention isEqualToString:@"mp4"]) {
                    RMModel *_model = [[RMModel alloc] init];
                    _model.url = [[[[resultDataArr objectAtIndex:i] objectForKey:@"urls"] objectAtIndex:0] objectForKey:@"m_down_url"];
                    _model.title = [[resultDataArr objectAtIndex:i] objectForKey:@"name"];
                    [RMPlayer presentVideoPlayerWithPlayModel:_model withUIViewController:self withVideoType:1 withIsLocationVideo:NO];
                }else{
                    RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
                    loadingWebCtl.name = [[resultDataArr objectAtIndex:i] objectForKey:@"name"];
                    loadingWebCtl.loadingUrl = [[[[resultDataArr objectAtIndex:i] objectForKey:@"urls"] objectAtIndex:0] objectForKey:@"jumpurl"];
                    [self presentViewController:loadingWebCtl animated:YES completion:^{
                    }];
                }
                break;
            }
        }
    }
}

/**
 *  删除单个搜索记录
 */
- (void)deleteSearchRecordsMethod:(NSInteger)value {
    [recordsDataArr removeObjectAtIndex:value];
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:value inSection:0];
//    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
//    [self.searchTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
    NSMutableArray * arr = [[NSMutableArray alloc] initWithArray:[storage objectForKey:UserSearchRecordData_KEY]];
    [arr removeObjectAtIndex:value];
    [storage beginUpdates];
    [storage setObject:arr forKey:UserSearchRecordData_KEY];
    [storage endUpdates];
    [self.searchTableView reloadData];
}

/**
 *  删除全部搜索记录
 */
- (void)deleteAllSearchRecordsMethod {
    [recordsDataArr removeAllObjects];
    CUSFileStorage *storage = [CUSFileStorageManager getFileStorage:CURRENTENCRYPTFILE];
    NSMutableArray * arr = [[NSMutableArray alloc] initWithArray:[storage objectForKey:UserSearchRecordData_KEY]];
    [arr removeAllObjects];
    [storage beginUpdates];
    [storage setObject:arr forKey:UserSearchRecordData_KEY];
    [storage endUpdates];
    [self.searchTableView reloadData];
}

/**
 *  多于两个搜索记录的时候，显示更多搜索记录
 */
- (void)moreRecordsMethod {
    self.isDisplayMoreRecords = NO;
    [self.searchTableView reloadData];
}

#pragma mark - requset RMAFNRequestManagerDelegate

/**
 *  搜索推荐标签
 */
- (void)startRequestSearchRecommend {
    requestManagerType = requestSearchRecommend;
    self.manager.delegate = self;
    [self.manager getSearchRecommend];
}

/**
 *  动态联想搜索
 */
- (void)startDynamicAssociativeSearchRequest:(NSString *)key {
    requestManagerType = requestDynamicAssociativeSearchType;
    self.manager.delegate = self;
    [self.manager getSearchTipsWithWork:key];
}

/**
 *  目标搜索
 */
- (void)startSearchRequest:(NSString *)key {
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
    [self.searchTextField resignFirstResponder];
    requestManagerType = requestSearchType;
    self.manager.delegate = self;
    [self.manager searchWithKeyword:key Page:[NSString stringWithFormat:@"%ld",(long)pageCount]];
}

- (void)requestFinishiDownLoadWithModel:(RMPublicModel *)model {
    self.dataModel = model;
    if ([self.dataModel.star_list count] == 0){ //明星列表为空 普通视频列表
        self.refreshControl.topEnabled = YES;
        self.refreshControl.bottomEnabled = YES;
        self.searchTableView.hidden = YES;
        self.displayResultTableView.hidden = NO;
        if (isRefresh){
            [resultDataArr removeAllObjects];
            for (NSInteger i=0; i<[self.dataModel.video_list count]; i++){
                [resultDataArr addObject:[self.dataModel.video_list objectAtIndex:i]];
            }
            [self.displayResultTableView reloadData];
            [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
        }else{
            for (NSInteger i=0; i<[self.dataModel.video_list count]; i++){
                [resultDataArr addObject:[self.dataModel.video_list objectAtIndex:i]];
            }
            [self.displayResultTableView reloadData];
            [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        }
        [self hideLoading];
    }else{  //有明星  也有对应下的视频列表
        self.searchTableView.hidden = YES;
        self.displayResultTableView.hidden = YES;
        self.searchStarView.hidden = NO;
        self.searchStarView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
        self.searchStarView.dataModel = self.dataModel;
        [self.searchStarView initSearchStarView:self];
    }
    [self hideLoading];
}

- (void)requestFinishiDownLoadWith:(NSMutableArray *)data {
    if (requestManagerType == requestSearchType){ //目标搜索
        //Ignore this method
    }else if (requestManagerType == requestSearchRecommend){ //搜索推荐标签
        searchRecommendArr = [NSMutableArray arrayWithArray:data];
        NSMutableArray * recommendArr = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<searchRecommendArr.count; i++) {
            RMPublicModel * model = [searchRecommendArr objectAtIndex:i];
            [recommendArr addObject:model.name];
        }
        [self DefaultSearchFootViewWithRecommendArr:recommendArr];
    }else{ //联想搜索
        self.refreshControl.topEnabled = NO;
        self.refreshControl.bottomEnabled = NO;
        self.searchTableView.hidden = YES;
        self.displayResultTableView.hidden = NO;
        self.searchStarView.hidden = YES;
        resultDataArr = [NSMutableArray arrayWithArray:data];
        [self.displayResultTableView reloadData];
    }
    [self hideLoading];
}

- (void)requestError:(NSError *)error {
    NSLog(@"error:%@",error);
    [self hideLoading];
}

@end
