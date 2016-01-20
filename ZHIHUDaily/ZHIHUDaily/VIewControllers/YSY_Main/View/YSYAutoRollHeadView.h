//
//  YSYAutoRollHeadView.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/15.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * 基础填充视图
 */
@class ThemeMainStories;
@interface YSYRollUnitView : UIView

@property (nonatomic, strong) ThemeMainStories *mModel;// 数据

@end

/**
 * 横向循环滚动视图 UIScrollView
 */
@interface YSYRollBaseView : UIView

@property (nonatomic, strong) NSArray *dataArrays;// 数据

@end

/**
 * 横向循环滚动视图 自定义
 */
@interface YSYRollBaseMeView : UIView

@property (nonatomic, strong) NSArray *dataArrays;// 数据

@end

/**
 * 竖直拖动视图
 */
UIKIT_EXTERN const CGFloat kMaxRollHeight;// 最大拖动高度
UIKIT_EXTERN const CGFloat kRollHeadHeight;// headView高度
UIKIT_EXTERN const CGFloat kRollScale;// 拖动系数

@interface YSYAutoRollHeadView : YSYRollBaseView

- (instancetype)initWithFrame:(CGRect)frame
                  observeView:(nullable UIScrollView *)oView;

@property (nonatomic, strong) UIScrollView * _Nullable mObserveView;

@end
