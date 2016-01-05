//
//  YSYRefreshFooter.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/25.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSYRefreshFooter.h"

@interface YSYRefreshFooter (){
    
    CGFloat mContentHeight;
    CGFloat mScrollHeight;
    CGFloat mScrollWidth;
    CGFloat mFooterHeight;
    BOOL mIsAddFoot;//是否添加了footer,默认是NO
    BOOL mIsRefreshing;//是否正在刷新,默认是NO
    
    UIView *mFooterView;
    UIActivityIndicatorView *mActivityView;
}
@property(nonatomic,strong) UIScrollView *mScrollView;

@end

static NSString *kContenOffsetKVC = @"contentOffset";

@implementation YSYRefreshFooter

- (instancetype)initFooterWithFrame:(CGRect)frame withSuper:(UIScrollView *)mSuper {
    self = [super init];
    if (self) {
        _mScrollView = mSuper;
        mScrollHeight = _mScrollView.frame.size.height;
        mScrollWidth = _mScrollView.frame.size.width;
        mFooterHeight = frame.size.height;
        mIsAddFoot = NO;
        mIsRefreshing = NO;
        mFooterView = [[UIView alloc] init];
        mActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_mScrollView addObserver:self forKeyPath:kContenOffsetKVC options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (![kContenOffsetKVC isEqualToString:keyPath]) {
        return;
    }
    mContentHeight = _mScrollView.contentSize.height;
    if (!mIsAddFoot) {
        mIsAddFoot = YES;
        mFooterView.frame = CGRectMake(0, mContentHeight, mScrollWidth, mFooterHeight);
        [_mScrollView addSubview:mFooterView];
        mActivityView.frame = CGRectMake((mScrollWidth-mFooterHeight)/2, 0, mFooterHeight, mFooterHeight);
        [mFooterView addSubview:mActivityView];
    }
    
    mFooterView.frame = CGRectMake(0, mContentHeight, mScrollWidth, mFooterHeight);
    mActivityView.frame = CGRectMake((mScrollWidth-mFooterHeight)/2, 0, mFooterHeight, mFooterHeight);
    int currentPostion = _mScrollView.contentOffset.y;
    // 进入刷新状态
    if (!mIsRefreshing &&
        (currentPostion > (mContentHeight-mScrollHeight*2)) &&
        (mContentHeight > mScrollHeight)) {
        [self beginRefreshing];
    }
}

/**
 *  开始刷新操作  如果正在刷新则不做操作
 */
- (void)beginRefreshing {
    if (!mIsRefreshing) {
        NSLog(@"beginRefreshing");
        mIsRefreshing = YES;
        if (mFooterHeight > 1.0f) {
            [mActivityView startAnimating];
            // 设置刷新状态_scrollView的位置
            [UIView animateWithDuration:0.25 animations:^{
                _mScrollView.contentInset = UIEdgeInsetsMake(0, 0, mFooterHeight, 0);
            }];
        }
        // block回调
        _beginBlock();
    }
}

/**
 *  关闭刷新操作  请加在UIScrollView数据刷新后，如[tableView reloadData];
 */
- (void)endRefreshing {
    NSLog(@"endRefreshing");
    if (mFooterHeight > 1.0f) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                [mActivityView stopAnimating];
                _mScrollView.contentInset = UIEdgeInsetsMake(0,0,0,0);
                mFooterView.frame = CGRectMake(0, mContentHeight, [[UIScreen mainScreen] bounds].size.width, mFooterHeight);
            } completion:^(BOOL finished) {
                if (finished) {
                    mIsRefreshing = NO;
                }
            }];
        });
    }
    else {
        mIsRefreshing = NO;
    }
}

- (void)dealloc {
    [_mScrollView removeObserver:self forKeyPath:kContenOffsetKVC];
}

@end