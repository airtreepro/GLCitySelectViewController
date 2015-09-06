//
//  GLLocation.m
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "GLLocation.h"
#import "GLLocationManager.h"
#import "NSDictionary+GLAdditional.h"

@interface GLLocation ()
{
    BOOL isAddObserver;
}
@end

@implementation GLLocation
//添加通知观察
- (id)init
{
    self = [super init];
    if (self)
    {
        [[GLLocationManager sharedManager] startUpdatingLocation];
        [self addObserverLocation];
    }
    return self;
}
/*
 *注意测试
 */
-(void)addObserverLocation
{
    if(isAddObserver){
        return;
    }
    
    isAddObserver = TRUE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationChanged:)
                                                 name:GLLocationManagerUserLocationDidChangeOrFailNotification
                                               object:nil];
    
}

+ (id)shareInstance {
    
    return nil;
}

-(void)removeObserverLocation
{
    if(!isAddObserver)
        return;
    //    DLog(@"");
    isAddObserver = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)dealloc
{
    [self removeObserverLocation];
}
#pragma mark 地理位置改变回调
- (void)locationChanged:(NSNotification *)note
{
    //暂时不太好区分定位多次返回的情况，考虑用时间，距离或者第一次返回无效3种方式
    NSDictionary* userInfo = note.userInfo;
    NSError* error = [userInfo getObjectForKey:GLLocationManagerNotificationErrorInfoKey defaultValue:nil];
    if(error)
    {
        [self postErrorNotification:error];
        //        DLog(@"定位失败");
        return;
    }
    
    //定位成功，获取到newLocation和oldLocation
    CLLocation* newLocation = (CLLocation*)[userInfo getObjectForKey:GLLocationManagerNotificationLocationUserInfoKey defaultValue:nil];
    CLLocation* oldLocation = (CLLocation*)[userInfo getObjectForKey:GLLocationManagerNotificationLocationUserInfoKeyOldLocation defaultValue:nil];
    
    if(newLocation == nil){
        //        DLog(@"ERROR: newLocation == nil");
        return;
    }
    //    [self locationChangedFrom:oldLocation toNewLocation:newLocation];
    [self locationChangedTocity:[userInfo getObjectForKey:GLLocationManagerNotificationLocationUserInfoKeyCity defaultValue:nil]];
}

#pragma mark 抛出通知相关custom方法
//抛出正常通知，携带正常object对象到object
-(void)postNotification:(NSObject*)object
{
    [self postNotification:object userInfo:nil];
}
//抛出错误通知，携带error对象到object
-(void)postErrorNotification:(NSError*)error
{
    [self postNotification:error userInfo:nil];
}
//抛出通知名字：kLocationAddressChangeNotification
-(void)postNotification:(NSObject*)object userInfo:(NSDictionary*)userInfo
{
    NSString* locationName = [self notificationName];
    if(locationName.length == 0){
        //        DLog(@"ERROR: notificationName == nil");
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:locationName
                                                        object:object
                                                      userInfo:userInfo];
}

#pragma mark 外部public方法
//重新获取位置
+ (void)reObtainLocation
{
    [[GLLocationManager sharedManager] stopUpdatingLocation];
    [[GLLocationManager sharedManager] startUpdatingLocation];
}
+ (void)reObtainLocationOnce
{
    [[GLLocationManager sharedManager] stopUpdatingLocation];
    [[GLLocationManager sharedManager] updateUserLocation];
}
#pragma mark 派生类负责实现
-(NSString*)notificationName
{
    return nil;
}
-(void)locationChangedFrom:(CLLocation*)oldLocation toNewLocation:(CLLocation*)newLocation
{
    [self postNotification:newLocation];
}

-(void)locationChangedTocity:(NSString *)city
{
    [self postNotification:city];
}

@end
