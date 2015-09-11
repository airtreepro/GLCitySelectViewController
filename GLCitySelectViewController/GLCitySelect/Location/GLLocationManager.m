//
//  GLLocationManager.m
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "GLLocationManager.h"
#import "GLGlobal.h"
#import "GLCityModel.h"

#define MAX_MONITORING_REGIONS 20

#define kDefaultHeadingFilter           8
#define kDefaultUserDistanceFilter      100
#define kDefaultUserDesiredAccuracy     kCLLocationAccuracyNearestTenMeters
#define kDefaultRegionDistanceFilter    kCLLocationAccuracyBestForNavigation
#define kDefaultRegionDesiredAccuracy   kCLLocationAccuracyBest
#define kDefaultRegionRadiusDistance    500

//location Notification
NSString * const GLLocationManagerUserLocationDidChangeOrFailNotification = @"GLLocationManagerUserLocationDidChangeNotification";
//region Notification
NSString * const GLLocationManagerUserRegionDidChangeOrFailNotification = @"GLLocationManagerUserRegionDidChangeNotification";
//heading Notification
NSString * const GLLocationManagerUserHeadingDidChangeOrFailNotification = @"GLLocationManagerUserHeadingDidChangeNotification";

//location Info
NSString * const GLLocationManagerNotificationLocationUserInfoKey = @"kNewLocationKey";
NSString * const GLLocationManagerNotificationLocationUserInfoKeyOldLocation = @"kOldLocationKey";
NSString * const GLLocationManagerNotificationLocationUserInfoKeyCity = @"kCityKey";
//region Info
NSString * const GLLocationManagerNotificationRegionInfoKey = @"kRegionInfo";
NSString * const GLLocationManagerNotificationRegionEnterOrExitKey = @"kRegionEnterOrExit";
//heading Info
NSString * const GLLocationManagerNotificationHeadingUserInfoKey = @"kNewHeadingKey";

//error Info
NSString * const GLLocationManagerNotificationErrorInfoKey = @"kErrorKey";

@interface GLLocationManager () <CLLocationManagerDelegate>
{
    BOOL _isUpdatingUserLocation;
    BOOL _isOnlyOneRefresh;
    CLLocationManager *_userLocationManager;
    CLLocationManager *_regionLocationManager;
}

- (void)_init;
- (void)_addRegionForMonitoring:(CLRegion *)region desiredAccuracy:(CLLocationAccuracy)accuracy;
- (BOOL)region:(CLRegion *)region inRegion:(CLRegion *)otherRegion;
- (BOOL)isMonitoringThisCoordinate:(CLLocationCoordinate2D)coordinate;
- (BOOL)isMonitoringThisRegion:(CLRegion *)region;
@end



@implementation GLLocationManager

+ (GLLocationManager *)sharedManager {
    static GLLocationManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GLLocationManager alloc] init];
    });
    
    return _sharedClient;
}

- (id)init
{
    NSLog(@"[%@] init:", NSStringFromClass([self class]));
    if (self = [super init]) {
        // Init
        [self _init];
    }
    return self;
}

- (void)dealloc
{
    self.purpose = nil;
}

- (id)initWithUserDistanceFilter:(CLLocationDistance)userDistanceFilter userDesiredAccuracy:(CLLocationAccuracy)userDesiredAccuracy purpose:(NSString *)purpose
{
    NSLog(@"[%@] init:", NSStringFromClass([self class]));
    
    if (self = [super init]) {
        // Init
        [self _init];
        _userLocationManager.distanceFilter = userDistanceFilter;
        _userLocationManager.desiredAccuracy = userDesiredAccuracy;
        _purpose = purpose;
    }
    return self;
}

- (void)_init
{
    NSLog(@"[%@] _init:", NSStringFromClass([self class]));
    
    _isUpdatingUserLocation = NO;
    _isOnlyOneRefresh = NO;
    
    _userLocationManager = [[CLLocationManager alloc] init];
    _userLocationManager.distanceFilter  = kDefaultUserDistanceFilter;
    _userLocationManager.desiredAccuracy = kDefaultUserDesiredAccuracy;
    _userLocationManager.headingFilter   = kDefaultHeadingFilter;
    _userLocationManager.delegate = self;
    
    _regionLocationManager = [[CLLocationManager alloc] init];
    _regionLocationManager.distanceFilter = kDefaultRegionDistanceFilter;
    _regionLocationManager.desiredAccuracy = kDefaultRegionDesiredAccuracy;
    _regionLocationManager.delegate = self;
    
    //    if([_userLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
    //        [_userLocationManager requestAlwaysAuthorization];
    //        [_userLocationManager requestWhenInUseAuthorization];
    //        [_regionLocationManager requestAlwaysAuthorization];
    //        [_regionLocationManager requestWhenInUseAuthorization];
    //    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {    switch (status) {
    case kCLAuthorizationStatusNotDetermined:
        if ([_userLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//            [_userLocationManager requestAlwaysAuthorization];
        }
        break;
    default:
    break;    }
}

