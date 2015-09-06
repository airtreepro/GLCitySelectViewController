//
//  NSDictionary+GLAdditional.m
//  GLCitySelectViewController
//
//  Created by Glenn on 15/8/31.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "NSDictionary+GLAdditional.h"

@implementation NSDictionary (GLAdditional)

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    return [self objectForKey:key] == [NSNull null] ? defaultValue
    : [[self objectForKey:key] boolValue];
}

- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue {
    return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] intValue];
}

- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue {
    NSString *stringTime   = [self objectForKey:key];
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
    struct tm created;
    time_t now;
    time(&now);
    
    if (stringTime) {
        if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
            strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
        }
        return mktime(&created);
    }
    return defaultValue;
}

- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
    id obj = [self objectForKey:key];
    if (nil == obj)
    {
        return defaultValue;
    }
    if ([NSNull null] == obj)
    {
        return defaultValue;
    }
    if ([obj isKindOfClass:[NSString class]])
    {
        return [obj longLongValue];
    }
    if ([obj isKindOfClass:[NSNumber class]])
    {
        return [obj longLongValue];
    }
    return defaultValue;
}

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    id obj = [self objectForKey:key];
    if (nil == obj)
    {
        return defaultValue;
    }
    if ([NSNull null] == obj)
    {
        return defaultValue;
    }
    if ([obj isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@",[((NSNumber *)obj) stringValue]];
    }
    if ([obj isKindOfClass:[NSString class]])
    {
        return obj;
    }
    return defaultValue;
}
- (int)getStringIntValueForKey:(NSString *)key defaultValue:(int)defaultValue
{
    NSString* str = [self getStringValueForKey:key defaultValue:nil];
    if (nil == str)
    {
        return defaultValue;
    }
    return [str intValue];
    
}
-(id)getObjectForKey:(NSString*)key defaultValue:(id)defaultValue
{
    return ([self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null])? defaultValue : [self objectForKey:key];
}


@end
