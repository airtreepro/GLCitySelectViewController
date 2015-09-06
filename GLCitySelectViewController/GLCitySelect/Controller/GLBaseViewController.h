//
//  GLBaseViewController.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    LSGuideType_Arround=0,
    LSGuideType_Account
}LSGuideType;

@interface GLBaseViewController : UIViewController<UIGestureRecognizerDelegate>


/**
 *	@brief	自定义titlte居中处理
 *
 *	@param 	title 	title
 */
- (void)setNavTitle:(NSString *)title;

- (void)setNavRightButtonwithImg:(NSString *)normalImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action;
- (void)setNavLeftButtonwithImg:(NSString *)normalImg selImg:(NSString *)selImg title:(NSString *)title action:(SEL)action;
- (void)setNavRightButtonEnable:(BOOL)enable;
- (void)setNavLeftButtonEnable:(BOOL)enable;
- (void)setNavBackArrow;
- (void)setNavBackArrowWithWidth:(CGFloat)width;
//common nav button event
- (void)navGoHomeButtonClicked:(UIButton *)sender;
- (void)navBackButtonClicked:(UIButton *)sender;
- (void)showPeopleLoadAnimation:(BOOL)isShow;
//progress event
- (void)showProgressViewWithTitle:(NSString *)title;
- (void)hideProgressView;
//add swipeGR in VC Transition
- (void)switchOfGR:(BOOL)flag;

/** pop多层的方法:level从1开始. level=1等价于popViewController */
-(void)popToMultiLevelOfViewController:(NSInteger)level animated:(BOOL)animated;

/**
 *  显示引导页
 *
 *  @param type
 */
-(void)showGuideView:(LSGuideType)type;

-(void)retryToGetData;


@end