#pragma mark - Private

/**
 * @discussion check if region is correct
 */
- (void)_addRegionForMonitoring:(CLRegion *)region desiredAccuracy:(CLLocationAccuracy)accuracy
{
    NSSet *regions = _regionLocationManager.monitoredRegions;
    NSLog(@"[%@] _addRegionForMonitoring:desiredAccuracy: [regions count]: %d", NSStringFromClass([self class]), [regions count]);
    
    NSAssert([CLLocationManager regionMonitoringAvailable] || [CLLocationManager regionMonitoringEnabled], @"RegionMonitoring not available!");
    NSAssert([regions count] < MAX_MONITORING_REGIONS, @"Only support %d regions!", MAX_MONITORING_REGIONS);
    NSAssert(accuracy < _regionLocationManager.maximumRegionMonitoringDistance, @"Accuracy is too long!");
    
    [_regionLocationManager startMonitoringForRegion:region desiredAccuracy:accuracy];
}

/**
 * @discussion only check if region is inside otherRegion
 */
- (BOOL)region:(CLRegion *)region inRegion:(CLRegion *)otherRegion
{
    NSLog(@"[%@] region:containsRegion:", NSStringFromClass([self class]));
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:otherRegion.center.latitude longitude:otherRegion.center.longitude];
    
    if ([region containsCoordinate:otherRegion.center] || [otherRegion containsCoordinate:region.center]) {
        if ([location distanceFromLocation:otherLocation] + region.radius <= otherRegion.radius ) {
            return YES;
        } else if ([location distanceFromLocation:otherLocation] + otherRegion.radius <= region.radius ) {
            return NO;
        }
    }
    return NO;
}

/**
 * @discussion check if coordinate is in a region
 */
- (BOOL)isMonitoringThisCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"[%@] isMonitoringThisCoordinate:", NSStringFromClass([self class]));
    
    NSSet *regions = _regionLocationManager.monitoredRegions;
    
    for (CLRegion *reg in regions) {
        if ([reg containsCoordinate:coordinate]) {
            return YES;
        }
    }
    return NO;
}

/**
 * @discussion check if region is inside other region
 */
