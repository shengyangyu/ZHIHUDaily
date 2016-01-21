//
//  YSYAutoRollHeadView.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/15.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "YSYAutoRollHeadView.h"
#import "ThemeMainModel.h"

#pragma mark -
#pragma mark YSYRollUnitView

@interface YSYRollUnitView ()
// 初始化高度
@property (nonatomic, assign) CGFloat mOriginHeight;
// 初始化宽度
@property (nonatomic, assign) CGFloat mOriginWidth;

@property (nonatomic, strong) UIImageView *mImageView;

@end

@implementation YSYRollUnitView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //self.autoresizesSubviews = YES;
        _mOriginHeight = frame.size.height;
        _mOriginWidth = frame.size.width;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.mImageView];
    }
    return self;
}

- (UIImageView *)mImageView {
    if (!_mImageView) {
        _mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _mOriginWidth, _mOriginHeight)];
        _mImageView.backgroundColor = [UIColor whiteColor];
        //_mImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _mImageView;
}

- (void)setMModel:(ThemeMainStories *)mModel {
    
    [self.mImageView yy_setImageWithURL:[NSURL URLWithString:mModel.image] options:YYWebImageOptionShowNetworkActivity];
}

@end


#pragma mark -
#pragma mark YSYRollBaseView

static CGFloat kTimerDuration = 5.0f;

@interface YSYRollBaseView ()<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger mIndex;
@property (nonatomic, assign) NSInteger mCount;
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) NSMutableArray *mContentViews;
@property (nonatomic, strong) NSTimer *mTimer;
@property (nonatomic, assign) NSTimeInterval mDuration;
@property (nonatomic, strong) UIPageControl *mPageControl;
@property (nonatomic, assign) CGFloat mContentWidth;
@property (nonatomic, assign) CGFloat mContentHeight;
// 点击事件
@property (nonatomic, copy) void (^touchActionBlock)(NSInteger mIndex);

@end

@implementation YSYRollBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //self.autoresizesSubviews = YES;
        _mContentWidth = CGRectGetWidth(frame);
        _mContentHeight = CGRectGetHeight(frame);
        _mContentViews = [NSMutableArray new];
        [self addSubview:self.mScrollView];
        [self addSubview:self.mPageControl];
        self.mIndex = 0;
        if (self.mDuration > 0.0f) {
            self.mTimer = [NSTimer scheduledTimerWithTimeInterval:self.mDuration target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
            //[self.mTimer stopTimer];
        }
    }
    return self;
}

#pragma mark setter getter
- (UIScrollView *)mScrollView {
    if (!_mScrollView) {
        _mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mScrollView.backgroundColor = [UIColor whiteColor];
        //_mScrollView.autoresizingMask = 0xFF;
        //_mScrollView.contentMode = UIViewContentModeCenter;
        _mScrollView.contentSize = CGSizeMake(self.mContentWidth, self.mContentHeight);
        _mScrollView.delegate = self;
        _mScrollView.contentOffset = CGPointMake(0, 0);
        _mScrollView.pagingEnabled = YES;
    }
    return _mScrollView;
}

- (UIPageControl *)mPageControl {
    if (!_mPageControl) {
        _mPageControl = [[UIPageControl alloc] init];
        _mPageControl.ysy_centerX = self.ysy_centerX;
        _mPageControl.ysy_top = self.mScrollView.ysy_height - 10;
    }
    return _mPageControl;
}

- (NSTimeInterval)mDuration {
    return kTimerDuration;
}

//- (void)setFrame:(CGRect)frame {
//    [super setFrame:frame];
//    self.mScrollView.frame = self.bounds;
//    /*
//     for (UIView *tView in self.mScrollView.subviews) {
//     tView.ysy_height = self.mScrollView.ysy_height;
//     }*/
//    self.mPageControl.ysy_top = self.mScrollView.ysy_height - 10;
//}

- (void)setDataArrays:(NSArray *)dataArrays {
    // 空
    if (!dataArrays || dataArrays.count == 0) {
        return;
    }
    // 一条数据
    else if (dataArrays.count == 1) {
        // 重置ContentSize
        if (_mCount != dataArrays.count) {
            // 移除旧的
            [self.mScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.mScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.mScrollView.frame), CGRectGetHeight(self.mScrollView.frame))];
            // 添加新的
            YSYRollUnitView *base = [[YSYRollUnitView alloc] initWithFrame:CGRectMake(0, 0, self.mContentWidth, self.mContentHeight)];
            [self.mScrollView addSubview:base];
            [self.mContentViews addObject:base];
        }
        // 赋值
        _dataArrays = nil;
        _dataArrays = dataArrays;
        _mCount = _dataArrays.count;
        self.mPageControl.numberOfPages = _mCount;
        YSYRollUnitView *base = self.mContentViews[0];
        base.mModel = dataArrays[[self getValidIndex:0]];
    }
    // 多条数据
    else {
        // 重置ContentSize
        if (_mCount <= 1) {
            // 移除旧的
            [self.mScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.mScrollView setContentSize:CGSizeMake(([dataArrays count]+2)*self.mContentWidth, self.mContentHeight)];
            // 添加新的
            for (NSInteger i = 0; i < [dataArrays count]+2; i++) {
                YSYRollUnitView *base = [[YSYRollUnitView alloc] initWithFrame:CGRectMake(self.mContentWidth*i, 0, self.mContentWidth, self.mContentHeight)];
                [self.mScrollView addSubview:base];
                [self.mContentViews addObject:base];
            }
        }
        // 赋值
        _dataArrays = nil;
        _dataArrays = dataArrays;
        _mCount = _dataArrays.count;
        self.mPageControl.numberOfPages = _mCount;
        for (NSInteger i = 0; i < [dataArrays count]+2; i++) {
            YSYRollUnitView *base = self.mContentViews[i];
            base.mModel = dataArrays[[self getValidIndex:i-1]];
        }
    }
}

