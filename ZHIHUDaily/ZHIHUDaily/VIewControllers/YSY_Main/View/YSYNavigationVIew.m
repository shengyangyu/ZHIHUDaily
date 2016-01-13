//
//  YSYNavigationView.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/13.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "YSYNavigationView.h"

@interface YSYNavigationView ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *menuLeft;

@end

@implementation YSYNavigationView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    [self addSubview:self.title];
    
    [self addSubview:self.menuLeft];
    
    
    return self;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.attributedText = [[NSAttributedString alloc] initWithString:@"今日热闻" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18] ,NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [_title sizeToFit];
        [_title setCenter:CGPointMake(self.center.x, self.center.y)];
    }
    return _title;
}

- (UIButton *)menuLeft {
    if (!_menuLeft) {
        _menuLeft = [[UIButton alloc] initWithFrame:CGRectMake(16.f, 28.f, 22.f, 22.f)];
        [_menuLeft setImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
        //[_menuLeft addTarget:self action:@selector(showLeftMenu:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuLeft;
}

#pragma mark - public


@end
