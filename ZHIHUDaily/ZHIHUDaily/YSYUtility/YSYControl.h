//
//  YSYControl.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/5.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSYControl : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void (^touchBlock)(YSYControl *view, YSYGestureRecognizerState state,NSSet *touches,UIEvent *event);
@property (nonatomic, copy) void (^longPressBlock)(YSYControl *view, CGPoint point);

@end
