//
//  YSYAutoRollHeadView.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 16/1/15.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "YSYAutoRollHeadView.h"
#import "ThemeMainModel.h"

const CGFloat kMaxRollHeight = 90.0f;
const CGFloat kRollHeadViewHeight = 260.0f;

@interface YSYAutoRollHeadView ()
// 初始化高度
@property (nonatomic, assign) CGFloat mOriginHeight;
// 初始化宽度
@property (nonatomic, assign) CGFloat mOriginWidth;

@end

@implementation YSYAutoRollHeadView

- (instancetype)initWithFrame:(CGRect)frame
                  observeView:(UIScrollView *)oView {
    
    self = [super initWithFrame:frame];
    if (self) {
        _mOriginHeight = frame.size.height;
        _mOriginWidth = frame.size.width;
        [self addSubview:self.mImageView];
        _mObserveView = oView;
        [_mObserveView addObserver:self
                forKeyPath:@"contentOffset"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
    }
    return self;
}

- (UIImageView *)mImageView {
    if (!_mImageView) {
        _mImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        //_mImageView.backgroundColor = [UIColor clearColor];
    }
    return _mImageView;
}

- (void)setDataArrays:(NSArray *)dataArrays {
    if (_dataArrays != dataArrays) {
        _dataArrays = dataArrays;
        [self setMModel:_dataArrays[0]];
    }
}

- (void)setMModel:(ThemeMainStories *)mModel {
    
    self.mImageView.hidden = NO;
    [self.mImageView.layer removeAnimationForKey:@"contents"];
    @weakify(self);
    [self.mImageView.layer yy_setImageWithURL:[NSURL URLWithString:mModel.image] placeholder:nil options:YYWebImageOptionAvoidSetImage completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        @strongify(self);
        if (!self.mImageView) {
            return ;
        }
        if (image && stage == YYWebImageStageFinished) {
            // 宽图把左右两边裁掉
            self.mImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.mImageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
            self.mImageView.image = image;
            if (from != YYWebImageFromMemoryCacheFast) {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.15;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                transition.type = kCATransitionFade;
                [self.mImageView.layer addAnimation:transition forKey:@"contents"];
            }
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context{
    UIScrollView *scrollView = object;
    CGFloat offSetY = scrollView.contentOffset.y;
    //NSLog(@"%@",@(offSetY));
    // 渐变过程
    if (offSetY <= 0 && offSetY >= -kMaxRollHeight) {
        NSLog(@"渐变过程:%@,%@,%@",@(offSetY),@(self.frame.origin.y),@((-kMaxRollHeight-[UIDevice statusBarHeight]-offSetY)*0.5));
        self.frame = CGRectMake(0, (-kMaxRollHeight-[UIDevice statusBarHeight]-offSetY)*0.5, self.mOriginWidth, self.mOriginHeight-offSetY*0.5);
    }
    // 最大限度
    else if(offSetY < -kMaxRollHeight){
        self.mObserveView.contentOffset = CGPointMake(0, -kMaxRollHeight*0.5);
    }
    // 往上滚动
    else if(offSetY <= self.mOriginHeight) {
        self.ysy_top = -kMaxRollHeight*0.5-offSetY;
    }
}

- (void)dealloc {
    [self.mObserveView removeObserver:self
                           forKeyPath:@"contentOffset"];
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

@end
