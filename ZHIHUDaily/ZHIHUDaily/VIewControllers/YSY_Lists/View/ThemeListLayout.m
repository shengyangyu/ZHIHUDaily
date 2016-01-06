//
//  ThemeListLayout.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/4.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "ThemeListLayout.h"

@implementation ThemeListLayout

- (instancetype)initWithStories:(ThemeStories *)stories {
    if (!stories || !stories.title) return nil;
    self = [super init];
    _stories = stories;
    [self layout];
    return self;
}

- (void)layout {
    [self _layout];
}
    
- (void)_layout {
    // 文本排版，计算布局
    [self _layoutTitle];
}

- (void)_layoutTitle {
    
    _cellType = ThemeListCellTypeNormal;
    _marginTop = TLCellVerticalMargin;
    _titleHeight = 0;
    _titleTextLayout = nil;
    _marginBottom = TLCellVerticalMargin;
    
    NSMutableAttributedString *text = [self _textWithStories:_stories fontSize:TLCellFontSize textColor:UIColorHex(333333)];
    if (text.length == 0) return;
    
    if (_stories.images && _stories.images.count != 0) {
        _cellType = ThemeListCellTypeImage;
        //_picSize = CGSizeZero;
        _picSize = CGSizeMake(TLCellImageWidth, TLCellImageHeight);
    }
    
    LTTextLinePositionModifier *modifier = [LTTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:TLCellFontSize];
    modifier.paddingTop = TLCellTextPadding;
    modifier.paddingBottom = TLCellTextPadding;
    
    YYTextContainer *container = [YYTextContainer new];
    if (_cellType == ThemeListCellTypeImage) {
        container.size = CGSizeMake(TLCellWidth-TLCellImageOffset-TLCellImageWidth, HUGE);
    }
    else {
        container.size = CGSizeMake(TLCellWidth, HUGE);
    }
    container.linePositionModifier = modifier;
    
    _titleTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_titleTextLayout) return;
    
    _titleHeight = [modifier heightForLineCount:_titleTextLayout.rowCount];
    
    // 计算高度
    _height = 0;
    _height += _marginTop;
    if (_cellType == ThemeListCellTypeImage &&
        _titleHeight < TLCellImageHeight) {
        _height += TLCellImageHeight;
    }
    else {
        _height += _titleHeight;
    }
    _height += _marginBottom;
}

- (NSMutableAttributedString *)_textWithStories:(ThemeStories *)stories fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    
    if (!stories) return nil;
    NSMutableString *string = stories.title.mutableCopy;
    if (string.length == 0) return nil;
    // 字体
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = UIColorHex(bfdffe);
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = font;
    text.yy_color = textColor;
    
    return text;
}

@end




/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，
 但是在 PingFang SC 中，ascent + descent > font size。
 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性。
 间距仍然用字体默认
 */
@implementation LTTextLinePositionModifier

- (instancetype)init {
    self = [super init];
    
    if (kiOS9Later) {
        _lineHeightMultiple = 1.34;   // for PingFang SC
    } else {
        _lineHeightMultiple = 1.3125; // for Heiti SC
    }
    
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    //CGFloat ascent = _font.ascender;
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    LTTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    //    CGFloat ascent = _font.ascender;
    //    CGFloat descent = -_font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}

@end
