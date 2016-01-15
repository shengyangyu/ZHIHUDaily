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

@end

@implementation YSYMainVC

#pragma mark - life cycle
#pragma mark -hide navi
- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (instancetype)init {
    self = [super init];
    _mLayouts = [NSMutableArray new];
    _mDates = [NSMutableArray new];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [self requestForIndex:-1];
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
            [strongSelf requestForIndex:(1)];
        });
    };
    // 顶部循环滚动
    [self.view addSubview:self.mTopHead];
    // 透明
    [self.view addSubview:self.naviView];
}

#pragma mark - request data
- (NSURLSessionDataTask *)requestForIndex:(u_int64_t)index {
    // 刷新首页
    if (index == -1) {
        return [ThemeMainModel themesLateWithBlock:^(ThemeMainModel *themes, NSError *error) {
            // 数据为空或失败
            if (!themes || error) {
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
                    [_mDates addObject:themes.c_date];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // reload
                    [self.mTypeTable reloadData];
                    // 顶部
                    if (themes.top_stories.count) {
                        self.mTopHead.dataArrays = [NSArray arrayWithArray:themes.top_stories];
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
                    [_mDates addObject:themes.c_date];
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
    [header setDataModel];
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    if (section == 0) {
        self.mNaviView.backgroundView.ysy_height = _mNaviHeight;
        self.mNaviView.title.hidden = NO;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    if (section == 0) {
        self.mNaviView.backgroundView.ysy_height = (_mNaviHeight-kMainHeaderHeight);
        self.mNaviView.title.hidden = YES;
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
    
    ThemeStories *tData = ((ThemeListLayout *)_mLayouts[indexPath.row][indexPath.row]).stories;
    DetailViewModel *tModel = [[DetailViewModel alloc] init];
    tModel.mModelID = tData.mID;
    YSYThemeDetailVC *detail = [[YSYThemeDetailVC alloc] initWithModel:tModel];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.mTypeTable) {
        UIColor * color = [UIColor ysy_convertHexToRGB:@"00AFF5"];
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 0) {
            CGFloat alpha = MIN(1, offsetY / _mNaviHeight);
            [self.naviView.backgroundView setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        } else {
            [self.naviView.backgroundView setBackgroundColor:[color colorWithAlphaComponent:0]];
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
        CGFloat tHeight = (kRollHeadViewHeight-kMaxRollHeight/2);
        UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, tHeight)];
        vv.backgroundColor = [UIColor redColor];
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
        _mTopHead = [[YSYAutoRollHeadView alloc] initWithFrame:CGRectMake(0, -kMaxRollHeight/2, __MainScreen_Width, kRollHeadViewHeight) observeView:self.mTypeTable];
    }
    return _mTopHead;
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
