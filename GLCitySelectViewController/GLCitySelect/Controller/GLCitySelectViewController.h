//
//  GLCitySelectViewController.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/2.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "GLBaseViewController.h"
#import "GLCityModel.h"

@class GLCitySelectViewController;

@protocol GLCitySelectViewControllerDeleage <NSObject>

/**
 *  定位城市文字描述,定位成功时调用该代理方法
 *
 *  @param citySelectViewController 城市选择控制器
 *  @param LocationCity             定位城市模型
 *
 *  @return 定位城市的描述
 */
- (NSString *)locationCityDesCityOfSelectViewController:(GLCitySelectViewController *)citySelectViewController updateLocationWithLocationCity:(id)LocationCity;

/**
 *  城市选择控制器获取列表数据，获取列表数据时调用该代理方法
 *
 *  @param citySelectViewController 城市选择控制器
 *  @param completion               传入数据的block
 */
- (void)citySelectViewController:(GLCitySelectViewController *)citySelectViewController getDataWithCompletionHandler:(void (^)(GLCityModel *data))completion;

/**
 *  点击城市时调用该代理方法
 *
 *  @param citySelectViewController 城市选择控制器
 *  @param selectCity               选择的城市模型
 *  @param locationCity             定位城市模型
 *
 *  @return 返回YES跳转，返回NO不跳回
 */
- (BOOL)citySelectViewController:(GLCitySelectViewController *)citySelectViewController didSelectCity:(id)selectCity locationCity:(id)locationCity;

@end

@interface GLCitySelectViewController : GLBaseViewController

///** default is Yes */
//@property (nonatomic, assign) BOOL showSearchBar;
//
/** default is Yes 暂时无法使用 */
@property (nonatomic, assign) BOOL showLocationCell;
//
/** default is Yes */
@property (nonatomic, assign) BOOL showRecentCityCell;
//
/** default is Yes */
@property (nonatomic, assign) BOOL showHotCityCell;

@property (nonatomic, weak) id <GLCitySelectViewControllerDeleage> delegate;

@end
