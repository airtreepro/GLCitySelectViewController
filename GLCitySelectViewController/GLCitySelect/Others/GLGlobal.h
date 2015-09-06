//
//  GLGlobal.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GLCityModel.h"

@interface GLGlobal : NSObject<NSCoding>

@property (nonatomic, strong) GLCity   *currentCity;    //当前选择的城市
@property (nonatomic, strong) GLCity   *locationCity;   //当前定位的城市
@property (nonatomic,assign) BOOL  iPhone6Plus;

+ (GLGlobal *)sharedGlobal;

+ (void) writeGlobeVariablesToFile;

@end
