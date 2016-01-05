//
//  ThemeListLayout.h
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/4.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeListModel.h"


#define TLCellTextPadding __View_Scale(2.0f) // 行距
#define TLCellHorizontalMargin __View_Scale(17.0f) // 横向间隔
#define TLCellVerticalMargin __View_Scale(17.0f) // 纵向间隔
#define TLCellFontSize __View_Scale(17.0f) // 字体
#define TLCellImageOffset __View_Scale(10.0f) // image 间距
#define TLCellImageWidth __View_Scale(95.0f) // image 宽
#define TLCellImageHeight __View_Scale(62.0f) // image 高
#define TLCellWidth (__MainScreen_Width-2*TLCellHorizontalMargin)// cell 除边距宽度


/// cell类型 有无图片
typedef NS_ENUM(NSUInteger, ThemeListCellType) {
    ThemeListCellTypeNormal = 0,   ///< 文本
    ThemeListCellTypeImage,    ///< 文本 + 图片
};

/**
 一个 Cell 的布局。
 布局排版应该在后台线程完成。
 */
@interface ThemeListLayout : NSObject

- (instancetype)initWithStories:(ThemeStories *)stories;
- (void)layout; ///< 计算布局
// 以下是数据
@property (nonatomic, strong) ThemeStories *stories;
//以下是布局结果
// 顶部留白
@property (nonatomic, assign) CGFloat marginTop; //顶部灰色留白
// 标题栏
@property (nonatomic, assign) CGFloat titleHeight; //标题栏高度，0为没标题栏
@property (nonatomic, strong) YYTextLayout *titleTextLayout; // 标题栏
@property (nonatomic, assign) ThemeListCellType cellType;
// 下边留白
@property (nonatomic, assign) CGFloat marginBottom; //下边留白
// 总高度
@property (nonatomic, assign) CGFloat height;


@end



/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface LTTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end