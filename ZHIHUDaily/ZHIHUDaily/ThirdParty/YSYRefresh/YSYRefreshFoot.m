//
//  YSYRefreshFoot.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/18.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSYRefreshFoot.h"

@interface YSYRefreshFoot ()

@property (weak, nonatomic) UIActivityIndicatorView *mloading;
@property (strong, nonatomic) UIView *mvv;

@end

@implementation YSYRefreshFoot

+ (instancetype)footWithBlock:(YSYRefreshBaseRefreshingBlock)block {
    YSYRefreshFoot *foot = [[self alloc] init];
    foot.mBlock = block;
    return foot;
}

+ (instancetype)footWithTarget:(id)target action:(SEL)action {
    YSYRefreshFoot *foot = [[self alloc] init];
    [foot setTarget:target action:action];
    return foot;
}

- (void)ysyPrepare {
    [super ysyPrepare];
    // 设置高度
    self.ysy_height = YSYRefreshFootHeight;
    // 自动隐藏
    self.autoHidden = YES;
    // 默认底部控件100%出现时才会自动刷新
    self.triggerAutoRefreshPercent = 1.0;
    // 设置为默认状态
    self.autoChangeAlpha = YES;
    //
    self.autoRefresh = YES;
    // 自定义控件
    [self customerUI];
}
// 控件位置
- (void)ysyLayoutSubviews {
    [super ysyLayoutSubviews];
    self.mvv.frame = self.bounds;
    self.mloading.center = CGPointMake(self.ysy_width*0.5, self.ysy_height*0.5);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    // 监听scrollView数据的变化
    if (newSuperview) {
        if ([self.mScrollView isKindOfClass:[UITableView class]] || [self.mScrollView isKindOfClass:[UICollectionView class]]) {
            [self.mScrollView setYsy_reloadBlock:^(NSInteger totalDataCount) {
                if (self.isAutoHidden) {
                    self.hidden = (totalDataCount == 0);
                }
            }];
        }
    }
    // 设置位置
    if (newSuperview) {
        // 设置foot位置
        if (self.hidden == NO) {
            self.mScrollView.ysy_insetBottom += self.ysy_height;
        }
        // 设置位置
        self.ysy_top = self.mScrollView.ysy_contentHeight;
    }
    else {
        // 被移除了
        if (self.hidden == NO) {
            self.mScrollView.ysy_insetBottom -= self.ysy_height;
        }
    }
    
}

- (void)endRefreshingWithNoMoreData {
    self.mState = YSYRefreshStateNoMoreData;
}

- (void)resetNoMoreData {
    self.mState = YSYRefreshStateFree;
}

#pragma mark - KVO
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    // 设置位置
    self.ysy_top = self.mScrollView.ysy_contentHeight;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    // 状态不能处于 普通闲置
    // 必须要自动刷新
    // content 要有值 显示foot
    if (YSYRefreshStateFree != self.mState ||
        !self.autoRefresh ||
        self.ysy_top == 0) {
        return;
    }
    // 内容超过ScrollView frame height
    CGFloat tScrollContent = (self.mScrollView.ysy_insetTop + self.mScrollView.ysy_contentHeight);
    if (tScrollContent > self.mScrollView.ysy_height) {
        CGFloat tScrollMax = (self.mScrollView.ysy_contentHeight - self.mScrollView.ysy_height + self.mScrollView.ysy_height * self.triggerAutoRefreshPercent + self.mScrollView.ysy_insetBottom - self.ysy_height);
        if (self.mScrollView.ysy_offsetY >= tScrollMax) {
            // 防止手松开时连续调用
            CGPoint told = [change[@"old"] CGPointValue];
            CGPoint tnew = [change[@"new"] CGPointValue];
            if (tnew.y <= told.y)
                return;
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
    // 处于闲置状态 才能响应拖动
    if (YSYRefreshStateFree != self.mState) {
        return;
    }
    // 手松开
    if (self.mScrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // 不够一个屏幕
        if (self.mScrollView.ysy_insetTop + self.mScrollView.ysy_contentHeight <= self.mScrollView.ysy_height) {
            // 向上拽
            if (self.mScrollView.ysy_offsetY >= - self.mScrollView.ysy_insetTop) {
                [self beginRefreshing];
            }
        }
        // 超出一个屏幕
        else {
            if (self.mScrollView.ysy_insetTop >= self.mScrollView.ysy_contentHeight + self.mScrollView.ysy_insetBottom - self.mScrollView.ysy_height) {
                [self beginRefreshing];
            }
        }
    }
}

- (void)setMState:(YSYRefreshState)mState {
    
    YSYRefreshCheckState
    
    if (mState == YSYRefreshStateRefreshing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self callBackMethod];
        });
    }
    switch (mState) {
        case YSYRefreshStateFree:
            [self.mloading stopAnimating];
            break;
        case YSYRefreshStateRefreshing:
            [self.mloading startAnimating];
            break;
        case YSYRefreshStateNoMoreData:
            [self.mloading stopAnimating];
            break;
        default:
            break;
    }
}

- (void)setHidden:(BOOL)hidden {
    
    BOOL lastHidden = self.isHidden;
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.mState = YSYRefreshStateFree;
        self.mScrollView.ysy_insetBottom -= self.ysy_height;
    } else if (lastHidden && !hidden) {
        self.mScrollView.ysy_insetBottom += self.ysy_height;
        // 设置位置
        self.ysy_top = self.mScrollView.ysy_contentHeight;
    }
}
#pragma mark － 自定义控件
- (void)customerUI {
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.mloading = loading;
    
    UIView *vv =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ysy_width, self.ysy_height)];
    vv.backgroundColor = [UIColor redColor];
    [self addSubview:vv];
    self.mvv = vv;
}

@end
