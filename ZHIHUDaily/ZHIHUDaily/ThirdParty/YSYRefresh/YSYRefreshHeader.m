//
//  YSYRefreshHeader.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/20.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "YSYRefreshHeader.h"

#pragma mark -
#pragma mark YSYShowHeader

// 控件高度
const CGFloat kShowHeaderSize = 50.0f;

@interface YSYShowHeader ()

// 显示中属性
@property (nonatomic, assign ,readwrite) BOOL isShowing;
//
@property (nonatomic, strong) UILabel *lab;

@end


@implementation YSYShowHeader

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake((__MainScreen_Width-kShowHeaderSize)/2, frame.origin.y, kShowHeaderSize, kShowHeaderSize)];
    if (self) {
        
    }
    return self;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.frame = CGRectMake((__MainScreen_Width-kShowHeaderSize)/2, -kShowHeaderSize, kShowHeaderSize, kShowHeaderSize);
        self.backgroundColor = [UIColor yellowColor];
        self.layer.cornerRadius = kShowHeaderSize/2;
        [self.lab setHidden:YES];
        [self addSubview:self.lab];
    }
    return self;
}

- (UILabel *)lab {
    if (!_lab) {
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kShowHeaderSize, kShowHeaderSize)];
        _lab.backgroundColor = [UIColor clearColor];
        _lab.text = @"中";
        _lab.textAlignment = NSTextAlignmentCenter;
    }
    return _lab;
}

#pragma mark action

- (void)showAnimation {
    [self.lab setHidden:NO];
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//绕着z轴为矢量，进行旋转(@"transform.rotation.z"==@@"transform.rotation")
    anima.toValue = [NSNumber numberWithFloat:2*M_PI];
    anima.repeatCount = HUGE_VALF;
    anima.duration = 1.5f;
    [self.lab.layer addAnimation:anima forKey:@"rotateAnimation"];
    self.isShowing = YES;
}

- (void)dismissAnimation {
    [self.lab.layer removeAnimationForKey:@"rotateAnimation"];
    [self.lab setHidden:YES];
    self.isShowing = NO;
}

@end

#pragma mark -
#pragma mark YSYRefreshHeader

@interface YSYRefreshHeader ()<UIGestureRecognizerDelegate>

// 父View
@property (nonatomic, weak) UIView *mSuperView;
// 刷新View
@property (nonatomic, strong) YSYShowHeader *mShowView;
// 控制属性
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) CGFloat mDragOffset;

@end

// 控件最大拖动高度 进入刷新状态
static CGFloat kRefreshHeight = 100.0f;

@implementation YSYRefreshHeader

- (instancetype)initWithSuperView:(UIView *)sView {
    self = [super init];
    if (self) {
        _mSuperView = sView;
        // 添加手势监听
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        pan.delegate = self;
        [self.mSuperView addGestureRecognizer:pan];
        // 添加刷新控件
        [self.mSuperView addSubview:self.mShowView];
    }
    return self;
}

#pragma makr getter setter
- (YSYShowHeader *)mShowView {
    if (!_mShowView) {
        _mShowView = [[YSYShowHeader alloc] init];
        [_mShowView setAlpha:0.0f];
    }
    return _mShowView;
}

#pragma mark UIPanGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
    
    // 刷新控件显示中
    // 没有到达顶部
    // 返回
    if (self.mShowView.isShowing && self.isScrollTop) {
        return;
    }
    // 开始
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"StateBegan");
        self.isDragging = YES;
        self.mDragOffset = 0.0f;
    }
    // 改变
    else if (sender.state == UIGestureRecognizerStateChanged) {
        NSLog(@"StateChanged");
        CGPoint mLocation = [sender translationInView:self.mSuperView];
        // 往下拉
        if (mLocation.y > 0 && self.isDragging) {
            [self showProgress:MIN(mLocation.y,kRefreshHeight*1.4)];
            self.mDragOffset = MAX(self.mDragOffset, mLocation.y);
        }
    }
    // 结束
    else {
        NSLog(@"StateEnd");
        self.isDragging = NO;
        if (self.mDragOffset >= kRefreshHeight*1.4) {
            [self startRefresh];
        }
        else {
            [self showProgress:0.0f];
        }
    }
}

- (void)showProgress:(CGFloat)progress {
    
    [self.mShowView setAlpha:progress/kRefreshHeight];
    self.mShowView.ysy_top = MIN(progress-CGRectGetHeight(self.mShowView.frame), kRefreshHeight);
}

- (void)startRefresh {
    
    [self showProgress:kRefreshHeight];
    [self.mShowView showAnimation];
    
    if (self.startBlock) {
        self.startBlock();
    }
}

- (void)endRefresh {
    
    [self showProgress:0.0f];
    [self.mShowView dismissAnimation];
    
    if (self.endBlock) {
        self.endBlock(YES);
    }
}

@end
