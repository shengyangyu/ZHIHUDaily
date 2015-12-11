//
//  AppDelegate.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/8.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "AppDelegate.h"
#import "YSYRootVC.h"
#import "YSYLeftVC.h"
#import "YSYMainVC.h"

@interface AppDelegate ()

// 程序框架
@property (nonatomic, strong) YSYRootVC *drawerVC;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //******MMDrawerController*****//
    YSYLeftVC *left = [[YSYLeftVC alloc] init];
    YSYMainVC *main = [[YSYMainVC alloc] init];
    UINavigationController *nav_m = [[UINavigationController alloc] initWithRootViewController:main];
    [left setCenterVCs:nav_m];
    self.drawerVC = [[YSYRootVC alloc]
                     initWithCenterViewController:nav_m
                     leftDrawerViewController:left];
    [self.drawerVC setMaximumLeftDrawerWidth:__LeftScreen_Width];
    [self.drawerVC setShowsShadow:NO];
    [self.drawerVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerVC setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
        if(block){
            block(drawerController, drawerSide, percentVisible);
        }
    }];
    //******UINavigationBar*****//
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor convertHexToRGB:@"00AFF5"]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:21], NSFontAttributeName, nil]];
    //******window*****//
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //UIColor *tColor = [UIColor convertHexToRGB:@"112233"];
    //[self.window setTintColor:tColor];
    [self.window setRootViewController:self.drawerVC];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 监测网络状态
    [self connectStatus];
    // 显示
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark -监测网络状态
- (void)connectStatus {
    AFNetworkReachabilityManager *tmp = [AFNetworkReachabilityManager manager];
    [tmp setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"无网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"WiFi网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"无线网络");
                break;
            }
            default:
                break;
        }
    }];
    [tmp startMonitoring];
}

#pragma mark -禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -应用进入后台时间过长，重进支持进入原来界面
- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    
    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {

    NSString *mkey = [identifierComponents lastObject];
    if ([mkey isEqualToString:@""]) {
        
    }
    else if ([mkey isEqualToString:@""]) {
    
    }
    return nil;
}


@end
