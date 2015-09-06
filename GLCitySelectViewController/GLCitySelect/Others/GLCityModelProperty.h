//
//  GLCityModelProperty.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/2.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#ifndef GLCitySelectViewController_GLCityModelProperty_h
#define GLCitySelectViewController_GLCityModelProperty_h

@protocol GLCityModelProperty <NSObject>
@property (nonatomic, strong)NSString *cityName;
@property (nonatomic, strong)NSString *province;
@property (nonatomic, strong)NSString *pinyin;
@end

#endif
