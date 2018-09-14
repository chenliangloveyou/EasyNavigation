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
#import "EasyNavigationView+Add.h"
#import "UIView+EasyNavigationExt.h"
#import <objc/runtime.h>

@implementation UIViewController (EasyNavigationExt)

@dynamic navigationView ;


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
     
        Class vc = [UIViewController class];
        
        SEL originalSEL = @selector(viewDidLoad);
        SEL swizzledSEL = @selector(Easy_viewDidLoad);
        
        Method originalMethod = class_getInstanceMethod(vc, originalSEL);
        Method swizzledMethod = class_getInstanceMethod(vc, swizzledSEL);
        
        BOOL didAddMethod =
        class_addMethod(vc, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(vc, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)Easy_viewDidLoad
{
    
    if (self.navigationController) {
        
        [self checkNavigationBackButton];
    }
    else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkNavigationBackButton) object:nil];
        [self performSelector:@selector(checkNavigationBackButton) withObject:nil afterDelay:0.01];
    }
    
    [self Easy_viewDidLoad];
}

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


- (EasyNavigationView *)navigationView
{
    EasyNavigationView *navView = objc_getAssociatedObject(self, _cmd);
    if (nil == navView) {
        navView = [[EasyNavigationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth_N() , NavigationHeight_N())];
       
        [self willChangeValueForKey:NSStringFromClass([EasyNavigationView class])];
        objc_setAssociatedObject(self, @selector(navigationView), navView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:NSStringFromClass([EasyNavigationView class])];
      
        __weak typeof(self)weakSelf = self;
        __weak typeof(EasyNavigationView *)weakNav = navView;
        dispatch_main_async_safe_easyN(^{
            [weakSelf.view addSubview:weakNav];
        });
    }
    return navView ;
}
- (void)checkNavigationBackButton
{
    if (![self.navigationController isKindOfClass:[EasyNavigationController class]]) {
        return ;
    }
    
    if (self.navigationController.viewControllers.count > 1) {
        NSString *imgName = EasyImageFile_N(@"nav_btn_back.png") ;
        if ([EasyNavigationOptions shareInstance].navigationBackButtonImageName) {
            imgName = [EasyNavigationOptions shareInstance].navigationBackButtonImageName ;
        }
        NSString *title = @"   " ;
        if ([EasyNavigationOptions shareInstance].navigationBackButtonTitle) {
            title = [EasyNavigationOptions shareInstance].navigationBackButtonTitle ;
        }
        __weak typeof(self)weakSelf = self;
        UIButton *backButton = [self.navigationView addLeftButton:^EasyNavigationButton *{
            return [EasyNavigationButton button].setTitle(title).setImageName(imgName).setImageFrame(CGRectMake(5, 10, 30, 24)).setTitleFrame(CGRectMake(44, 0, 40, 44));
        } callback:^(UIView *view) {
            [EasyNavigationUtils navigationBack:weakSelf];
        }];
        //        backButton.backgroundColor = [UIColor redColor];
        self.navigationView.navigationBackButton = backButton ;
    }
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

//- (BOOL)isShowBigTitle
//{
//    if (ScreenIsHorizontal_N()) {//如果屏幕是水平方向，不要大标题
//        return NO ;
//    }
//    
//    BOOL shouldShow = NO ;
//    switch (self.navbigTitleType) {
//        case NavBigTitleTypeIOS11:
////            shouldShow = IS_IOS11_OR_LATER ;
//            break;
//        case NavBigTitleTypePlus:
////            shouldShow = ISIPHONE_6P ;
//            break ;
//        case NavBigTitleTypeIphoneX:
////            shouldShow = ISIPHONE_X ;
//            break ;
//        case NavBigTitleTypeAll :
//            shouldShow = YES ;
//            break ;
//        case NavBigTitleTypePlusOrX:
////            shouldShow = ISIPHONE_X || ISIPHONE_6P ;
//            break ;
//        default:
//            break;
//    }
//    return shouldShow ;
//}
//
//- (NavBigTitleType)navbigTitleType
//{
//    return [objc_getAssociatedObject(self, _cmd) integerValue];
//}
//- (void)setNavbigTitleType:(NavBigTitleType)navbigTitleType
//{
//    objc_setAssociatedObject(self, @selector(navbigTitleType), @(navbigTitleType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    
//    //设置大标题的时候，通知导航条刷新高度
//    if (self.navigationView) {
//        [self.navigationView layoutNavSubViews];
//    }
//}
//
//- (NavTitleAnimationType)navTitleAnimationType
//{
//    return [objc_getAssociatedObject(self, _cmd) integerValue];
//}
//- (void)setNavTitleAnimationType:(NavTitleAnimationType)navTitleAnimationType
//{
//    objc_setAssociatedObject(self, @selector(navTitleAnimationType), @(navTitleAnimationType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}


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

//- (BOOL)horizontalScreenShowStatusBar
//{
//    return [objc_getAssociatedObject(self, _cmd) boolValue] ;
//}
//
//-(void)setHorizontalScreenShowStatusBar:(BOOL)horizontalScreenShowStatusBar
//{
//    if (self.horizontalScreenShowStatusBar == horizontalScreenShowStatusBar) {
//        return ;
//    }
//    objc_setAssociatedObject(self, @selector(horizontalScreenShowStatusBar), @(horizontalScreenShowStatusBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    
//    [self setNeedsStatusBarAppearanceUpdate];
//}

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


//- (void)replaceTableView
//{
//    if ([self.view isKindOfClass:[UITableView class]]) {
//
//        UITableView *tableView = (UITableView *)self.view ;
//        if (@available(iOS 11.0, *)) {
//            if ([tableView respondsToSelector:@selector(contentInsetAdjustmentBehavior)]) {
//                [tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//            }
//        }else{
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
//
//        if (tableView.Easy_y > 0) {
//            CGFloat tableViewY = tableView.Easy_y ;
//            tableView.frame = CGRectMake(tableView.Easy_x, 0, tableView.Easy_width, tableView.Easy_height+tableViewY);
//        }
//
//        tableView.contentInset = UIEdgeInsetsMake(NavigationHeight_N(), 0, 0, 0);
//        [tableView setContentOffset:CGPointMake(0, -NavigationHeight_N()) animated:NO];
//
//        UIView *tempV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth_N(), ScreenHeight_N())];
//        tempV.backgroundColor = [UIColor cyanColor];
//        self.view = tempV ;
//        [self.view addSubview:tableView];
//        ((UITableViewController*)self).tableView = tableView ;
//    }
//}
//继承自 tableviewControler 处理
//if ([self isKindOfClass:[UITableViewController class]]) {
//    
//    if (self.navigationController && [self.navigationController isKindOfClass:[EasyNavigationController class]]) {
//        [self replaceTableView];
//    }else{
//        UITableView *tableView = (UITableView *)self.view ;
//        ((UITableViewController*)self).tableView = tableView ;
//    }
//}
//else{
//    if (![self isKindOfClass:[UITabBarController class]] && ![self isKindOfClass:[UINavigationController class]] ) {
//        
//        UIView *view = self.view ;
//        
//        UIView *tempV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth_N(), ScreenHeight_N())];
//        tempV.backgroundColor = [UIColor cyanColor];
//        self.view = tempV ;
//        
//        view.frame = CGRectMake(0, NavigationHeight_N(), ScreenWidth_N(), ScreenHeight_N()-NavigationHeight_N());
//        [self.view addSubview:view];
//    }
//}
@end














