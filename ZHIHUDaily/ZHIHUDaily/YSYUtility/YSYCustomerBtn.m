//
//  YSYCustomerBtn.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/11.
//  Copyright © 2015年 yushengyang. All rights reserved.
//  

#import "YSYCustomerBtn.h"

@implementation YSYCustomerBtn

- (void)layoutSubviews {
    
    [super layoutSubviews];
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2.0;
    center.y = (self.frame.size.height-self.titleLabel.frame.size.height)/2 - 1.0;
    self.imageView.center = center;
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0.0;
    newFrame.origin.y = CGRectGetMaxY(self.imageView.frame) + 5.0;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


@end
