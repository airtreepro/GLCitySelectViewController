//
//  UIView+GLAdditions.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/8/31.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GLAdditional)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property(nonatomic,readonly) CGFloat screenX;
@property(nonatomic,readonly) CGFloat screenY;
@property(nonatomic,readonly) CGFloat screenViewX;
@property(nonatomic,readonly) CGFloat screenViewY;
@property(nonatomic,readonly) CGRect screenFrame;

@property(nonatomic,readonly) CGFloat orientationWidth;
@property(nonatomic,readonly) CGFloat orientationHeight;

@end
