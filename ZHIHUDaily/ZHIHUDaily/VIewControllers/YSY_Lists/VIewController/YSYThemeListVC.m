//
//  YSYThemeListVC.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/14.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSYThemeListVC.h"
#import "ThemeListCell.h"
#import "YSYTableView.h"
#import "YSYRefreshFooter.h"
#import "YSYThemeDetailVC.h"

@interface YSYThemeListVC ()<UITableViewDelegate, UITableViewDataSource>
{
    YSYRefreshFooter *mFoot;
}
// table
@property (nonatomic, strong) YSYTableView *mTypeTable;
@property (nonatomic, strong) ThemeLists *mThemes;
@property (nonatomic, strong) NSMutableArray *mLayouts;

@end

@implementation YSYThemeListVC

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
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // top
    /*
    NSIndexPath *topRow = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.mTypeTable scrollToRowAtIndexPath:topRow
                           atScrollPosition:UITableViewScrollPositionTop animated:NO];
     */
}


//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)setMType:(u_int64_t)mType {
    _mType = mType;
    [self requestForIndex:-1];
}

- (NSURLSessionDataTask *)requestForIndex:(u_int64_t)index {

    return [ThemeLists themesListsID:self.mType withIndex:index withBlock:^(ThemeLists *themes, NSError *error) {
        // 数据为空或失败
        if (!themes.stories ||
            themes.stories.count == 0 ||
            error) {
            // 完成任务
            [mFoot endRefreshing];
            return ;
        }
        // 成功
        // 获取最新数据时 清除旧的
        if (index == -1) {
            _mThemes = nil;
            _mThemes = themes;
            [_mLayouts removeAllObjects];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 添加数据
            NSUInteger mCount = _mLayouts.count;
            for (ThemeStories *stories in themes.stories) {
                ThemeListLayout *layout = [[ThemeListLayout alloc] initWithStories:stories];
                [layout layout];
                [_mLayouts addObject:layout];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // reload
                if (index == -1) {
                    self.title = _mThemes.name;
                    [self.mTypeTable reloadData];
                }
                // add
                else {
                    NSMutableArray *indexs = [NSMutableArray new];
                    for (NSInteger i = mCount; i < _mLayouts.count; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        [indexs addObject:indexPath];
                    }
                    [self.mTypeTable insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationNone];
                }
                // 完成任务
                [mFoot endRefreshing];
            });
        });
    }];
}

- (void)setUI {
    
    [self.mTypeTable setFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    [self.view addSubview:self.mTypeTable];
    // 给一个标识符，告诉tableView要创建哪个类
    [self.mTypeTable registerClass:[ThemeListCell class] forCellReuseIdentifier:NSStringFromClass([ThemeListCell class])];
    // 加载更多
    mFoot = [[YSYRefreshFooter alloc] initFooterWithFrame:CGRectZero withSuper:self.mTypeTable];
    //CGRectMake(0, 0, __MainScreen_Width, 44.0)
    //typeof(mFoot) __weak weakFoot = mFoot;
    typeof(self) __weak weakSelf = self;
    mFoot.beginBlock = ^(){
        // 后台执行
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 请求
            typeof(weakSelf) __strong strongSelf = weakSelf;
            ThemeStories *mData = ((ThemeListLayout *)[strongSelf.mLayouts lastObject]).stories;
            [strongSelf requestForIndex:(mData?mData.mID:-1)];
        });
    };
}

#pragma mark -UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ((ThemeListLayout *)_mLayouts[indexPath.row]).height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _mLayouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ThemeListCell class])];
    
    return cell;
}
// 显示时 绑定数据
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThemeListCell *tCell = (ThemeListCell *)cell;
    [tCell setLayout:_mLayouts[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThemeStories *tData = ((ThemeListLayout *)_mLayouts[indexPath.row]).stories;
    DetailViewModel *tModel = [[DetailViewModel alloc] init];
    tModel.mModelID = tData.mID;
    YSYThemeDetailVC *detail = [[YSYThemeDetailVC alloc] initWithModel:tModel];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
