//
//  RMRelatedViewController.m
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-5.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMPlayRelatedViewController.h"
#import "RMPlayRelatedCell.h"
#import "RMVideoPlaybackDetailsViewController.h"

@interface RMPlayRelatedViewController ()<UITableViewDataSource,UITableViewDelegate,PlayRelatedDelegate>{
    UITableView * mTableView;
    NSInteger pageCount;
    BOOL isFefresh;
    BOOL isFirstViewAppear;
    
    NSMutableArray * dataArr;
}

@end

@implementation RMPlayRelatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self hideCustomNavigationBar:YES withHideCustomStatusBar:YES];
    dataArr = [[NSMutableArray alloc] init];
    
    if (IS_IPHONE_6p_SCREEN | IS_IPHONE_6_SCREEN){
        mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 261 - 49) style:UITableViewStylePlain];
    }else{
        mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 261 - 40) style:UITableViewStylePlain];
    }
    
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
//    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * CellIdentifier = [NSString stringWithFormat:@"PlayRelatedCellIdentifier%ld",(long)indexPath.row];
    RMPlayRelatedCell * cell = (RMPlayRelatedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (! cell) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RMPlayRelatedCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        cell.directBroadcast.hidden = YES;
    }
    [cell.videoImage sd_setImageWithURL:[NSURL URLWithString:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"pic"]] placeholderImage:LOADIMAGE(@"92_138")];
    [cell setTitleLableWithString:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"name"]];
    cell.directBroadcast.identifierString = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"video_id"];
    cell.videoScore.text = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"gold"];
    cell.videoPlayNum.text = [NSString stringWithFormat:@"点播数:%@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"hits"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RMVideoPlaybackDetailsViewController * videoPlaybackDetailsCtl = self.videoPlaybackDetailsDelegate;
    [videoPlaybackDetailsCtl reloadViewDidLoadWithVideo_id:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"video_id"]];
}

- (void)directBroadcastMethodWithImage:(RMImageView *)image {
}

- (void)reloadDataWithModel:(RMPublicModel *)model {
    [dataArr removeAllObjects];
    for (NSInteger i=0; i<[model.relevant count]; i++){
        [dataArr addObject:[model.relevant objectAtIndex:i]];
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
