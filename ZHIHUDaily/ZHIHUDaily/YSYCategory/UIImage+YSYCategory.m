//
//  UIImage+YSYCategory.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/5.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "UIImage+YSYCategory.h"

@implementation UIImage (YSYCategory)

+ (UIImage *)ysy_imageWithSize:(CGSize)size drawBlock:(void (^)(CGContextRef context))drawBlock {

    if (!drawBlock)
        return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return nil;
    drawBlock(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
