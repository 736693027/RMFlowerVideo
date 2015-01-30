//
//  UtilityFunc.m
//  RMVideo
//
//  Created by runmobile on 14-9-29.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "UtilityFunc.h"
#import "Reachability.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation UtilityFunc
@synthesize globleWidth, globleHeight, globleAllHeight,dic,isAudio;

+ (UtilityFunc *)shareInstance {
    static UtilityFunc *__singletion;
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

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return [[self class] colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    // Check for hash and add the missing hash
    if('#' != [hexString characterAtIndex:0])
    {
        hexString = [NSString stringWithFormat:@"#%@", hexString];
    }
    
    // check for string length
    assert(7 == hexString.length || 4 == hexString.length);
    
    // check for 3 character HexStrings
    hexString = [[self class] hexStringTransformFromThreeCharacters:hexString];
    
    NSString *redHex    = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(1, 2)]];
    unsigned redInt = [[self class] hexValueToUnsigned:redHex];
    
    NSString *greenHex  = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(3, 2)]];
    unsigned greenInt = [[self class] hexValueToUnsigned:greenHex];
    
    NSString *blueHex   = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(5, 2)]];
    unsigned blueInt = [[self class] hexValueToUnsigned:blueHex];
    
    UIColor *color = [UtilityFunc colorWith8BitRed:redInt green:greenInt blue:blueInt alpha:alpha];
    
    return color;
}

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    return [[self class] colorWith8BitRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha {
    UIColor *color = nil;
#if (TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE)
    color = [UIColor colorWithRed:(float)red/255 green:(float)green/255 blue:(float)blue/255 alpha:alpha];
#else
    color = [UIColor colorWithCalibratedRed:(float)red/255 green:(float)green/255 blue:(float)blue/255 alpha:alpha];
#endif
    
    return color;
}

+ (NSString *)hexStringTransformFromThreeCharacters:(NSString *)hexString {
    if(hexString.length == 4)
    {
        hexString = [NSString stringWithFormat:@"#%@%@%@%@%@%@",
                     [hexString substringWithRange:NSMakeRange(1, 1)],[hexString substringWithRange:NSMakeRange(1, 1)],
                     [hexString substringWithRange:NSMakeRange(2, 1)],[hexString substringWithRange:NSMakeRange(2, 1)],
                     [hexString substringWithRange:NSMakeRange(3, 1)],[hexString substringWithRange:NSMakeRange(3, 1)]];
    }
    
    return hexString;
}

+ (unsigned)hexValueToUnsigned:(NSString *)hexValue {
    unsigned value = 0;
    
    NSScanner *hexValueScanner = [NSScanner scannerWithString:hexValue];
    [hexValueScanner scanHexInt:&value];
    
    return value;
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

+ (UIView *)rotatingView:(UIView *)view {
    CGAffineTransform transform = view.transform;
    transform =  CGAffineTransformRotate(transform, (- M_PI / 4.0));
    view.transform = transform;
    return view;
}

/**
 *
 *  返回缓存图片的本地路径
 *
 */
+ (NSString *)localImageCachesPath {
    return [NSString stringWithFormat:@"%@/DBImageView", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]];
}

/**
 *
 * 计算该路径下文件大小 返回单位为M
 *
 */
//+ (CGFloat) fileSizeAtPath:(NSString*) filePath{
//    NSFileManager* manager = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:filePath]){
//        return ([[manager attributesOfItemAtPath:filePath error:nil] fileSize])/1024.0;
//    }
//    return 0;
//}

/**
 *
 *  返回总共硬盘大小 返回单位是bt
 *
 */
+ (NSNumber *)totalDiskSpace {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

/**
 *
 *  返回硬盘剩余大小 返回单位是bt
 *
 */
+ (NSNumber *) freeDiskSpace {
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

//这个方法不能用了  需要把6 6+ 得判断加上
+ (UIDeviceResolution) currentResolution {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
            return (result.height == 960 ? UIDevice_iPhoneHiRes : UIDevice_iPhoneTallerHiRes);
        } else
            return UIDevice_iPhoneStandardRes;
    } else
        return (([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) ? UIDevice_iPadHiRes : UIDevice_iPadStandardRes);
}

//单个文件的大小
+ (float) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/2048.0/1024.0;
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* fileManeger = [NSFileManager defaultManager];
    NSError *error;
    NSArray *array = [fileManeger contentsOfDirectoryAtPath:folderPath error:&error];
    float sum = 0;
    for(NSString *string in array){
        sum = sum + [self fileSizeAtPath:[NSString stringWithFormat:@"%@/%@",folderPath,string]];
    }
    return sum;
}

#pragma mark- 缩放图片

//按比例缩放
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//缩放到指定大小
+ (UIImage*)scaleFromImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (width <= newSize.width && height <= newSize.height){
        return image;
    }
    
    if (width == 0 || height == 0){
        return image;
    }
    
    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = (widthFactor<heightFactor?widthFactor:heightFactor);
    
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(NSDictionary*)deviceNamesByCode {
    
    static NSDictionary* deviceNamesByCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceNamesByCode = @{
                              @"iPhone3,1" :[NSNumber numberWithInteger:iPhone4],
                              @"iPhone4,1" :[NSNumber numberWithInteger:iPhone4S],
                              @"iPhone5,1" :[NSNumber numberWithInteger:iPhone5],
                              @"iPhone5,2" :[NSNumber numberWithInteger:iPhone5],
                              @"iPhone5,3" :[NSNumber numberWithInteger:iPhone5C],
                              @"iPhone5,4" :[NSNumber numberWithInteger:iPhone5C],
                              @"iPhone6,1" :[NSNumber numberWithInteger:iPhone5S],
                              @"iPhone7,2" :[NSNumber numberWithInteger:iPhone6],
                              @"iPhone7,1" :[NSNumber numberWithInteger:iPhone6Plus],
                              @"i386"      :[NSNumber numberWithInteger:Simulator],
                              @"x86_64"    :[NSNumber numberWithInteger:Simulator]
                              };
    });
    
    return deviceNamesByCode;
}

