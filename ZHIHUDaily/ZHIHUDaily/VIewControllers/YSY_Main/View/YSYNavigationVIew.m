//
//  YSYNavigationView.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/13.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "YSYNavigationView.h"

@interface YSYNavigationView ()


@property (nonatomic, strong) UIButton *mMenuLeft;

@end

@implementation YSYNavigationView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mBackgroundView];
        [self addSubview:self.mTitle];
        [self addSubview:self.mMenuLeft];
    }
    
    return self;
}

- (UILabel *)mTitle {
    if (!_mTitle) {
        _mTitle = [[UILabel alloc] init];
        _mTitle.attributedText = [[NSAttributedString alloc] initWithString:@"今日热闻" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18] ,NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [_mTitle sizeToFit];
        [_mTitle setCenter:CGPointMake(self.center.x, self.center.y+[UIDevice statusBarHeight]/2)];
    }
    return _mTitle;
}

- (UIButton *)mMenuLeft {
    if (!_mMenuLeft) {
        _mMenuLeft = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, [UIDevice statusBarHeight], CGRectGetHeight(self.frame)-[UIDevice statusBarHeight], CGRectGetHeight(self.frame)-[UIDevice statusBarHeight])];
        [_mMenuLeft setImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
        // [_menuLeft addTarget:self action:@selector(showLeftMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mMenuLeft;
}

- (UIView *)mBackgroundView {
    if (!_mBackgroundView) {
        _mBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _mBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _mBackgroundView;
}

#pragma mark - public


@end
