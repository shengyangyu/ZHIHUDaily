//
//  UIScrollView+YSYCategory.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/18.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "UIScrollView+YSYCategory.h"
#import <objc/runtime.h>
#import "YSYRefreshFoot.h"


@implementation UIView (YSYCategory)

- (CGFloat)ysy_x{
    return self.frame.origin.x;
}

- (CGFloat)ysy_y{
    return self.frame.origin.y;
}

- (CGFloat)ysy_width{
    return self.frame.size.width;
}

- (CGFloat)ysy_height{
    return self.frame.size.height;
}

- (void)setYsy_x:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setYsy_y:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setYsy_width:(CGFloat)w{
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}

- (void)setYsy_height:(CGFloat)h{
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}

- (void)setYsy_origin:(CGPoint)mj_origin
{
    CGRect frame = self.frame;
    frame.origin = mj_origin;
    self.frame = frame;
}

- (CGPoint)ysy_origin
{
    return self.frame.origin;
}

- (void)setYsy_size:(CGSize)mj_size
{
    CGRect frame = self.frame;
    frame.size = mj_size;
    self.frame = frame;
}

- (CGSize)ysy_size
{
    return self.frame.size;
}


@end

@implementation UIScrollView (YSYCategory)
/**
 刷新控件的原理是将scrollerView 拖动到一定程度，回调至view开始刷新，控制显示刷新控件的变量就是contentInset
 contentInset 默认是是zero 可以理解为是整个scrollView最外围的一层可控的变化区间
 */
- (void)setYsy_insetTop:(CGFloat)ysy_insetTop {
    UIEdgeInsets inset = self.contentInset;
    inset.top = ysy_insetTop;
    self.contentInset = inset;
}

- (CGFloat)ysy_insetTop {
    return self.contentInset.top;
}

- (void)setYsy_insetBottom:(CGFloat)ysy_insetBottom {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = ysy_insetBottom;
    self.contentInset = inset;
}

- (CGFloat)ysy_insetBottom {
    return self.contentInset.bottom;
}

- (void)setYsy_insetLeft:(CGFloat)ysy_insetLeft {
    UIEdgeInsets inset = self.contentInset;
    inset.left = ysy_insetLeft;
    self.contentInset = inset;
}

- (CGFloat)ysy_insetLeft {
    return self.contentInset.left;
}

- (void)setYsy_insetRight:(CGFloat)ysy_insetRight {
    UIEdgeInsets inset = self.contentInset;
    inset.right = ysy_insetRight;
    self.contentInset = inset;
}

- (CGFloat)ysy_insetRight {
    return self.contentInset.right;
}

/**
 offset 是scrollView的滑动量
 */
- (void)setYsy_offsetX:(CGFloat)ysy_offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = ysy_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)ysy_offsetX {
    return self.contentOffset.x;
}

- (void)setYsy_offsetY:(CGFloat)ysy_offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = ysy_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)ysy_offsetY {
    return self.contentOffset.y;
}

/**
 content 是scrollView的真实区域 只有比frame大时 才可能会滑动
 */
- (void)setYsy_contentWidth:(CGFloat)ysy_contentWidth {
    CGSize size = self.contentSize;
    size.width = ysy_contentWidth;
    self.contentSize = size;
}

- (CGFloat)ysy_contentWidth {
    return self.contentSize.width;
}

- (void)setYsy_contentHeight:(CGFloat)ysy_contentHeight {
    CGSize size = self.contentSize;
    size.height = ysy_contentHeight;
    self.contentSize = size;
}

- (CGFloat)ysy_contentHeight {
    return self.contentSize.height;
}
@end

/**
 添加替换对象、类方法的 黑魔法
 */
@implementation NSObject (YSYRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

@implementation UIScrollView (YSYRefresh)

#pragma mark - foot
static const char YSYRefreshFootKey = '\0';
- (void)setYsy_foot:(YSYRefreshFoot *)ysy_foot {
    if (ysy_foot != self.ysy_foot) {
        // 删除旧的
        [self.ysy_foot removeFromSuperview];
        [self addSubview:ysy_foot];
    }
    // 添加新的
    // 支持KVO
    [self willChangeValueForKey:@"ysy_foot"];
    // 既然为OBJC_ASSOCIATION_ASSIGN 为何声明的时候是strong
    objc_setAssociatedObject(self, &YSYRefreshFootKey, ysy_foot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"ysy_foot"];
}

- (YSYRefreshFoot *)ysy_foot {
    return objc_getAssociatedObject(self, &YSYRefreshFootKey);
}

static const char YSYRefreshReloadBlockKey = '\0';
- (void)setYsy_reloadBlock:(void (^)(NSInteger))ysy_reloadBlock {
    // 支持KVO
    [self willChangeValueForKey:@"ysy_reloadBlock"];
    objc_setAssociatedObject(self, &YSYRefreshReloadBlockKey, ysy_reloadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"ysy_reloadBlock"];
}

- (void (^)(NSInteger))ysy_reloadBlock {
    return objc_getAssociatedObject(self, &YSYRefreshReloadBlockKey);
}

- (NSInteger)ysy_totalCount {
    NSInteger total = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *table = (UITableView *)self;
        for (NSInteger i = 0; i < table.numberOfSections; i++) {
            total += [table numberOfRowsInSection:i];
        }
    }
    else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collect = (UICollectionView *)self;
        for (NSInteger i = 0; i < collect.numberOfSections; i++) {
            total += [collect numberOfItemsInSection:i];
        }
    }
    return total;
}

- (void)callReloadBlock {
    if (self.ysy_reloadBlock) {
        self.ysy_reloadBlock(self.ysy_totalCount);
    }
}

@end

@implementation UITableView (YSYRefresh)

+ (void)load {
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(ysy_reloadData)];
}

- (void)ysy_reloadData {
    [self ysy_reloadData];
    [self callReloadBlock];
}

@end

@implementation UICollectionView (YSYRefresh)

+ (void)load {
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(ysy_reloadData)];
}

- (void)ysy_reloadData {
    // 调用自己一次 实际上是需要进行方法替换 不会引起递归
    [self ysy_reloadData];
    // 之后执行回调
    [self callReloadBlock];
}
@end


