//
//  YSYRefreshBase.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/18.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSYRefreshBase.h"

@interface YSYRefreshBase ()

// 拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer *mPan;

@end

@implementation YSYRefreshBase

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        // 初始设置
        [self ysyPrepare];
        // 默认状态
        self.mState = YSYRefreshStateFree;
    }
    return self;
}

- (void)ysyPrepare {
    // 自动调整view的宽度，保证左边距和右边距不变
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    // 透明背景
    self.backgroundColor = [UIColor clearColor];
}
/**
 系统自动调用
 ayoutSubviews在以下情况下会被调用：
 1、init初始化不会触发layoutSubviews
 2、addSubview会触发layoutSubviews
 3、设置view的Frame会触发layoutSubviews,当然前提是frame的值设置前后发生了变化
 4、滚动一个UIScrollView会触发layoutSubviews
 5、旋转Screen会触发父UIView上的layoutSubviews事件
 6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    [self ysyLayoutSubviews];
}

- (void)ysyLayoutSubviews {

}

/**
 系统自动调用
 当视图发生改变的时候(理解为当刷新控件要添加到一个scrollView上调用此方法)
 */
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    // 不为UIScrollView 直接返回
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    // 开始更新控件
    // 移除旧的KVO
    [self removeObservers];
    if (newSuperview) {
        // 等宽
        self.ysy_width = newSuperview.ysy_width;
        // 起点为0
        self.ysy_x = 0;
        // 获取父视图
        _mScrollView = (UIScrollView *)newSuperview;
        // 设置垂直弹簧效果
        _mScrollView.alwaysBounceVertical = YES;
        // 记录scrollView默认的外部值
        _mOriginInset = _mScrollView.contentInset;
        // 添加KVO
        [self addObsevers];
    }
}

// 绘制
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // 界面没有出来 不能为 将要刷新
    if (YSYRefreshStateWillRefresh == self.mState) {
        self.mState = YSYRefreshStateRefreshing;
    }
}


#pragma mark - ScrollView KVO 
// 监听 省去代理且与自定义的方法绑定
- (void)addObsevers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.mScrollView addObserver:self forKeyPath:YSYRefreshKeyPathContentOffset options:options context:nil];
    [self.mScrollView addObserver:self forKeyPath:YSYRefreshKeyPathContentSize options:options context:nil];
    self.mPan = self.mScrollView.panGestureRecognizer;
    [self.mPan addObserver:self forKeyPath:YSYRefreshKeyPathPanState options:options context:nil];
}

// 控件是加在mScrollView上的
// 所以superview == mScrollView
- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:YSYRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:YSYRefreshKeyPathContentSize];
    [self.mPan removeObserver:self forKeyPath:YSYRefreshKeyPathPanState];
    self.mPan = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    // 不允许交互刷新毫无意义
    if (!self.userInteractionEnabled) {
        return;
    }
    // size改变 需要监听
    if ([keyPath isEqualToString:YSYRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
        return;
    }
    // 看不见
    if (self.hidden) {
        return;
    }
    // offset改变 需要监听
    if ([keyPath isEqualToString:YSYRefreshKeyPathContentOffset])  {
            [self scrollViewContentOffsetDidChange:change];
            return;
    }
    else if ([keyPath isEqualToString:YSYRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
    /*
    SEL kvoSel = NSSelectorFromString(keyPath);
    if ([self respondsToSelector:kvoSel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:kvoSel withObject:change];
#pragma clang diagnostic pop
    }*/
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    
}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    
}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    
}

#pragma mark - 绑定代理 回调方法
- (void)setTarget:(id)target action:(SEL)action {
    self.mTarget = target;
    self.mAction = action;
}

#pragma mark - 主动调用方法
// 开始刷新
- (void)beginRefreshing {
    // 显示刷新view
    [UIView animateWithDuration:YSYRefreshAnimationDuration animations:^{
        self.alpha = 1.0;
    }];
    // 模拟拖动了100%
    self.mPullPercent = 1.0;
    // 判断被添加到ScrollView
    if (self.window) {
        self.mState = YSYRefreshStateRefreshing;
    }
    else {
        self.mState = YSYRefreshStateWillRefresh;
        // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
        [self setNeedsDisplay];
    }
}
// 结束刷新
- (void)endRefreshing {
    self.mState = YSYRefreshStateFree;
}
// 判断刷新状态
- (BOOL)isRefreshing {
    return (self.mState == YSYRefreshStateRefreshing || self.mState == YSYRefreshStateWillRefresh);
}

#pragma mark - 改变透明度
- (void)setAutoChangeAlpha:(BOOL)autoChangeAlpha {
    _autoChangeAlpha = autoChangeAlpha;
    if (self.isRefreshing) {
        return;
    }
    if (autoChangeAlpha) {
        self.alpha = self.mPullPercent;
    }
    else {
        self.alpha = 1.0;
    }
}

- (void)setMPullPercent:(CGFloat)mPullPercent {
    _mPullPercent = mPullPercent;
    if (self.isRefreshing) {
        return;
    }
    if (self.isAutoChangeAlpha) {
        self.alpha = mPullPercent;
    }
}

#pragma mark -回调
- (void)callBackMethod {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.mBlock) {
            self.mBlock();
        }
        if ([self.mTarget respondsToSelector:self.mAction]) {
            YSYRefreshMsgSend(YSYRefreshMsgTarget(self.mTarget), self.mAction, self);
        }
    });
}


@end
