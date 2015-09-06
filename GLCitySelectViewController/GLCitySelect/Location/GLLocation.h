//
//  GLLocation.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GLLocation : NSObject

+(id)shareInstance;
/*
 *note 一直获取位置，只要位置改变，就会有通知。
 */
+ (void)reObtainLocation;
/*
 *note 只获取一次位置，获取完毕后关闭定位
 */
+ (void)reObtainLocationOnce;

#pragma mark 派生类负责实现
/*
 *@brief 派生类负责return通知名字
 */
-(NSString*)notificationName;
/*
 *@brief 派生类负责对old和newLocation进行操作。基类默认抛出object为newLocation的通知。
 */
-(void)locationChangedFrom:(CLLocation*)oldLocation toNewLocation:(CLLocation*)newLocation;

-(void)addObserverLocation;
-(void)removeObserverLocation;

#pragma mark 抛出通知相关custom方法
-(void)postNotification:(NSObject*)object;
-(void)postErrorNotification:(NSError*)error;
-(void)postNotification:(NSObject*)object userInfo:(NSDictionary*)userInfo;

@end
