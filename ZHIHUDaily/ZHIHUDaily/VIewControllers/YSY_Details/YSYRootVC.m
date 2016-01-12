//
//  YSYRootVC.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/9.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSYRootVC.h"
#import "YSYLeftVC.h"
#import "YSYMainVC.h"

@interface YSYRootVC ()

@end

@implementation YSYRootVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //******MMDrawerController*****//
    YSYLeftVC *left = [[YSYLeftVC alloc] init];
    YSYMainVC *main = [[YSYMainVC alloc] init];
    self.mRoot = [[UINavigationController alloc] initWithRootViewController:main];
    self.centerViewController = self.mRoot;
    self.leftDrawerViewController = left;
    [self setMaximumLeftDrawerWidth:__LeftScreen_Width];
    [self setShowsShadow:NO];
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
        if(block){
            block(drawerController, drawerSide, percentVisible);
        }
    }];
}

#pragma mark －状态栏颜色 白色
//- (UIViewController*)childViewControllerForStatusBarStyle {
//    return self.leftDrawerViewController;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
