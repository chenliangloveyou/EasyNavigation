//
//  EasyNavigationController.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/9/10.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationController.h"

#import "EasyUtils.h"
#import "EasyNavigationView.h"
#import "UIViewController+EasyNavigationExt.h"
#import "UIView+EasyNavigationExt.h"



@interface EasyNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>


@property (nonatomic,strong)UINavigationBar *tempNavBar ;


@property (nonatomic,weak)id systemGestureTarget ;

@end

@implementation EasyNavigationController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil
     ];
    
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBarHidden = NO ;
    self.navigationBar.hidden = YES ;
    
    self.delegate = self ;

    self.systemGestureTarget = self.interactivePopGestureRecognizer.delegate ;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];


    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 移除全屏滑动手势
    if ([self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.systemGestureTarget]) {
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.systemGestureTarget];
    }
    
    //重新处理手势
    [viewController dealSlidingGestureDelegate];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0 ) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    viewController.navigationView = [[EasyNavigationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , NAV_HEIGHT)];
    
    if (self.viewControllers.count > 0) {
        kWeakSelf(self)
        UIImage *img = [UIImage imageNamed:EasyImageFile(@"nav_btn_back.png")] ;
        [viewController.navigationView addLeftButtonWithImage:img  clickCallBack:^(UIView *view) {
             [weakself popViewControllerAnimated:YES];
        }];
    }
    [viewController.view addSubview:viewController.navigationView];

    [super pushViewController:viewController animated:animated];

    
    EasyNavigationView  *navView = self.topViewController.navigationView ;
    if (navView.width != self.topViewController.view.width) {
        navView.width = self.topViewController.view.width ;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.statusBarStyle ;
}



- (void)pushViewControllerRetro:(UIViewController *)viewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 1.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self pushViewController:viewController animated:NO];
}

- (void)popViewControllerRetro {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self popViewControllerAnimated:NO];
}


- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
{
    
    EasyNavigationView  *navView = self.topViewController.navigationView ;
    if (nil == navView) {
        return ;
    }
    
    if (navView.width != self.topViewController.view.width) {
        navView.width = self.topViewController.view.width ;
    }
    [self setNeedsStatusBarAppearanceUpdate];
    
//    //1.获取 当前设备 实例
//    UIDevice *device = [UIDevice currentDevice] ;
//    
//    EasyLog(@" %@ = %@",NSStringFromCGRect(self.topViewController.view.frame) , NSStringFromCGRect(navView.frame));
//    
//    switch (device.orientation) {
//        case UIDeviceOrientationUnknown: EasyLog(@"未知方向"); break;
//            
//        case UIDeviceOrientationFaceUp: EasyLog(@"屏幕朝上平躺"); break;
//            
//        case UIDeviceOrientationFaceDown:  EasyLog(@"屏幕朝下平躺");  break;
//            
//        case UIDeviceOrientationLandscapeLeft: EasyLog(@"屏幕向左横置");  break;
//            
//        case UIDeviceOrientationLandscapeRight: EasyLog(@"屏幕向右橫置"); break;
//            
//        case UIDeviceOrientationPortrait:  EasyLog(@"屏幕直立");  break;
//            
//        case UIDeviceOrientationPortraitUpsideDown: EasyLog(@"屏幕直立，上下位置调换了");  break;
//            
//        default: EasyLog(@"无法辨识"); break;
//    }
    
}


#pragma mark - getter
//- (NSMutableDictionary *)navBarDictionary
//{
//    if (nil == _navBarDictionary) {
//        _navBarDictionary  = [NSMutableDictionary dictionaryWithCapacity:10];
//    }
//    return _navBarDictionary ;
//}

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
