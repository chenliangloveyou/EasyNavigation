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

@interface EasyNavigationController ()<UINavigationControllerDelegate>

@property (nonatomic,strong)NSMutableDictionary *navBarDictionary ;//每个页面对应的导航条
@property (nonatomic,strong)NSMutableArray *navBarArray ;
@end

@implementation EasyNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.delegate = self ;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{

    
    BOOL      sysNavBar = [[self.navBarDictionary objectForKey:viewController.description] boolValue];
    
//    [self setNavigationBarHidden:sysNavBar animated:YES];
    
    self.navigationBar.hidden = sysNavBar ;
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.isSystemNavigationBar = YES ;
         BOOL      sysNavBar = [[self.navBarDictionary objectForKey:viewController.description] boolValue];

    self.navigationBar.hidden = !sysNavBar ;

}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
   UIViewController *tempController = [super popViewControllerAnimated:animated];
    
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
    
    return tempController ;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated sysNavBar:(BOOL)sysNavBar
{
    if (self.viewControllers.count > 0 ) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [self.navBarDictionary setObject:@(sysNavBar) forKey:viewController.description];

    if (sysNavBar == NO) {
        
        UINavigationBar *tempNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT)];
        UINavigationItem *tempNavItem = [[UINavigationItem alloc]init];
        tempNavBar.items = @[tempNavItem];
        
        [viewController.view addSubview:tempNavBar];
        
    }
    self.navigationBar.hidden = !sysNavBar ;
    [super pushViewController:viewController animated:animated];
    
    
    
    //    [super pushViewController:viewController animated:animated];
    
}

- (NSMutableDictionary *)navBarDictionary
{
    if (nil == _navBarDictionary) {
        _navBarDictionary  = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _navBarDictionary ;
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
