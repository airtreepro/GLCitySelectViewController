//
//  GLDefine.h
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/1.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#ifndef GLCitySelectViewController_GLDefine_h
#define GLCitySelectViewController_GLDefine_h

#ifdef __IPHONE_6_0

#define kTextAlignment                      NSTextAlignment
#define kTextAlignmentLeft                  NSTextAlignmentLeft
#define kTextAlignmentCenter                NSTextAlignmentCenter
#define kTextAlignmentRight                 NSTextAlignmentRight

#define kLineBreadMode                      NSLineBreakMode
#define kLineBreakModeCharaterWrap          NSLineBreakByCharWrapping
#define kLineBreakModeWordWrap              NSLineBreakByWordWrapping
#define kLineBreakModeClip                  NSLineBreakByClipping
#define kLineBreakModeTruncatingHead        NSLineBreakByTruncatingHead
#define kLineBreakModeTruncatingMiddle      NSLineBreakByTruncatingMiddle
#define kLineBreakModeTruncatingTail        NSLineBreakByTruncatingTail

#else

#define kTextAlignment                      UITextAlignment
#define kTextAlignmentLeft                  UITextAlignmentLeft
#define kTextAlignmentCenter                UITextAlignmentCenter
#define kTextAlignmentRight                 UITextAlignmentRight

#define kLineBreadMode                      UILineBreakMode
#define kLineBreakModeCharaterWrap          UILineBreakModeCharacterWrap
#define kLineBreakModeWordWrap              UILineBreakModeWordWrap
#define kLineBreakModeClip                  UILineBreakModeClip
#define kLineBreakModeTruncatingHead        UILineBreakModeHeadTruncation
#define kLineBreakModeTruncatingMiddle      UILineBreakModeMiddleTruncation
#define kLineBreakModeTruncatingTail        UILineBreakModeTailTruncation

#endif

#endif
