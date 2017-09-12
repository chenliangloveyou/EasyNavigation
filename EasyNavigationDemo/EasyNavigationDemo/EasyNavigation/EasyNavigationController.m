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

@interface EasyNavigationController ()<UINavigationControllerDelegate>

//@property (nonatomic,strong)NSMutableDictionary *navBarDictionary ;//每个页面对应的导航条
//@property (nonatomic,strong)NSMutableArray *navBarArray ;

@property (nonatomic,strong)UINavigationBar *tempNavBar ;
@end

@implementation EasyNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.navigationBarHidden = NO ;
    self.navigationBar.hidden = YES ;
    
    self.delegate = self ;
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
        UIImage *img =[UIImage imageNamed:@"back@2x.png"] ;
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

//- (NSMutableDictionary *)navBarDictionary
//{
//    if (nil == _navBarDictionary) {
//        _navBarDictionary  = [NSMutableDictionary dictionaryWithCapacity:10];
//    }
//    return _navBarDictionary ;
//}
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
