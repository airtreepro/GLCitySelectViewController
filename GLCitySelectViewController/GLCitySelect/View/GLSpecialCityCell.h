//
//  GLSpecialCityCell.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "GLBaseCell.h"
#import "GLCommonEnum.h"

@class GLCity;
@protocol GLSpecialCityCellDelegate;

@interface GLSpecialCityCell : GLBaseCell
@property (nonatomic, strong)NSArray* specialCityArray;

@property (nonatomic, assign) id<GLSpecialCityCellDelegate> delegate;
@property (nonatomic, assign) GLCitySelectType type;
@end

@protocol GLSpecialCityCellDelegate <NSObject>

-(void)specialCell:(GLSpecialCityCell*)cell selectModel:(GLCity*)city;

@end
