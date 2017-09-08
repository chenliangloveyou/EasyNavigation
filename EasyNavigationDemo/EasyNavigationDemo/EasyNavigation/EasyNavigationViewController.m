//
//  EasyNavigationViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationViewController.h"
#import "EasyNavigationBar.h"
#import "EasyWarpViewController.h"
#import "UIViewController+EasyNavigationExt.h"

#import <objc/runtime.h>

@interface EasyNavigationViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>


@property (nonatomic, strong) UIPanGestureRecognizer *backGesture;

@property (nonatomic, strong) id backGestureDelegate;

@end

@implementation EasyNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarHidden:YES];
    self.delegate = self ;
    
    self.backGestureDelegate = self.interactivePopGestureRecognizer.delegate ;
    SEL action  = NSSelectorFromString(@"handleNavigationTransition:");
    
    self.backGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self.backGestureDelegate action:action];
    self.backGesture.maximumNumberOfTouches = 1 ;
    
    
//    UINavigationBar *bar = [UINavigationBar appearance];
//    
//    // 2.设置导航栏的背景图片
//    [bar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    //返回按钮图片
    //    [bar setShadowImage:[[UIImage alloc]init]];
    //    UIImage *backImg = [[UIImage imageNamed:@"return"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    [bar setBackIndicatorTransitionMaskImage:backImg];
    //    [bar setBackIndicatorImage:backImg];
    
    //去掉返回按钮文字
//    UIBarButtonItem *backItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
//    UIOffset offSet = UIOffsetZero ;
//    offSet.horizontal = -500 ;
//    [backItem setBackButtonTitlePositionAdjustment:offSet forBarMetrics:UIBarMetricsDefault];
//    
//    //导航栏文字大小和颜色
//    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSForegroundColorAttributeName , nil];
//    [bar setTitleTextAttributes:titleAttributes];
    
    
    // 3.设置导航栏文字的主题
    //    [bar setTitleTextAttributes:@{
    //                                  NSForegroundColorAttributeName : [UIColor blackColor],
    //                                  NSShadowAttributeName : [NSValue valueWithUIOffset:UIOffsetZero]
    //                                  }];
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL isRootVC  = NO ;
    if (viewController==navigationController.viewControllers.firstObject) {
        isRootVC = YES ;
    }
    
    if (viewController.vcBackGestureEnabled) {
        
        if (isRootVC) {
            [self.view removeGestureRecognizer:self.backGesture];
        }
        else{
            [self.view addGestureRecognizer:self.backGesture];
        }
        
        self.interactivePopGestureRecognizer.delegate = self.backGestureDelegate ;
        self.interactivePopGestureRecognizer.enabled = NO ;
    }
    else{
        
        [self.view removeGestureRecognizer:self.backGesture];
        self.interactivePopGestureRecognizer.delegate = self ;
        self.interactivePopGestureRecognizer.enabled = !isRootVC ;
    }
}


//修复有水平方向滚动的ScrollView时边缘返回手势失效的问题
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

- (NSArray *)easyViewControllers
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
    for (EasyWarpViewController *vc in self.viewControllers) {
        [tempArray addObject:vc.rootViewController];
    }
    return tempArray.copy ;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (id)init
{
  return [super initWithNavigationBarClass:[EasyNavigationBar class] toolbarClass:nil];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
//  self = [super initWithNavigationBarClass:[EasyNavigationBar class] toolbarClass:nil];
//  if (self) {
//    self.viewControllers = @[rootViewController];
//  }

    if (self = [super init]) {
        rootViewController.vcEasyNavController = self ;
        self.viewControllers = @[[EasyWarpViewController wrapViewController:rootViewController]];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.viewControllers.firstObject.vcEasyNavController = self ;
        self.viewControllers = @[[EasyWarpViewController wrapViewController:self.viewControllers.firstObject]];
    }
    return self ;
}




//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//
//    BOOL ok = YES; // 默认为支持右滑反回
//    if ([self.topViewController isKindOfClass:[EFBaseViewController class]]) {
//        if ([self.topViewController respondsToSelector:@selector(gestureRecognizerShouldBegin)]) {
//            EFBaseViewController *vc = (EFBaseViewController *)self.topViewController;
//            ok = [vc gestureRecognizerShouldBegin];
//        }
//    }
//    return ok;
//}


- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
    if (self.viewControllers.count > 0 ) {
        UIViewController *lastVC = viewControllers.lastObject ;
        lastVC.hidesBottomBarWhenPushed = YES;
    }
    [super setViewControllers:viewControllers animated:YES];
}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//}

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    EFLog(@"popVC=====");
//    return [super popViewControllerAnimated:YES];
//}

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



- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [self.navigationController popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated

{
    EasyNavigationViewController *easyNavigationVC = viewController.vcEasyNavController;
    NSInteger index = [easyNavigationVC.easyViewControllers indexOfObject:viewController];
    return [self.navigationController popToViewController:easyNavigationVC.viewControllers[index] animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0 ) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    viewController.vcEasyNavController = (EasyNavigationViewController *)self.navigationController;
    viewController.vcBackGestureEnabled = viewController.vcEasyNavController.backGestureEnabled;
    
    UIImage *backButtonImage = viewController.vcEasyNavController.backButtonImage;
    
    if (!backButtonImage) {
        backButtonImage = [UIImage imageNamed:@"back.png"];
    }
    
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton)];
    
    [self.navigationController pushViewController:[EasyWarpViewController wrapViewController:viewController] animated:animated];
    
    

//    [super pushViewController:viewController animated:animated];
    
}

- (void)didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self.navigationController dismissViewControllerAnimated:flag completion:completion];
    self.viewControllers.firstObject.vcEasyNavController = nil;
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











