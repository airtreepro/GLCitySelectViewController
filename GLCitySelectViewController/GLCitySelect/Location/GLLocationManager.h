//
//  GLLocationManager.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/*
 Success and Fail have the same Notification Name.
 *to distinguish them:
 *  notification's userinfo == ERROR (Fail    Notification)
 *  notification's userinfo != nil (Success Notification, keys are listed below)
 *For example:
 *
 */


//location Notification
extern NSString * const GLLocationManagerUserLocationDidChangeOrFailNotification;
//region Notification
extern NSString * const GLLocationManagerUserRegionDidChangeOrFailNotification;
//heading Notification
extern NSString * const GLLocationManagerUserHeadingDidChangeOrFailNotification;

//location Info
extern NSString * const GLLocationManagerNotificationLocationUserInfoKey;
extern NSString * const GLLocationManagerNotificationLocationUserInfoKeyOldLocation;
extern NSString * const GLLocationManagerNotificationLocationUserInfoKeyCity;
//region Info
extern NSString * const GLLocationManagerNotificationRegionInfoKey;
extern NSString * const GLLocationManagerNotificationRegionEnterOrExitKey;
//heading Info
extern NSString * const GLLocationManagerNotificationHeadingUserInfoKey;
//error Info
extern NSString * const GLLocationManagerNotificationErrorInfoKey;

@interface GLLocationManager : NSObject
@property (nonatomic, readonly) CLLocation *location;
@property (nonatomic, strong) NSString *purpose;

#pragma mark - Customization
@property (nonatomic) CLLocationDistance userDistanceFilter;
@property (nonatomic) CLLocationAccuracy userDesiredAccuracy;

@property (nonatomic) CLLocationDistance regionDistanceFilter;
@property (nonatomic) CLLocationAccuracy regionDesiredAccuracy;

+ (GLLocationManager *)sharedManager;

+ (BOOL)locationServicesEnabled;

//location will be updated in one time. after update, stopUpdatingLocation will be automatically called.
- (void)updateUserLocation;
//location will be updated in real time. You need explicitly call stopUpdatingLocation
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
