//
//  GLTravelCityModel.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLTravelCityModel : NSObject
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) NSInteger desCity;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *pinyin;
@end

@interface GLTravelCityListModel : NSObject
@property (nonatomic, strong) NSArray *hot_city;
@property (nonatomic, strong) NSArray *city_list;
@end
