//
//  EasyNavigationController.h
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/9/10.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EasyNavigationController : UINavigationController

//@property (nonatomic,assign)BOOL isSystemNavigationBar ;//是否展示自带的导航条

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated sysNavBar:(BOOL)sysNavBar ;

- (void)pushViewControllerRetro:(UIViewController *)viewController;
- (void)popViewControllerRetro;

@end
