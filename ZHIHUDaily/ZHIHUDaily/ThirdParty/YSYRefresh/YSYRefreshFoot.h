//
//  YSYRefreshFoot.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/18.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSYRefreshBase.h"

@interface YSYRefreshFoot : YSYRefreshBase

// 忽略底部量
@property (nonatomic, assign) CGFloat ignoredInsetBottom;
// 自动根据有无数据来显示和隐藏
@property (assign, nonatomic, getter=isAutoHidden) BOOL autoHidden;
/**
 初始化 foot
 */
+ (instancetype)footWithBlock:(YSYRefreshBaseRefreshingBlock)block;
+ (instancetype)footWithTarget:(id)target action:(SEL)action;
// 没有更多数据
- (void)endRefreshingWithNoMoreData;
// 又有更多数据了
- (void)resetNoMoreData;

/**********自动刷新 foot 设置***********/
// 是否自动刷新(默认为YES)
@property (nonatomic, assign,getter=isAutoRefresh) BOOL autoRefresh;
// 当底部控件出现多少时就自动刷新
// 默认为1.0,也就是底部控件完全出现时,才会自动刷新
@property (assign, nonatomic) CGFloat triggerAutoRefreshPercent;

@end
