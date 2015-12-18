//
//  UIColor+YSYCategory.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/9.
//  Copyright © 2015年 yushengyang. All rights reserved.
//  1、使用16进制字符串设置颜色 2、根据颜色生成图片

#import <UIKit/UIKit.h>

@interface UIColor (YSYCategory)

// 16进制 生成Color
+ (UIColor *)ysy_convertHexToRGB:(NSString *)hexString;
// 16进制 生成Color 透明度
+ (UIColor *)ysy_convertHexToRGB:(NSString *)hexString withAlpha:(CGFloat)alpha;
// 随机Color
+ (UIColor *)ysy_randomColor;
// 生成对应Color的 Image
+ (UIImage *)ysy_createImageWithColor:(UIColor *)color withFrame:(CGRect)frame;

@end