- (BOOL)isMonitoringThisRegion:(CLRegion *)region {
    NSLog(@"[%@] isMonitoringThisRegion:", NSStringFromClass([self class]));
    
    NSSet *regions = _regionLocationManager.monitoredRegions;
    
    for (CLRegion *reg in regions) {
        if ([self region:region inRegion:reg]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Setters

- (void)setUserDistanceFilter:(CLLocationDistance)userDistanceFilter {
    NSLog(@"[%@] setUserDistanceFilter:%f", NSStringFromClass([self class]), userDistanceFilter);
    
    _userDistanceFilter = userDistanceFilter;
    [_userLocationManager setDistanceFilter:_userDistanceFilter];
}

- (void)setUserDesiredAccuracy:(CLLocationAccuracy)userDesiredAccuracy {
    NSLog(@"[%@] setUserDesiredAccuracy:%f", NSStringFromClass([self class]), userDesiredAccuracy);
    
    _userDesiredAccuracy = userDesiredAccuracy;
    [_userLocationManager setDesiredAccuracy:_userDesiredAccuracy];
}

- (void)setRegionDistanceFilter:(CLLocationDistance)regionDistanceFilter {
    NSLog(@"[%@] setRegionDistanceFilter:%f", NSStringFromClass([self class]), regionDistanceFilter);
    
    _regionDistanceFilter = regionDistanceFilter;
    [_regionLocationManager setDistanceFilter:_regionDistanceFilter];
}

- (void)setRegionDesiredAccuracy:(CLLocationAccuracy)regionDesiredAccuracy {
    NSLog(@"[%@] setRegionDesiredAccuracy:%f", NSStringFromClass([self class]), regionDesiredAccuracy);
    
    _regionDesiredAccuracy = regionDesiredAccuracy;
    [_regionLocationManager setDesiredAccuracy:_regionDesiredAccuracy];
}

- (void)setPurpose:(NSString *)purpose {
    NSLog(@"[%@] setPurpose:%@", NSStringFromClass([self class]), purpose);
    
    if (![_purpose isEqualToString:purpose]) {
        _userLocationManager.purpose = [purpose copy];
        _regionLocationManager.purpose = [purpose copy];
        _purpose = [purpose copy];
    }
}

#pragma mark - Getters

- (CLLocation *)location
{
    NSLog(@"[%@] location:", NSStringFromClass([self class]));
    
    return _userLocationManager.location;
}

- (NSSet *)regions
{
    return _regionLocationManager.monitoredRegions;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"[%@] locationManager:didFailWithError:%@ ", NSStringFromClass([self class]), error);
    
    //userInfo == nil: means failed, Uses need to judge "locationEnabled, networkStatus and other"
    [[NSNotificationCenter defaultCenter] postNotificationName:GLLocationManagerUserLocationDidChangeOrFailNotification
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error, GLLocationManagerNotificationErrorInfoKey, nil]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"[%@] locationManager:didUpdateToLocation:fromLocation: %@", NSStringFromClass([self class]), newLocation);
    
    //for refresh once
    if (_isOnlyOneRefresh) {
        [_userLocationManager stopUpdatingLocation];
        _isOnlyOneRefresh = NO;
    }
    
    //反地理编码
    [self geocoderWithNewLocation:newLocation andOldLocation:oldLocation];
}

- (void)geocoderWithNewLocation:(CLLocation *)newLocation andOldLocation:(CLLocation *)oldLocation {
    [[[CLGeocoder alloc] init] reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count == 0) {//失败
            [self geocoderWithNewLocation:newLocation andOldLocation:oldLocation];
        } else { // 编码成功（找到了具体的位置信息）
            // 输出查询到的所有地标信息
            NSString *city = nil;
            for (CLPlacemark *placemark in placemarks) {
                NSDictionary *addressDictionary = placemark.addressDictionary;
                city = addressDictionary[@"State"];
                city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
            }
           
            NSMutableDictionary *inforDict = [NSMutableDictionary dictionary];
            if (newLocation) {
              [inforDict setObject:newLocation forKey:GLLocationManagerNotificationLocationUserInfoKey];
            }
            if (oldLocation) {
              [inforDict setObject:oldLocation forKey:GLLocationManagerNotificationLocationUserInfoKeyOldLocation];
            }
            if (city) {
              [inforDict setObject:city forKey:GLLocationManagerNotificationLocationUserInfoKeyCity];
            }
            
            //userInfo != nil: newLocation and oldLocation is returned in userInfo
            //attention: oldLocation may be nil, so I use dictionaryWithObjectsAndKeys instead of @{}.
            [[NSNotificationCenter defaultCenter] postNotificationName:GLLocationManagerUserLocationDidChangeOrFailNotification
                                                                object:self
                                                              userInfo:inforDict];
            
            GLCity *locationCity = [[GLCity alloc] init];
            locationCity.cityName = city;
            locationCity.cityLat = newLocation.coordinate.latitude;
            locationCity.cityLng = newLocation.coordinate.longitude;
            [GLGlobal sharedGlobal].locationCity = locationCity;
            [GLGlobal writeGlobeVariablesToFile];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"[%@] locationManager:didEnterRegion:%@ at %@", NSStringFromClass([self class]), region.identifier, [NSDate date]);
    
    //userInfo != nil: enterOrExit and region are returned in useInfo
    [[NSNotificationCenter defaultCenter] postNotificationName:GLLocationManagerUserRegionDidChangeOrFailNotification
                                                        object:self
                                                      userInfo:@{GLLocationManagerNotificationRegionInfoKey: region, GLLocationManagerNotificationRegionEnterOrExitKey: @YES}];
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"[%@] locationManager:didExitRegion:%@ at %@", NSStringFromClass([self class]), region.identifier, [NSDate date]);
    
    //userInfo != nil: enterOrExit and region are returned in useInfo
    [[NSNotificationCenter defaultCenter] postNotificationName:GLLocationManagerUserRegionDidChangeOrFailNotification
                                                        object:self
                                                      userInfo:@{GLLocationManagerNotificationRegionInfoKey: region, GLLocationManagerNotificationRegionEnterOrExitKey: @NO}];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"[%@] locationManager:monitoringDidFailForRegion:%@: %@", NSStringFromClass([self class]), region.identifier, error);
    
    //userInfo == ERROR: monitoring Region Failed.
    [[NSNotificationCenter defaultCenter] postNotificationName:GLLocationManagerUserRegionDidChangeOrFailNotification
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error, GLLocationManagerNotificationErrorInfoKey, nil]];
}

//heading
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    //    NSLog(@"[%@] didUpdateHeading: %@", NSStringFromClass([self class]), newHeading);
    
    //userInfo != nil: enterOrExit and region are returned in useInfo
    [[NSNotificationCenter defaultCenter] postNotificationName:GLLocationManagerUserHeadingDidChangeOrFailNotification
                                                        object:self
                                                      userInfo:@{GLLocationManagerNotificationHeadingUserInfoKey: newHeading}];
}
#pragma mark Method's

