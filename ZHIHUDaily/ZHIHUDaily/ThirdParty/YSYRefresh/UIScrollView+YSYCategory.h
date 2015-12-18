//
//  UIScrollView+YSYCategory.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/18.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSYRefreshConst.h"

@interface UIView (YSYCategory)

@property (assign, nonatomic) CGFloat ysy_x;
@property (assign, nonatomic) CGFloat ysy_y;
@property (assign, nonatomic) CGFloat ysy_width;
@property (assign, nonatomic) CGFloat ysy_height;
@property (assign, nonatomic) CGSize ysy_size;
@property (assign, nonatomic) CGPoint ysy_origin;

@end

@interface UIScrollView (YSYCategory)

@property (assign, nonatomic) CGFloat ysy_insetTop;
@property (assign, nonatomic) CGFloat ysy_insetBottom;
@property (assign, nonatomic) CGFloat ysy_insetLeft;
@property (assign, nonatomic) CGFloat ysy_insetRight;

@property (assign, nonatomic) CGFloat ysy_offsetX;
@property (assign, nonatomic) CGFloat ysy_offsetY;

@property (assign, nonatomic) CGFloat ysy_contentWidth;
@property (assign, nonatomic) CGFloat ysy_contentHeight;

@end

@class YSYRefreshFoot;
@interface UIScrollView (YSYRefresh)

// foot
@property (nonatomic, strong) YSYRefreshFoot *ysy_foot;
// 回调
@property (nonatomic, copy) void (^ysy_reloadBlock)(NSInteger totalCount);
// 获取数据
- (NSInteger)ysy_totalCount;


@end