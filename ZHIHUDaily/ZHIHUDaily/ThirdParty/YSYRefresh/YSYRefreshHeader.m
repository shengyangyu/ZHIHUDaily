//
//  YSYRefreshHeader.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/20.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "YSYRefreshHeader.h"


#pragma mark -
#pragma mark YSYShowLayer

#define kCenterY (self.frame.size.height/2)
#define kRadius  10
#define kSpace    1
#define kLineLength 30
#define kDegree M_PI/3

@implementation YSYShowLayer

- (void)drawInContext:(CGContextRef)ctx {
    
    [super drawInContext:ctx];
    
    UIGraphicsPushContext(ctx);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 开始绘制
    //arrowPath
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    //Path 2
    UIBezierPath *curvePath2 = [UIBezierPath bezierPath];
    curvePath2.lineCapStyle = kCGLineCapRound;
    curvePath2.lineJoinStyle = kCGLineJoinRound;
    curvePath2.lineWidth = 2.0f;
    if (self.mProgress <= 0.5) {
        CGPoint pointA = CGPointMake(self.frame.size.width/2+kRadius, 2*self.mProgress * (kCenterY + kSpace - kLineLength));
        CGPoint pointB = CGPointMake(self.frame.size.width/2+kRadius,kLineLength + 2*self.mProgress*(kCenterY + kSpace - kLineLength));
        [curvePath2 moveToPoint:pointA];
        [curvePath2 addLineToPoint:pointB];
        //arrow
        [arrowPath moveToPoint:pointB];
        [arrowPath addLineToPoint:CGPointMake(pointB.x + 3*(cosf(kDegree)), pointB.y - 3*(sinf(kDegree)))];
        [curvePath2 appendPath:arrowPath];
    }
    if (self.mProgress > 0.5) {
        [curvePath2 moveToPoint:CGPointMake(self.frame.size.width/2+kRadius, kCenterY + kSpace - kLineLength + kLineLength*(self.mProgress-0.5)*2)];
        [curvePath2 addLineToPoint:CGPointMake(self.frame.size.width/2+kRadius, kCenterY + kSpace)];
        [curvePath2 addArcWithCenter:CGPointMake(self.frame.size.width/2, (kCenterY+kSpace)) radius:kRadius startAngle:0 endAngle:(M_PI*9/10)*(self.mProgress-0.5)*2 clockwise:YES];
        //arrow
        [arrowPath moveToPoint:curvePath2.currentPoint];
        [arrowPath addLineToPoint:CGPointMake(curvePath2.currentPoint.x + 3*(cosf(kDegree - ((M_PI*9/10) * (self.mProgress-0.5)*2))), curvePath2.currentPoint.y - 3*(sinf(kDegree - ((M_PI*9/10) * (self.mProgress-0.5)*2))))];
        [curvePath2 appendPath:arrowPath];
    }
    
    CGContextSaveGState(context);
    CGContextRestoreGState(context);
    
    [[UIColor blackColor] setStroke];
    [arrowPath  stroke];
    [curvePath2 stroke];
    
    UIGraphicsPopContext();
}

#pragma mark Help Method
- (CGPoint)getMiddlePointWithPoint1:(CGPoint)point1
                             point2:(CGPoint)point2 {
    
    CGFloat middle_x = (point1.x + point2.x)/2;
    CGFloat middle_y = (point1.y + point2.y)/2;
    return CGPointMake(middle_x, middle_y);
}

- (CGFloat)getDistanceWithPoint1:(CGPoint)point1
                          point2:(CGPoint)point2 {
    
    return sqrtf(pow(fabs(point1.x - point2.x), 2) + pow(fabs(point1.y - point2.y), 2));
}

#pragma mark setter getter
- (void)setMProgress:(CGFloat)mProgress {
    _mProgress = mProgress;
    [self setNeedsDisplay];
}

@end



#pragma mark -
#pragma mark YSYShowHeader

// 控件高度
const CGFloat kShowHeaderSize = 50.0f;

@interface YSYShowHeader ()

// 显示中属性
@property (nonatomic, assign ,readwrite) BOOL mIsShowing;
// 转圈圈
@property (nonatomic, strong) YSYShowLayer *mLayer;
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
        // 外观设置
        self.backgroundColor = [UIColor yellowColor];
        self.layer.cornerRadius = kShowHeaderSize/2;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(2,2);
        self.layer.shadowOpacity = 0.9;
        // 圈圈
        [self.layer addSublayer:self.mLayer];
        //[self.lab setHidden:YES];
        //[self addSubview:self.lab];
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

- (YSYShowLayer *)mLayer {
    if (!_mLayer) {
        _mLayer = [YSYShowLayer layer];
        _mLayer.frame = self.bounds;
        _mLayer.contentsScale = [UIScreen mainScreen].scale;
        _mLayer.mProgress = 0.0f;
        [_mLayer setNeedsDisplay];
    }
    return _mLayer;
}

