//
//  RMMoreAppViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMMoreAppViewController.h"
#import "RMMoreAPPTableViewCell.h"
#import "RMAFNRequestManager.h"
#import "Flurry.h"

@interface RMMoreAppViewController ()<RMMoreAPPTableViewCellDelegate,RMAFNRequestManagerDelegate>{
    NSMutableArray *dataArray;
    RMAFNRequestManager *requestManager;
    BOOL isFristDownLoad;
}

@end

@implementation RMMoreAppViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Flurry logEvent:@"VIEW_MoreApp" timed:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [Flurry endTimedEvent:@"VIEW_MoreApp" withParameters:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!isFristDownLoad){
        [self showLoadingSimpleWithUserInteractionEnabled:YES];
        requestManager = [[RMAFNRequestManager alloc] init];
        requestManager.delegate = self;
        [requestManager getMoreApp];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hideLoading];
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    rightBarButton.hidden = YES;
    [self setCustomNavTitle:@"更多应用"];
    dataArray = [[NSMutableArray alloc] init];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CELLIDENTIFIER";
    RMMoreAPPTableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMMoreAPPTableViewCell" owner:self options:nil] lastObject];
    }
    RMPublicModel *model = [dataArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.app_pic] placeholderImage:LOADIMAGE(@"60_60")];
    cell.titleLable.text = model.app_name;
    cell.openBtn.tag = indexPath.row;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.f;
}

- (void)cellBtnSelectWithIndex:(NSInteger)index{
    RMPublicModel *model = [dataArray objectAtIndex:index];
    NSURL *url = [NSURL URLWithString:model.ios];
    [[UIApplication sharedApplication] openURL:url];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestFinishiDownLoadWith:(NSMutableArray *)data{
    dataArray = data;
    [self.mainTableView reloadData];
    [self hideLoading];
}

@end
