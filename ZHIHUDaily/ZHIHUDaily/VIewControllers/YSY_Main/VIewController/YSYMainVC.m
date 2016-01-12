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

@interface YSYMainVC ()
// table
@property (nonatomic, strong) YSYTableView *mTypeTable;

@end

@implementation YSYMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
