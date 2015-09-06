//
//  NSString+GLAdditions.m
//  GLCitySelectViewController
//
//  Created by Glenn on 15/8/31.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "NSString+GLAdditional.h"
#import <CommonCrypto/CommonDigest.h>
#import "GLCommonMacro.h"

@implementation NSString (GLAdditional)

- (BOOL)isEmptyOrWhitespace {
    return !self.length ||
    ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}

- (CGSize)getSizeWithFont:(UIFont *)font
{
    CGSize size;
    if (font == nil) {
        return size;
    }
    
    if (kIS_IOS7) {
        size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    } else {
        size = [self sizeWithFont:font];
    }
    
    return size;
}


//sizeWithFont:messageLabel.font constrainedToSize:m
- (CGSize)adaptSizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size lineBreakMode:(kLineBreadMode)lineMode
{
    if (kIS_IOS7)
    {
        NSDictionary *attributes = @{ NSFontAttributeName: font};
        CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return rect.size;
    }
    else
    {
        return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineMode];
    }
}



@end
