//
//  YSYRefreshFooter.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/25.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSYRefreshFooter.h"

@interface YSYRefreshFooter ()
{
    CGFloat mContentHeight;
    CGFloat mScrollHeight;
    CGFloat mScrollWidth;
    //是否正在刷新,默认是NO
    BOOL mIsRefreshing;
    // 是否添加了footer,默认是NO
    BOOL mIsAddFoot;
    // footer
    UIView *mFooterView;
    UIActivityIndicatorView *mActivityView;
    CGFloat mFooterHeight;
}

@property (nonatomic, strong) UIScrollView *mScrollView;

@end

//static NSString *kContenOffsetKVC = @"kContenOffset";

@implementation YSYRefreshFooter

- (instancetype)initFooterWithFrame:(CGRect)frame withSuper:(UIScrollView *)mSuper {
    if (self = [super init]) {
        _mScrollView = mSuper;
        mScrollWidth = _mScrollView.frame.size.width;
        mScrollHeight = _mScrollView.frame.size.height;
        mFooterHeight = 35.0f;
        mIsAddFoot = NO;
        mIsRefreshing = NO;
        mFooterView = [UIView new];
        mActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_mScrollView addObserver:self forKeyPath:@"kContenOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (![@"kContenOffset" isEqualToString:keyPath]) {
        return;
    }
    mContentHeight = _mScrollView.contentSize.height;
    // 没有添加 加一个
    if (!mIsAddFoot) {
        mIsAddFoot = YES;
        // foot
        mFooterView.frame = CGRectMake(0, mContentHeight, mScrollWidth, mFooterHeight);
        [_mScrollView addSubview:mFooterView];
        // Activity
        mActivityView.center = CGPointMake(mScrollWidth/2, mFooterHeight/2);
        [mFooterView addSubview:mActivityView];
    }
    // 有了设置位置
    mFooterView.frame = CGRectMake(0, mContentHeight, mScrollWidth, mFooterHeight);
    mActivityView.center = CGPointMake(mScrollWidth/2, mFooterHeight/2);
    // 进入刷新状态
    NSInteger cPostion = _mScrollView.contentOffset.y;
    if ((cPostion > (mContentHeight - mScrollHeight)) &&(mContentHeight > mScrollHeight)) {
        [self beginRefreshing];
    }
}

- (void)beginRefreshing {
    if (!mIsRefreshing) {
        mIsRefreshing = YES;
        [mActivityView startAnimating];
        // 设置刷新状态scrollView的位置
        [UIView animateWithDuration:0.25 animations:^{
            _mScrollView.contentInset = UIEdgeInsetsMake(0, 0, mFooterHeight, 0);
        }];
        // block回调
        _beginBlock();
    }
}

- (void)endRefreshing {
    mIsRefreshing = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            [mActivityView stopAnimating];
            _mScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            mFooterView.frame = CGRectMake(0, mContentHeight, mScrollWidth, mFooterHeight);
        }];
    });
}


-(void)endRefreshMehod {
    mIsRefreshing = NO;
    
}
- (void)dealloc {
    [_mScrollView removeObserver:self forKeyPath:@"kContenOffset"];
}

@end
/*
#import "YSYRefreshFooter.h"

@interface YSYRefreshFooter (){
    
    float contentHeight;
    float scrollFrameHeight;
    float footerHeight;
    float scrollWidth;
    BOOL isAdd;//是否添加了footer,默认是NO
    BOOL isRefresh;//是否正在刷新,默认是NO
    
    UIView *footerView;
    UIActivityIndicatorView *activityView;
}
@property(nonatomic,strong) UIScrollView *scrollView;

@end

@implementation YSYRefreshFooter

- (instancetype)initFooterWithFrame:(CGRect)frame withSuper:(UIScrollView *)mSuper {
    self = [super init];
    if (self) {
        _scrollView = mSuper;
        scrollWidth=_scrollView.frame.size.width;
        footerHeight=35;
        scrollFrameHeight=_scrollView.frame.size.height;
        isAdd=NO;
        isRefresh=NO;
        footerView=[[UIView alloc] init];
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![@"contentOffset" isEqualToString:keyPath])
        return;
    contentHeight=_scrollView.contentSize.height;
    if (!isAdd) {
        isAdd=YES;
        footerView.frame=CGRectMake(0, contentHeight, scrollWidth, footerHeight);
        [_scrollView addSubview:footerView];
        activityView.frame=CGRectMake((scrollWidth-footerHeight)/2, 0, footerHeight, footerHeight);
        [footerView addSubview:activityView];
    }
    
    footerView.frame=CGRectMake(0, contentHeight, scrollWidth, footerHeight);
    activityView.frame=CGRectMake((scrollWidth-footerHeight)/2, 0, footerHeight, footerHeight);
    int currentPostion = _scrollView.contentOffset.y;
    // 进入刷新状态
    if (!isRefresh &&
        (currentPostion > (contentHeight-scrollFrameHeight*2)) &&
        (contentHeight > scrollFrameHeight)) {
        [self beginRefreshing];
    }
}

/**
 *  开始刷新操作  如果正在刷新则不做操作
 *//*
- (void)beginRefreshing
{
    if (!isRefresh) {
        NSLog(@"beginRefreshing");
        isRefresh=YES;
        [activityView startAnimating];
        //        设置刷新状态_scrollView的位置
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentInset=UIEdgeInsetsMake(0, 0, footerHeight, 0);
        }];
        //        block回调
        _beginBlock();
    }
}
*/
/**
 *  关闭刷新操作  请加在UIScrollView数据刷新后，如[tableView reloadData];
 *//*
- (void)endRefreshing
{
    NSLog(@"endRefreshing");
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            [activityView stopAnimating];
            _scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
            footerView.frame=CGRectMake(0, contentHeight, [[UIScreen mainScreen] bounds].size.width, footerHeight);
        } completion:^(BOOL finished) {
            if (finished) {
                //isRefresh=NO;
            }
        }];
    });
}



- (void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end*/