//
//  UIDevice+YSYCategory.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/14.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "UIDevice+YSYCategory.h"

@implementation UIDevice (YSYCategory)

+ (CGFloat)statusBarHeight {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    return statusBarFrame.size.height;
}

@end
