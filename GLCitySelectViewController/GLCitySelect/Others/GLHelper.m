//
//  GLHelper.m
//  GLCitySelectViewController
//
//  Created by Airtree_pro on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "GLHelper.h"
#include <sys/utsname.h>
#import "GLGlobal.h"
#import "GLCommonMacro.h"
#import "pinyin.h"

#define kUUID @"uuid_created"
#define kSignKeyChainServiceName @"kSignKeyChainServiceName"

@implementation GLHelper

+ (UIImage *)imageAtApplicationDirectoryWithName:(NSString *)fileName {
    if(fileName) {
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[fileName stringByDeletingPathExtension]];
        //判断是否为5.5寸，5.5寸设备使用三倍图
        NSString *imgIconStr = @"2x";
        NSString* tmpPath = nil;
        if([GLGlobal sharedGlobal].iPhone6Plus){
            imgIconStr = @"3x";
            tmpPath = [NSString stringWithFormat:@"%@@%@.%@",path,imgIconStr, [fileName pathExtension]];
            if(![[NSFileManager defaultManager] fileExistsAtPath:tmpPath]) {
                imgIconStr = @"2x";
            }
            tmpPath = [NSString stringWithFormat:@"%@@%@.%@",path,imgIconStr, [fileName pathExtension]];
            if(![[NSFileManager defaultManager] fileExistsAtPath:tmpPath]) {
                imgIconStr = nil;
            }
            if(!tmpPath) {
                tmpPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
            }
            return [UIImage imageWithContentsOfFile:tmpPath];
        }else{
            path = [NSString stringWithFormat:@"%@@%@.%@",path,imgIconStr, [fileName pathExtension]];
            if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                path = nil;
            }
            if(!path) {
                path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
            }
            return [UIImage imageWithContentsOfFile:path];
        }
    }
    return nil;
}

/**
 *	@brief 获取当前设备类型如ipod，iphone，ipad
 *
 */
+ (NSString *)deviceType {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}


+ (void)dismissModalViewController:(UIViewController *)viewController Animated:(BOOL)animated {
    //    if ([viewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
    //        [viewController dismissViewControllerAnimated:animated completion:nil];
    //    } else {
    //        [viewController dismissViewControllerAnimated:animated completion:^{
    //
    //        }];
    //    }
    [viewController dismissViewControllerAnimated:animated completion:nil];
}
+ (void)presentModalViewRootController:(UIViewController *)rootViewController toViewController:(UIViewController *)presentViewController Animated:(BOOL)animated {
    //    if ([rootViewController respondsToSelector:@selector(presentViewController:animated:completion:)]) {
    //        [rootViewController  presentViewController:presentViewController animated:animated completion:nil];
    //    } else {
    //        [rootViewController presentViewController:presentViewController animated:animated completion:^{
    //
    //        }];
    //    }
    [rootViewController  presentViewController:presentViewController animated:animated completion:nil];
}


+ (NSString*)getPathInUserDocument:(NSString*) aPath{
    NSString *fullPath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if ([paths count] > 0)
    {
        fullPath = (NSString *)[paths objectAtIndex:0];
        if(aPath != nil && [aPath compare:@""] != NSOrderedSame)
        {
            fullPath = [fullPath stringByAppendingPathComponent:aPath];
        }
    }
    
    return fullPath;
}



+ (NSDate*)dateOfFileCreateWithFolderName:(NSString *)folderName cacheName:(NSString *)cacheName
{
    NSString *folder = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:folderName];
    NSString *filePath = [folder stringByAppendingPathComponent:cacheName];
    NSError *error;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    
    if(!error) {
        return [attributes objectForKey:NSFileCreationDate];
    }
    
    return nil;
}

+ (int)sizeOfFolder:(NSString*)folderPath {
    NSError *error;
    NSArray *contents = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    NSEnumerator *enumerator = [contents objectEnumerator];
    int totalFileSize = 0;
    
    NSString *path = nil;
    while (path = [enumerator nextObject]) {
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:path] error:&error];
        totalFileSize += [attributes fileSize];
    }
    
    return totalFileSize;
}

+ (void)removeContentsOfFolder:(NSString *)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager subpathsAtPath:folderPath];
    NSEnumerator *enumerator = [contents objectEnumerator];
    
    NSString *file;
    while (file = [enumerator nextObject]) {
        NSString *path = [folderPath stringByAppendingPathComponent:file];
        [fileManager removeItemAtPath:path error:nil];
    }
}

+ (void) deleteContentsOfFolder:(NSString *)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:folderPath error:nil];
    
    
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}


#pragma mark alert
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message withBtnTitle:(NSString*)btnTitle{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:btnTitle
                                              otherButtonTitles:nil];
    [alertView show];
}



/**
 @pram postion(key:位置  value:长度)
 */
+(NSMutableAttributedString *)setNSStringCorlor:(NSString *)_content positon:(NSDictionary*)positionDict withColor:(UIColor*)color
{
    //    NSString *endLength = [NSString stringWithFormat:@"%d",endNum];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_content];
    for (int i=0;i<positionDict.allKeys.count;i++) {
        NSString* key = positionDict.allKeys[i];
        NSString* val = positionDict[key];
        [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange([key intValue],[val intValue])];
    }
    return str;
}



