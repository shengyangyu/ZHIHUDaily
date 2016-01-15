//
//  YSYRollHeadView.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/13.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "YSYRollHeadView.h"
#import "ThemeMainModel.h"

static CGFloat kTimerDuration = 5.0f;

#pragma mark -
#pragma mark YSYRollBaseView

@interface YSYRollUnitView ()

@property (nonatomic, strong) UIImageView *mImageView;
@property (nonatomic, assign, getter=isObserve) BOOL observe;
@property (nonatomic, strong) UIScrollView *mScrollView;

@end

@implementation YSYRollUnitView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mImageView];
    }
    return self;
}

+ (instancetype)attchToSuperView:(UIView *)sView observeScorllView:(UIScrollView *)oView {
    
    YSYRollUnitView *tView = [[YSYRollUnitView alloc] initWithFrame:sView.bounds];
    if (tView) {
        tView.observe = YES;
        [sView addSubview:tView];
        tView.mScrollView = oView;
        [oView addObserver:tView
                forKeyPath:@"contentOffset"
                   options:NSKeyValueObservingOptionNew
                   context:nil];

    }
    return tView;
}

- (void)setMModel:(ThemeStories *)mModel {
    _mModel = mModel;
    //self.titleLabel.text = storyModel.title;
    //[self.mImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"Field_Mask_Bg"]];
    //
    //self.mImageView.ysy_frame = (CGRect){.origin = origin, .size = _layout.picSize};
    self.mImageView.hidden = NO;
    [self.mImageView.layer removeAnimationForKey:@"contents"];
    @weakify(self);
    [self.mImageView.layer yy_setImageWithURL:[NSURL URLWithString:mModel.images[0]] placeholder:nil options:YYWebImageOptionAvoidSetImage completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        @strongify(self);
        if (!self.mImageView) {
            return ;
        }
        if (image && stage == YYWebImageStageFinished) {
            // 宽图把左右两边裁掉
            self.mImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.mImageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
            self.mImageView.image = image;
            if (from != YYWebImageFromMemoryCacheFast) {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.15;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                transition.type = kCATransitionFade;
                [self.mImageView.layer addAnimation:transition forKey:@"contents"];
            }
        }
    }];
    
}

- (UIImageView *)mImageView {
    if (!_mImageView) {
        _mImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _mImageView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context{
    UIScrollView *scrollView = object;
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY <= 0 && offSetY >= -90) {
        self.frame = CGRectMake(0, -45 - 0.5 * offSetY, kScreenWidth, 265 - 0.5 * offSetY);
    }else if(offSetY<-90){
        self.mScrollView.contentOffset = CGPointMake(0, -90);
    }else if(offSetY <= 500) {
        if (offSetY <= 220) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }else [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        self.ysy_top = -45 - offSetY;
    }
}

- (void)dealloc{
    if (self.isObserve) {
        [self.mScrollView removeObserver:self
                              forKeyPath:@"contentOffset"];
        //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}


@end

#pragma mark -
#pragma mark YSYRollBaseView
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
// 获取指定index view
@property (nonatomic, copy) UIView *(^getContentViewBlock)(NSInteger mIndex);
// 点击事件
@property (nonatomic, copy) void (^touchActionBlock)(NSInteger mIndex);

@end

@implementation YSYRollBaseView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
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
/*- (UIScrollView *)mScrollView {
    if (_mScrollView) {
        _mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mScrollView.autoresizingMask = 0xFF;
        _mScrollView.contentMode = UIViewContentModeCenter;
        _mScrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(_mScrollView.frame), CGRectGetHeight(_mScrollView.frame));
        _mScrollView.delegate = self;
        _mScrollView.contentOffset = CGPointMake(CGRectGetWidth(_mScrollView.frame), 0);
        _mScrollView.pagingEnabled = YES;
    }
    return _mScrollView;
}*/

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
    for (UIView *tView in self.mScrollView.subviews) {
        tView.ysy_height = self.mScrollView.ysy_height;
    }
    self.mPageControl.ysy_top = self.mScrollView.ysy_height - 10;
}

- (void)setTotalCountBlock:(NSInteger (^)(void))totalCountBlock {
    _mCount = totalCountBlock();
    if (_mCount > 0) {
        [self configViews];
    }
}

#pragma mark set data for UI
- (void)configViews {
    // 移除旧的
    [self.mScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加新的
    [self addContentView];
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
    [self.mScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.mScrollView.frame), 0)];
}

- (void)addContentView {
    NSInteger tPreIndex = [self getValidIndex:self.mIndex-1];
    NSInteger tNextIndex = [self getValidIndex:self.mIndex+1];
    if (!self.mContentViews) {
        self.mContentViews = [NSMutableArray new];
    }
    [self.mContentViews removeAllObjects];
    if (self.getContentViewBlock) {
        [self.mContentViews addObject:self.getContentViewBlock(tPreIndex)];
        [self.mContentViews addObject:self.getContentViewBlock(self.mIndex)];
        [self.mContentViews addObject:self.getContentViewBlock(tNextIndex)];
    }
}

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
    if (tOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.mIndex = [self getValidIndex:self.mIndex+1];
        [self configViews];
    }
    if (self.mIndex <= 0) {
        self.mIndex = [self getValidIndex:self.mIndex-1];
        [self configViews];
    }
    self.mPageControl.currentPage = self.mIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}
@end

#pragma mark -
#pragma mark YSYRollHeadView

@implementation YSYRollHeadView

+ (instancetype)addToSuperView:(UIView *)sView observeView:(UIScrollView *)oView {
    
    YSYRollHeadView *tHead = [[YSYRollHeadView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 0)];
    tHead.mScrollView = oView;
    [oView addObserver:tHead
            forKeyPath:@"contentOffset"
               options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
               context:nil];
    return tHead;
}

- (void)setDataArrays:(NSArray *)dataArrays {
    
    _dataArrays = dataArrays;
    __weak typeof(self) weakSelf = self;
    self.getContentViewBlock = ^UIView *(NSInteger pageIndex) {
        YSYRollUnitView *vv = [[YSYRollUnitView alloc] initWithFrame:weakSelf.frame];
        vv.mModel = weakSelf.dataArrays[pageIndex];
        return vv;
    };
    self.totalCountBlock = ^NSInteger(void) {
        return dataArrays.count;
    };
    self.touchActionBlock = ^(NSInteger pageIndex) {
        //weakSelf.topViewBlock(dataArrays[pageIndex]);
    };
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context{
    
    UIScrollView *scrollView = object;
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY <=0 && offSetY >= -90) {
        self.frame = CGRectMake(0, -45 - 0.5 * offSetY, kScreenWidth, 265 - 0.5 * offSetY);
    }else if(offSetY<-90){
        self.mScrollView.contentOffset = CGPointMake(0, -90);
    }else if(offSetY <= 500) {
        self.ysy_top = -45 - offSetY;
    }
}

- (void)dealloc{
    [self.mScrollView removeObserver:self
                          forKeyPath:@"contentOffset"];
}
@end
