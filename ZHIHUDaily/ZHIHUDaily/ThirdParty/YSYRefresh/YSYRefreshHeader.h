//
//  YSYRefreshHeader.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/20.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN const CGFloat kShowHeaderSize;

@interface YSYShowHeader : UIView

// 显示中属性
@property (nonatomic, assign ,readonly) BOOL isShowing;
// 显示动画
- (void)showAnimation;
// 结束动画
- (void)dismissAnimation;

@end

@interface YSYRefreshHeader : NSObject

// 定义回调
typedef void(^YSYStartBlock)();
typedef BOOL(^YSYEndBlock)();
@property (nonatomic, copy) YSYStartBlock startBlock;
@property (nonatomic, copy) YSYEndBlock endBlock;
// 在顶部
@property (nonatomic, assign) BOOL isScrollTop;
// 初始化
- (instancetype)initWithSuperView:(UIView *)sView;
// 开始刷新
- (void)startRefresh;
// 结束刷新
- (void)endRefresh;

@end
