//
//  NSDictionary+GLAdditional.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/8/31.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GLAdditional)

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;
- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

-(id)getObjectForKey:(NSString*)key defaultValue:(id)defaultValue;

/*
 获取以字符串形式存放的Int类型值,用于简化调用时的判断处理
 */
- (int)getStringIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;



@end
