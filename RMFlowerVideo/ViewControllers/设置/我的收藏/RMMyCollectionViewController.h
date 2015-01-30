//
//  RMMyCollectionViewController.h
//  RMFlowerVideo
//
//  Created by runmobile on 15-1-4.
//  Copyright (c) 2015年 runmoble. All rights reserved.
//

#import "RMBaseViewController.h"
#import "RMDownLoadBaseViewController.h"
#import "CUSFileStorage.h"
#import "CUSSerializer.h"
#import "RMAFNRequestManager.h"
#import "RefreshControl.h"
#import "CustomRefreshView.h"

@interface RMMyCollectionViewController : RMDownLoadBaseViewController<RMAFNRequestManagerDelegate,RefreshControlDelegate>

@end
