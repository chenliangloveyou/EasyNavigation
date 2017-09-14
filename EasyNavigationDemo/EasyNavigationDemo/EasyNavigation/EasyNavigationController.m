//
//  EasyNavigationController.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/9/10.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationController.h"

#import "EasyUtils.h"
#import "EasyWarpViewController.h"
#import "EasyNavigationView.h"
#import "UIViewController+EasyNavigationExt.h"
#import "UIView+EasyNavigationExt.h"

@interface customBackGestureDelegate : NSObject<UIGestureRecognizerDelegate>

@property (nonatomic,weak)EasyNavigationController *navController ;

@property (nonatomic,weak)id systemGestureTarget ;
@end

@implementation customBackGestureDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    // 没有开启自动以返回
    UIViewController *topViewController = self.navController.topViewController;
    if (!topViewController.customBackGestureEnabel){
    return NO;
    }
    
    // 正在做过渡动画
    if ([[self.navController valueForKey:@"_isTransitioning"] boolValue]){
        return NO;
    }
    
    // 是否是自定义手势
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return  NO;
    }
    
    UIPanGestureRecognizer *customGesture = (UIPanGestureRecognizer *)gestureRecognizer;
    
    // 手势所在视图的速度
    CGPoint velocity = [customGesture velocityInView:customGesture.view];
    if (velocity.x < 0) {
        return NO;
    }

    // 手势所在的起始点
    CGPoint startPoint = [customGesture locationInView:customGesture.view];
    CGFloat allowMax  = topViewController.customBackGestureEdge;

    if (topViewController.customBackGestureEdge > 0 && startPoint.x > allowMax  ) {
        return NO;
    }
    
    // 获取系统手势的操作
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    
    // 把系统侧滑的手势操作给自定义的手势
    [gestureRecognizer addTarget:self.systemGestureTarget action:action];
    
    return YES;
}


@end

@interface EasyNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>


@property (nonatomic,strong)UINavigationBar *tempNavBar ;

@property (nonatomic,strong)UIPanGestureRecognizer *customBackGesture ;//自定义侧滑返回

@property (nonatomic,strong)customBackGestureDelegate *customBackGestureDelegate ;//自定义返回的代理
@property (nonatomic,weak)id systemGestureTarget ;

@end

@implementation EasyNavigationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBarHidden = NO ;
    self.navigationBar.hidden = YES ;
    
    self.delegate = self ;

    self.systemGestureTarget = self.interactivePopGestureRecognizer.delegate ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerPropertyChanged:) name:GKViewControllerPropertyChangedNotification object:nil];

}
- (void)viewControllerPropertyChanged:(NSNotification *)notify {
    //    UIViewController *topViewController = self.topViewController;
    
    UIViewController *vc = (UIViewController *)notify.object[@"viewController"];
    
    [self dealSlideGestureWithViewController:vc];
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
//        rootViewController.navigationBar = [[EasyNavigationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , NAV_HEIGHT)];
//        [rootViewController.view addSubview:rootViewController.navigationBar];
    }
//    self.navigationController.navigationBar ;
//    [self.navigationController setValue:[[EasyNavigationView alloc]init] forKeyPath:@"navigationBar"];

    return self ;
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 移除全屏滑动手势，重新处理手势
    if ([self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.systemGestureTarget]) {
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.systemGestureTarget];
    }
    
    [self dealSlideGestureWithViewController:viewController];
    
}

- (void)dealSlideGestureWithViewController:(UIViewController *)viewController
{
    if (viewController.disableSlidingBackGesture) {
        self.interactivePopGestureRecognizer.delegate = nil ;
        self.interactivePopGestureRecognizer.enabled = NO ;
    }
    else{
        
        self.interactivePopGestureRecognizer.delegate = self ;
        self.interactivePopGestureRecognizer.enabled = YES ;
        
        if (viewController.customBackGestureEnabel) {
            
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.customBackGesture];
            
            self.customBackGesture.delegate = self.customBackGestureDelegate ;
            
            self.interactivePopGestureRecognizer.delegate = nil;
            self.interactivePopGestureRecognizer.enabled  = NO;
        }
        
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{

   
   
}
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
//{

    
//    BOOL      sysNavBar = [[self.navBarDictionary objectForKey:viewController.description] boolValue];
    
//    [self setNavigationBarHidden:sysNavBar animated:YES];
    
//    self.navigationBar.hidden = sysNavBar ;
//}
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    self.isSystemNavigationBar = YES ;
//         BOOL      sysNavBar = [[self.navBarDictionary objectForKey:viewController.description] boolValue];

//    self.navigationBar.hidden = !sysNavBar ;

//}
//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
//{
//    
////    return [super navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
//}
//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//   UIViewController *tempController = [super popViewControllerAnimated:animated];

//    [self.navBarDictionary removeObjectForKey:tempController.description];
    
//    BOOL isSystemNavBar = YES ;
//    
//    for (NSString *tempDesc in [self.navBarDictionary allKeys]) {
//        if ([tempDesc isEqualToString:tempController.description]) {
//            isSystemNavBar = [[self.navBarDictionary objectForKey:tempController.description] boolValue];
//            break ;
//        }
//    }
//    
//    
//    if (isSystemNavBar) {
//        self.navigationBar.hidden = NO ;
//    }
//    else{
//        self.navigationBar.hidden = YES ;
//    }
    
//    return tempController ;
//}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0 ) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    viewController.navigationView = [[EasyNavigationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , NAV_HEIGHT)];
    
    kWeakSelf(self)
    if (self.viewControllers.count > 0) {
        UIImage *img =[UIImage imageNamed:@"nav_back_btn@2x.png"] ;
        [viewController.navigationView addLeftButtonWithImage:img  clickCallBack:^(UIView *view) {
            [weakself popViewControllerAnimated:YES];
        }];
    }
    
    [viewController.view addSubview:viewController.navigationView];

    [super pushViewController:viewController animated:animated];
    
//    [self.navBarDictionary setObject:@(sysNavBar) forKey:viewController.description];

//    if (sysNavBar == NO) {
    
//        UINavigationBar *tempNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT)];
//        UINavigationItem *tempNavItem = [[UINavigationItem alloc]init];
//        tempNavBar.items = @[tempNavItem];
//        
//        [viewController.view addSubview:tempNavBar];
//    
//    _tempNavBar = tempNavBar ;
    
//    }
//    self.navigationBar.hidden = !sysNavBar ;
    
    
}

- (void)pushViewControllerRetro:(UIViewController *)viewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
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
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

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
- (customBackGestureDelegate *)customBackGestureDelegate
{
    if (nil == _customBackGestureDelegate) {
        _customBackGestureDelegate = [[customBackGestureDelegate alloc]init];
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
