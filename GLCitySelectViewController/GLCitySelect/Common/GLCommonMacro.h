//
//  GLCommonMacro.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#ifndef GLCitySelectViewController_GLCommonMacro_h
#define GLCitySelectViewController_GLCommonMacro_h

#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define RGB(r,g,b)                  [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1.0f]

#define IMAGE_AT_APPDIR(name)       [GLHelper imageAtApplicationDirectoryWithName:name]
#define PATH_AT_DOCDIR(name)        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name]
#define PATH_AT_CACHEDIR(name)		[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name]
#define is4Inch                     ([UIScreen instancesRespondToSelector:@selector(currentMode)] && [[UIScreen mainScreen] currentMode].size.height == 1136)

/*
 *@bref  系统版本判断
 */
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define iOS7System (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES:NO)

//本地缓存文件定义
#define kCityCachefolder    @"CityCachefolder"
#define kCityCachefile      @"CityCachefile"
#define kCityRecentfolder   @"CityRecentfolder"
#define kCityRecentfile     @"CityRecentfile"
#define kGlobeVariablesArchiveFileName @"GlobeVariables.dat"
#define kMainScreenWidth    ([UIScreen mainScreen].applicationFrame).size.width //应用程序的宽度
#define kMainScreenHeight   ([UIScreen mainScreen].applicationFrame).size.height //应用程序的高度
//#define kMainBoundsHeight   ([UIScreen mainScreen].bounds).size.height //屏幕的高度
#define kMainBoundsWidth    ([UIScreen mainScreen].bounds).size.width //屏幕的宽度
#define kViewSizeWidth      (self.view.frame.size.width)
#define kViewSizeHeight     (self.view.frame.size.height)
#define kNavigationBarHeight 44

#define KNoSelectedCity     @"请先选择城市"
#define kLocationCityUnSuitable [NSString stringWithFormat:@"地址与选择的城市(%@)不一致", [[GLGlobal sharedGlobal]currentCity].cityName]

#define kViewControllerBackgroundColor RGBA(226.f, 226.f, 226.f, 1.0f)
#define kTableViewCellSelectionColor  [[UIColor grayColor] colorWithAlphaComponent:0.4]
#define kTableViewCellSpaceColor RGBA(219, 219, 219, 1.0f)
#define kCheckVerSionInfo @"checkSoftVersion"
#define kOrangeTextColor RGB(250, 54, 21)

#define kIS_IOS7                (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define kMainBoundsHeight   ([UIScreen mainScreen].bounds).size.height //屏幕的高度

#endif
