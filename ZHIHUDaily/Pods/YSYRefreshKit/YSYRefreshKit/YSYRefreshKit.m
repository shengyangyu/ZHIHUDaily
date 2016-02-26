//
//  YSYRefreshKit.m
//  YSYRefreshKit
//
//  Created by shengyang_yu on 16/1/22.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "YSYRefreshKit.h"
#import "UIView+YSYCategory.h"

#pragma mark -
#pragma mark YSYRKLayer

static NSString *kYSYRingEndAnimationKey = @"YSYRefreshKit.end";
static NSString *kYSYRingStrokeAnimationKey = @"YSYRefreshKit.stroke";
static NSString *kYSYRingRotationAnimationKey = @"YSYRefreshKit.rotation";

#pragma mark -
#pragma mark YSYRKHeader
// 控件高度
const CGFloat kShowHeaderSize = 50.0f;
// 控件内圈圈直径
const CGFloat kShowLayerSize = (kShowHeaderSize*0.5);

@interface YSYRKHeader ()

// 圈圈
@property (nonatomic, readonly) CAShapeLayer *mLayer;
// 动画显示中 拉拽中
@property (nonatomic, readwrite) BOOL mIsTracking;

@end


@implementation YSYRKHeader
@synthesize mLayer = _mLayer;


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.frame = CGRectMake((__MainScreen_Width-kShowHeaderSize)/2, kShowHeaderSize, kShowHeaderSize, kShowHeaderSize);
        // 外观设置
        self.backgroundColor = [UIColor yellowColor];
        self.layer.cornerRadius = kShowHeaderSize/2;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(2,2);
        self.layer.shadowOpacity = 0.9;
        // 圈圈
        self.mDuration = 1.0f;
        [self.layer addSublayer:self.mLayer];
        // 重置动画通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetAnimations) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (CAShapeLayer *)mLayer {
    if (!_mLayer) {
        _mLayer = [CAShapeLayer layer];
        _mLayer.strokeColor = self.tintColor.CGColor;
        _mLayer.fillColor = nil;
        _mLayer.lineWidth = 3.5f;
        _mLayer.lineCap = kCALineCapRound;
    }
    return _mLayer;
}

- (BOOL)mIsTracking {
    return _mIsTracking;
}

// 拖动进度
- (void)setMProgress:(CGFloat)mProgress {
    
    _mProgress = mProgress;
    CGFloat tStart = MAX(0.f, (mProgress - 1.0f));
    CGFloat tEnd = MIN(mProgress+tStart, 1.0);
    // 旋转
    if (mProgress > 1.0f) {
        [self updatePathStartStroke:0.1 endStroke:0.9 startAngle:(CGFloat)(tStart*2*M_PI) endAngle:(CGFloat)((1+tStart)*2*M_PI)];
    }
    // 绘制
    else {
        [self updatePathStartStroke:tStart endStroke:(tEnd-0.1) startAngle:(CGFloat)(0) endAngle:(CGFloat)(2*M_PI)];
    }
}

#pragma mark -action
// 显示
- (void)showAnimation {

    if (self.mIsTracking) {
        return;
    }
    // 还原
    self.transform = CGAffineTransformIdentity;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = self.mDuration / 0.375f;
    animation.fromValue = @(0.f);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    animation.removedOnCompletion = NO;
    [self.mLayer addAnimation:animation forKey:kYSYRingRotationAnimationKey];
    
    CABasicAnimation *headAnimation = [CABasicAnimation animation];
    headAnimation.keyPath = @"strokeStart";
    headAnimation.duration = self.mDuration / 1.5f;
    headAnimation.fromValue = @(0.f);
    headAnimation.toValue = @(0.25f);
    headAnimation.timingFunction = self.mTimeFunction;
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animation];
    tailAnimation.keyPath = @"strokeEnd";
    tailAnimation.duration = self.mDuration / 1.5f;
    tailAnimation.fromValue = @(0.f);
    tailAnimation.toValue = @(1.f);
    tailAnimation.timingFunction = self.mTimeFunction;
    
    
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animation];
    endHeadAnimation.keyPath = @"strokeStart";
    endHeadAnimation.beginTime = self.mDuration / 1.5f;
    endHeadAnimation.duration = self.mDuration / 3.0f;
    endHeadAnimation.fromValue = @(0.25f);
    endHeadAnimation.toValue = @(1.f);
    endHeadAnimation.timingFunction = self.mTimeFunction;
    
    CABasicAnimation *endTailAnimation = [CABasicAnimation animation];
    endTailAnimation.keyPath = @"strokeEnd";
    endTailAnimation.beginTime = self.mDuration / 1.5f;
    endTailAnimation.duration = self.mDuration / 3.0f;
    endTailAnimation.fromValue = @(1.f);
    endTailAnimation.toValue = @(1.f);
    endTailAnimation.timingFunction = self.mTimeFunction;
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    [animations setDuration:self.mDuration];
    [animations setAnimations:@[headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]];
    animations.repeatCount = INFINITY;
    animations.removedOnCompletion = NO;
    [self.mLayer addAnimation:animations forKey:kYSYRingStrokeAnimationKey];
    // 设置属性
    self.mIsTracking = YES;
    
    if (self.mHidesWhenStop) {
        self.hidden = NO;
    }
}

