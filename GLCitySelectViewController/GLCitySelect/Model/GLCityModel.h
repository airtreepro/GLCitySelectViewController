//
//  GLCityModel.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GLCity : NSObject
@property (nonatomic, strong) NSString          *cityName;
@property (nonatomic,assign ) NSInteger         cityStatus;
@property (nonatomic, strong) NSString          *province;
@property (nonatomic, strong) NSString          *pinyin;
@property (nonatomic,assign ) CLLocationDegrees cityLng;//经度
@property (nonatomic,assign ) CLLocationDegrees cityLat;//纬度
@end

@interface GLCityModel : NSObject

@property (nonatomic,strong)NSArray*    hotcity;
@property (nonatomic,strong)NSArray*    allcity;
@end
