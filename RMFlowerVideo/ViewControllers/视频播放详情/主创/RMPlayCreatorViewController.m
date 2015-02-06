//
//  RMPlayCreatorViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-5.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMPlayCreatorViewController.h"
#import "RMHomeStartCell.h"
#import "RMStarDetailsViewController.h"                 //明星详情
#import "RMVideoPlaybackDetailsViewController.h"        //视频详情
#import "RMCustomPresentNavViewController.h"
#import "RMCustomNavViewController.h"

@interface RMPlayCreatorViewController ()<UITableViewDataSource,UITableViewDelegate,RMHomeStartCellDelegate>{
    UITableView * mTableView;
    NSInteger pageCount;
    BOOL isFefresh;
    BOOL isFirstViewAppear;
    
    NSMutableArray * dataArr;
}

@end

@implementation RMPlayCreatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    dataArr = [[NSMutableArray alloc] init];
    if (IS_IPHONE_6_SCREEN | IS_IPHONE_6p_SCREEN){
        mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 261 - 49) style:UITableViewStylePlain];
    }else{
        mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 261 - 40) style:UITableViewStylePlain];
    }
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([dataArr count]%3 == 0){
        return [dataArr count] / 3;
    }else if ([dataArr count]%3 == 1){
        return ([dataArr count] + 2) / 3;
    }else {
        return ([dataArr count] + 1) / 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * CellIdentifier = [NSString stringWithFormat:@"MyAttentionLabelCellIdentifier%ld",(long)indexPath.row];
    RMHomeStartCell * cell = (RMHomeStartCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        NSArray *array;
        if (IS_IPHONE_6_SCREEN){
            array = [[NSBundle mainBundle] loadNibNamed:@"RMHomeStartCell_6" owner:self options:nil];
        }else if (IS_IPHONE_6p_SCREEN){
            array = [[NSBundle mainBundle] loadNibNamed:@"RMHomeStartCell_6p" owner:self options:nil];
        }else {
            array = [[NSBundle mainBundle] loadNibNamed:@"RMHomeStartCell" owner:self options:nil];
        }
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    
    NSInteger left = indexPath.row*3;
    NSInteger center = indexPath.row*3 + 1;
    NSInteger right = indexPath.row*3 + 2;
    
    cell.fristTitle.text = [[dataArr objectAtIndex:left] objectForKey:@"name"];
    [cell.fristHeadImage sd_setImageWithURL:[NSURL URLWithString:[[dataArr objectAtIndex:left] objectForKey:@"pic"]] placeholderImage:LOADIMAGE(@"92_138")];
    cell.fristHeadImage.identifierString = [[dataArr objectAtIndex:left] objectForKey:@"tag_id"];
    
    if (indexPath.row * 3 + 1 >= [dataArr count]){
    }else{
        cell.secondTitle.text = [[dataArr objectAtIndex:center] objectForKey:@"name"];
        [cell.secondHeadImage sd_setImageWithURL:[NSURL URLWithString:[[dataArr objectAtIndex:center] objectForKey:@"pic"]] placeholderImage:LOADIMAGE(@"92_138")];
        cell.secondHeadImage.identifierString = [[dataArr objectAtIndex:center] objectForKey:@"tag_id"];
    }
    
    if (indexPath.row * 3 + 2 >= [dataArr count]){
    }else{
        cell.thirdTitle.text = [[dataArr objectAtIndex:right] objectForKey:@"name"];
        [cell.thirdHeadImage sd_setImageWithURL:[NSURL URLWithString:[[dataArr objectAtIndex:right] objectForKey:@"pic"]] placeholderImage:LOADIMAGE(@"92_138")];
        cell.thirdHeadImage.identifierString = [[dataArr objectAtIndex:right] objectForKey:@"tag_id"];
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
    return 184;
}

-(void)homeTableViewCellDidSelectWithImage:(RMImageView *)imageView{
    if (![imageView.identifierString isEqualToString:@""]){
        RMVideoPlaybackDetailsViewController * videoPlaybackDetailsCtl = self.videoPlaybackDetailsDelegate;
        [videoPlaybackDetailsCtl replaceAVPlayer];
        RMStarDetailsViewController * starDetailsCtl = [[RMStarDetailsViewController alloc] init];
        starDetailsCtl.tag_id = imageView.identifierString;
        RMCustomPresentNavViewController *starDetailsNav = [[RMCustomPresentNavViewController alloc] initWithRootViewController:starDetailsCtl];
        starDetailsNav.navigationBar.hidden = YES;
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        [videoPlaybackDetailsCtl presentViewController:starDetailsNav animated:YES completion:^{
        }];
    }
}

- (void)playBtnWithIndex:(NSInteger)index andLocation:(NSInteger)location {
    
}

- (void)reloadDataWithModel:(RMPublicModel *)model {
    for (NSInteger i=0; i<[model.creator count]; i++){
        [dataArr addObject:[model.creator objectAtIndex:i]];
    }
    [mTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
