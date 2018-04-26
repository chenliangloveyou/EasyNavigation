//
//  UIViewController+EasyNavigationExt.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//


#import "UIViewController+EasyNavigationExt.h"

#import "EasyNavigationController.h"
#import "EasyNavigationUtils.h"
#import "EasyNavigationView+LeftButton.h"
#import <objc/runtime.h>


@implementation UIViewController (EasyNavigationExt)

@dynamic navigationView ;

- (BOOL)disableSlidingBackGesture
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setDisableSlidingBackGesture:(BOOL)disableSlidingBackGesture
{
    objc_setAssociatedObject(self, @selector(disableSlidingBackGesture), @(disableSlidingBackGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self dealSlidingGestureDelegate];
}

- (BOOL)customBackGestureEnabel
{
    return [objc_getAssociatedObject(self, _cmd) boolValue] ;
}
- (void)setCustomBackGestureEnabel:(BOOL)customBackGestureEnabel
{
    objc_setAssociatedObject(self, @selector(customBackGestureEnabel), @(customBackGestureEnabel), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self dealSlidingGestureDelegate];

}

- (CGFloat)customBackGestureEdge
{
    return [objc_getAssociatedObject(self, _cmd) floatValue] ;
}
- (void)setCustomBackGestureEdge:(CGFloat)customBackGestureEdge
{
    objc_setAssociatedObject(self, @selector(customBackGestureEdge), @(customBackGestureEdge), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


//- (EasyNavigationController *)vcEasyNavController
//{
//    EasyNavigationController *vcNav=  objc_getAssociatedObject(self, _cmd);
//    if (nil == vcNav) {
//        vcNav = (EasyNavigationController *)self.navigationController ;
//        objc_setAssociatedObject(self, @selector(vcEasyNavController), vcNav, OBJC_ASSOCIATION_ASSIGN);
//    }
//    return vcNav ;
//}

- (EasyNavigationView *)navigationView
{
    EasyNavigationView *navView = objc_getAssociatedObject(self, _cmd);
    if (nil == navView) {
        navView = [[EasyNavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth_N() , NavigationHeight_N())];
        
        if (!self.navigationController) {
            NSAssert(NO, @"attention: this controller's navigationcontroller is null: %@",self);
        }
        if (self.navigationController.viewControllers.count > 1) {
            UIImage *img = [UIImage imageNamed:EasyImageFile_N(@"nav_btn_back.png")] ;
            if ([EasyNavigationOptions shareInstance].navigationBackButtonImage) {
                img = [EasyNavigationOptions shareInstance].navigationBackButtonImage ;
            }
            NSString *title = @"      " ;
            if ([EasyNavigationOptions shareInstance].navigationBackButtonTitle) {
                title = [EasyNavigationOptions shareInstance].navigationBackButtonTitle ;
            }
            __weak typeof(self)weakSelf = self;
            UIButton *backButton = [navView addLeftButtonWithTitle:title image:img clickCallBack:^(UIView *view) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            navView.navigationBackButton = backButton ;
        }

        [self willChangeValueForKey:NSStringFromClass([EasyNavigationView class])];
        objc_setAssociatedObject(self, @selector(navigationView), navView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:NSStringFromClass([EasyNavigationView class])];
        [self.view addSubview:navView];
        
    }
    return navView ;
}


//- (CGFloat)navigationHeight
//{
//    CGFloat normalHeight = kNavNormalHeight_N + (ISHORIZONTA_N ? 0 : (ISIPHONE_X ?44:20));
//
////    NSLog(@"---%d",[UIDevice currentDevice].orientation);
//    NSLog(@"===%f,%f,%@",self.view.width,self.view.height ,NSStringFromCGRect([UIApplication sharedApplication].statusBarFrame) );
////    return normalHeight ;
////
////    CGFloat orginalHeight = kStatusBarHeight + kNavNormalHeight ;
////
////    if (self.isShowBigTitle) {
////        CGFloat additionalHeight = ISHORIZONTALSCREEM ? 0 : kNavBigTitleHeight ;
//////        return orginalHeight + additionalHeight + x;
////    }
//
//    return normalHeight ;
//}

- (BOOL)isShowBigTitle
{
    if (ScreenIsHorizontal_N()) {//如果屏幕是水平方向，不要大标题
        return NO ;
    }
    
    BOOL shouldShow = NO ;
    switch (self.navbigTitleType) {
        case NavBigTitleTypeIOS11:
//            shouldShow = IS_IOS11_OR_LATER ;
            break;
        case NavBigTitleTypePlus:
//            shouldShow = ISIPHONE_6P ;
            break ;
        case NavBigTitleTypeIphoneX:
//            shouldShow = ISIPHONE_X ;
            break ;
        case NavBigTitleTypeAll :
            shouldShow = YES ;
            break ;
        case NavBigTitleTypePlusOrX:
//            shouldShow = ISIPHONE_X || ISIPHONE_6P ;
            break ;
        default:
            break;
    }
    return shouldShow ;
}

- (NavBigTitleType)navbigTitleType
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setNavbigTitleType:(NavBigTitleType)navbigTitleType
{
    objc_setAssociatedObject(self, @selector(navbigTitleType), @(navbigTitleType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //设置大标题的时候，通知导航条刷新高度
    if (self.navigationView) {
        [self.navigationView layoutNavSubViews];
    }
}

- (NavTitleAnimationType)navTitleAnimationType
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setNavTitleAnimationType:(NavTitleAnimationType)navTitleAnimationType
{
    objc_setAssociatedObject(self, @selector(navTitleAnimationType), @(navTitleAnimationType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIStatusBarStyle)statusBarStyle
{
    return [objc_getAssociatedObject(self, _cmd) integerValue] ;
}
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    if (self.statusBarStyle == statusBarStyle) {
        return ;
    }
    
    objc_setAssociatedObject(self, @selector(statusBarStyle), @(statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (BOOL)statusBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue] ;
}
- (void)setStatusBarHidden:(BOOL)statusBarHidden
{
    if (self.statusBarHidden == statusBarHidden) {
        return ;
    }
    
    objc_setAssociatedObject(self, @selector(statusBarHidden), @(statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)horizontalScreenShowStatusBar
{
    return [objc_getAssociatedObject(self, _cmd) boolValue] ;
}

-(void)setHorizontalScreenShowStatusBar:(BOOL)horizontalScreenShowStatusBar
{
    if (self.horizontalScreenShowStatusBar == horizontalScreenShowStatusBar) {
        return ;
    }
    objc_setAssociatedObject(self, @selector(horizontalScreenShowStatusBar), @(horizontalScreenShowStatusBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)dealSlidingGestureDelegate
{
    EasyNavigationController *navController = (EasyNavigationController *)self.navigationController ;
    if (nil == navController) {
        return ;
    }

    if (navController.interactivePopGestureRecognizer.delegate != navController) {
        navController.interactivePopGestureRecognizer.delegate = navController ;
    }
    if (!navController.interactivePopGestureRecognizer.enabled) {
        navController.interactivePopGestureRecognizer.enabled = YES ;
    }
    
    if (self.customBackGestureEnabel) {
        
        [navController.interactivePopGestureRecognizer.view addGestureRecognizer:navController.customBackGesture];
        
        navController.customBackGesture.delegate = navController.customBackGestureDelegate ;
        
//        navController.interactivePopGestureRecognizer.delegate = nil;
//        navController.interactivePopGestureRecognizer.enabled  = NO;
    }
   

}

- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}


@end














