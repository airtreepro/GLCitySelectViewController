//
//  GLGlobal.m
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "GLGlobal.h"
#import "GLCommonMacro.h"
#import "GLHelper.h"
#import "GLNotificationMacro.h"

static GLGlobal *_instance = nil;

@implementation GLGlobal

#pragma mark singleton

+ (GLGlobal *)sharedGlobal {
    if(_instance == nil)
    {
        _instance = [GLGlobal readGlobeVariablesFromFile];
        if(_instance == nil){
            _instance = [[GLGlobal alloc] init];
        }
    }
    return _instance;
}

- (id)init {
    if(self = [super init]) {
        _currentCity = [[GLCity alloc] init];
        _locationCity = [[GLCity alloc] init];
        //        //城市初始化
        _locationCity.cityStatus = 0;
        _locationCity.cityName = @"";
    }
    
    return self;
}

+ (void) writeGlobeVariablesToFile
{
    NSString *archivedDataFile = [GLHelper getPathInUserDocument:kGlobeVariablesArchiveFileName];
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:_instance];
    if(archivedData){
        [archivedData writeToFile:archivedDataFile atomically:NO];
    }
}

+(GLGlobal *) readGlobeVariablesFromFile
{
    GLGlobal * object = nil;
    NSString *archivedDataFile = [GLHelper getPathInUserDocument:kGlobeVariablesArchiveFileName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:archivedDataFile]) return object;
    NSData *archivedData = [[NSData alloc] initWithContentsOfFile:archivedDataFile];
    if(archivedData) {
        object = (GLGlobal *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    }
    return object;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        _currentCity = [decoder decodeObjectForKey:@"currentCity"];
        _locationCity = [decoder decodeObjectForKey:@"locationCity"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeBool:_iPhone6Plus forKey:@"iPhone6Plus"];
    [encoder encodeObject:_currentCity forKey:@"currentCity"];
    [encoder encodeObject:_locationCity forKey:@"locationCity"];
}


@end