// 消失
- (void)dismissAnimation:(BOOL)isAnimation {

    if (!self.mIsTracking) {
        return;
    }
    [self.mLayer removeAnimationForKey:kYSYRingStrokeAnimationKey];
    [self.mLayer removeAnimationForKey:kYSYRingRotationAnimationKey];
    // 变小 动画 再消失
    if (isAnimation) {
        CABasicAnimation *headAnimation = [CABasicAnimation animation];
        headAnimation.keyPath = @"strokeStart";
        headAnimation.duration = self.mDuration / 1.5f;
        headAnimation.fromValue = @(0.f);
        headAnimation.toValue = @(0.25f);
        headAnimation.timingFunction = self.mTimeFunction;
        
        CABasicAnimation *tailAnimation = [CABasicAnimation animation];
        tailAnimation.keyPath = @"strokeEnd";
        tailAnimation.duration = self.mDuration / 1.5f;
        tailAnimation.fromValue = @(0.f);
        tailAnimation.toValue = @(1.f);
        tailAnimation.timingFunction = self.mTimeFunction;
        CAAnimationGroup *animations = [CAAnimationGroup animation];
        [animations setDuration:self.mDuration];
        [animations setAnimations:@[headAnimation, tailAnimation]];
        animations.removedOnCompletion = YES;
        [self.mLayer addAnimation:animations forKey:kYSYRingEndAnimationKey];
    }
    // 设置属性
    self.mIsTracking = NO;
    
    if (self.mHidesWhenStop) {
        self.hidden = YES;
    }
}

// 重新绘制
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mLayer.frame = CGRectMake((kShowHeaderSize-kShowLayerSize)/2,(kShowHeaderSize-kShowLayerSize)/2,kShowLayerSize,kShowLayerSize);
    [self updatePathStartStroke:0.f endStroke:0.f startAngle:(CGFloat)(0) endAngle:(CGFloat)(2*M_PI)];
}

// 设置颜色
- (void)tintColorDidChange {
    [super tintColorDidChange];
    
    self.mLayer.strokeColor = self.tintColor.CGColor;
}

// 重置
- (void)resetAnimations {
    if (self.mIsTracking) {
        [self dismissAnimation:YES];
        [self showAnimation];
    }
}

#pragma mark -Private
- (void)updatePathStartStroke:(CGFloat)sStroke
                    endStroke:(CGFloat)eStroke
                   startAngle:(CGFloat)sAngle
                     endAngle:(CGFloat)eAngle {
    
    CGPoint center = CGPointMake((kShowHeaderSize-kShowLayerSize)/2, (kShowHeaderSize-kShowLayerSize)/2);
    CGFloat radius = kShowLayerSize/2-self.mLayer.lineWidth/2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:sAngle endAngle:eAngle clockwise:YES];
    self.mLayer.path = path.CGPath;
    
    self.mLayer.strokeStart = sStroke;
    self.mLayer.strokeEnd = eStroke;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

@end

#pragma mark -
#pragma mark YSYRefreshKit

@interface YSYRefreshKit ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>

// 刷新View
@property (nonatomic, readwrite) YSYRKHeader *mShowView;
// 父View
@property (nonatomic, weak) UIView *mSuperView;
// 父视图滚动view
@property (nonatomic, weak) UIScrollView *mScrollView;
// 控制属性
@property (nonatomic, assign) BOOL mIsScrollToTop;
// 拖动距离
@property (nonatomic, assign) CGFloat mDragOffset;
// 起始位置
@property (nonatomic, assign) CGFloat mOriginOffset;
// 拖动手势
@property (nonatomic, strong) UIPanGestureRecognizer *mPan;

@end

// 控件最大拖动高度 进入刷新状态
static CGFloat kRefreshHeight = 100.0f;
// 控件回弹系数
static CGFloat kRKbounds = 1.4f;
// 控件回弹动画时间
static CGFloat kRKTime = 0.35;


@implementation YSYRefreshKit

- (instancetype)initWithSuperView:(UIView *)superView
                   withScrollView:(UIScrollView *)scrollView {
    
    self = [super init];
    if (self) {
        _mSuperView = superView;
        _mStatusHeight = 0;
        _mOriginOffset = 0;
        _mDragOffset = 0;
        // 添加手势监听
        _mPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        _mPan.delegate = self;
        [self.mSuperView addGestureRecognizer:_mPan];
        // 添加刷新控件
        [self.mSuperView addSubview:self.mShowView];
        // 添加scrollView监听
        _mIsScrollToTop = NO;
        if (scrollView) {
            _mScrollView = scrollView;
            [_mScrollView addObserver:self
                           forKeyPath:@"contentOffset"
                              options:NSKeyValueObservingOptionNew
                              context:nil];
        }
    }
    return self;
}

