//
//  UIImage+GLAdditions.m
//  GLCitySelectViewController
//
//  Created by Glenn on 15/8/31.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "UIImage+GLAdditional.h"

@implementation UIImage (GLAdditional)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size

{
    
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context,
                                       
                                       color.CGColor);
        
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        return img;
    }
}

@end
