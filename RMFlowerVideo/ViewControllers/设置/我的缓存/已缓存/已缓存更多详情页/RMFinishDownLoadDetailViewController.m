//
//  RMFinishDownLoadDetailViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-15.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMFinishDownLoadDetailViewController.h"
#import "RMTVDownLoadViewController.h"
#import "RMFinishDownLoadTableViewCell.h"
#import "RMModel.h"
#import "RMPlayer.h"

@interface RMFinishDownLoadDetailViewController (){
    NSMutableArray *tableDataArray;
}

@end

@implementation RMFinishDownLoadDetailViewController

- (void)navgationBarButtonClick:(UIBarButtonItem *)sender{
    [self setRightBarBtnItemImageWith:isEditing];
    [self.mainTableView setEditing:NO animated:YES];
    switch (sender.tag) {
        case 1:{
            if(isEditing){
                [[NSNotificationCenter defaultCenter] postNotificationName:kFinishDownLoadControEndEditing object:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 2:{
            if(!isEditing){
                [UIView animateWithDuration:0.5 animations:^{
                    btnView.frame = CGRectMake(0, ScreenHeight-49, ScreenWidth, 49);
                    self.mainTableView.frame = CGRectMake(self.mainTableView.frame.origin.x, self.mainTableView.frame.origin.y, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height-25);
                }];
                [[NSNotificationCenter defaultCenter] postNotificationName:kFinishDownLoadControStartEditing object:nil];
                
            }
            else{
                [UIView animateWithDuration:0.5 animations:^{
                    btnView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
                    self.mainTableView.frame = CGRectMake(self.mainTableView.frame.origin.x, self.mainTableView.frame.origin.y, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height+25);
                }];
                [[NSNotificationCenter defaultCenter] postNotificationName:kFinishDownLoadControEndEditing object:nil];
                for(int i=0;i<selectCellArray.count;i++){
                    NSNumber *number = [selectCellArray objectAtIndex:i];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:number.integerValue inSection:0];
                    RMFinishDownLoadTableViewCell *cell = (RMFinishDownLoadTableViewCell*)[self.mainTableView cellForRowAtIndexPath:indexPath];
                    cell.editingImage.image = [UIImage imageNamed:@"cell_no_select"];
                    [cellEditingImageArray replaceObjectAtIndex:number.integerValue withObject:@"cell_no_select"];
                }
                [selectCellArray removeAllObjects];
            }
            isEditing = !isEditing;
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1] forState:UIControlStateNormal];
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            break;
        }
            
        default:
            break;
    }

}
- (void) getDataFromDataBase{
    [tableDataArray removeAllObjects];
    [self.dataArray removeAllObjects];
    NSString *tmpStr = [self.navTitleString substringFromIndex:[self.navTitleString rangeOfString:@"_"].location+1];
    tmpStr = [tmpStr substringToIndex:[tmpStr rangeOfString:@"_"].location];
    self.dataArray = [[[Database sharedDatabase] readItemFromDownLoadList] mutableCopy];
    NSMutableArray *tmpDataArray = [[NSMutableArray alloc] init];
    for (RMPublicModel *model in self.dataArray) {
        if([model.name rangeOfString:tmpStr].location != NSNotFound){
            [tmpDataArray addObject:model];
        }
    }
    NSArray *sortArray = [tmpDataArray sortedArrayUsingComparator:^NSComparisonResult(RMPublicModel *model1, RMPublicModel *model2) {
        NSString *tmpStr1 = [model1.name substringFromIndex:[model1.name rangeOfString:@"_"].location+1];
        tmpStr1 = [tmpStr1 substringFromIndex:[tmpStr1 rangeOfString:@"_"].location+1];
        
        NSString *tmpStr2 = [model2.name substringFromIndex:[model2.name rangeOfString:@"_"].location+1];
        tmpStr2 = [tmpStr2 substringFromIndex:[tmpStr2 rangeOfString:@"_"].location+1];
        return  [tmpStr1 intValue]>[tmpStr2 intValue];
    }];
    for (int i=0; i<tmpDataArray.count; i++) {
        [cellEditingImageArray addObject:@"cell_no_select"];
    }
    tableDataArray = [sortArray mutableCopy];
    [self.mainTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *tmpStr = [self.navTitleString substringFromIndex:[self.navTitleString rangeOfString:@"_"].location+1];
    tmpStr = [tmpStr substringToIndex:[tmpStr rangeOfString:@"_"].location];
    [self setCustomNavTitle:tmpStr];
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    [rightBarButton setBackgroundImage:LOADIMAGE(@"nav_editing_btn") forState:UIControlStateNormal];
    self.dataArray = [[NSMutableArray alloc] init];
    cellEditingImageArray = [[NSMutableArray alloc] init];
    selectCellArray = [[NSMutableArray alloc] init];
    tableDataArray = [[NSMutableArray alloc] init];
    [self getDataFromDataBase];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadSuccessUpdate) name:@"DownLoadSuccess" object:nil];
}

