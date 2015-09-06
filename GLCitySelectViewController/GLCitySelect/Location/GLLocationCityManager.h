//
//  GLLocationCityManager.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "GLLocation.h"
#import "GLLocation.h"
#import "GLCityModel.h"

@interface GLLocationCityManager : GLLocation
#pragma mark 根据坐标获取城市名字和id。
typedef void (^FetchLSCityCompletionBlock)(GLCity *city, NSError *error);
/*
 * @brief 根据坐标获取LSCity的id和name，不写入到LSGlobal中
 */
+(void)obtainLSCityWithCoor:(CLLocationCoordinate2D)coordinate
              completeBlock:(FetchLSCityCompletionBlock)completionBlock;
/**
 * @brief 根据坐标获取LSCity的id和name
 * @param isWrite 是否写入到LSGlobal.locationCity中
 */
+(void)obtainLSCityWithCoor:(CLLocationCoordinate2D)coordinate
            isWriteToGlobal:(BOOL)isWrite
              completeBlock:(FetchLSCityCompletionBlock)completionBlock;
@end
