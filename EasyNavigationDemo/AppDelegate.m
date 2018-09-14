//
//  AppDelegate.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/8/31.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>

#import "EasyNavigation.h"

#import "ViewController.h"
#import "SystemNavViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//storyboard 用navigationcontroller
//代码
//xib 适配
//不支持tableviewcontroller

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    EasyNavigationOptions *options = [EasyNavigationOptions shareInstance];
    options.titleColor = [UIColor whiteColor];
    options.buttonTitleFont = [UIFont systemFontOfSize:18];
    options.navBackgroundImage = [UIImage imageNamed:@"nav_background_image.png"];
    options.buttonTitleColor = [UIColor whiteColor];
    
    // 设置系统返回按钮为样式
//    options.btnTitleType = FBackBtnTitleType_System;

    
#if 1//这个1改成0将会从staryboard中启动
    
    UITabBarController *tabbar = [[UITabBarController alloc]init];
    EasyNavigationController *navVC = [[EasyNavigationController alloc]initWithRootViewController:ViewController.new];
    navVC.tabBarItem.title = @"Easy导航烂";
    UINavigationController *snav = [[UINavigationController alloc]initWithRootViewController:SystemNavViewController.new];
    snav.tabBarItem.title = @"系统导航栏";
    tabbar.viewControllers = @[navVC,snav];
    self.window.rootViewController  = tabbar ;
    
#endif
    
    
    // Override point for customization after application launch.
    [self setupBugly];
    return YES;
}




- (void)setupBugly {
    BuglyConfig * config = [[BuglyConfig alloc] init];
    config.debugMode = YES;
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 1.5;
    config.viewControllerTrackingEnable = NO;
    config.consolelogEnable = NO ;
    [Bugly startWithAppId:@"bce1cf9ee3"
        developmentDevice:YES
                   config:config];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].identifierForVendor]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
