//
//  GLCommonCityCell.m
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "GLCommonCityCell.h"
#import "GLCityModel.h"
#import "GLCommonEnum.h"
#import "GLCommonMacro.h"
#import "GLHelper.h"
#import "UIView+GLAdditional.h"
typedef enum
{
    LSCityLocationDisable = -3,
    LSCityLocating = -2,
    LSCityLocationFailed = -1,
}LSCitySelectedType;
@interface GLCommonCityCell()
{
    GLCity*                             _city;
}
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *line;

@end

@implementation GLCommonCityCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _label.width = kMainScreenWidth;
    _line.width = kMainScreenWidth;
    _statusImageView.right = kMainScreenWidth - 30.f;
}

-(void)fillCellWithObject:(id)object
{
    _city = object;
    if(self.type == kTravelCitySelect){
    }else if (_city.cityStatus == LSCityLocationDisable) {
        _titleLabel.text = @"定位服务不可用";
        _titleLabel.textColor = [UIColor lightGrayColor];
        [_titleLabel sizeToFit];
    }else if(_city.cityStatus == LSCityLocating){
        _titleLabel.text = @"正在定位中...";
        _titleLabel.textColor = kOrangeTextColor;
        [_titleLabel sizeToFit];
    }else if(_city.cityStatus == LSCityLocationFailed){
        NSString* str = @"定位失败，请点击重试";
        NSRange range = [str rangeOfString:@"请点击重试"];
        _titleLabel.attributedText = [GLHelper setNSStringCorlor:str positon:@{@(range.location):@(range.length)} withColor:kOrangeTextColor];
        [_titleLabel sizeToFit];
    }else{
        _titleLabel.text = _city.cityName;
        _titleLabel.textColor = kOrangeTextColor;
        [_titleLabel sizeToFit];
        _titleLabel.centerY = self.contentView.centerY;
        _tipLabel.hidden = YES;
        _tipLabel.left = _titleLabel.right+5;
    }
}

-(void)setTitle:(NSString*)title
{
    _titleLabel.text = title;
}
-(void)setStatus:(BOOL)flag
{
    if (flag) {
        _statusImageView.hidden = NO;
    }else{
        _statusImageView.hidden = YES;
    }
}
-(void)setTitleColor:(UIColor*)color
{
    _titleLabel.textColor = color;
}

@end
