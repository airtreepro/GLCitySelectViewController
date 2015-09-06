//
//  GLHelper.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GLHelper : NSObject

+ (char)pingyinOfFirstLetter:(NSString *)letter ;

/**********************************文件系统操作****************************/
/** 得到用户document中的一个路径 */
+ (NSString*)getPathInUserDocument:(NSString *)fileName;

/** 获取NSBundele中的资源图片 */
+ (UIImage *)imageAtApplicationDirectoryWithName:(NSString *)fileName;

/*********************************util方法********************************/
/** 将json数据转换成id */
+ (id)parserJsonData:(id)jsonData;

+ (void)cacheRequestData:(NSData *)data
              folderName:(NSString *)folderName
                  prefix:(NSString *)prefix
                  subfix:(NSString *)subfix;

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message withBtnTitle:(NSString*)btnTitle;
+ (NSData *)requestDataOfCacheWithFolderName:(NSString *)folderName
                                      prefix:(NSString *)prefix
                                      subfix:(NSString *)subfix;

//根据text获取label的宽度
+ (CGFloat)widthForLabelWithString:(NSString *)labelString withFontSize:(CGFloat)fontsize withWidth:(CGFloat)width withHeight:(CGFloat)height;

/**
 @pram postion(key:位置  value:长度)
 */
+(NSMutableAttributedString *)setNSStringCorlor:(NSString *)_content positon:(NSDictionary*)positionDict withColor:(UIColor*)color;

/***跳转到根控制器*****/
+(void)jumpRootViewController:(NSInteger)index;


@end
