//
//  GLSpecialCityCell.m
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "GLSpecialCityCell.h"
#import "GLCityModel.h"
#import "GLTravelCityListModel.h"
#import "GLCommonMacro.h"
#import "GLHelper.h"
#import "UIView+GLAdditional.h"

#define BASE_TAG 100

@interface GLSpecialCityCell()
{
    UIView*                             _bgView ;
}
@end

@implementation GLSpecialCityCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 44)];
        _bgView.backgroundColor = RGB(224, 224, 224);
        [self.contentView addSubview:_bgView];
    }
    return self;
}


-(void)fillCellWithObject:(id)object
{
    _specialCityArray = object;
    BOOL isNeedToCreateBtn = YES;
    if ([self.subviews[0]subviews].count>=_specialCityArray.count+1) {
        isNeedToCreateBtn = NO;
    }
    for (int i=0;i< _specialCityArray.count;i++) {
        if (i>15) {
            break;
        }
        NSString *name = nil;
        if(self.type == kTravelCitySelect){
            GLCity* city = _specialCityArray[i];
            name = city.cityName;
        }
        else{
            GLTravelCityModel *model = _specialCityArray[i];
            name = model.cityName;
        }
        UIButton* cityBtn = nil;
        if (isNeedToCreateBtn) {
            cityBtn = [self createBtnWithTag:i+BASE_TAG andCity:name];
            [self.contentView addSubview:cityBtn];
        }else{
            cityBtn = (UIButton*)[self viewWithTag:i+BASE_TAG];
        }
        [cityBtn setTitle:name forState:UIControlStateNormal];
        [self.contentView bringSubviewToFront:cityBtn];
    }
    if (_specialCityArray.count>15) {
        _bgView.height = 168;
    }else{
        _bgView.height = 44;
    }
}

-(UIButton*)createBtnWithTag:(int)tag andCity:(NSString *)cityName
{
    CGFloat left = (kMainScreenWidth - 20) / 4.f;
    CGFloat width = (kMainScreenWidth - 20 - 36) / 4.f ;
    
    
    UIButton* cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(6+((tag-BASE_TAG)%4)*left, 8+((tag-BASE_TAG)/4)*40, width, 30);
    [cityBtn setTitle:cityName forState:UIControlStateNormal];
    cityBtn.tag = tag;
    cityBtn.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    [cityBtn addTarget:self action:@selector(cityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cityBtn setBackgroundImage:IMAGE_AT_APPDIR(@"bg_city.png") forState:UIControlStateNormal];
    return cityBtn;
}

#pragma mark private method
-(void)cityBtnClicked:(UIButton*)sender
{
    GLCity* city = _specialCityArray[sender.tag-BASE_TAG];
    if (_delegate && [_delegate respondsToSelector:@selector(specialCell:selectModel:)]) {
        [_delegate specialCell:self selectModel:city];
    }
}
@end
