//
//  RMFinishDownLoadViewController.h
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-6.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMBaseViewController.h"

@interface RMFinishDownLoadViewController : RMBaseViewController
{
    void(^didSelectCells)(NSMutableArray *selectArray);
    void(^commitEditings)(NSMutableArray *selectArray);
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic,assign) id delegete;

@property (nonatomic,strong) NSMutableArray *dataArray;

- (void)didSelectTableViewCell:(void(^)(NSMutableArray *selectArray))block;
- (void)tableViewcommitEditing:(void(^)(NSMutableArray *commitArray))block;
//开始编辑
- (void)beginEditingTableViewCell;

//结束编辑
- (void)endEditingTableViewCell;

//全选
- (void)selectAllTableViewWithState:(BOOL)state;

//删除
- (void)deleteDidSelectCell;

- (void)getDataFrameDataBase;
@end
