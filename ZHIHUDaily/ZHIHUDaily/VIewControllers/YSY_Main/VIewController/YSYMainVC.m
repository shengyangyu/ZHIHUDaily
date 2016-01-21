//
//  YSYMainVC.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/9.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSYMainVC.h"
#import "ThemeListCell.h"
#import "YSYTableView.h"
#import "YSYRefreshFooter.h"
#import "YSYThemeDetailVC.h"
#import "ThemeMainModel.h"
#import "YSYNavigationView.h"
#import "YSYSectionHeadView.h"
#import "YSYAutoRollHeadView.h"
#import "YSYRefreshHeader.h"

#define NAVBAR_CHANGE_POINT 50

@interface YSYMainVC ()<UITableViewDelegate, UITableViewDataSource>
{
    YSYRefreshFooter *mFoot;
}
// navi
@property (nonatomic, strong) YSYNavigationView *mNaviView;
@property (nonatomic, assign) CGFloat mNaviHeight;
// table
@property (nonatomic, strong) YSYTableView *mTypeTable;
@property (nonatomic, strong) ThemeMainModel *mThemes;
@property (nonatomic, strong) NSMutableArray *mLayouts;
@property (nonatomic, strong) NSMutableArray *mDates;
@property (nonatomic, copy) NSString *mDate;
// top head
@property (nonatomic, strong) YSYAutoRollHeadView *mTopHead;
// 默认状态栏高度
@property (nonatomic, assign) CGFloat mStatusHeight;

@property (nonatomic, strong) YSYRefreshHeader *mShowHead;
@end

@implementation YSYMainVC

#pragma mark - life cycle
#pragma mark -hide navi
- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (instancetype)init {
    self = [super init];
    _mStatusHeight = [UIDevice statusBarHeight];
    _mLayouts = [NSMutableArray new];
    _mDates = [NSMutableArray new];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [self requestForIndex:-1 completion:nil];
}

- (void)setUI {
    // nav 高度
    _mNaviHeight = (kMainHeaderHeight+[UIDevice statusBarHeight]);
    // 列表
    [self.view addSubview:self.mTypeTable];
    // 给一个标识符，告诉tableView要创建哪个类
    [self.mTypeTable registerClass:[ThemeListCell class] forCellReuseIdentifier:NSStringFromClass([ThemeListCell class])];
    [self.mTypeTable registerClass:[YSYSectionHeadView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([YSYSectionHeadView class])];
    // 加载更多
    mFoot = [[YSYRefreshFooter alloc] initFooterWithFrame:CGRectZero withSuper:self.mTypeTable];
    typeof(self) __weak weakSelf = self;
    mFoot.beginBlock = ^(){
        // 后台执行
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 请求
            typeof(weakSelf) __strong strongSelf = weakSelf;
            [strongSelf requestForIndex:(1) completion:nil];
        });
    };
    // 顶部循环滚动
    [self.view addSubview:self.mTopHead];
    // navi
    [self.view addSubview:self.naviView];
    // refresh head
    self.mShowHead = [[YSYRefreshHeader alloc] initWithSuperView:self.view withScrollView:self.mTypeTable];
    // __weak __typeof(self)weakSelf = self;
    self.mShowHead.startBlock = ^() {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf requestForIndex:-1 completion:^(BOOL finished) {
            if (finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf.mShowHead endRefresh];
                });
            }
        }];
    };
}