+(DeviceVersion)deviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    DeviceVersion version = (DeviceVersion)[[self.deviceNamesByCode objectForKey:code] integerValue];
    
    return version;
}

+(DeviceSize)deviceSize {
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight == 480)
        return iPhone35inch;
    else if(screenHeight == 568)
        return iPhone4inch;
    else if(screenHeight == 667)
        return  iPhone47inch;
    else if(screenHeight == 736)
        return iPhone55inch;
    else
        return 0;
}

+(NSString*)deviceName {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([code isEqualToString:@"x86_64"] || [code isEqualToString:@"i386"]) {
        code = @"Simulator";
    }
    
    return code;
}

/**
 *  获取当前显示的UIViewController
 */
+ (UIViewController *)getCurrentRootViewController {
    UIViewController *result;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (topWindow.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows){
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [topWindow subviews].firstObject;
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isMemberOfClass:[UIViewController class]]){
        result = nextResponder;
    }else if([nextResponder isMemberOfClass:[UITabBarController class]] | [nextResponder isMemberOfClass:[UINavigationController class]]){
        result = [self findViewController:nextResponder];
    }else if([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil){
        result = topWindow.rootViewController;
    }else{
        NSAssert(NO, @"找不到顶端VC");
    }
    return result;
}

+ (UIViewController *)findViewController:(id)controller{
    if ([controller isMemberOfClass:[UINavigationController class]]) {
        return [self findViewController:[(UINavigationController *)controller visibleViewController]];
    }else if([controller isMemberOfClass:[UITabBarController class]]){
        return [self findViewController:[(UITabBarController *)controller selectedViewController]];
    }else if([controller isKindOfClass:[UIViewController class]]){
        return controller;
    }else{
        NSAssert(NO, @"找不到顶端VC");
        return nil;
    }
}

////缩放
//static inline CGRect ScaleRect(CGRect rect, float n) {
//    return CGRectMake((rect.size.width - rect.size.width * n)/ 2, (rect.size.height - rect.size.height * n) / 2, rect.size.width * n, rect.size.height * n);
//}


@end
