//
//  UIView+YSYCategory.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/15.
//  Copyright © 2015年 yushengyang. All rights reserved.
//  便于设置控件位置

#import <UIKit/UIKit.h>

@interface UIView (YSYCategory)

- (float)x;
- (float)y;
- (float)width;
- (float)height;

- (void)setX:(float)x;
- (void)setY:(float)y;
- (void)setWidth:(float)w;
- (void)setHeight:(float)h;

- (float)boundsWidth;
- (float)boundsHeight;
- (void)setBoundsWidth:(float)w;
- (void)setBoundsHeight:(float)h;

@end
