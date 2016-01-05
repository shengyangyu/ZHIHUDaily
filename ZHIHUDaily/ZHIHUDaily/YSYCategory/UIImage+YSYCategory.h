//
//  UIImage+YSYCategory.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/5.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YSYCategory)

/**
 绘制制定尺寸的image
 */
+ (UIImage *)ysy_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock;

@end
