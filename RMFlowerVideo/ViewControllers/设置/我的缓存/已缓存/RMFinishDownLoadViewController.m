//
//  RMFinishDownLoadViewController.m
//  RMFlowerVideo
//
//  Created by 润华联动 on 15-1-6.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMFinishDownLoadViewController.h"
#import "RMMyCacheViewController.h"
#import "RMFinishDownLoadTableViewCell.h"
#import "RMFinishDownLoadDetailViewController.h"
#import "RMModel.h"
#import "RMPlayer.h"

@interface RMFinishDownLoadViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL isStartEditing;
    NSMutableArray *cellEditingImageArray;
    NSMutableArray *selectCellArray;
    NSMutableArray *dataBaseArray;
}

@end

@implementation RMFinishDownLoadViewController

- (void)getDataFrameDataBase{
   
    [self.dataArray removeAllObjects];
    NSArray *tmpArray = [[Database sharedDatabase] readItemFromDownLoadList];
    if ([tmpArray count] == 0){
//        [self isShouldSetHiddenEmptyView:NO];
    }else{
        // dataBaseArray主要实在删除的时候使用 dataBaseArray包含的是所有的下载视屏数据
        if(dataBaseArray==nil){
            dataBaseArray = [NSMutableArray arrayWithArray:tmpArray];
        }
        else{
            [dataBaseArray removeAllObjects];
            dataBaseArray = [tmpArray mutableCopy];
        }
//        [self isShouldSetHiddenEmptyView:YES];
        for(RMPublicModel *model in tmpArray){
            if([model.name rangeOfString:@"电视剧"].location == NSNotFound){
                [self.dataArray addObject:model];
            }else {
                NSString *mm = [model.name substringFromIndex:[model.name rangeOfString:@"_"].location+1];
                NSString *nn = [mm substringToIndex:[mm rangeOfString:@"_"].location];
                
                if(![self arrayIsHaveTitle:nn inArray:self.dataArray]){
                    model.isTVModel = YES;
                    [self.dataArray addObject:model];
                }
            }
        }
    }
    if(self.dataArray.count>cellEditingImageArray.count){
        NSInteger number = cellEditingImageArray.count;
        for(int i=0;i<(self.dataArray.count-number);i++){
            [cellEditingImageArray addObject:@"cell_no_select"];
        }
    }
    [self.mainTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    self.dataArray = [[NSMutableArray alloc] init];
    cellEditingImageArray = [[NSMutableArray alloc] init];
    selectCellArray = [[NSMutableArray alloc] init];
    //电视机下载详情页面中，编辑完电视机的时候，该界面要进行更新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeTheDataFromDataBase) name:kTVSeriesDetailDeleteFinish object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadSuccessUpdate) name:@"DownLoadSuccess" object:nil];
    
    /***********************************************/
    
//    RMPublicModel *model = [[RMPublicModel alloc] init];
//    model.pic = @"http://vodimg.runmobile.cn/images/48/480fd9e9e78e63f206af98b71572c6b6.jpg";
//    model.name = @"电视剧_分手_50";
//    model.actors = @"邓超，杨幂";
//    model.directors = @"邓超";
//    model.hits = @"123";
//    model.totalMemory = @"31M";
//    model.isTVModel = YES;
//    [[Database sharedDatabase] insertDownLoadMovieItem:model];
    
    
//    RMPublicModel *model1 = [[RMPublicModel alloc] init];
//    model1.pic = @"http://vodimg.runmobile.cn/images/48/480fd9e9e78e63f206af98b71572c6b6.jpg";
//    model1.name = @"一个人的武林";
//    model1.actors = @"王宝强，甄子丹";
//    model1.directors = @"刘伟强";
//    model1.hits = @"123";
//    model1.totalMemory = @"31M";
//    model1.isTVModel = NO;
//    [[Database sharedDatabase] insertDownLoadMovieItem:model1];
    /***********************************************/
}

- (void)downLoadSuccessUpdate{
    [self getDataFrameDataBase];
}
#pragma mark tableView dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 139;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"FINISHDOWNLOADCELL";
    RMFinishDownLoadTableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RMFinishDownLoadTableViewCell" owner:self options:nil] lastObject];
        if(isStartEditing) [cell setCellViewFrame];
    }
    RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell.editingImage setImage:[UIImage imageNamed:[cellEditingImageArray objectAtIndex:indexPath.row]]];
    
    if(model.isTVModel){
        NSString *tmpStr = [model.name substringFromIndex:[model.name rangeOfString:@"_"].location+1];
        tmpStr = [tmpStr substringToIndex:[tmpStr rangeOfString:@"_"].location];
        cell.titleLabel.text = tmpStr;
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.headImage.layer.borderColor = [UIColor colorWithRed:0.95 green:0.69 blue:0.17 alpha:1].CGColor;
        cell.headImage.layer.borderWidth = 5;
        cell.casheLable.text = @"";
    }else{
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
        cell.titleLabel.text = model.name;
        cell.headImage.layer.borderColor = [UIColor clearColor].CGColor;
        cell.headImage.layer.borderWidth = 1;
        cell.casheLable.text = model.totalMemory;
    }
    cell.starringLable.text = model.actors;
    cell.directorLable.text = model.directors;
    cell.playCount.text = model.hits;
    
    return cell;
}
#pragma mark tableView delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(isStartEditing){
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
         NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if(model.isTVModel){
            NSString *mm = [model.name substringFromIndex:[model.name rangeOfString:@"_"].location+1];
            NSString *nn = [mm substringToIndex:[mm rangeOfString:@"_"].location];
            for (RMPublicModel *tmpModel in dataBaseArray) {
                if([tmpModel.name rangeOfString:nn].location != NSNotFound){
                    NSString *removePath = [NSString stringWithFormat:@"%@/%@.mp4",document,tmpModel.name];
                    NSError *error = nil;
                    BOOL remove = [[NSFileManager defaultManager] removeItemAtPath:removePath error:&error];
                    [[Database sharedDatabase] deleteItem:tmpModel fromListName:DOWNLOADLISTNAME];
                    if(remove){
                        NSLog(@"删除成功");
                    }
                }
            }
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [cellEditingImageArray removeObjectAtIndex:indexPath.row];
        }else{
            NSString *removePath = [NSString stringWithFormat:@"%@/%@.mp4",document,model.name];
            NSError *error = nil;
            BOOL remove = [[NSFileManager defaultManager] removeItemAtPath:removePath error:&error];
            [[Database sharedDatabase] deleteItem:model fromListName:DOWNLOADLISTNAME];
            if(remove){
                NSLog(@"删除成功");
            }
            [self.dataArray removeObjectAtIndex:indexPath.row];
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.mainTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [cellEditingImageArray removeObjectAtIndex:indexPath.row];
        }
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        commitEditings(self.dataArray);
    }
}
- (void)tableViewcommitEditing:(void (^)(NSMutableArray *))block{
    commitEditings = block;
}
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
        RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row];
        RMMyCacheViewController *mainCasheViewContro = self.delegete;
        if(model.isTVModel){
             NSLog(@"电视剧详情");
            RMFinishDownLoadDetailViewController *finishDownLoadDetail = [[RMFinishDownLoadDetailViewController alloc] init];
            finishDownLoadDetail.navTitleString = model.name;
            [mainCasheViewContro.navigationController pushViewController:finishDownLoadDetail animated:YES];
        }else{
             NSLog(@"播放器");
            NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            //播放本地电视剧视频 调用 RMPlayer presemtVideoPlayerWithLocationTVArry的方法，其中array中每个model的类型值具体为：
            //title   需要将该页面的model.name字符串截取（该字符串为保存方便，认为改变了电视剧名称，全称为：电视剧_电视剧名称_集数）
            //url     对应的在沙河中的目录位置
            //EpisodeValue  集数
            RMModel *tmpModel = [[RMModel alloc] init];
            tmpModel.url = [NSString stringWithFormat:@"%@/%@.mp4",document,model.name];
            NSString *tmpTitle = [model.name substringFromIndex:[model.name rangeOfString:@"_"].location+1];
            NSString *title = tmpTitle;
            tmpModel.title = [title substringToIndex:[title rangeOfString:@"_"].location];
            [RMPlayer presentVideoPlayerWithPlayModel:tmpModel withUIViewController:mainCasheViewContro withVideoType:1 withIsLocationVideo:YES];
        }
    }
}
#pragma mark 开始编辑
- (void)beginEditingTableViewCell{
    [self.mainTableView setEditing:NO animated:YES];
    isStartEditing = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kFinishDownLoadControStartEditing object:nil];
}
#pragma mark 结束编辑
- (void)endEditingTableViewCell{
    isStartEditing = NO;
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
        return obj1.integerValue<obj2.integerValue;
    }];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    for(int i=0;i<sort.count;i++){
        NSNumber *number = [sort objectAtIndex:i];
        RMPublicModel *model = [self.dataArray objectAtIndex:number.intValue];
        if(model.isTVModel){
            NSString *mm = [model.name substringFromIndex:[model.name rangeOfString:@"_"].location+1];
            NSString *nn = [mm substringToIndex:[mm rangeOfString:@"_"].location];
            for (RMPublicModel *tmpModel in dataBaseArray) {
                if([tmpModel.name rangeOfString:nn].location != NSNotFound){
                    NSString *removePath = [NSString stringWithFormat:@"%@/%@.mp4",document,tmpModel.name];
                    NSError *error = nil;
                    BOOL remove = [[NSFileManager defaultManager] removeItemAtPath:removePath error:&error];
                    [[Database sharedDatabase] deleteItem:tmpModel fromListName:DOWNLOADLISTNAME];
                    if(remove){
                        NSLog(@"删除成功");
                    }
                }
            }
            [self.dataArray removeObjectAtIndex:number.integerValue];
            [cellEditingImageArray removeObjectAtIndex:number.integerValue];
        }else{
            NSString *removePath = [NSString stringWithFormat:@"%@/%@.mp4",document,model.name];
            NSError *error = nil;
            BOOL remove = [[NSFileManager defaultManager] removeItemAtPath:removePath error:&error];
            [[Database sharedDatabase] deleteItem:model fromListName:DOWNLOADLISTNAME];
            if(remove){
                NSLog(@"删除成功");
            }
            [self.dataArray removeObjectAtIndex:number.integerValue];
            [cellEditingImageArray removeObjectAtIndex:number.integerValue];
        }
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:number.integerValue inSection:0];
        NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
        [self.mainTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//        if (self.dataArray.count==0) {
//            [self isShouldSetHiddenEmptyView:NO];
//        }else{
//            [self isShouldSetHiddenEmptyView:YES];
//        }
    }
    commitEditings(self.dataArray);
    [selectCellArray removeAllObjects];
    isStartEditing = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kFinishDownLoadControEndEditing object:nil];
}
- (void)didSelectTableViewCell:(void(^)(NSMutableArray *selectArray))block{
    didSelectCells = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//判断相关的电视剧有几部  在cell
- (NSInteger)searchTVCountWith:(NSString *)title{
    NSArray *tmpArray = [[Database sharedDatabase] readItemFromDownLoadList];
    int sum = 0;
    for(RMPublicModel *model in tmpArray){
        if([model.name rangeOfString:title].location!= NSNotFound){
            sum++;
        }
    }
    return sum;
    return 0;
}
//判断数组中是否存在改字段的model
- (BOOL)arrayIsHaveTitle:(NSString *)titel inArray:(NSMutableArray *)array{
    for(RMPublicModel *model in array){
        if([model.name rangeOfString:titel].location != NSNotFound){
            return YES;
        }
    }
    return NO;
}
//从数据库中去数据，并对数据进行分类，主要是对电视剧进行归类
- (void)takeTheDataFromDataBase{
    [self.dataArray removeAllObjects];
    NSArray *tmpArray = [[Database sharedDatabase] readItemFromDownLoadList];
    if(dataBaseArray==nil){
        dataBaseArray = [NSMutableArray arrayWithArray:tmpArray];
    }
    else{
        [dataBaseArray removeAllObjects];
        dataBaseArray = [tmpArray mutableCopy];
    }
    for(RMPublicModel *model in tmpArray){
        if([model.name rangeOfString:@"电视剧"].location == NSNotFound){
            [self.dataArray addObject:model];
        }else {
            NSString *mm = [model.name substringFromIndex:[model.name rangeOfString:@"_"].location+1];
            NSString *nn = [mm substringToIndex:[mm rangeOfString:@"_"].location];
            
            if(![self arrayIsHaveTitle:nn inArray:self.dataArray]){
                model.isTVModel = YES;
                [self.dataArray addObject:model];
            }
        }
    }
//    if (self.dataArray.count==0) {
//        [self isShouldSetHiddenEmptyView:NO];
//    }else{
//        [self isShouldSetHiddenEmptyView:YES];
//    }
    [self.mainTableView reloadData];
    [cellEditingImageArray removeAllObjects];
    for (int i=0; i<self.dataArray.count; i++) {
        [cellEditingImageArray addObject:@"cell_no_select"];
    }
}
@end
