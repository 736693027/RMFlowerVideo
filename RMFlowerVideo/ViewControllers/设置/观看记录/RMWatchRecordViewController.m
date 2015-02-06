//
//  RMWatchRecordViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMWatchRecordViewController.h"
#import "RMWatchRecordTableViewCell.h"
//#import "Database.h"
#import "RMVideoPlaybackDetailsViewController.h"
#import "RMModel.h"
#import "RMPlayer.h"
#import "RMLoadingWebViewController.h"

@interface RMWatchRecordViewController ()<RMWatchRecordTableViewCellDelegate>

@end

@implementation RMWatchRecordViewController

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
            [self.mainTableView setEditing:NO animated:YES];
            if(!isEditing){
                [UIView animateWithDuration:0.5 animations:^{
                    btnView.frame = CGRectMake(0, ScreenHeight-49, ScreenWidth, 49);
                    self.mainTableView.frame = CGRectMake(self.mainTableView.frame.origin.x, self.mainTableView.frame.origin.y, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height-49);
                }];
                [[NSNotificationCenter defaultCenter] postNotificationName:kBeginEdingtingTableViewCell object:nil];
                
            }
            else{
                [UIView animateWithDuration:0.5 animations:^{
                    btnView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
                    self.mainTableView.frame = CGRectMake(self.mainTableView.frame.origin.x, self.mainTableView.frame.origin.y, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height+49);
                }];
                [[NSNotificationCenter defaultCenter ] postNotificationName:kEndEditingTableViewCell object:nil];
                for(int i=0;i<selectCellArray.count;i++){
                    NSNumber *number = [selectCellArray objectAtIndex:i];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:number.integerValue inSection:0];
                    RMWatchRecordTableViewCell *cell = (RMWatchRecordTableViewCell*)[self.mainTableView cellForRowAtIndexPath:indexPath];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [leftBarButton setBackgroundImage:LOADIMAGE(@"backup") forState:UIControlStateNormal];
    [rightBarButton setBackgroundImage:LOADIMAGE(@"nav_editing_btn") forState:UIControlStateNormal];
    [self setCustomNavTitle:@"观看记录"];

    [showMemoryView removeFromSuperview];
    
    self.dataArray = [[[Database sharedDatabase] readitemFromHistroyList] mutableCopy];
    for(int i=0;i<self.dataArray.count;i++){
        [cellEditingImageArray addObject:@"cell_no_select"];
    }
    if(self.dataArray.count==0){
        rightBarButton.hidden = YES;
        self.mainTableView.hidden = YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cellIIdentifier11";
    RMWatchRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if(cell==nil){
        if([model.name rangeOfString:@"综艺"].location == NSNotFound){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMWatchRecordTableViewCell" owner:self options:nil] lastObject];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RMWatchRecordTableViewVarietyCell" owner:self options:nil] lastObject];
        }
        if(isEditing){
            [cell setCellViewFrame];
        }
    }
    [cell.editingImage setImage:[UIImage imageNamed:[cellEditingImageArray objectAtIndex:indexPath.row]]];
    cell.delegate = self;
    cell.playBtn.tag = indexPath.row;
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:LOADIMAGE(@"92_138")];
    if([model.name rangeOfString:@"电视剧"].location == NSNotFound && [model.name rangeOfString:@"综艺"].location == NSNotFound){
        cell.titleLable.text = model.name;
    }
    else{
        NSString *title = [model.name substringFromIndex:[model.name rangeOfString:@"_"].location+1];
        cell.titleLable.text = title;
    }
    cell.starringLable.text = model.actors;
    cell.directorLable.text = model.directors;
    cell.playCount.text = model.hits;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(isEditing){
        RMWatchRecordTableViewCell *cell = (RMWatchRecordTableViewCell *)[self.mainTableView cellForRowAtIndexPath:indexPath];
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
        if(selectCellArray.count==self.dataArray.count){
            isSeleltAllCell = YES;
            [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        }else{
            isSeleltAllCell = NO;
            [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
    }else{
        RMPublicModel *model = [self.dataArray objectAtIndex:indexPath.row];
        RMVideoPlaybackDetailsViewController * videoPlaybackDetailsCtl = [[RMVideoPlaybackDetailsViewController alloc] init];
        videoPlaybackDetailsCtl.video_id = model.video_id;
        if([model.name rangeOfString:@"电视剧"].location == NSNotFound&&[model.name rangeOfString:@"综艺"].location)
            videoPlaybackDetailsCtl.segVideoType = @"电影";
        else
            videoPlaybackDetailsCtl.segVideoType = @"电视剧";
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        [self presentViewController:videoPlaybackDetailsCtl animated:YES completion:^{
        }];
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
        NSUInteger row = [indexPath row];
        [self.dataArray removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if(self.dataArray.count==0){
            rightBarButton.hidden = YES;
            self.mainTableView.hidden = YES;
        }
    }
}

- (void)EditingViewBtnClick:(UIButton *)sender{
    if(sender==selectAllBtn){
        [selectCellArray removeAllObjects];
        if(!isSeleltAllCell){
            for(int i=0; i<self.dataArray.count;i++){
                [cellEditingImageArray replaceObjectAtIndex:i withObject:@"cell_selected"];
                [selectCellArray addObject:[NSNumber numberWithInt:i]];
            }
            [selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
            [deleteBtn setTitle:[NSString stringWithFormat:@"删除（%d）",(int)selectCellArray.count] forState:UIControlStateNormal];
            [deleteBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] forState:UIControlStateNormal];
        }
        else{
            for(int i=0; i<self.dataArray.count;i++){
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
        for(int i=0;i<sort.count;i++){
            NSNumber *number = [sort objectAtIndex:i];
            RMPublicModel *model = [self.dataArray objectAtIndex:number.integerValue];
            [cellEditingImageArray removeObjectAtIndex:number.integerValue];
            [self.dataArray removeObjectAtIndex:number.integerValue];
            [[Database  sharedDatabase] deleteItem:model fromListName:@"PlayHistoryListname"];
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:number.integerValue inSection:0];
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.mainTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
        [selectCellArray removeAllObjects];
        [UIView animateWithDuration:0.5 animations:^{
            btnView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
            self.mainTableView.frame = CGRectMake(self.mainTableView.frame.origin.x, self.mainTableView.frame.origin.y, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height+49);
        }];
        [self setRightBarBtnItemImageWith:YES];
        [[NSNotificationCenter defaultCenter ] postNotificationName:kEndEditingTableViewCell object:nil];
        isEditing = NO;
        if(self.dataArray.count==0){
            rightBarButton.hidden = YES;
            self.mainTableView.hidden = YES;
        }
    }
}

- (void)palyMovieWithIndex:(NSInteger)index{
    RMPublicModel *model = [self.dataArray objectAtIndex:index];
    if ([model.name rangeOfString:@"电视剧"].location == NSNotFound&&[model.name rangeOfString:@"综艺"].location){
        NSString* pathExtention = [model.m_down_url pathExtension];
        if([pathExtention isEqualToString:@"mp4"]) {
            RMModel *_model = [[RMModel alloc] init];
            _model.url = model.m_down_url;
            _model.title = model.name;
            [RMPlayer presentVideoPlayerWithPlayModel:_model withUIViewController:self withVideoType:1 withIsLocationVideo:NO];
        }else{
            RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
            loadingWebCtl.name = model.name;
            loadingWebCtl.loadingUrl = model.jumpurl;
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            [self presentViewController:loadingWebCtl animated:YES completion:^{
            }];
        }
    }else{
        NSString* pathExtention = [model.m_down_url pathExtension];
        if([pathExtention isEqualToString:@"mp4"]) {
            RMModel *_model = [[RMModel alloc] init];
            _model.url = model.m_down_url;
            _model.title = model.name;
            [RMPlayer presentVideoPlayerWithPlayModel:_model withUIViewController:self withVideoType:1 withIsLocationVideo:NO];
        }else{
            RMLoadingWebViewController * loadingWebCtl = [[RMLoadingWebViewController alloc] init];
             NSString *title = [model.name substringFromIndex:[model.name rangeOfString:@"_"].location+1];
            loadingWebCtl.name = title;
            loadingWebCtl.loadingUrl = model.jumpurl;
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
            [self presentViewController:loadingWebCtl animated:YES completion:^{
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
