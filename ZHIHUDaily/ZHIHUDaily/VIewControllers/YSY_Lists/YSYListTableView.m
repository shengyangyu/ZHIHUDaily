//
//  YSYListTableView.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/15.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSYListTableView.h"
#import "UIView+YSYCategory.h"
#import "NSString+YSYCategory.h"
#import "ThemeListCell.h"

@interface YSYListTableView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *datas;
    NSMutableArray *needLoads;
    BOOL scrollToToping;
}

@end

@implementation YSYListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withArray:(NSArray *)tArrays {
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
        datas = [[NSMutableArray alloc] initWithArray:tArrays];
        needLoads = [[NSMutableArray alloc] init];
        [self loadData];
    }
    return self;
}

#pragma mark -读取 数据
- (void)loadData {
    
    for (ThemeStories *tData in datas) {
        // cell文字最大宽度
        CGFloat mwidth = (__MainScreen_Width-__View_Scale(15.0*2));
        // 如果有图片 图片放右边
        if (tData.images && [tData.images count] > 0) {
            mwidth -= __View_Scale(75.0+15.0);
        }
        // 计算文字size
        CGSize msize = [tData.title sizeWithConstrainedToWidth:mwidth fromFont:[UIFont systemFontOfSize:__View_Scale(18.0)] lineSpace:__View_Scale(4.0)];
        // 文字高度 加一点点
        NSInteger msizeHeight = (msize.height+.5);
        // 赋值 文字frame
        tData.tFrame = [NSValue valueWithCGRect:CGRectMake(__View_Scale(15.0), __View_Scale(15.0), mwidth, msizeHeight)];
        // 考虑有图片时 cell的高度最少为图片的高度
        if (tData.images && [tData.images count] > 0) {
            msizeHeight = msizeHeight>__View_Scale(60.0)?msizeHeight:__View_Scale(60.0);
        }
        // 加上 上下留白
        msizeHeight += __View_Scale(15.0*2);
        // 赋值 cell frame
        tData.cFrame = [NSValue valueWithCGRect:CGRectMake(0, 0, __MainScreen_Width, msizeHeight)];
    }
    // 出现列表
    [self reloadData];
}


#pragma mark -UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThemeStories *tData = datas[indexPath.row];
    float height = [tData.cFrame CGRectValue].size.height;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return datas.count;
}

- (NSInteger)numberOfSections {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeListCell"];
    if (cell==nil) {
        cell = [[ThemeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ThemeListCell"];
    }
    [self drawCell:cell withIndexPath:indexPath];
    return cell;
}

- (void)drawCell:(ThemeListCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    
    [cell clearCell];
    cell.mData = [datas objectAtIndex:indexPath.row];
    if (needLoads.count > 0 &&
        [needLoads indexOfObject:indexPath] == NSNotFound) {
        [cell clearCell];
        return;
    }
    if (scrollToToping) {
        return;
    }
    [cell drawCell];
}

#pragma mark －加载优化
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [needLoads removeAllObjects];
}

/**按需加载
 如果目标行与当前行相差超过指定行数，只在目标滚动范围的前后指定3行加载
 */
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    NSIndexPath *ip = [self indexPathForRowAtPoint:CGPointMake(0, targetContentOffset->y)];
    NSIndexPath *cip = [[self indexPathsForVisibleRows] firstObject];
    NSInteger skipCount = 8;
    if (labs(cip.row-ip.row)>skipCount) {
        NSArray *temp = [self indexPathsForRowsInRect:CGRectMake(0, targetContentOffset->y, self.width, self.height)];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:temp];
        if (velocity.y<0) {
            NSIndexPath *indexPath = [temp lastObject];
            if (indexPath.row+3<datas.count) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+3 inSection:0]];
            }
        } else {
            NSIndexPath *indexPath = [temp firstObject];
            if (indexPath.row>3) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-3 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0]];
            }
        }
        [needLoads addObjectsFromArray:arr];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    scrollToToping = YES;
    return YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    scrollToToping = NO;
    [self loadContent];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    scrollToToping = NO;
    [self loadContent];
}
- (void)loadContent {
    if (scrollToToping) {
        return;
    }
    if (self.indexPathsForVisibleRows.count<=0) {
        return;
    }
    if (self.visibleCells&&self.visibleCells.count>0) {
        for (id temp in [self.visibleCells copy]) {
            ThemeListCell *cell = (ThemeListCell *)temp;
            [cell drawCell];
        }
    }
}
// 用户触摸时第一时间加载内容
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (!scrollToToping) {
        [needLoads removeAllObjects];
        [self loadContent];
    }
    return [super hitTest:point withEvent:event];
}

@end
