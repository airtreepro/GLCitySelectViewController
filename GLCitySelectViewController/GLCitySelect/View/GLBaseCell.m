//
//  GLBaseCell.m
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "GLBaseCell.h"

@implementation GLBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


+(id)loadFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}

+(NSString*)cellIdentifier
{
    return NSStringFromClass(self);
}
+(id)loadFromCellStyle:(UITableViewCellStyle)cellStyle{
    
    return [[self alloc] initWithStyle:cellStyle reuseIdentifier:NSStringFromClass(self)];
}

- (void)awakeFromNib
{
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)fillCellWithObject:(id)object {

}

+ (CGFloat)heightOfClass {
    return 0;
}

+ (CGFloat)rowHeightForObject:(id)object {
    return 0;
}

@end
