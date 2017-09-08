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

- (BOOL)vcBackGestureEnabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue] ;
}
- (void)setVcBackGestureEnabled:(BOOL)vcBackGestureEnabled
{
    objc_setAssociatedObject(self, @selector(vcBackGestureEnabled), @(vcBackGestureEnabled), OBJC_ASSOCIATION_RETAIN);
}

- (EasyNavigationViewController *)vcEasyNavController
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setVcEasyNavController:(EasyNavigationViewController *)vcEasyNavController
{
    objc_setAssociatedObject(self, @selector(vcEasyNavController), vcEasyNavController, OBJC_ASSOCIATION_ASSIGN);
}

@end