#pragma mark - request data
- (NSURLSessionDataTask *)requestForIndex:(u_int64_t)index completion:(void (^)(BOOL finished))completion{
    // 刷新首页
    if (index == -1) {
        return [ThemeMainModel themesLateWithBlock:^(ThemeMainModel *themes, NSError *error) {
            // 数据为空或失败
            if (!themes || error) {
                if (completion) {
                    completion(YES);
                }
                return ;
            }
            // 成功
            _mThemes = themes;
            [_mLayouts removeAllObjects];
            [_mDates removeAllObjects];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 添加数据
                NSMutableArray *tArray = [NSMutableArray new];
                for (ThemeStories *stories in themes.stories) {
                    ThemeListLayout *layout = [[ThemeListLayout alloc] initWithStories:stories];
                    [layout layout];
                    [tArray addObject:layout];
                }
                if (tArray.count != 0) {
                    [_mLayouts addObject:tArray];
                    [self.mDates addObject:themes.c_date];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // reload
                    [self.mTypeTable reloadData];
                    // 顶部
                    if (themes.top_stories.count) {
                        self.mTopHead.dataArrays = [NSArray arrayWithArray:themes.top_stories];
                    }
                    if (completion) {
                        completion(YES);
                    }
                });
            });
        }];
    }
    // 请求后续
    else {
        return [ThemeMainBeforeModel themesBeforeWithDate:_mThemes.c_date withBlock:^(ThemeMainBeforeModel *themes, NSError *error) {
            // 数据为空或失败
            if (!themes || error) {
                // 完成任务
                [mFoot endRefreshing];
                return ;
            }
            // 成功
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 添加数据
                NSMutableArray *tArray = [NSMutableArray new];
                _mThemes.c_date = themes.c_date;
                for (ThemeStories *stories in themes.stories) {
                    ThemeListLayout *layout = [[ThemeListLayout alloc] initWithStories:stories];
                    [layout layout];
                    [tArray addObject:layout];
                }
                if (tArray.count != 0) {
                    [_mLayouts addObject:tArray];
                    [self.mDates addObject:themes.c_date];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // add
                        [self.mTypeTable insertSections:[NSIndexSet indexSetWithIndex:(_mLayouts.count-1)] withRowAnimation:UITableViewRowAnimationNone];
                        // 完成任务
                        [mFoot endRefreshing];
                    });
                }
            });
        }];
    }
    return nil;
}

#pragma mark - UITableView Delegate
#pragma mark -head view
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return nil;
    }
    YSYSectionHeadView *header = (YSYSectionHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([YSYSectionHeadView class])];
    [header setDataModel:self.mDates[section]];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return kMainHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ((ThemeListLayout *)_mLayouts[indexPath.section][indexPath.row]).height;
}
/**
 将要显示
 */
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    if (section == 0) {
        self.mNaviView.mBackgroundView.ysy_height = _mNaviHeight;
        self.mNaviView.mTitle.hidden = NO;
    }
}
/**
 显示完成
 */
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    if (section == 0) {
        self.mNaviView.mBackgroundView.ysy_height = (_mNaviHeight-kMainHeaderHeight);
        self.mNaviView.mTitle.hidden = YES;
    }
}
#pragma mark -cell view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _mLayouts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ((NSArray *)_mLayouts[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ThemeListCell class])];
    
    return cell;
}
// 显示时 绑定数据
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThemeListCell *tCell = (ThemeListCell *)cell;
    [tCell setLayout:_mLayouts[indexPath.section][indexPath.row]];
}

#pragma mark -did select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThemeStories *tData = ((ThemeListLayout *)_mLayouts[indexPath.section][indexPath.row]).stories;
    DetailViewModel *tModel = [[DetailViewModel alloc] init];
    tModel.mModelID = tData.mID;
    YSYThemeDetailVC *detail = [[YSYThemeDetailVC alloc] initWithModel:tModel];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.mTypeTable) {
        UIColor * color = [UIColor ysy_convertHexToRGB:@"00AFF5"];
        CGFloat offsetY = scrollView.contentOffset.y+self.mStatusHeight;
        if (offsetY > 0) {
            CGFloat alpha = MIN(1, offsetY / _mNaviHeight);
            [self.naviView.mBackgroundView setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        } else {
            [self.naviView.mBackgroundView setBackgroundColor:[color colorWithAlphaComponent:0]];
            scrollView.contentOffset = CGPointMake(0, -self.mStatusHeight);
        }
    }
}

#pragma mark - setter getter

- (YSYTableView *)mTypeTable {
    if (!_mTypeTable) {
        _mTypeTable = [YSYTableView new];
        _mTypeTable.delegate = self;
        _mTypeTable.dataSource = self;
        [_mTypeTable setFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
        UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, kRollHeadHeight)];
        vv.backgroundColor = [UIColor whiteColor];
        _mTypeTable.backgroundColor = [UIColor whiteColor];
        _mTypeTable.tableHeaderView = vv;
    }
    return _mTypeTable;
}

- (YSYNavigationView *)naviView {
    if (!_mNaviView) {
        _mNaviView = [[YSYNavigationView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, _mNaviHeight)];
    }
    return _mNaviView;
}

- (YSYAutoRollHeadView *)mTopHead {
    if (!_mTopHead) {
        _mTopHead = [[YSYAutoRollHeadView alloc] initWithFrame:CGRectMake(0, -kMaxRollHeight*kRollScale, __MainScreen_Width, kRollHeadHeight+kMaxRollHeight*kRollScale+[UIDevice statusBarHeight]) observeView:self.mTypeTable];
    }
    return _mTopHead;
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