+ (BOOL)headingServicesAvailable{
    return [CLLocationManager headingAvailable];
}
+ (BOOL)locationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

+ (BOOL)regionMonitoringAvailable {
    return [CLLocationManager regionMonitoringAvailable];
}

+ (BOOL)regionMonitoringEnabled {
    return [CLLocationManager regionMonitoringEnabled];
}

+ (BOOL)significantLocationChangeMonitoringAvailable {
    return [CLLocationManager significantLocationChangeMonitoringAvailable];
}


#pragma mark Location methods
- (void)startUpdatingLocation
{
    NSLog(@"[%@] startUpdatingLocation:", NSStringFromClass([self class]));
    
    _isUpdatingUserLocation = YES;
    [_userLocationManager startUpdatingLocation];
    
#if TARGET_IPHONE_SIMULATOR
    //    [self locationManager:_userLocationManager
    //      didUpdateToLocation:[[CLLocation alloc] initWithLatitude:40.007065 longitude:116.484016]
    //             fromLocation:[[CLLocation alloc] initWithLatitude:40.007065 longitude:116.484016]];
#endif
}

- (void)updateUserLocation {
    NSLog(@"[%@] updateUserLocation:", NSStringFromClass([self class]));
    
    if (!_isOnlyOneRefresh) {
        _isOnlyOneRefresh = YES;
        [_userLocationManager startUpdatingLocation];
    }
}

- (void)stopUpdatingLocation {
    NSLog(@"[%@] stopUpdatingLocation:", NSStringFromClass([self class]));
    
    _isUpdatingUserLocation = NO;
    [_userLocationManager stopUpdatingLocation];
}

#pragma mark Heading
//heading will be updated in real time. You need explicitly call stopUpdatingHeading
- (void)startUpdatingHeading
{
    NSLog(@"[%@] startUpdatingHeading:", NSStringFromClass([self class]));
    
    if([CLLocationManager headingAvailable])
    {
        [_userLocationManager startUpdatingHeading];
    }
}
- (void)stopUpdatingHeading
{
    NSLog(@"[%@] stopUpdatingHeading:", NSStringFromClass([self class]));
    
    [_userLocationManager stopUpdatingHeading];
}
#pragma mark Coordinate methods
- (void)addCoordinateForMonitoring:(CLLocationCoordinate2D)coordinate {
    NSLog(@"[%@] addCoordinateForMonitoring:", NSStringFromClass([self class]));
    
    [self addCoordinateForMonitoring:coordinate withRadius:kDefaultRegionRadiusDistance desiredAccuracy:kDefaultRegionDesiredAccuracy];
}

- (void)addCoordinateForMonitoring:(CLLocationCoordinate2D)coordinate withRadius:(CLLocationDistance)radius {
    [self addCoordinateForMonitoring:coordinate withRadius:radius desiredAccuracy:kDefaultRegionDesiredAccuracy];
}

- (void)addCoordinateForMonitoring:(CLLocationCoordinate2D)coordinate withRadius:(CLLocationDistance)radius desiredAccuracy:(CLLocationAccuracy)accuracy {
    NSLog(@"[%@] addCoordinateForMonitoring:withRadius:", NSStringFromClass([self class]));
    
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:coordinate radius:radius identifier:[NSString stringWithFormat:@"Region with center (%f, %f) and radius (%f)", coordinate.latitude, coordinate.longitude, radius]];
    
    [self addRegionForMonitoring:region desiredAccuracy:accuracy];
}

#pragma mark Region methods
- (void)addRegionForMonitoring:(CLRegion *)region {
    NSLog(@"[%@] addRegionForMonitoring:", NSStringFromClass([self class]));
    
    [self addRegionForMonitoring:region desiredAccuracy:kDefaultRegionDesiredAccuracy];
}

- (void)addRegionForMonitoring:(CLRegion *)region desiredAccuracy:(CLLocationAccuracy)accuracy {
    NSLog(@"[%@] addRegionForMonitoring:", NSStringFromClass([self class]));
    
    if (![self isMonitoringThisRegion:region]) {
        [self _addRegionForMonitoring:region desiredAccuracy:accuracy];
    }
}

- (void)stopMonitoringForRegion:(CLRegion *)region {
    NSLog(@"[%@] stopMonitoringForRegion:", NSStringFromClass([self class]));
    
    [_regionLocationManager stopMonitoringForRegion:region];
}

- (void)stopMonitoringAllRegions {
    NSSet *regions = _regionLocationManager.monitoredRegions;
    NSLog(@"[%@] stopMonitoringAllRegion: [regions count]: %d", NSStringFromClass([self class]), [regions count]);
    
    for (CLRegion *reg in regions) {
        [_regionLocationManager stopMonitoringForRegion:reg];
    }
}

@end