- (void)downLoadSuccessUpdate{
    [self getDataFromDataBase];
    [self upDataMemory];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableDataArray.count;
}
#pragma mark tableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cellIIdentifier";
    RMFinishDownLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMFinishDownLoadTableViewCell" owner:self options:nil] lastObject];
        if(isEditing)
            [cell setCellViewFrame];
    }
    RMPublicModel *model = [tableDataArray objectAtIndex:indexPath.row];
    [cell.editingImage setImage:[UIImage imageNamed:[cellEditingImageArray objectAtIndex:indexPath.row]]];
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
    NSString *tmpStr = [model.name substringFromIndex:[model.name rangeOfString:@"_"].location+1];
    cell.titleLabel.text = tmpStr;
    cell.starringLable.text = model.actors;
    cell.directorLable.text = model.directors;
    cell.playCount.text = model.hits;
    cell.casheLable.text = model.totalMemory;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 139.f;
}
#pragma mark tableView delegale
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(isEditing){
        RMFinishDownLoadTableViewCell *cell = (RMFinishDownLoadTableViewCell *)[self.mainTableView cellForRowAtIndexPath:indexPath];
        if([[cellEditingImageArray objectAtIndex:indexPath.row] isEqualToString:@"cell_no_select"]){
            [cell.editingImage setImage:LOADIMAGE(@"cell_selected")];
            [cellEditingImageArray replaceObjectAtIndex:indexPath.row withObject:@"cell_selected"];
            [selectCellArray addObject:[NSNumber numberWithInteger:indexPath.row]];
            [deleteBtn setTitle:[NSString stringWithFormat:@"删除（%d）",(int)selectCellArray.count] forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
        }
        else{
            [cell.editingImage setImage:LOADIMAGE(@"cell_no_select")];
            [cellEditingImageArray replaceObjectAtIndex:indexPath.row withObject:@"cell_no_select"];
            [selectCellArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
            if(selectCellArray.count==0){
                [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
                [deleteBtn setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1] forState:UIControlStateNormal];
            }else{
                [deleteBtn setTitle:[NSString stringWithFormat:@"删除（%d）",(int)selectCellArray.count] forState:UIControlStateNormal];
                [deleteBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
            }
        }
        if(selectCellArray.count==tableDataArray.count){
            isSeleltAllCell = YES;
            [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        }else{
            isSeleltAllCell = NO;
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
    }else{
        
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //播放本地电视剧视频 调用 RMPlayer presemtVideoPlayerWithLocationTVArry的方法，其中array中每个model的类型值具体为：
        //title   需要将该页面的model.name字符串截取（该字符串为保存方便，认为改变了电视剧名称，全称为：电视剧_电视剧名称_集数）
        //url     对应的在沙河中的目录位置
        //EpisodeValue  集数
        NSMutableArray *tvArrya = [NSMutableArray array];
        for(RMPublicModel *model in tableDataArray){
            RMModel *tmpModel = [[RMModel alloc] init];
            tmpModel.url = [NSString stringWithFormat:@"%@/%@.mp4",document,model.name];
            NSString *tmpTitle = [model.name substringFromIndex:[model.name rangeOfString:@"_"].location+1];
            NSString *title = tmpTitle;
            tmpModel.title = [title substringToIndex:[title rangeOfString:@"_"].location];
            tmpModel.EpisodeValue = [tmpTitle substringFromIndex:[tmpTitle rangeOfString:@"_"].location+1];
            [tvArrya addObject:tmpModel];
        }
        [RMPlayer presentVideoPlayerCurrentOrder:0 withPlayArr:tvArrya withUIViewController:self withVideoType:2 withIsLocationVideo:YES];
    }
}
#pragma mark tableView delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(isEditing){
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        RMPublicModel *model = [tableDataArray objectAtIndex:indexPath.row];
        NSString *removePath = [NSString stringWithFormat:@"%@/%@.mp4",document,model.name];
        NSError *error = nil;
        BOOL remove = [[NSFileManager defaultManager] removeItemAtPath:removePath error:&error];
        [[Database sharedDatabase] deleteItem:model fromListName:DOWNLOADLISTNAME];
        if(remove){
            NSLog(@"删除成功");
        }
        [tableDataArray removeObjectAtIndex:indexPath.row];
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [self.mainTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [cellEditingImageArray removeObjectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:kTVSeriesDetailDeleteFinish object:nil];
        if(tableDataArray.count==0){
            rightBarButton.hidden = YES;
        }
    }
}
#pragma mark 全选、删除
- (void)EditingViewBtnClick:(UIButton *)sender{
    if(sender==selectAllBtn){
        [selectCellArray removeAllObjects];
        if(!isSeleltAllCell){
            for(int i=0; i<tableDataArray.count;i++){
                NSLog(@"cellEditingImageArray:%@   count:%lu",cellEditingImageArray,(unsigned long)cellEditingImageArray.count);
                [cellEditingImageArray replaceObjectAtIndex:i withObject:@"cell_selected"];
                [selectCellArray addObject:[NSNumber numberWithInt:i]];
            }
            [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
            [deleteBtn setTitle:[NSString stringWithFormat:@"删除（%d）",(int)selectCellArray.count] forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
        }
        else{
            for(int i=0; i<tableDataArray.count;i++){
                [cellEditingImageArray replaceObjectAtIndex:i withObject:@"cell_no_select"];
            }
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1] forState:UIControlStateNormal];
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
        isSeleltAllCell = !isSeleltAllCell;
        [self.mainTableView reloadData];
    }else{
        NSArray *sort = [selectCellArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
            return obj1.integerValue<obj2.integerValue;
        }];
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        for(int i=0;i<sort.count;i++){
            NSNumber *number = [sort objectAtIndex:i];
            RMPublicModel *model = [tableDataArray objectAtIndex:number.intValue];
            NSString *removePath = [NSString stringWithFormat:@"%@/%@.mp4",document,model.name];
            NSError *error = nil;
            BOOL remove = [[NSFileManager defaultManager] removeItemAtPath:removePath error:&error];
            [[Database sharedDatabase] deleteItem:model fromListName:DOWNLOADLISTNAME];
            if(remove){
                NSLog(@"删除成功");
            }
            [tableDataArray removeObjectAtIndex:number.integerValue];
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:number.integerValue inSection:0];
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.mainTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [cellEditingImageArray removeObjectAtIndex:number.integerValue];
//            if (tableDataArray.count==0) {
//                [self isShouldSetHiddenEmptyView:NO];
//            }else{
//                [self isShouldSetHiddenEmptyView:YES];
//            }
        }
        [selectCellArray removeAllObjects];
        [UIView animateWithDuration:0.5 animations:^{
            btnView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
            self.mainTableView.frame = CGRectMake(self.mainTableView.frame.origin.x, self.mainTableView.frame.origin.y, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height+25);
        }];
        [self setRightBarBtnItemImageWith:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFinishDownLoadControEndEditing object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kTVSeriesDetailDeleteFinish object:nil];
        isEditing = NO;
        if(tableDataArray.count==0){
            rightBarButton.hidden = YES;
        }
        [self upDataMemory];
    }
}
- (IBAction)addMoreTvEpisode:(UIButton *)sender {
    
    if(isEditing){
        [UIView animateWithDuration:0.5 animations:^{
            btnView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
            self.mainTableView.frame = CGRectMake(self.mainTableView.frame.origin.x, self.mainTableView.frame.origin.y, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height+25);
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFinishDownLoadControEndEditing object:nil];
        [self setRightBarBtnItemImageWith:YES];
        isEditing = !isEditing;
    }
    if(tableDataArray.count==0) return;
    RMTVDownLoadViewController *tvDownLoadMoreViewControl = [[RMTVDownLoadViewController alloc] init];
    RMPublicModel *model = [tableDataArray objectAtIndex:0];
    NSString *tmpStr = [self.navTitleString substringFromIndex:[self.navTitleString rangeOfString:@"_"].location+1];
    tmpStr = [tmpStr substringToIndex:[tmpStr rangeOfString:@"_"].location];
    tvDownLoadMoreViewControl.videoName = tmpStr;
    tvDownLoadMoreViewControl.actors = model.actors;
    tvDownLoadMoreViewControl.director = model.directors;
    tvDownLoadMoreViewControl.PlayCount = model.hits;
    tvDownLoadMoreViewControl.videoHeadImage = model.pic;
    tvDownLoadMoreViewControl.video_id = model.video_id;
    tvDownLoadMoreViewControl.isNavPushViewController = YES;
    [self.navigationController pushViewController:tvDownLoadMoreViewControl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
