//
//  RMDownLoadBaseViewController.m
//  RMVideo
//
//  Created by 润华联动 on 14-10-22.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMDownLoadBaseViewController.h"
#import "UtilityFunc.h"
#import "CONST.h"

@interface RMDownLoadBaseViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation RMDownLoadBaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    cellEditingImageArray = [[NSMutableArray alloc] init];
    selectCellArray = [[NSMutableArray alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];
    
    float freeNum = [[UtilityFunc freeDiskSpace] floatValue];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    float alreadyCache = [UtilityFunc folderSizeAtPath:document];

    
    showMemoryView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-25, ScreenWidth, 25)];
    [showMemoryView setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
    
    showHaveCasheLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth*(alreadyCache/(freeNum+alreadyCache)), 25)];
    showHaveCasheLable.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
    [showMemoryView addSubview:showHaveCasheLable];

    showMemoryLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
    showMemoryLable.backgroundColor = [UIColor clearColor];
    showMemoryLable.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    showMemoryLable.textAlignment = NSTextAlignmentCenter;
    showMemoryLable.font = FONT(12.0);
    
    
    if((freeNum/1024/1024)>1024){
        freeNum = freeNum/1024/1024/1024-0.2;
        showMemoryLable.text =[NSString stringWithFormat:@"已缓存%.2fM,剩余%.2fG可用",alreadyCache*2,freeNum];
    }
    else{
        freeNum = freeNum/1024/1024-200;
        showMemoryLable.text =[NSString stringWithFormat:@"已缓存%.2fM,剩余%.0fM可用",alreadyCache*2,freeNum];
    }
    [showMemoryView addSubview:showMemoryLable];
    [self.view addSubview:showMemoryView];
    
    btnView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight , ScreenWidth, 49)];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,  0 , ScreenWidth, 1)];
    lable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [btnView addSubview:lable];
    [btnView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    for (int i = 0;i<2; i++) {
        if(i==0){
            selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            selectAllBtn.frame = CGRectMake(i*(ScreenWidth/2), 1, ScreenWidth/2, 48);
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            selectAllBtn.titleLabel.font = FONT(15.0);
            [selectAllBtn addTarget:self action:@selector(EditingViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [selectAllBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
            [btnView addSubview:selectAllBtn];
        }
        else{
            deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame = CGRectMake(i*(ScreenWidth/2)-1, 0, ScreenWidth/2, 49);
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            deleteBtn.titleLabel.font = FONT(15.0);
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1] forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(EditingViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnView addSubview:deleteBtn];
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(i*(ScreenWidth/2), 4, 1, 40)];
            line.backgroundColor =  [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
            [btnView addSubview:line];
        }
    }
    [self.view addSubview:btnView];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 161.f;
}
- (void)EditingViewBtnClick:(UIButton *)sender{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置导航右边的按钮的状态
- (void)setRightBarBtnItemImageWith:(BOOL)state{
    if(!state){
        [rightBarButton setBackgroundImage:LOADIMAGE(@"nav_cancel_btn") forState:UIControlStateNormal];
    }
    else{
        [rightBarButton setBackgroundImage:LOADIMAGE(@"nav_editing_btn") forState:UIControlStateNormal];
    }
}
- (void)upDataMemory{
    float freeNum = [[UtilityFunc freeDiskSpace] floatValue];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    float alreadyCache = [UtilityFunc folderSizeAtPath:document];
    
    if((freeNum/1024/1024)>1024){
        freeNum = freeNum/1024/1024/1024-0.2;
        showMemoryLable.text =[NSString stringWithFormat:@"已缓存%.2fM,剩余%.2fG可用",alreadyCache*2,freeNum];
    }
    else{
        freeNum = freeNum/1024/1024-200;
        showMemoryLable.text =[NSString stringWithFormat:@"已缓存%.2fM,剩余%.0fM可用",alreadyCache*2,freeNum];
    }
}
@end
