//
//  EasyNavigationViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationViewController.h"
#import "EasyNavigationBar.h"

@interface EasyNavigationViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    UIScreenEdgePanGestureRecognizer *_screenEdgePanGesture ;
}
@end

@implementation EasyNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationBar *bar = [UINavigationBar appearance];
    
    // 2.设置导航栏的背景图片
    [bar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    //返回按钮图片
    //    [bar setShadowImage:[[UIImage alloc]init]];
    //    UIImage *backImg = [[UIImage imageNamed:@"return"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    [bar setBackIndicatorTransitionMaskImage:backImg];
    //    [bar setBackIndicatorImage:backImg];
    
    //去掉返回按钮文字
    UIBarButtonItem *backItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    UIOffset offSet = UIOffsetZero ;
    offSet.horizontal = -500 ;
    [backItem setBackButtonTitlePositionAdjustment:offSet forBarMetrics:UIBarMetricsDefault];
    
    //导航栏文字大小和颜色
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSForegroundColorAttributeName , nil];
    [bar setTitleTextAttributes:titleAttributes];
    
    
    // 3.设置导航栏文字的主题
    //    [bar setTitleTextAttributes:@{
    //                                  NSForegroundColorAttributeName : [UIColor blackColor],
    //                                  NSShadowAttributeName : [NSValue valueWithUIOffset:UIOffsetZero]
    //                                  }];
    
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
  self = [super initWithNavigationBarClass:[EasyNavigationBar class] toolbarClass:nil];
  if (self) {
    self.viewControllers = @[rootViewController];
  }
  return self;
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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0 ) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}
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
