//
//  EasyWarpViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyWarpViewController.h"

#import "EasyNavigationViewController.h"
#import "EasyWarpNavigationViewController.h"
#import "UIViewController+EasyNavigationExt.h"

static NSValue *easyTabBarRectValue;


@interface EasyWarpViewController ()

@end

@implementation EasyWarpViewController

+ (EasyWarpViewController *)wrapViewController:(UIViewController *)viewController
{
    EasyWarpNavigationViewController  *navVC = [[EasyWarpNavigationViewController alloc]init];
    navVC.viewControllers = @[viewController];
    
    EasyWarpViewController *easyVC = [[EasyWarpViewController alloc]init];
    [easyVC.view addSubview:navVC.view];
    [easyVC addChildViewController:navVC];
    
    return easyVC ;
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.tabBarController && !easyTabBarRectValue) {
        easyTabBarRectValue = [NSValue valueWithCGRect:self.tabBarController.tabBar.frame];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.tabBarController && [self rootViewController].hidesBottomBarWhenPushed) {
        self.tabBarController.tabBar.frame = CGRectZero ;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.translucent  = YES ;
    
    if (self.tabBarController && self.tabBarController.tabBar.hidden && easyTabBarRectValue) {
        self.tabBarController.tabBar.frame = easyTabBarRectValue.CGRectValue ;
    }
}

//- (BOOL)backGestureEnabled
//{
//    return self.rootViewController.vcBackGestureEnabled ;
//}
- (BOOL)hidesBottomBarWhenPushed
{
    return self.rootViewController.hidesBottomBarWhenPushed ;
}
- (UITabBarItem *)tabBarItem
{
    return self.rootViewController.tabBarItem ;
}
- (NSString *)title
{
    return self.rootViewController.title ;
}
- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.rootViewController ;
}
- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.rootViewController ;
}
- (UIViewController *)rootViewController
{
    EasyWarpNavigationViewController *easyVC = self.childViewControllers.firstObject ;
    return easyVC.viewControllers.firstObject ;
    
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
