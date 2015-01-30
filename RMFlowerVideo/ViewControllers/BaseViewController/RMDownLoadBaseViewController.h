//
//  RMDownLoadBaseViewController.h
//  RMVideo
//
//  Created by 润华联动 on 14-10-22.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMDownLoadBaseViewController : RMBaseViewController{
    
    UIView *showMemoryView; //显示内存大小
    UILabel *showMemoryLable; //显示内存大小
    UILabel *showHaveCasheLable; //显示已缓存所占百分比位置
    UIView *btnView; //全选和删除
    BOOL isEditing;  //是否开启编辑状态
    NSMutableArray *cellEditingImageArray;  //cell 编辑按钮的image string
    NSMutableArray *selectCellArray;  //要删除的cell
    BOOL isSeleltAllCell;//是否全选 默认为YES
    UIButton *selectAllBtn;  //全选按钮
    UIButton *deleteBtn;  //删除按钮
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong ,nonatomic)NSMutableArray *dataArray;

- (void)EditingViewBtnClick:(UIButton *)sender;

- (void)setRightBarBtnItemImageWith:(BOOL)state;

- (void)upDataMemory;


@end
