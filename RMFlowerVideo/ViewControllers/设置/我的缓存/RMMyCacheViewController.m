//
//  RMMyCacheViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMMyCacheViewController.h"
#import "RMDownLoadingViewController.h"
#import "RMFinishDownLoadViewController.h"
#import "RMSegmentedController.h"

@interface RMMyCacheViewController ()<SwitchSelectedMethodDelegate>{
    RMDownLoadingViewController *downLoadingCtl;
    RMFinishDownLoadViewController *finishedCtl;
    RMSegmentedController *segmentedCtl;
    int selectViewControIndex;  //标示当前是那个控制器，1--已缓存的控制器  2--缓存中的控制器
    BOOL isSelectAllCells; //是否全选 
}

@end

@implementation RMMyCacheViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self switchSelectedMethodWithValue:(int)self.selectIndex withTitle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upDataMemory];
    // Do any additional setup after loading the view from its nib.
    [self setCustomNavTitle:@"我的缓存"];
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    [rightBarButton setBackgroundImage:LOADIMAGE(@"nav_editing_btn") forState:UIControlStateNormal];
    selectViewControIndex = -1;
    NSArray * nameArr = [[NSMutableArray alloc] initWithObjects:@"已缓存", @"缓存中", nil];
    segmentedCtl = [[RMSegmentedController alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 43) withSectionTitles:@[[nameArr objectAtIndex:0], [nameArr objectAtIndex:1]] withIdentifierType:@"我的缓存" withLineEdge:6 withAddLine:NO];
    segmentedCtl.delegate = self;
    [segmentedCtl setSelectedIndex:self.selectIndex];
    [segmentedCtl setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]];
    [segmentedCtl setTextColor:[UIColor clearColor]];
    [segmentedCtl setSelectionIndicatorColor:[UIColor clearColor]];
    [self.view addSubview:segmentedCtl];
    if (! finishedCtl){
        finishedCtl = [[RMFinishDownLoadViewController alloc] init];
    }
    [finishedCtl didSelectTableViewCell:^(NSMutableArray *selectArray) {
        if(selectArray.count==0){
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1] forState:UIControlStateNormal];
            isSelectAllCells = YES;
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }else{
            if(selectArray.count == finishedCtl.dataArray.count){
                isSelectAllCells = NO;
                [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
            }else{
                isSelectAllCells = YES;
                [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            }
            [deleteBtn setTitle:[NSString stringWithFormat:@"删除（%d）",(int)selectArray.count] forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
        }
        
    }];
    [finishedCtl tableViewcommitEditing:^(NSMutableArray *commitArray) {
        if(finishedCtl.dataArray.count>0) return;
        if(commitArray.count==0) rightBarButton.hidden = YES;
        [self upDataMemory];
    }];
    if (! downLoadingCtl){
        downLoadingCtl = [[RMDownLoadingViewController shared] init];
    }
    [downLoadingCtl didSelectTableViewCell:^(NSMutableArray *selectArray) {
        if(selectArray.count==0){
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1] forState:UIControlStateNormal];
            isSelectAllCells = YES;
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            
        }else{
            if(selectArray.count == finishedCtl.dataArray.count){
                isSelectAllCells = NO;
                [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
            }
            else{
                isSelectAllCells = YES;
                [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            }
            [deleteBtn setTitle:[NSString stringWithFormat:@"删除（%d）",(int)selectArray.count] forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
        }
    }];
    [downLoadingCtl tableViewcommitEditing:^(NSMutableArray *commitArray) {
        if(downLoadingCtl.dataArray.count>0) return;
        if(commitArray.count==0) rightBarButton.hidden = YES;
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadSuccessUpdate) name:@"DownLoadSuccess" object:nil];
}

- (void)downLoadSuccessUpdate{
    [self upDataMemory];
}

- (void)switchSelectedMethodWithValue:(int)value withTitle:(NSString *)title {
    isSelectAllCells = YES;
    if(value==selectViewControIndex) return;
    selectViewControIndex = value;
    switch (value) {
        case 0:{
            finishedCtl.view.hidden = NO;
            downLoadingCtl.view.hidden = YES;
            [finishedCtl getDataFrameDataBase];
            //若跳转已缓存界面的时候，需要先关闭缓存中界面的编辑状态
            if(isEditing){
                [self setRightBarBtnItemImageWith:isEditing];
                [downLoadingCtl endEditingTableViewCell];
                [downLoadingCtl selectAllTableViewWithState:NO];
                isEditing = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    btnView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
                    downLoadingCtl.view.frame = CGRectMake(0, 107, ScreenWidth, ScreenHeight-107-24);
                }];
            }
            [finishedCtl.mainTableView setEditing:NO animated:YES];
            finishedCtl.view.frame = CGRectMake(0, 107, ScreenWidth, ScreenHeight-107-24);
            finishedCtl.delegete = self;
            [self.view addSubview:finishedCtl.view];
            [self setRightBarBtnItemState];
            break;
        }
        case 1:{
            finishedCtl.view.hidden = YES;
            downLoadingCtl.view.hidden = NO;
            //若跳转缓存中界面的时候，需要先关闭已缓存界面的编辑状态
            if(isEditing){
                [self setRightBarBtnItemImageWith:isEditing];
                [finishedCtl endEditingTableViewCell];
                [finishedCtl selectAllTableViewWithState:NO];   
                isEditing = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    btnView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
                    finishedCtl.view.frame = CGRectMake(0, 107, ScreenWidth, ScreenHeight-107-24);
                }];
            }
            [downLoadingCtl.mainTableView setEditing:NO animated:YES];
            downLoadingCtl.view.frame = CGRectMake(0, 107, ScreenWidth, ScreenHeight-107-24);
            downLoadingCtl.delegete = self;
            [self.view addSubview:downLoadingCtl.view];
            [self setRightBarBtnItemState];
            break;
        }
            
        default:
            break;
    }
}

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender {
    [self setRightBarBtnItemImageWith:isEditing];
    switch (sender.tag) {
        case 1:{
            if(isEditing){
                [[NSNotificationCenter defaultCenter] postNotificationName:kEndEditingTableViewCell object:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 2:{
            if(!isEditing){
                [UIView animateWithDuration:0.5 animations:^{
                    btnView.frame = CGRectMake(0, ScreenHeight-49, ScreenWidth, 49);
                    finishedCtl.view.frame = CGRectMake(0, 107, ScreenWidth, ScreenHeight-107-49);
                    downLoadingCtl.view.frame = CGRectMake(0, 107, ScreenWidth, ScreenHeight-107-49);
                    //弹出
                    if(selectViewControIndex==0){
                        [finishedCtl beginEditingTableViewCell];
                    }
                    else{
                        [downLoadingCtl beginEditingTableViewCell];
                    }
                }];
            }
            else{
                [UIView animateWithDuration:0.5 animations:^{
                    btnView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
                    finishedCtl.view.frame = CGRectMake(0, 107, ScreenWidth, ScreenHeight-107-24);
                    downLoadingCtl.view.frame = CGRectMake(0, 107, ScreenWidth, ScreenHeight-107-24);
                    //收回
                    if(selectViewControIndex==0){
                        [finishedCtl endEditingTableViewCell];
                    }
                    else{
                        [downLoadingCtl endEditingTableViewCell];

                    }

                }];
            }
            isEditing = !isEditing;
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1] forState:UIControlStateNormal];
            isSelectAllCells = YES;
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            break;
        }
            
        default:
            break;
    }
}
#pragma mark 全选/删除
- (void)EditingViewBtnClick:(UIButton *)sender{
    if(sender == selectAllBtn){
        if(selectViewControIndex==0){
            [finishedCtl selectAllTableViewWithState:isSelectAllCells];
            if(isSelectAllCells){
                [deleteBtn setTitle:[NSString stringWithFormat:@"删除（%d）",(int)finishedCtl.dataArray.count] forState:UIControlStateNormal];
                [deleteBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
                [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
            }
            else{
                [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
                [deleteBtn setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1] forState:UIControlStateNormal];
                [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            }
        }else{
            if(isSelectAllCells){
                [deleteBtn setTitle:[NSString stringWithFormat:@"删除（%d）",(int)downLoadingCtl.dataArray.count] forState:UIControlStateNormal];
                [deleteBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
                [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
            }
            else{
                [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
                [deleteBtn setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1] forState:UIControlStateNormal];
                [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            }
            [downLoadingCtl selectAllTableViewWithState:isSelectAllCells];
        }
        isSelectAllCells = !isSelectAllCells;
    }
    else{
        if(isEditing){
            if(selectViewControIndex==0){
                [finishedCtl deleteDidSelectCell];
                [self upDataMemory];
            }else{
                [downLoadingCtl deleteDidSelectCell];
            }
            [self setRightBarBtnItemState];
            isEditing = NO;
            [self setRightBarBtnItemImageWith:YES];
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1] forState:UIControlStateNormal];
            isSelectAllCells = YES;
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5 animations:^{
                btnView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
                finishedCtl.view.frame = CGRectMake(0, 107, ScreenWidth, ScreenHeight-107-24);
                downLoadingCtl.view.frame = CGRectMake(0, 107, ScreenWidth, ScreenHeight-107-24);
            }];
        }
    }
}

- (void)setRightBarBtnItemState{
    NSInteger count = 0;
    if(selectViewControIndex==0){
        count = finishedCtl.dataArray.count;
    }else{
        count = downLoadingCtl.dataArray.count;
    }
    if(count>0){
        rightBarButton.hidden = NO;
    }else{
        rightBarButton.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
