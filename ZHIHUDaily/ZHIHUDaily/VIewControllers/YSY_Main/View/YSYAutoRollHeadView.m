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
        [self addSubview:self.mImageView];
    }
    return self;
}

- (UIImageView *)mImageView {
    if (!_mImageView) {
        _mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _mOriginWidth, _mOriginHeight)];
        _mImageView.backgroundColor = [UIColor yellowColor];
        //_mImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _mImageView;
}

- (void)setMModel:(ThemeMainStories *)mModel {
    
    //[self.mImageView yy_setImageWithURL:[NSURL URLWithString:mModel.image] options:YYWebImageOptionShowNetworkActivity];
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
// 获取总数
@property (nonatomic, copy) NSInteger (^totalCountBlock)(void);
// 点击事件
@property (nonatomic, copy) void (^touchActionBlock)(NSInteger mIndex);

@end

@implementation YSYRollBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //self.autoresizesSubviews = YES;
        [self addSubview:self.mScrollView];
        [self addSubview:self.mPageControl];
        self.mIndex = 0;
        if (self.mDuration > 0.0f) {
            self.mTimer = [NSTimer scheduledTimerWithTimeInterval:self.mDuration target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
            [self.mTimer stopTimer];
        }
    }
    return self;
}

#pragma mark setter getter
- (UIScrollView *)mScrollView {
    if (!_mScrollView) {
        _mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mScrollView.backgroundColor = [UIColor redColor];
        //_mScrollView.autoresizingMask = 0xFF;
        //_mScrollView.contentMode = UIViewContentModeCenter;
        _mScrollView.contentSize = CGSizeMake(CGRectGetWidth(_mScrollView.frame), CGRectGetHeight(_mScrollView.frame));
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

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.mScrollView.frame = self.bounds;
    /*
     for (UIView *tView in self.mScrollView.subviews) {
     tView.ysy_height = self.mScrollView.ysy_height;
     }*/
    self.mPageControl.ysy_top = self.mScrollView.ysy_height - 10;
}

- (void)setDataArrays:(NSArray *)dataArrays {
    if (_dataArrays != dataArrays) {
        _dataArrays = dataArrays;
        // 移除旧的
        [self.mScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        // 添加新的
        [self.mScrollView setContentSize:CGSizeMake(dataArrays.count*CGRectGetWidth(self.mScrollView.frame), CGRectGetHeight(self.mScrollView.frame))];
        for (NSInteger i = 0; i < dataArrays.count; i++) {
            YSYRollUnitView *base = [[YSYRollUnitView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.mScrollView.frame)*i, 0, CGRectGetWidth(self.mScrollView.frame), CGRectGetHeight(self.mScrollView.frame))];
            [self.mScrollView addSubview:base];
            base.mModel = dataArrays[i];
            
            [self.mContentViews addObject:base];
        }
        self.mPageControl.numberOfPages = _mCount;
        NSInteger tCount = 0;
        for (UIView *tView in self.mContentViews) {
            // 添加手势
            tView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction:)];
            [tView addGestureRecognizer:tapGesture];
            // frame
            CGRect rightRect = tView.frame;
            rightRect.origin = CGPointMake(CGRectGetWidth(self.mScrollView.frame) * (tCount++), 0);
            tView.frame = rightRect;
            [self.mScrollView addSubview:tView];
        }
        [self.mScrollView setContentOffset:CGPointMake(0, 0)];
    }
}

- (void)setMModel:(ThemeMainStories *)mModel {
    
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
    self.mPageControl.currentPage = tOffsetX/CGRectGetWidth(scrollView.frame);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}
@end

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

#pragma mark -
#pragma mark YSYAutoRollHeadView

@implementation YSYAutoRollHeadView

- (instancetype)initWithFrame:(CGRect)frame
                  observeView:(UIScrollView *)oView {
    
    self = [super initWithFrame:frame];
    if (self) {
        _mOriginHeight = frame.size.height;
        _mOriginWidth = frame.size.width;
        _mStatusHeight = [UIDevice statusBarHeight];
        _mObserveView = oView;
        [_mObserveView addObserver:self
                forKeyPath:@"contentOffset"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
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
        self.frame = CGRectMake(0, (-kMaxRollHeight-offSetY)*kRollScale, self.mOriginWidth, self.mOriginHeight-offSetY*kRollScale);
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
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

@end

