//
//  ThemeListCell.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/14.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSYTableViewCell.h"
#import "ThemeListLayout.h"

/**
 主题信息cell
 */
@class TLStoriesView;
@interface ThemeListCell : YSYTableViewCell

@property (nonatomic, strong) TLStoriesView *storiesView;

- (void)setLayout:(ThemeListLayout *)layout;

@end

/**
 填充内容
 */
@interface TLStoriesView : UIView

@property (nonatomic, strong) UIView *contentView; // 容器
@property (nonatomic, strong) YYLabel *textLabel; // 文本
@property (nonatomic, strong) YSYControl *imageView;
@property (nonatomic, strong) CALayer *bottomLine; // 底部线
@property (nonatomic, strong) ThemeListLayout *layout;
@property (nonatomic, weak) ThemeListCell *cell;

@end