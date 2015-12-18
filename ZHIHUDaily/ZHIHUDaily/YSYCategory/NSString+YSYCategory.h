//
//  NSString+YSYCategory.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/15.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YSYCategory)
/**
 在约定宽度的情况下获取一段字符串的size
 */
- (CGSize)ysy_sizeWithConstrainedToWidth:(CGFloat)width
                            fromFont:(UIFont *)font
                           lineSpace:(CGFloat)lineSpace;
/**
 在约定一个参考size的情况下获取一段字符串的size
 */
- (CGSize)ysy_sizeWithConstrainedToSize:(CGSize)size
                           fromFont:(UIFont *)font
                          lineSpace:(CGFloat)lineSpace;
/**
 在约定的位置和size下 绘制一个字符串
 */
- (void)ysy_drawInContext:(CGContextRef)context
             position:(CGPoint)pos
                 font:(UIFont *)font
            textColor:(UIColor *)color
               height:(CGFloat)height
                width:(CGFloat)width;
/**
 在约定的位置和高度下 绘制一个字符串
 */
- (void)ysy_drawInContext:(CGContextRef)context
             position:(CGPoint)pos
                 font:(UIFont *)font
            textColor:(UIColor *)color
               height:(CGFloat)height;

@end
