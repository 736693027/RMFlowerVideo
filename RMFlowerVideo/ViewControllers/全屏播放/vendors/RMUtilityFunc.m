//
//  UtilityFunc.m
//  RMVideo
//
//  Created by runmobile on 14-9-29.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMUtilityFunc.h"
#import "Reachability.h"

@implementation RMUtilityFunc
@synthesize globleWidth, globleHeight, globleAllHeight;

+ (RMUtilityFunc *)shareInstance {
    static RMUtilityFunc *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion=[[self alloc] init];
    });
    return __singletion;
}

//检查网络链接是否可用
+ (NSInteger)isConnectionAvailable {
    NSInteger isNet = 0;
    Reachability * reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isNet = 0;
            break;
        case ReachableViaWiFi:
            isNet = 1;
            break;
        case ReachableViaWWAN:
            isNet = 2;
            break;
        case ReachableVia2G:
            isNet = 3;
            break;
        case ReachableVia3G:
            isNet = 4;
            break;
        default:
            
            break;
    }
    return isNet;
}

+ (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font text:(NSString*)text {
    CGSize resultSize;
    //    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
    //        resultSize = [text sizeWithFont:font
    //                      constrainedToSize:size
    //                          lineBreakMode:NSLineBreakByTruncatingTail];
    //    } else {
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect rect = [text boundingRectWithSize:size
                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                  attributes:attrs
                                     context:nil];
    resultSize = rect.size;
    resultSize = CGSizeMake(ceil(resultSize.width), ceil(resultSize.height));
    //    }
    return resultSize;
}

@end
