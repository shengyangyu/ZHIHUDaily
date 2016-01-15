//
//  YSYRollHeadView.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/13.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YSYRollHeadViewBlock)(id data);

/**
 * 显示单元视图
 */
@class ThemeStories;
@interface YSYRollUnitView : UIView


@property (nonatomic, strong) ThemeStories *mModel;

+ (instancetype)attchToSuperView:(UIView *)sView observeScorllView:(UIScrollView *)oView;

@end

/**
 * 滚动基视图
 */
@interface YSYRollBaseView : UIView

@end

/**
 * 滚动视图
 */
@interface YSYRollHeadView : YSYRollBaseView

// block
@property (nonatomic, copy) YSYRollHeadViewBlock touchBlock;
// data
@property (nonatomic, strong) NSArray *dataArrays;
// init
+ (instancetype)addToSuperView:(UIView *)sView observeView:(UIScrollView *)oView;

@end
