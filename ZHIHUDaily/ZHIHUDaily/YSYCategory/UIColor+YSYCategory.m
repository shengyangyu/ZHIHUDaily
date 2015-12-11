//
//  UIColor+YSYCategory.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/9.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "UIColor+YSYCategory.h"

@implementation UIColor (YSYCategory)

/**
 *十六进制转RGB
 */
+ (UIColor *)convertHexToRGB:(NSString *)hexString{
    NSString *str;
    if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        str=[[NSString alloc] initWithFormat:@"%@",hexString];
    }else {
        str=[[NSString alloc] initWithFormat:@"0x%@",hexString];
    }
    
    int rgb;
    sscanf([str cStringUsingEncoding:NSUTF8StringEncoding], "%i", &rgb);
    int red=rgb/(256*256)%256;
    int green=rgb/256%256;
    int blue=rgb%256;
    UIColor *color=[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    return color;
}

/**
 *十六进制转RGB
 */
+ (UIColor *)convertHexToRGB:(NSString *)hexString withAlpha:(CGFloat)alpha{
    NSString *str;
    if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        str=[[NSString alloc] initWithFormat:@"%@",hexString];
    }else {
        str=[[NSString alloc] initWithFormat:@"0x%@",hexString];
    }
    
    int rgb;
    sscanf([str cStringUsingEncoding:NSUTF8StringEncoding], "%i", &rgb);
    int red=rgb/(256*256)%256;
    int green=rgb/256%256;
    int blue=rgb%256;
    UIColor *color=[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
    return color;
}

/*
 *随机颜色
 */
+(UIColor *)randomColor{
    static BOOL	seeded=NO;
    if(!seeded){
        seeded=YES;
        srandom((unsigned)time(NULL));
    }
    CGFloat red=(CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green=(CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue=(CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

/*
 *UIColor Image
 */
+ (UIImage *)createImageWithColor:(UIColor *)color withFrame:(CGRect)frame {
    CGRect rect = frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