+ (NSData *)requestDataOfCacheWithFolderName:(NSString *)folderName
                                      prefix:(NSString *)prefix
                                      subfix:(NSString *)subfix {
    
    NSString *requestDataCachePath = PATH_AT_DOCDIR((folderName ? folderName : @""));
    NSString *filePrefix = (prefix ? [NSString stringWithFormat:@"%@_", prefix] : @"_");
    NSString *fileSubfix = (subfix ? [NSString stringWithFormat:@"_%@", subfix] : nil);
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:requestDataCachePath];
    
    for(NSString *fileName in files) {
        if([fileName hasPrefix:filePrefix] && (!fileSubfix || (fileSubfix && [fileName hasSuffix:fileSubfix]))) {
            //            double expireTime = [[[fileName componentsSeparatedByString:@"_"] objectAtIndex:1] doubleValue];
            
            //            if((double)[[NSDate date] timeIntervalSince1970] < expireTime) {
            return [NSData dataWithContentsOfFile:[requestDataCachePath stringByAppendingPathComponent:fileName]];
            //            }
        }
    }
    
    return nil;
}


+ (NSData*)readCacheFolderName:(NSString *)folderName cacheName:(NSString *)cacheName
{
    NSString *folder = PATH_AT_CACHEDIR(folderName);
    NSString *filePath = [folder stringByAppendingPathComponent:cacheName];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

+ (NSData *)archiverObject:(NSObject *)object forKey:(NSString *)key {
    if(object == nil) {
        return nil;
    }
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:object forKey:key];
    [archiver finishEncoding];
    
    return data;
}

+ (NSObject *)unarchiverObject:(NSData *)archivedData withKey:(NSString *)key {
    if(archivedData == nil) {
        return nil;
    }
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archivedData];
    NSObject *object = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    
    return object;
}

#pragma mark- 保持与读取最近使用支付方式
+(void)savePayWaysByUserId:(NSDictionary *)dicInfo forkey:(NSString *)theKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = nil;
    if (dicInfo) {
        data = [NSKeyedArchiver archivedDataWithRootObject:dicInfo];
    }
    [defaults setObject:data forKey:theKey];
    [defaults synchronize];
}

+(NSDictionary *)getSavedPayWays:(NSString *)theKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:theKey];
    NSDictionary *dicInfo = nil;
    if (data) {
        dicInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return dicInfo;
}

+ (void)writeCache:(NSData *)cache folderName:(NSString *)folderName cacheName:(NSString *)cacheName {
    NSString *folder = PATH_AT_CACHEDIR(folderName);
    NSString *filePath = [folder stringByAppendingPathComponent:cacheName];
    
    [GLHelper deleteContentsOfFolder:folder];
    [cache writeToFile:filePath atomically:NO];
}

+ (id)valueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}
+ (void)setValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}


/** 定位城市和选择城市是否一致 */
+ (BOOL)isSelectCitySameAsLocatedCity{
    if([GLGlobal sharedGlobal].currentCity.cityStatus == [GLGlobal sharedGlobal].locationCity.cityStatus){
        return YES;
    }
    return NO;
}

+(NSMutableAttributedString *)setNSStringFontAndColor:(NSString *)_content dictionary:(NSDictionary *)dic range:(NSRange)range
{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_content];
    [str addAttributes:dic range:range];
    return str;
}

+ (char)pingyinOfFirstLetter:(NSString *)letter {
    unsigned short hanzi = [letter characterAtIndex:0];
    char pinyin = pinyinFirstLetter(hanzi);
    return pinyin;
}

+ (void)cacheRequestData:(NSData *)data
              folderName:(NSString *)folderName
                  prefix:(NSString *)prefix
                  subfix:(NSString *)subfix{
    
    NSString *requestDataCachePath = PATH_AT_DOCDIR((folderName ? folderName : @""));
    NSString *filePrefix = (prefix ? [NSString stringWithFormat:@"%@_", prefix] : @"_");
    NSString *fileSubfix = (subfix ? [NSString stringWithFormat:@"%@", subfix] : nil);
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:requestDataCachePath];
    
    for(NSString *fileName in files) {
        if([fileName hasPrefix:filePrefix] && (!fileSubfix || (fileSubfix && [fileName hasSuffix:fileSubfix]))) {
            [[NSFileManager defaultManager] removeItemAtPath:[requestDataCachePath stringByAppendingPathComponent:fileName] error:nil];
            break;
        }
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",requestDataCachePath,filePrefix];
    
    if (fileSubfix) {
        filePath = [filePath stringByAppendingString:fileSubfix];
    }
    
    [GLHelper createFolder:filePath isDirectory:NO];
    [data writeToFile:filePath atomically:NO];
}

+ (BOOL)createFolder:(NSString*)folderPath isDirectory:(BOOL)isDirectory {
    NSString *path = nil;
    if(isDirectory) {
        path = folderPath;
    } else {
        path = [folderPath stringByDeletingLastPathComponent];
    }
    
    if(folderPath && [[NSFileManager defaultManager] fileExistsAtPath:path] == NO) {
        NSError *error = nil;
        BOOL ret;
        
        ret = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                        withIntermediateDirectories:YES
                                                         attributes:nil
                                                              error:&error];
        if(!ret && error) {
            NSLog(@"create folder failed at path '%@',error:%@,%@",folderPath,[error localizedDescription],[error localizedFailureReason]);
            return NO;
        }
    }
    
    return YES;
}


@end
