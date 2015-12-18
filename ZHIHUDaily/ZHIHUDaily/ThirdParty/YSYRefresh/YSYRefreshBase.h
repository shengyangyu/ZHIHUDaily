//
//  YSYRefreshBase.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/18.
//  Copyright © 2015年 yushengyang. All rights reserved.
//  基础控件

#import <UIKit/UIKit.h>
#import "YSYRefreshConst.h"
#import "UIScrollView+YSYCategory.h"

/** 
 刷新控件的状态 
 */
typedef NS_ENUM(NSInteger, YSYRefreshState) {
    /** 普通闲置状态 */
    YSYRefreshStateFree = 1,
    /** 松开就可以进行刷新的状态 */
    YSYRefreshStatePulling,
    /** 正在刷新中的状态 */
    YSYRefreshStateRefreshing,
    /** 即将刷新的状态 */
    YSYRefreshStateWillRefresh,
    /** 所有数据加载完毕,没有更多的数据了 */
    YSYRefreshStateNoMoreData
};
/**
 刷新状态回调
 */
typedef void (^YSYRefreshBaseRefreshingBlock)();
/**
 刷新的基础控件
 */
@interface YSYRefreshBase : UIView

/**********基本信息绑定***********/
// scrollView 刚开始的inset
@property (nonatomic, assign, readonly) UIEdgeInsets mOriginInset;
// 持有父控件
@property (nonatomic, weak, readonly) UIScrollView *mScrollView;

/**********回调设置***********/
// 回调
@property (nonatomic, copy)YSYRefreshBaseRefreshingBlock mBlock;
// 代理持有
@property (nonatomic, weak) id mTarget;
// 实现方法
@property (nonatomic, assign) SEL mAction;
// 设置代理持有者 及实现其方法
- (void)setTarget:(id)target action:(SEL)action;
// 实现回调
- (void)callBackMethod;

/**********刷新状态***********/
@property (nonatomic ,assign) YSYRefreshState mState;
// 开始刷新
- (void)beginRefreshing;
// 结束刷新
- (void)endRefreshing;
// 是否正在刷新
- (BOOL)isRefreshing;

/**********用于子类重载方法***********/
// NS_REQUIRES_SUPER 左右是可以提醒子类重载时注意调用super方法
// 初始化
- (void)ysyPrepare NS_REQUIRES_SUPER;
//子控件位置
- (void)ysyLayoutSubviews NS_REQUIRES_SUPER;
// scrollView contentOffset改变 监听
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
// scrollView contentSize改变 监听
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
// scrollView 拖拽状态改变 监听
- (void)scrollViewPanStateDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;

/**********用于子类重载方法***********/
// 拖拽百分比 可自由设置
@property (nonatomic, assign) CGFloat mPullPercent;
// 根据拖拽比例自动切换透明度
@property (nonatomic, assign, getter=isAutoChangeAlpha) BOOL autoChangeAlpha;

@end