#pragma mark set data for UI
- (NSInteger)getValidIndex:(NSInteger)cIndex {
    
    if (cIndex == -1) {
        return self.mCount-1;
    }
    else if (cIndex == self.mCount){
        return 0;
    }
    else {
        return cIndex;
    }
}

#pragma mark action
- (void)touchAction:(UITapGestureRecognizer *)tap {
    
    if (self.touchActionBlock) {
        self.touchActionBlock(self.mIndex);
    }
}

- (void)timerAction:(NSTimer *)timer {
    
    CGPoint tOffset = CGPointMake(self.mScrollView.contentOffset.x + CGRectGetWidth(self.mScrollView.frame), self.mScrollView.contentOffset.y);
    [self.mScrollView setContentOffset:tOffset animated:YES];
}

#pragma mark UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.mTimer stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self.mTimer resumeTimerAfterTimeInterval:self.mDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger tOffsetX = scrollView.contentOffset.x;
    if (tOffsetX/self.mContentWidth == (self.mCount+1)) {
        self.mScrollView.contentOffset = CGPointMake(self.mContentWidth, 0);
        self.mPageControl.currentPage = 0;
    }else if (tOffsetX < 0){
        self.mScrollView.contentOffset = CGPointMake(self.mCount*self.mContentWidth, 0);
        self.mPageControl.currentPage = self.mCount-1;
    }else {
        self.mPageControl.currentPage=tOffsetX/self.mContentWidth-1;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self.mTimer resumeTimerAfterTimeInterval:self.mDuration];
}
@end


#pragma mark -
#pragma mark YSYRollBaseMeView

@interface YSYRollBaseMeView ()
{
    __weak NSTimer *mTimer;
}

@property (nonatomic, strong) YSYRollUnitView *mFirstView;
@property (nonatomic, strong) YSYRollUnitView *mSecondView;
@property (nonatomic, strong) YSYRollUnitView *mContentView;
@property (nonatomic, assign) NSInteger mIndex;
@property (nonatomic, assign) CGFloat mViewHeight;
@property (nonatomic, assign) CGFloat mViewOffset;

@end

static const CGFloat kHomeNewsTime = 0.3;

@implementation YSYRollBaseMeView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        // height
        _mViewOffset = 0.0;
        _mViewHeight = (frame.size.height - _mViewOffset);
        //  first
        _mFirstView = [[YSYRollUnitView alloc] initWithFrame:CGRectMake(0, _mViewOffset, frame.size.width, _mViewHeight)];
        //_mFirstView.delegate = self;
        [self addSubview:_mFirstView];
        [_mFirstView setHidden:YES];
        //  second
        _mSecondView = [[YSYRollUnitView alloc] initWithFrame:CGRectMake(0, _mViewOffset, frame.size.width, _mViewHeight)];
        //_mSecondView.delegate = self;
        [self addSubview:_mSecondView];
        [_mSecondView setHidden:YES];
    }
    return self;
}


- (void)setDataArrays:(NSArray *)dataArrays {
    
    if (!dataArrays || dataArrays.count == 0) {
        return;
    }
    // 默认数据
    if (!_mContentView) {
        self.mContentView = self.mFirstView;
    }
    [self.mContentView setHidden:NO];
    [self bringSubviewToFront:self.mContentView];
    // 赋值
    // 没有切换个数 慢慢刷新
    if (!dataArrays || (dataArrays &&
                        dataArrays.count != _dataArrays.count)) {
        self.mIndex = 0;
        self.mContentView.mModel = dataArrays[self.mIndex];
    }
    _dataArrays = nil;
    _dataArrays = dataArrays;
    // 开始轮播动画
    if (_dataArrays.count >= 2) {
        // 两个都显示
        [self.mFirstView setHidden:NO];
        [self.mSecondView setHidden:NO];
        if (!mTimer) {
            mTimer = [NSTimer scheduledTimerWithTimeInterval:kHomeNewsTime*3 target:self selector:@selector(animationMethod) userInfo:nil repeats:YES];
        }
    }
    else {
        [self showContentView];
        [self cancelTimer];
    }
}

