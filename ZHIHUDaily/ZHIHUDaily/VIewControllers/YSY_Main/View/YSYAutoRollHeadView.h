//
//  YSYAutoRollHeadView.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/15.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThemeMainStories;
// 最大拖动高度
UIKIT_EXTERN const CGFloat kMaxRollHeight;
UIKIT_EXTERN const CGFloat kRollHeadViewHeight;


@interface YSYAutoRollHeadView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                  observeView:(UIScrollView *)oView;

@property (nonatomic, strong) NSArray *dataArrays;
@property (nonatomic, strong) UIImageView *mImageView;
@property (nonatomic, strong) UIScrollView *mObserveView;

@end
