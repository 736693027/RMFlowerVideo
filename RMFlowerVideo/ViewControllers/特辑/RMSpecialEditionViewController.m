//
//  RMMyChannelViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 14-12-30.
//  Copyright (c) 2014年 润滑联动. All rights reserved.
//

#import "RMSpecialEditionViewController.h"
#import "RMSpecialEditionDetailViewController.h"
#import "RMSpecialEditionCell.h"
#import "RefreshControl.h"
#import "CustomRefreshView.h"

@interface RMSpecialEditionViewController ()<UITableViewDataSource,UITableViewDelegate,RMSpecialEditionCellDelegate,RMAFNRequestManagerDelegate,RefreshControlDelegate>{
    UITableView * mTableView;
    NSInteger pageCount;
    BOOL isRefresh;
    BOOL isFirstViewAppear;
    BOOL isLoadComplete;
    RMAFNRequestManager * manager;
    NSMutableArray * dataArr;
}
@property (nonatomic, strong) RefreshControl * refreshControl;

@end

@implementation RMSpecialEditionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstViewAppear){
        [self startRequest];
        isFirstViewAppear = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomNavTitle:@"特辑"];
    dataArr = [[NSMutableArray alloc] init];
    manager = [[RMAFNRequestManager alloc] init];

    leftBarButton.hidden = YES;
    rightBarButton.hidden = YES;
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - TabBarHeight - NavBarHeight - 20) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];

    self.refreshControl=[[RefreshControl alloc] initWithScrollView:mTableView delegate:self];
    self.refreshControl.topEnabled=YES;
    self.refreshControl.bottomEnabled=YES;
    [self.refreshControl registerClassForTopView:[CustomRefreshView class]];
    
    pageCount = 1;
    isFirstViewAppear = YES;
    isRefresh = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(dataArr.count%3==0)
        return dataArr.count/3;
    else
        return dataArr.count/3+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"RMSpecialEditionCellIdentifier";
    RMSpecialEditionCell *cell = [mTableView dequeueReusableCellWithIdentifier:cellName];
    NSString *imageString = @"SpecialEditionCell_BG_Image";
    if(cell==nil){
        if(IS_IPHONE_6_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMSpecialEditionCell_6" owner:self options:nil] lastObject];
            imageString = @"SpecialEditionCell_BG_Image_6";
        }else if (IS_IPHONE_6p_SCREEN){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMSpecialEditionCell_6p" owner:self options:nil] lastObject];
            imageString = @"SpecialEditionCell_BG_Image_6p";
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMSpecialEditionCell" owner:self options:nil] lastObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    if(indexPath.row*3<dataArr.count){
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3];
        [cell.firstImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.firstImage.identifierString = model.tag_id;
        cell.firstName.text = model.name;
        [cell.fristBackImage setImage:[UIImage imageNamed:imageString]];
    }
    if(indexPath.row*3+1<dataArr.count){
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3+1];
        [cell.secondImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.secondImage.identifierString = model.tag_id;
        cell.secondName.text = model.name;
        [cell.secondBackImage setImage:[UIImage imageNamed:imageString]];
    }
    if(indexPath.row*3+2<dataArr.count){
        RMPublicModel *model = [dataArr objectAtIndex:indexPath.row*3+2];
        [cell.thirdImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.thirdImage.identifierString = model.tag_id;
        cell.thirdName.text = model.name;
        [cell.thridBackImage setImage:[UIImage imageNamed:imageString]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(IS_IPHONE_6_SCREEN){
        return 204;
    }
    else if (IS_IPHONE_6p_SCREEN){
        return 224;
    }
    return 185;
}

- (void)specialEditionCellMethodWithImage:(RMImageView *)imageView {
    for (NSInteger i=0; i<dataArr.count; i++) {
        RMPublicModel * model = [dataArr objectAtIndex:i];
        if ([imageView.identifierString isEqualToString:model.tag_id]){
            RMSpecialEditionDetailViewController *specialEditionDetailCtl = [[RMSpecialEditionDetailViewController alloc] init];
            specialEditionDetailCtl.customTitle = model.name;
            specialEditionDetailCtl.tag_id = imageView.identifierString;
            [self.navigationController pushViewController:specialEditionDetailCtl animated:YES];
        }else{
            NSLog(@"没有找到对应特辑");
        }
    }
}
#pragma mark 刷新代理

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction {
    if (direction == RefreshDirectionTop) { //下拉刷新
        pageCount = 1;
        isRefresh = YES;
        isLoadComplete = NO;
        [self startRequest];
    }else if(direction == RefreshDirectionBottom) { //上拉加载
        if (isLoadComplete){
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.44 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self showMessage:@"没有内容加载了" duration:1.0 position:1 withUserInteractionEnabled:YES];
                [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            });
        }else{
            pageCount ++;
            isRefresh = NO;
            [self startRequest];
        }
    }
}

#pragma mark - 请求

- (void)startRequest {
    [self showLoadingSimpleWithUserInteractionEnabled:YES];
    manager.delegate = self;
    [manager getSpecialTagWithPage:[NSString stringWithFormat:@"%ld",(long)pageCount]];
}

- (void)requestFinishiDownLoadWith:(NSMutableArray *)data {
    if (self.refreshControl.refreshingDirection==RefreshingDirectionTop) {
        [dataArr removeAllObjects];
        for (NSInteger i=0; i<data.count; i++) {
            RMPublicModel * model = [data objectAtIndex:i];
            [dataArr addObject:model];
        }
        [mTableView reloadData];
        [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }else if(self.refreshControl.refreshingDirection==RefreshingDirectionBottom) {
        if (data.count == 0){
            [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
            [self hideLoading];
            isLoadComplete = YES;
            return;
        }
        for (NSInteger i=0; i<data.count; i++) {
            RMPublicModel * model = [data objectAtIndex:i];
            [dataArr addObject:model];
        }
        [mTableView reloadData];
        [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    }
    
    if (isRefresh){
        [dataArr removeAllObjects];
        for (NSInteger i=0; i<data.count; i++) {
            RMPublicModel * model = [data objectAtIndex:i];
            [dataArr addObject:model];
        }
        [mTableView reloadData];
    }
    [self hideLoading];
}

- (void)requestFinishiDownLoadWithModel:(RMPublicModel *)model {
    //To ignore this method
}

- (void)requestError:(NSError *)error {
    [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
    [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    [self hideLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
