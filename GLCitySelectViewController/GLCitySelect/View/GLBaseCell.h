//
//  GLBaseCell.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLBaseCell : UITableViewCell
/**
 *  用xib创建Cell
 *
 *  @return self;
 */
+(id)loadFromXib;

/**
 *  用代码创建Cell时候设置的cellIdentifier
 *
 *  @return cellIdentifier;
 */
+(NSString*)cellIdentifier;
/**
 *  用代码创建Cell
 *
 *  @return self;
 */

+(id)loadFromCellStyle:(UITableViewCellStyle)cellStyle;

/**
 *  填充cell的对象
 *  子类去实现
 */

- (void)fillCellWithObject:(id)object;

/**
 *  计算cell高度
 *  子类去实现
 */

+ (CGFloat)rowHeightForObject:(id)object;


+ (CGFloat)heightOfClass;


@end
