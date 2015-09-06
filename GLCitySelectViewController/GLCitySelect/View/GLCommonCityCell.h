//
//  GLCommonCityCell.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "GLBaseCell.h"
#import "GLCommonEnum.h"

@interface GLCommonCityCell : GLBaseCell

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, assign) GLCitySelectType type;
-(void)setTitle:(NSString*)title;
-(void)setStatus:(BOOL)flag;
-(void)setTitleColor:(UIColor*)color;
@end
