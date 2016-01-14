//
//  YSYNavigationView.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/13.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "YSYNavigationView.h"

@interface YSYNavigationView ()


@property (nonatomic, strong) UIButton *menuLeft;

@end

@implementation YSYNavigationView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundView];
        [self addSubview:self.title];
        [self addSubview:self.menuLeft];
    }
    
    return self;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.attributedText = [[NSAttributedString alloc] initWithString:@"今日热闻" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18] ,NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [_title sizeToFit];
        [_title setCenter:CGPointMake(self.center.x, self.center.y+[UIDevice statusBarHeight]/2)];
    }
    return _title;
}

- (UIButton *)menuLeft {
    if (!_menuLeft) {
        _menuLeft = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, [UIDevice statusBarHeight], CGRectGetHeight(self.frame)-[UIDevice statusBarHeight], CGRectGetHeight(self.frame)-[UIDevice statusBarHeight])];
        [_menuLeft setImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
        // [_menuLeft addTarget:self action:@selector(showLeftMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuLeft;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor clearColor];
    }
    return _backgroundView;
}

#pragma mark - public


@end
