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
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "YSYRefreshFoot.h"

@interface YSYThemeListVC ()<UITableViewDelegate, UITableViewDataSource>
// table
@property (nonatomic, strong) YSYTableView *mTypeTable;
@property (nonatomic, strong) ThemeLists *mThemes;
@property (nonatomic, strong) NSMutableArray *mThemesArray;

@end

@implementation YSYThemeListVC

- (instancetype)init {
    self = [super init];
    _mTypeTable = [YSYTableView new];
    _mTypeTable.delegate = self;
    _mTypeTable.dataSource = self;
    _mThemesArray = [NSMutableArray new];
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
    NSIndexPath *topRow = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.mTypeTable scrollToRowAtIndexPath:topRow
                           atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)setMType:(u_int64_t)mType {
    _mType = mType;
    [self requestForIndex:-1];
}

- (NSURLSessionDataTask *)requestForIndex:(u_int64_t)index {
    
    return [ThemeLists themesListsID:self.mType withIndex:index withBlock:^(ThemeLists *themes, NSError *error) {
        // 成功
        if (!error) {
            // 获取最新数据时 清除旧的
            if (index == -1) {
                self.mThemes = nil;
                self.mThemes = themes;
                [self.mThemesArray removeAllObjects];
                // 添加数据
                [self.mThemesArray addObjectsFromArray:themes.stories];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.title = _mThemes.name;
                    // 给一个标识符，告诉tableView要创建哪个类
                    [self.mTypeTable registerClass:[ThemeListCell class] forCellReuseIdentifier:NSStringFromClass([ThemeListCell class])];
                    [self.mTypeTable reloadData];
                    // 完成任务
                });
            }
            else {
                // 原来数据数量
                NSUInteger mCount = self.mThemesArray.count;
                // 添加数据
                [self.mThemesArray addObjectsFromArray:themes.stories];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableArray *indexs = [NSMutableArray new];
                    for (NSInteger i = mCount; i < self.mThemesArray.count; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        [indexs addObject:indexPath];
                    }
                    [self.mTypeTable insertRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationNone];
                    // 完成任务
                });
            }
        }
        else {
            // 完成任务
        }
    }];
}

- (void)setUI {
    
    [self.mTypeTable setFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
    [self.view addSubview:self.mTypeTable];
    // 加载更多
    self.mTypeTable.ysy_foot = [YSYRefreshFoot footWithBlock:^{
        ThemeStories *mData = [self.mThemesArray lastObject];
        [self requestForIndex:(mData?mData.mID:-1)];
    }];
}

#pragma mark -UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([ThemeListCell class]) cacheByIndexPath:indexPath configuration:^(id cell) {
        
        ThemeListCell *tcell = (ThemeListCell*)cell;
        tcell.mData = self.mThemesArray[indexPath.row];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mThemesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ThemeListCell class])];
    
    cell.mData = self.mThemesArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
