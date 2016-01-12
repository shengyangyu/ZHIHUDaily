//
//  YSYMainVC.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/9.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSYMainVC.h"

@interface YSYMainVC ()

@end

@implementation YSYMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 100, 100)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}
- (void)jump:(UIButton *)sender {
    YSYMainVC *main = [[YSYMainVC alloc] init];
    [self.navigationController pushViewController:main animated:YES];
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
