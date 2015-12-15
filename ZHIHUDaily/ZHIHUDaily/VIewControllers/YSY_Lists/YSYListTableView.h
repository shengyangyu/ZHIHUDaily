//
//  YSYListTableView.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/15.
//  Copyright © 2015年 yushengyang. All rights reserved.
//  根据VVeboTableView 实现优化
//  目前来看 需要数据尚不支持分页加载

#import "YSYTableView.h"

@interface YSYListTableView : YSYTableView

/**
 初始化
 */
- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                    withArray:(NSArray *)tArrays;

@end
