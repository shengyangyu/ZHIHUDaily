//
//  UIColor+YSYCategory.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/9.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YSYCategory)

// 16进制 生成Color
+ (UIColor *)convertHexToRGB:(NSString *)hexString;
// 16进制 生成Color 透明度
+ (UIColor *)convertHexToRGB:(NSString *)hexString withAlpha:(CGFloat)alpha;
// 随机Color
+ (UIColor *)randomColor;
// 生成对应Color的 Image
+ (UIImage *)createImageWithColor:(UIColor *)color withFrame:(CGRect)frame;

@end