#pragma makr getter setter
- (YSYRKHeader *)mShowView {
    
    if (!_mShowView) {
        _mShowView = [[YSYRKHeader alloc] init];
        [_mShowView setAlpha:0.0f];
    }
    return _mShowView;
}

#pragma mark UIPanGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

// 拖动手势
- (void)panAction:(UIPanGestureRecognizer *)sender {
    
    // 刷新控件显示中、没有到达顶部
    // 返回
    if (self.mShowView.mIsTracking || !self.mIsScrollToTop) {
        return;
    }
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint mLocation=[sender translationInView:self.mSuperView];
        // 往下拉
        if (mLocation.y > 0 && self.mIsScrollToTop) {
            self.mDragOffset = MIN(mLocation.y-self.mOriginOffset,kRefreshHeight*kRKbounds);
            [self showProgress:self.mDragOffset withAnimation:NO];
        }
    }
    // 结束
    else if (sender.state == UIGestureRecognizerStateEnded) {
        // 达到一定程度
        // 放手后开始旋转动画
        if (self.mDragOffset >= kRefreshHeight*kRKbounds) {
            [self startRefresh];
        }
        else {
            [self cancelRefresh];
        }
    }
}

// 渐变显示控件
- (void)showProgress:(CGFloat)progress
       withAnimation:(BOOL)isAnimation {
    
    if (isAnimation) {
        [UIView animateWithDuration:kRKTime animations:^{
            [self.mShowView setAlpha:progress/kRefreshHeight];
            self.mShowView.ysy_top = MIN(progress-CGRectGetHeight(self.mShowView.frame), kRefreshHeight);
        }];
    }
    else {
        [self.mShowView setAlpha:progress/kRefreshHeight];
        self.mShowView.ysy_top = MIN(progress-CGRectGetHeight(self.mShowView.frame), kRefreshHeight);
    }
    // 进度
    self.mShowView.mProgress = progress/kRefreshHeight;
}

// 开始刷新控件动画
// ex: 控件开始刷新状态后 回调
- (void)startRefresh {
    
    // 开始动画
    [self.mShowView showAnimation];
    // 移动到上面一点点
    [UIView animateWithDuration:kRKTime animations:^{
        [self.mShowView setAlpha:1.0f];
        self.mShowView.ysy_top = MIN(kRefreshHeight-CGRectGetHeight(self.mShowView.frame), kRefreshHeight);
    }];
    // block 回调
    if (self.startBlock) {
        self.startBlock();
    }
}

// 结束刷新控件动画
// ex: 控件进入刷新状态后 回调
- (void)endRefresh {
    
    // 结束动画
    [self.mShowView dismissAnimation:YES];
    // 动画由大变小
    self.mShowView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
    [UIView animateWithDuration:kRKTime animations:^{
        self.mShowView.transform = CGAffineTransformMake(0.01, 0, 0, 0.01,0,kShowHeaderSize/2.0);
    } completion:^(BOOL finished) {
        self.mShowView.transform = CGAffineTransformIdentity;
        self.mShowView.alpha = 0.0f;
    }];
    // block 回调
    if (self.endBlock) {
        self.endBlock(YES);
    }
}

// 取消显示刷新控件
// ex: 控件未进入刷新状态
- (void)cancelRefresh {
    
    // 结束动画
    [self.mShowView dismissAnimation:NO];
    // 移除控件显示
    [self showProgress:0.0f withAnimation:YES];
    // block 回调
    if (self.endBlock) {
        self.endBlock(YES);
    }
}

#pragma mark 监听
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    UIScrollView *scrollView = object;
    CGFloat offSetY = (scrollView.contentOffset.y+_mStatusHeight);
    // 到顶了
    if (offSetY == 0) {
        if (!self.mIsScrollToTop) {
            // 表示可以出现刷新view
            self.mIsScrollToTop = YES;
            // 其实拖动位置
            self.mOriginOffset = self.mDragOffset;
        }
    }
    else {
        if (self.mIsScrollToTop) {
            // 表示可以不可以出现刷新view
            self.mIsScrollToTop = NO;
            self.mDragOffset = 0;
        }
        if (offSetY > 0) {
            if (self.mShowView.alpha > 0) {
                scrollView.contentOffset = CGPointMake(0, -self.mStatusHeight);
            }
        } else {
            scrollView.contentOffset = CGPointMake(0, -self.mStatusHeight);
        }
    }
}

- (void)dealloc {
    if (_mScrollView) {
        [_mScrollView removeObserver:self
                          forKeyPath:@"contentOffset"];
    }
}

@end
