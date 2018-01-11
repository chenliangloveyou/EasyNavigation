//
//  EasyNavigationController.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/9/10.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationController.h"

#import "EasyNavigationUtils.h"
#import "EasyNavigationView.h"
#import "UIViewController+EasyNavigationExt.h"
#import "UIView+EasyNavigationExt.h"
#import "EasyNavigationView+LeftButton.h"


@interface EasyNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIPanGestureRecognizer *customBackGesture ;//自定义侧滑返回
@property (nonatomic,strong)EasyCustomBackGestureDelegate *customBackGestureDelegate ;//自定义返回的代理


@property (nonatomic,strong)UINavigationBar *tempNavBar ;

@property (nonatomic,weak)id systemGestureTarget ;

@end

@implementation EasyNavigationController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBarHidden = NO ;
    self.navigationBar.hidden = YES ;
    self.delegate = self ;

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarChangeNoti:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
   
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        EasyNavigationView  *navView = self.topViewController.navigationView ;
//        if (navView.width != self.topViewController.view.width) {
//            navView.width = self.topViewController.view.width ;
//        }
//        if (self.view.width != SCREEN_WIDTH) {
//            navView.centerX = self.view.centerX ;
//        }
//    });
    
    // 移除全屏滑动手势
    if ([self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.systemGestureTarget]) {
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.systemGestureTarget];
    }
 
    //重新处理手势
    [viewController dealSlidingGestureDelegate];
   
}
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
    UIViewController *lastVC = viewControllers.lastObject ;
    NSAssert(lastVC, @"the viewcontrollers array is empty !");

    if (self.viewControllers.count > 0 ) {
        lastVC.hidesBottomBarWhenPushed = YES;
    }
    
    [super setViewControllers:viewControllers animated:YES];

}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0 ) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];

    if (IsIphoneX_N()) {  // 修改tabBra的frame
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = ScreenHeight_N() - frame.size.height;
        self.tabBarController.tabBar.frame = frame;
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        // 屏蔽调用rootViewController的滑动返回手势
        if (self.viewControllers.count<=1||self.visibleViewController==self.viewControllers.firstObject) {
            return NO;
        }
        //禁止侧滑了不让返回
        if (self.topViewController.disableSlidingBackGesture) {
            return NO ;
        }
    }
    return YES;
}
- (void)setTitle:(NSString *)title
{
    if (self.topViewController.navigationView) {
        [self.navigationView setTitle:title];
    }
}
- (void)statusBarChangeNoti:(NSNotification *)notifycation
{

    [self setNeedsStatusBarAppearanceUpdate];

    EasyNavigationView  *navView = self.topViewController.navigationView ;
    if (!navView)  return ;
    
    if (navView.width != self.topViewController.view.width) {
        navView.width = self.topViewController.view.width ;
    }

    [navView layoutNavSubViews];

    UIDevice *device = [UIDevice currentDevice] ;

    if (device.orientation == UIDeviceOrientationPortrait || device.orientation == UIDeviceOrientationPortraitUpsideDown) {
        EasyLog_N(@"竖屏 ====== %f , %f",self.topViewController.view.width ,self.topViewController.navigationView.height);
    }
    else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        EasyLog_N(@"横屏====== %f , %f",self.topViewController.view.width ,self.topViewController.navigationView.height);
    }
    else{
        EasyLog_N(@"未知状态====== %zd",device.orientation );
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.statusBarStyle ;
}


#pragma mark - getter

- (UIPanGestureRecognizer *)customBackGesture
{
    if (nil == _customBackGesture) {
        _customBackGesture = [[UIPanGestureRecognizer alloc]init];
        _customBackGesture.maximumNumberOfTouches = 1 ;
    }
    return _customBackGesture ;
}
- (EasyCustomBackGestureDelegate *)customBackGestureDelegate
{
    if (nil == _customBackGestureDelegate) {
        _customBackGestureDelegate = [[EasyCustomBackGestureDelegate alloc]init];
        _customBackGestureDelegate.navController = self ;
        _customBackGestureDelegate.systemGestureTarget = self.systemGestureTarget ;
    }
    return _customBackGestureDelegate ;
}
- (id)systemGestureTarget
{
    if (nil == _systemGestureTarget) {
        _systemGestureTarget = self.interactivePopGestureRecognizer.delegate ;
    }
    return _systemGestureTarget ;
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
