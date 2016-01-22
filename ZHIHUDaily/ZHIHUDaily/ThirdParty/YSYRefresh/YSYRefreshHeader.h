//
//  YSYRefreshHeader.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/20.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/**
 * 刷新基础组件
 */
@interface YSYShowLayer : CALayer

// 显示进度
@property (nonatomic, assign) CGFloat mProgress;

@end

UIKIT_EXTERN const CGFloat kShowHeaderSize;
/**
 * 刷新View
 */
@interface YSYShowHeader : UIView

// 显示中属性
@property (nonatomic, assign ,readonly) BOOL mIsShowing;
// 显示动画
- (void)showAnimation;
// 结束动画
- (void)dismissAnimation;

@end

/**
 * 刷新控制器
 */
@interface YSYRefreshHeader : NSObject

// 定义回调
typedef void(^YSYStartBlock)();
typedef BOOL(^YSYEndBlock)();
@property (nonatomic, copy) YSYStartBlock startBlock;
@property (nonatomic, copy) YSYEndBlock endBlock;
// 初始化
- (instancetype)initWithSuperView:(UIView *)superView
                   withScrollView:(UIScrollView *)scrollView;
// 开始刷新
- (void)startRefresh;
// 结束刷新
- (void)endRefresh;

@end
