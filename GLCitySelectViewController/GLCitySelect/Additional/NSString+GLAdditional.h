//
//  NSString+GLAdditions.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/8/31.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GLDefine.h"

@interface NSString (GLAdditional)

/**
 * Determines if the string is empty or contains only whitespace.
 */
- (BOOL)isEmptyOrWhitespace;

/**
 *@brief 根据当前的字符串字体获取字符串的CGSize数据，自动适配IOS7和IOS7以下系统
 *@param font   当前字符串的字体
 */
- (CGSize)getSizeWithFont:(UIFont *)font;

- (CGSize)adaptSizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size lineBreakMode:(kLineBreadMode)lineMode;

@end
