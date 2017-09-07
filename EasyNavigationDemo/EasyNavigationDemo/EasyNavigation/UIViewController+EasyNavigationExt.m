//
//  UIViewController+EasyNavigationExt.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "UIViewController+EasyNavigationExt.h"

#import <objc/runtime.h>


@implementation UIViewController (EasyNavigationExt)

- (BOOL)backGestureEnabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue] ;
}
- (void)setBackGestureEnabled:(BOOL)backGestureEnabled
{
    objc_setAssociatedObject(self, @selector(backGestureEnabled), @(backGestureEnabled), OBJC_ASSOCIATION_RETAIN);
}

- (EasyNavigationViewController *)easyNavigationController
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setEasyNavigationController:(EasyNavigationViewController *)easyNavigationController
{
    objc_setAssociatedObject(self, @selector(easyNavigationController), easyNavigationController, OBJC_ASSOCIATION_ASSIGN);
}

@end


