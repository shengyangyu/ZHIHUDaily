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

#define NAVBAR_CHANGE_POINT 50
static float kHeaderHeight = 36.0f;

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
@property (nonatomic, copy) NSString *mDate;

@end

@implementation YSYMainVC

- (instancetype)init {
    self = [super init];
    _mTypeTable = [YSYTableView new];
    _mTypeTable.delegate = self;
    _mTypeTable.dataSource = self;
    _mLayouts = [NSMutableArray new];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [self requestForIndex:-1];
}

#pragma mark - Hidden
- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (void)setUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 列表
    [self.mTypeTable setFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    [self.view addSubview:self.mTypeTable];
    // 给一个标识符，告诉tableView要创建哪个类
    [self.mTypeTable registerClass:[ThemeListCell class] forCellReuseIdentifier:NSStringFromClass([ThemeListCell class])];
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
    // 透明
    [self.view addSubview:self.naviView];
}

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
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // reload
                    [self.mTypeTable reloadData];
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

#pragma mark -UITableView Delegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, kHeaderHeight)];
    vv.backgroundColor = [UIColor redColor];
    return vv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return kHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ((ThemeListLayout *)_mLayouts[indexPath.section][indexPath.row]).height;
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThemeStories *tData = ((ThemeListLayout *)_mLayouts[indexPath.row][indexPath.row]).stories;
    DetailViewModel *tModel = [[DetailViewModel alloc] init];
    tModel.mModelID = tData.mID;
    YSYThemeDetailVC *detail = [[YSYThemeDetailVC alloc] initWithModel:tModel];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.mTypeTable) {
        UIColor * color = [UIColor ysy_convertHexToRGB:@"00AFF5"];
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 0) {
            CGFloat alpha = MIN(1, offsetY / _mNaviHeight);
            [self.naviView setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        } else {
            [self.naviView setBackgroundColor:[color colorWithAlphaComponent:0]];
        }
    }
}

#pragma mark - setter getter
- (YSYNavigationView *)naviView {
    if (!_mNaviView) {
        _mNaviHeight = (kHeaderHeight+[self statusBarHeight]);
        _mNaviView = [[YSYNavigationView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, _mNaviHeight)];
        _mNaviView.backgroundColor = [[UIColor ysy_convertHexToRGB:@"00AFF5"] colorWithAlphaComponent:0];
    }
    return _mNaviView;
}

- (CGFloat)statusBarHeight {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    return statusBarFrame.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
