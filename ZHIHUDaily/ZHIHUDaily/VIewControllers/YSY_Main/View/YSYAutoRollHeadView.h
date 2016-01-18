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

@property (nonatomic, strong) ThemeMainStories *mModel;

@end

/**
 * 滚动视图 基类
 */
@interface YSYRollBaseView : UIView

@property (nonatomic, strong) NSArray *dataArrays;

@end

/**
 * 滚动视图
 */
// 最大拖动高度
UIKIT_EXTERN const CGFloat kMaxRollHeight;
UIKIT_EXTERN const CGFloat kRollHeadViewHeight;
UIKIT_EXTERN const CGFloat kRollHeadHeight;
UIKIT_EXTERN const CGFloat kRollScale;

@interface YSYAutoRollHeadView : YSYRollBaseView

- (instancetype)initWithFrame:(CGRect)frame
                  observeView:(UIScrollView *)oView;

@property (nonatomic, strong) UIScrollView *mObserveView;

@end
