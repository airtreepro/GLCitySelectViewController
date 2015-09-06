//
//  GLCityModel.m
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "GLCityModel.h"

@implementation GLCity

- (id)copyWithZone:(NSZone *)zone
{
    GLCity* copyCity = [[[self class]allocWithZone:zone]init];
    copyCity.cityName = [self.cityName copy];
    copyCity.cityStatus = self.cityStatus;
    copyCity.province = [self.province copy];
    copyCity.pinyin = [self.pinyin copy];
    copyCity.cityLat = self.cityLat;
    copyCity.cityLng = self.cityLng;
    return copyCity;
}
-(NSDictionary *)attrMapDict
{
    return @{@"cityId":@"city_id",@"cityLng":@"centerx",@"cityLat":@"centery",@"cityName":@"name"};
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        _cityName = [decoder decodeObjectForKey:@"cityName"];
        _cityStatus = [decoder decodeIntegerForKey:@"cityStatus"];
        _province = [decoder decodeObjectForKey:@"province"];
        _pinyin = [decoder decodeObjectForKey:@"pinyin"];
        _cityLng = [decoder decodeDoubleForKey:@"cityLng"];
        _cityLat = [decoder decodeDoubleForKey:@"cityLat"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:_cityName forKey:@"cityName"];
    [encoder encodeInteger:(int)_cityStatus forKey:@"cityStatus"];
    [encoder encodeObject:_province forKey:@"province"];
    [encoder encodeObject:_pinyin forKey:@"pinyin"];
    [encoder encodeDouble:_cityLng forKey:@"cityLng"];
    [encoder encodeDouble:_cityLat forKey:@"cityLat"];
}
@end

@implementation GLCityModel

@end
