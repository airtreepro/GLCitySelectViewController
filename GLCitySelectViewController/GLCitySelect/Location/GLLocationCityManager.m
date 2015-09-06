//
//  GLLocationCityManager.m
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "GLLocationCityManager.h"
#import "GLCityModel.h"
#import "GLNotificationMacro.h"

@interface GLLocationCityManager ()
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, assign) BOOL isWrite;
@property(nonatomic, assign) NSInteger numOfRepeat;
@end

@implementation GLLocationCityManager
+(void)obtainLSCityWithCoor:(CLLocationCoordinate2D)coordinate
              completeBlock:(FetchLSCityCompletionBlock)completionBlock
{
    [[self class] obtainLSCityWithCoor:coordinate isWriteToGlobal:NO completeBlock:completionBlock];
}

+(void)obtainLSCityWithCoor:(CLLocationCoordinate2D)coordinate
            isWriteToGlobal:(BOOL)isWrite
              completeBlock:(FetchLSCityCompletionBlock)completionBlock
{
    GLLocationCityManager* cityManager = [GLLocationCityManager shareInstance];
    cityManager.numOfRepeat = 3;//默认次数为3次
    cityManager.isWrite = isWrite;
    cityManager.coordinate = coordinate;
    
    //发送请求
    [cityManager obtainLSCityWithCoor:coordinate isWriteToGlobal:isWrite completeBlock:completionBlock numOfRepeat:cityManager.numOfRepeat];
}

+(void)obtainLSCityWithCity:(NSString *)city
            isWriteToGlobal:(BOOL)isWrite
              completeBlock:(FetchLSCityCompletionBlock)completionBlock
{
    GLLocationCityManager* cityManager = [GLLocationCityManager shareInstance];
    cityManager.numOfRepeat = 3;//默认次数为3次
    
    //发送请求
    [cityManager obtainLSCityWithCity:city isWriteToGlobal:isWrite completeBlock:completionBlock numOfRepeat:cityManager.numOfRepeat];
}


-(void)obtainLSCityWithCoor:(CLLocationCoordinate2D)coordinate
            isWriteToGlobal:(BOOL)isWrite
              completeBlock:(FetchLSCityCompletionBlock)completionBlock
                numOfRepeat:(NSInteger)numOfRepeat
{
    //    //从服务器取城市id获取经纬度后，再回调结果
    //    LSLocateCityRequest *cityRequest = [[LSLocateCityRequest alloc] initWithCoor:coordinate andWriteToGlobal:isWrite];
    //    [cityRequest sendRequestSuccFinishBlock:^(LSBaseRequest *request)
    //     {
    //         if ([request.result isKindOfClass:[LSCity class]]) {
    //             DLog(@"获取城市ID成功：MaxRepeat:%d numOfRepeat:%d", self.numOfRepeat, self.numOfRepeat-numOfRepeat+1);
    //             completionBlock(request.result, nil);//如果获取城市名称成功，再次调用completionBlock发通知
    //         }
    //         else{
    //             NSError* error = [NSError errorWithDomain:@"定位获取服务器城市ID和Name失败" code:LSLocationObtainCityErrorCode userInfo:request.result];
    //             [self errorBlockWithResult:nil error:error completeBlock:completionBlock numOfRepeat:numOfRepeat];
    //         }
    //     } requestFailFinishBlock:^(LSBaseRequest *request) {
    //         NSError* error = [NSError errorWithDomain:@"定位获取服务器城市ID和Name失败" code:LSLocationObtainCityErrorCode userInfo:request.result];
    //         [self errorBlockWithResult:nil error:error completeBlock:completionBlock numOfRepeat:numOfRepeat];
    //     }];
}

-(void)obtainLSCityWithCity:(NSString *)city
            isWriteToGlobal:(BOOL)isWrite
              completeBlock:(FetchLSCityCompletionBlock)completionBlock
                numOfRepeat:(NSInteger)numOfRepeat
{
    
    GLCity *cityModel= [[GLCity alloc] init];
    cityModel.cityName = city;
//    cityModel.hasCinema = YES;
    
    if (city && ![city isEqualToString:@""]) {
        
        completionBlock(cityModel, nil);//如果获取城市名称成功，再次调用completionBlock发通知
    }
    else{
        NSError* error = [NSError errorWithDomain:@"定位获取服务器城市ID和Name失败" code:LSLocationObtainCityErrorCode userInfo:nil];
        [self errorBlockWithResult:nil error:error completeBlock:completionBlock numOfRepeat:numOfRepeat];
    }
}


-(void)errorBlockWithResult:(id)result
                      error:(NSError*)error
              completeBlock:(FetchLSCityCompletionBlock)completionBlock
                numOfRepeat:(NSInteger)numOfRepeat
{
    //    DLog(@"获取城市ID失败：MaxRepeat:%d numOfRepeat:%d", self.numOfRepeat, self.numOfRepeat-numOfRepeat+1);
    
    if(numOfRepeat <= 1){
        completionBlock(nil, error);
        return;
    }
    
    [self obtainLSCityWithCoor:self.coordinate isWriteToGlobal:self.isWrite completeBlock:completionBlock numOfRepeat:numOfRepeat-1];
}
#pragma mark 重写基类的方法

-(void)locationChangedTocity:(NSString *)city {
    
    //    DLog(@"位置改变：获取城市定位城市id");
    [[self class] obtainLSCityWithCity:city
                       isWriteToGlobal:YES
                         completeBlock:^(GLCity *city, NSError *error){
                             if(error){
                                 [self postErrorNotification:error];
                             }
                             else {
                                 [self postNotification:city];
                             }
                         }];
    
}


-(void)locationChangedFrom:(CLLocation *)oldLocation toNewLocation:(CLLocation *)newLocation
{
    //    DLog(@"位置改变：获取城市定位城市id");
    [[self class] obtainLSCityWithCoor:newLocation.coordinate
                       isWriteToGlobal:YES
                         completeBlock:^(GLCity *city, NSError *error){
                             if(error){
                                 [self postErrorNotification:error];
                             }
                             else {
                                 [self postNotification:city];
                             }
                         }];
}
-(NSString*)notificationName
{
    return kLocationCityChangeNotification;
}
//单例
+(id)shareInstance
{
    static dispatch_once_t onceToken;
    static GLLocation *location = nil;
    dispatch_once(&onceToken, ^{
        location = [[self alloc] init];
    });
    return location;
}

@end
