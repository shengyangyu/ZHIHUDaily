//
//  UIView+YSYCategory.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/4.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "UIView+YSYCategory.h"

@implementation UIView (YSYCategory)

- (CGFloat)ysy_left{
    return self.frame.origin.x;
}
- (CGFloat)ysy_right{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)ysy_top{
    return self.frame.origin.y;
}

- (CGFloat)ysy_bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)ysy_width{
    return self.frame.size.width;
}

- (CGFloat)ysy_height{
    return self.frame.size.height;
}

- (void)setYsy_left:(CGFloat)left{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (void)setYsy_right:(CGFloat)right{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)setYsy_top:(CGFloat)top{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)setYsy_bottom:(CGFloat)bottom{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setYsy_width:(CGFloat)w{
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}

- (void)setYsy_height:(CGFloat)h{
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}

- (void)setYsy_origin:(CGPoint)mj_origin
{
    CGRect frame = self.frame;
    frame.origin = mj_origin;
    self.frame = frame;
}

- (CGPoint)ysy_origin
{
    return self.frame.origin;
}

- (void)setYsy_size:(CGSize)mj_size
{
    CGRect frame = self.frame;
    frame.size = mj_size;
    self.frame = frame;
}

- (CGSize)ysy_size
{
    return self.frame.size;
}


- (void)setYsy_frame:(CGRect)frame
{
    self.frame = frame;
}

- (CGRect)ysy_frame
{
    return self.frame;
}

@end
