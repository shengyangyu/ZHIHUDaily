//
//  YSYRefreshFooter.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/25.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^YSYBeginRefreshBlock)(void);

@interface YSYRefreshFooter : NSObject

@property(nonatomic, copy) YSYBeginRefreshBlock beginBlock;

- (instancetype)initFooterWithFrame:(CGRect)frame withSuper:(UIScrollView *)mSuper;
-(void)beginRefreshing;
-(void)endRefreshing;
-(void)endRefreshMehod;

@end
