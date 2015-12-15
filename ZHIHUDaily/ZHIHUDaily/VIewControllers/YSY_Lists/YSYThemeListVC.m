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

@interface YSYThemeListVC ()<UITableViewDelegate, UITableViewDataSource>

// table
@property (nonatomic, strong) YSYTableView *mTypeTable;
@property (nonatomic, strong) ThemeLists *mThemes;

@end

@implementation YSYThemeListVC

- (instancetype)init {
    self = [super init];
    _mTypeTable = [YSYTableView new];
    _mTypeTable.delegate = self;
    _mTypeTable.dataSource = self;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [ThemeLists themesListsID:11 withBlock:^(ThemeLists *themes, NSError *error) {
        // 成功
        if (!error) {
            _mThemes = themes;
            self.title = _mThemes.name;
            [_mTypeTable reloadData];
        }
    }];
}

- (void)setUI {
    _mTypeTable.rowHeight = __View_Scale(92.0);
    [self.view addSubview:_mTypeTable];
    [_mTypeTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark -UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _mThemes.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = @"ThemeListCell";
    ThemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ThemeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setCellModel:_mThemes.stories[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
