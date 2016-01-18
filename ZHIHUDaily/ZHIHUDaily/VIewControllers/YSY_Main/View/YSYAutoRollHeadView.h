//
//  YSYAutoRollHeadView.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/15.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * 基视图
 */
@class ThemeMainStories;
@interface YSYRollUnitView : UIView

@property (nonatomic, strong) ThemeMainStories *mModel;// 数据

@end

/**
 * 滚动视图 基类
 */
@interface YSYRollBaseView : UIView

@property (nonatomic, strong) NSArray *dataArrays;// 数据

@end

/**
 * 滚动视图
 */
UIKIT_EXTERN const CGFloat kMaxRollHeight;// 最大拖动高度
UIKIT_EXTERN const CGFloat kRollHeadHeight;// headView高度
UIKIT_EXTERN const CGFloat kRollScale;// 拖动系数

@interface YSYAutoRollHeadView : YSYRollBaseView

- (instancetype)initWithFrame:(CGRect)frame
                  observeView:(UIScrollView *)oView;

@property (nonatomic, strong) UIScrollView *mObserveView;

@end
