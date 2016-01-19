//
//  ThemeListCell.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/14.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "ThemeListCell.h"


@interface ThemeListCell ()

@property (nonatomic, strong) UIView *mLine;

@end

@implementation ThemeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _storiesView = [TLStoriesView new];
    _storiesView.cell = self;
    [self.contentView addSubview:_storiesView];
    return self;
}

- (void)prepareForReuse {
    // ignore
}

- (void)setLayout:(ThemeListLayout *)layout {
    self.ysy_height = layout.height;
    self.contentView.ysy_height = layout.height;
    _storiesView.layout = layout;
}

@end



@implementation TLStoriesView

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = __MainScreen_Width;
        frame.size.height = 1;
    }
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    self.exclusiveTouch = YES;
//    @weakify(self);
    _contentView = [UIView new];
    _contentView.ysy_width = __MainScreen_Width;
    _contentView.ysy_height = 1;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    // 线
    _bottomLine = [CALayer layer];
    _bottomLine.ysy_size = CGSizeMake(TLCellWidth, CGFloatFromPixel(1));
    _bottomLine.ysy_left = TLCellHorizontalMargin;
    _bottomLine.ysy_bottom = self.ysy_height;
    _bottomLine.backgroundColor = UIColorHex(E8E8E8).CGColor;
    [self.layer addSublayer:_bottomLine];
    // 图片
    _imageView = [YSYControl new];
    _imageView.ysy_size = CGSizeMake(TLCellImageWidth, TLCellImageHeight);
    _imageView.hidden = YES;
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = UIColorHex(f0f0f0);
    _imageView.exclusiveTouch = YES;
    _imageView.touchBlock = ^(YSYControl *view, YSYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        //if (![weak_self.cell.delegate respondsToSelector:@selector(cell:didClickImageAtIndex:)]) return;
        if (state == YSYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:view];
            if (CGRectContainsPoint(view.bounds, p)) {
                //[weak_self.cell.delegate cell:weak_self.cell didClickImageAtIndex:i];
            }
        }
    };
    [_contentView addSubview:_imageView];
    // 标题
    _textLabel = [YYLabel new];
    _textLabel.ysy_left = TLCellHorizontalMargin;
    if (_layout.cellType == ThemeListCellTypeImage) {
        _textLabel.ysy_width = (TLCellWidth-TLCellImageOffset-TLCellImageWidth);
    }
    else {
        _textLabel.ysy_width = TLCellWidth;
    }
    _textLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _textLabel.displaysAsynchronously = YES;
    _textLabel.ignoreCommonProperties = YES;
    _textLabel.fadeOnAsynchronouslyDisplay = NO;
    _textLabel.fadeOnHighlight = NO;
    _textLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
//            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
//        }
    };
    [_contentView addSubview:_textLabel];
    
    return self;
}


- (void)setLayout:(ThemeListLayout *)layout {
    _layout = layout;
    
    self.ysy_height = layout.height;
    _contentView.ysy_top = layout.marginTop;
    _contentView.ysy_height = layout.height - layout.marginTop - layout.marginBottom;
    
    _bottomLine.ysy_bottom = self.ysy_height;
    
    CGFloat top = 0;
    _textLabel.ysy_top = top;
    _textLabel.ysy_height = layout.titleHeight;
    _textLabel.textLayout = layout.titleTextLayout;
    top += layout.titleHeight;
    
    if (_layout.cellType == ThemeListCellTypeImage) {
        _textLabel.ysy_width = (TLCellWidth-TLCellImageOffset-TLCellImageWidth);
        [self _setImageViewWithTop:0];
    }
    else {
        _textLabel.ysy_width = TLCellWidth;
        _imageView.hidden = YES;
    }
}

- (void)_setImageViewWithTop:(CGFloat)imageTop {
    NSArray *pics = _layout.stories.images;
    NSInteger picsCount = (NSInteger)pics.count;
    
    if (0 >= picsCount) {
        [_imageView.layer yy_cancelCurrentImageRequest];
        _imageView.hidden = YES;
    } else {
        CGPoint origin = {0};
        origin.x = __MainScreen_Width-_layout.picSize.width-TLCellHorizontalMargin;//_textLabel.ysy_right;
        origin.y = imageTop;
        _imageView.ysy_frame = (CGRect){.origin = origin, .size = _layout.picSize};
        _imageView.hidden = NO;
        [_imageView.layer removeAnimationForKey:@"contents"];
        @weakify(self);
        NSURL *tImageURL = [NSURL URLWithString:_layout.stories.images[0]];
        [_imageView.layer yy_setImageWithURL:tImageURL placeholder:nil options:YYWebImageOptionAvoidSetImage completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            @strongify(self);
            if (!self.imageView) {
                return ;
            }
            if (image && stage == YYWebImageStageFinished) {
                int width = image.size.width;
                int height = image.size.height;
                CGFloat scale = (height / width) / (self.imageView.ysy_height / self.imageView.ysy_width);
                if (scale < 0.99 || isnan(scale)) {
                    // 宽图把左右两边裁掉
                    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
                    self.imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                } else {
                    // 高图只保留顶部
                    self.imageView.contentMode = UIViewContentModeScaleToFill;
                    self.imageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
                }
                self.imageView.image = image;
                if (from != YYWebImageFromMemoryCacheFast) {
                    CATransition *transition = [CATransition animation];
                    transition.duration = 0.15;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                    transition.type = kCATransitionFade;
                    [self.imageView.layer addAnimation:transition forKey:@"contents"];
                }
            }
        }];
    }
}
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint p = [touch locationInView:_retweetBackgroundView];
    BOOL insideRetweet = CGRectContainsPoint(_retweetBackgroundView.bounds, p);
    
    if (!_retweetBackgroundView.hidden && insideRetweet) {
        [(_retweetBackgroundView) performSelector:@selector(setBackgroundColor:) withObject:kWBCellHighlightColor afterDelay:0.15];
        _touchRetweetView = YES;
    } else {
        [(_contentView) performSelector:@selector(setBackgroundColor:) withObject:kWBCellHighlightColor afterDelay:0.15];
        _touchRetweetView = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
    if (_touchRetweetView) {
        if ([_cell.delegate respondsToSelector:@selector(cellDidClickRetweet:)]) {
            [_cell.delegate cellDidClickRetweet:_cell];
        }
    } else {
        if ([_cell.delegate respondsToSelector:@selector(cellDidClick:)]) {
            [_cell.delegate cellDidClick:_cell];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesRestoreBackgroundColor];
}

- (void)touchesRestoreBackgroundColor {
    [NSObject cancelPreviousPerformRequestsWithTarget:_retweetBackgroundView selector:@selector(setBackgroundColor:) object:kWBCellHighlightColor];
    [NSObject cancelPreviousPerformRequestsWithTarget:_contentView selector:@selector(setBackgroundColor:) object:kWBCellHighlightColor];
    
    _contentView.backgroundColor = [UIColor whiteColor];
    _retweetBackgroundView.backgroundColor = kWBCellInnerViewColor;
}
*/
           
@end