#pragma mark action

- (void)showAnimation {
    [self.lab setHidden:NO];
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//绕着z轴为矢量，进行旋转(@"transform.rotation.z"==@@"transform.rotation")
    anima.toValue = [NSNumber numberWithFloat:2*M_PI];
    anima.repeatCount = HUGE_VALF;
    anima.duration = 1.5f;
    [self.lab.layer addAnimation:anima forKey:@"rotateAnimation"];
    self.mIsShowing = YES;
}

- (void)dismissAnimation {
    [self.lab.layer removeAnimationForKey:@"rotateAnimation"];
    [self.lab setHidden:YES];
    self.mIsShowing = NO;
}

@end

#pragma mark -
#pragma mark YSYRefreshHeader

@interface YSYRefreshHeader ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>

// 父View
@property (nonatomic, weak) UIView *mSuperView;
// 父视图滚动view
@property (nonatomic, weak) UIScrollView *mScrollView;
// 刷新View
@property (nonatomic, strong) YSYShowHeader *mShowView;
// 控制属性
@property (nonatomic, assign) BOOL mIsScrollToTop;
@property (nonatomic, assign) CGFloat mDragOffset;
@property (nonatomic, strong) UIPanGestureRecognizer *mPan;
// 默认状态栏高度
@property (nonatomic, assign) CGFloat mStatusHeight;

@end

// 控件最大拖动高度 进入刷新状态
static CGFloat kRefreshHeight = 100.0f;

@implementation YSYRefreshHeader

- (instancetype)initWithSuperView:(UIView *)superView
                   withScrollView:(UIScrollView *)scrollView {
    
    self = [super init];
    if (self) {
        _mSuperView = superView;
        _mStatusHeight = [UIDevice statusBarHeight];
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
- (YSYShowHeader *)mShowView {
    if (!_mShowView) {
        _mShowView = [[YSYShowHeader alloc] init];
        [_mShowView setAlpha:0.0f];
    }
    return _mShowView;
}

#pragma mark UIPanGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    NSLog(@"gestureRecognizer:%@,otherGestureRecognizer%@",gestureRecognizer.view,otherGestureRecognizer.view);
    return YES;
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
    //NSLog(@"panAction");
    // 刷新控件显示中、没有到达顶部
    // 返回
    if (self.mShowView.mIsShowing || !self.mIsScrollToTop) {
        return;
    }
    if (sender.state == UIGestureRecognizerStateChanged) {
        //self.mScrollView.userInteractionEnabled = NO;
        CGPoint mLocation=[sender translationInView:self.mSuperView];
        // 往下拉
        if (mLocation.y > 0 && self.mIsScrollToTop) {
            self.mDragOffset = MAX(self.mDragOffset, mLocation.y);
            // 增加
            [self showProgress:MIN(mLocation.y,kRefreshHeight*1.4) withAnimation:NO];
        }
    }
    // 结束
    else if (sender.state == UIGestureRecognizerStateEnded) {
        //self.mScrollView.userInteractionEnabled = YES;
        if (self.mDragOffset >= kRefreshHeight*1.4) {
            [self startRefresh];
        }
        else {
            [self endRefresh];
        }
    }
}

- (void)showProgress:(CGFloat)progress
       withAnimation:(BOOL)isAnimation {
   
    if (isAnimation) {
        [UIView animateWithDuration:0.35 animations:^{
            [self.mShowView setAlpha:progress/kRefreshHeight];
            self.mShowView.ysy_top = MIN(progress-CGRectGetHeight(self.mShowView.frame), kRefreshHeight);
        }];
    }
    else {
        [self.mShowView setAlpha:progress/kRefreshHeight];
        self.mShowView.ysy_top = MIN(progress-CGRectGetHeight(self.mShowView.frame), kRefreshHeight);
    }
    // 进度
    self.mShowView.mLayer.mProgress = progress/kRefreshHeight;
}

- (void)startRefresh {
    
    [self.mShowView showAnimation];
    [self showProgress:kRefreshHeight withAnimation:YES];
    
    if (self.startBlock) {
        self.startBlock();
    }
}

- (void)endRefresh {
    
    [self.mShowView dismissAnimation];
    [self showProgress:0.0f withAnimation:YES];
    
    if (self.endBlock) {
        self.endBlock(YES);
    }
}

#pragma mark 
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    //NSLog(@"observeValueForKeyPath");
    UIScrollView *scrollView = object;
    CGFloat offSetY = (scrollView.contentOffset.y+_mStatusHeight);
    // 到顶了
    if (offSetY == 0) {
        self.mIsScrollToTop = YES;
    }
    else {
        self.mIsScrollToTop = NO;
        self.mDragOffset = 0.0f;
        if (self.mShowView.alpha > 0) {
            //scrollView.contentOffset = CGPointMake(0, offSetY-_mStatusHeight);
            [self.mScrollView resignFirstResponder];
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
