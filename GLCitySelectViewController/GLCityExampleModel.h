//
//  GLCityExampleModel.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/2.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GLCityModelProperty.h"

@interface GLCityExampleModel : NSObject<GLCityModelProperty>
@property (nonatomic, strong) NSString          *cityName;
@property (nonatomic,assign ) NSInteger         cityId;
@property (nonatomic, strong) NSString          *province;
@property (nonatomic, strong) NSString          *pinyin;
@property (nonatomic,assign ) CLLocationDegrees cityLng;//经度
@property (nonatomic,assign ) CLLocationDegrees cityLat;//纬度
@end
