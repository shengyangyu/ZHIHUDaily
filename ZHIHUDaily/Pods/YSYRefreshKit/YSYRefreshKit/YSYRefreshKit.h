//
//  YSYRefreshKit.h
//  YSYRefreshKit
//
//  Created by shengyang_yu on 16/1/22.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef __MainScreenFrame
#define __MainScreenFrame [[UIScreen mainScreen] bounds]
#define __MainScreen_Width  __MainScreenFrame.size.width
#define __MainScreen_Height  __MainScreenFrame.size.height
#endif

UIKIT_EXTERN const CGFloat kShowHeaderSize;

/**
 * 刷新View 刷新整体呈现
 */
@interface YSYRKHeader : UIView

// 线宽
@property (nonatomic) CGFloat mLineWihdth;
// 拖动进度
@property (nonatomic) CGFloat mProgress;
// 隐藏停止动画
@property (nonatomic) BOOL mHidesWhenStop;
// 动画类型
@property (nonatomic, strong) CAMediaTimingFunction *mTimeFunction;
// 动画时间
@property (nonatomic, readwrite) NSTimeInterval mDuration;
// 动画显示中
@property (nonatomic, readonly) BOOL mIsTracking;
// 控件显示中
@property (nonatomic, readonly) BOOL mIsShowing;
// 显示动画
- (void)showAnimation;
// 结束动画
- (void)dismissAnimation:(BOOL)isAnimation;

@end

/**
 * 刷新控制器
 */
@interface YSYRefreshKit : NSObject

// 默认状态栏高度
@property (nonatomic) CGFloat mStatusHeight;
// 定义回调
typedef void(^YSYStartBlock)();
typedef BOOL(^YSYEndBlock)();
@property (nonatomic, copy) YSYStartBlock startBlock;
@property (nonatomic, copy) YSYEndBlock endBlock;
// 刷新View
@property (nonatomic, readonly) YSYRKHeader *mShowView;
// 初始化
- (instancetype)initWithSuperView:(UIView *)superView
                   withScrollView:(UIScrollView *)scrollView;
// 开始刷新
- (void)startRefresh;
// 结束刷新
- (void)endRefresh;
// 取消刷新
- (void)cancelRefresh;

@end