- (void)showContentView {
    // 设置当前显示的view 正常
    // self.mContentView.transform = CGAffineTransformIdentity;
    self.mContentView.center = CGPointMake(self.mContentView.center.x, self.mViewHeight/2+self.mViewOffset);
    [self.mContentView setHidden:NO];
    // 隐藏另外一个view
    if (self.mContentView == self.mFirstView) {
        [self.mSecondView setHidden:YES];
    }
    else {
        [self.mFirstView setHidden:YES];
    }
}

/*
 先是底下的变小
 后是上面的变小、底下的变大
 最后切换层次、还原
 */
- (void)animationMethod {
    // 循环
    self.mIndex ++;
    self.mIndex = (self.mIndex % self.dataArrays.count);
    // 当前显示的是first 下标偶数 需要切换至second
    if (self.mContentView == self.mFirstView) {
        self.mContentView = self.mSecondView;
        self.mContentView.mModel = self.dataArrays[self.mIndex];
        [self changeViewAnimation:self.mSecondView :self.mFirstView]
        ;
    }
    // 当前显示的是second 下标奇数 需要切换至first
    else {
        self.mContentView = self.mFirstView;
        self.mFirstView.mModel = self.dataArrays[self.mIndex];
        [self changeViewAnimation:self.mFirstView :self.mSecondView]
        ;
    }
}
/**
 view1 需要显示的view
 view2 需要隐藏的view
 */
- (void)changeViewAnimation:(UIView *)view1 :(UIView *)view2 {
//    // 先压缩需要显示的
//    view1.transform = CGAffineTransformScale(view1.transform, 1.0, kHomeNewsScale);
//    view1.center = CGPointMake(view1.center.x, self.mViewHeight);
//    // 需要隐藏的赋予正常值
//    view2.transform = CGAffineTransformIdentity;
//    [UIView animateWithDuration:kHomeNewsTime animations:^{
//        // 显示
//        view1.transform = CGAffineTransformIdentity;
//        view1.center = CGPointMake(view1.center.x, self.mViewHeight/2+self.mViewOffset);
//        // 隐藏
//        view2.transform = CGAffineTransformScale(self.mSecondView.transform, 1.0, kHomeNewsScale);
//        view2.center = CGPointMake(self.mSecondView.center.x, self.mViewOffset);
//    }];
//    [self bringSubviewToFront:view1];
    
    // 组合动画
    CATransition *animal = [CATransition animation];
    animal.type = kCATransitionPush;//设置动画的类型
    animal.subtype = kCATransitionFromRight; //设置动画的方向
    animal.duration = kHomeNewsTime; //时间
    [self.layer addAnimation:animal forKey:@"kCATransitionPush"];
    // 置顶
    [self bringSubviewToFront:view1];
}


- (void)cancelBind {
    [self.mFirstView setHidden:YES];
    [self.mSecondView setHidden:YES];
    [self cancelTimer];
}

- (void)cancelTimer {
    if (mTimer) {
        [mTimer invalidate];
        mTimer = nil;
    }
}

- (void)dealloc {
    [self cancelTimer];
}
@end


#pragma mark -
#pragma mark YSYAutoRollHeadView
const CGFloat kMaxRollHeight = 90.0f;
const CGFloat kRollHeadHeight = 200.0f;
const CGFloat kRollScale = 0.5f;

@interface YSYAutoRollHeadView ()
// 初始化高度
@property (nonatomic, assign) CGFloat mOriginHeight;
// 初始化宽度
@property (nonatomic, assign) CGFloat mOriginWidth;
// 默认状态栏高度
@property (nonatomic, assign) CGFloat mStatusHeight;

@end

@implementation YSYAutoRollHeadView

- (instancetype)initWithFrame:(CGRect)frame
                  observeView:(UIScrollView *)oView {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _mOriginHeight = frame.size.height;
        _mOriginWidth = frame.size.width;
        _mStatusHeight = [UIDevice statusBarHeight];
        if (oView) {
            _mObserveView = oView;
            [_mObserveView addObserver:self
                            forKeyPath:@"contentOffset"
                               options:NSKeyValueObservingOptionNew
                               context:nil];
        }
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    UIScrollView *scrollView = object;
    CGFloat offSetY = (scrollView.contentOffset.y+_mStatusHeight);
    // 渐变过程
    if (offSetY <= 0 && offSetY >= -kMaxRollHeight) {
        self.ysy_top = -kMaxRollHeight*kRollScale-offSetY*kRollScale;
    }
    // 最大限度
    else if(offSetY < -kMaxRollHeight){
        self.mObserveView.contentOffset = CGPointMake(0, -kMaxRollHeight-_mStatusHeight);
    }
    // 往上滚动
    else if(offSetY <= self.mOriginHeight) {
        self.ysy_top = -kMaxRollHeight*kRollScale-offSetY;
    }
}

- (void)dealloc {
    [self.mObserveView removeObserver:self
                           forKeyPath:@"contentOffset"];
}

@end

