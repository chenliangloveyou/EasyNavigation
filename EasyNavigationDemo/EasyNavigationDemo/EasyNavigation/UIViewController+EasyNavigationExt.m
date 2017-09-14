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


- (BOOL)disableSlidingBackGesture
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setDisableSlidingBackGesture:(BOOL)disableSlidingBackGesture
{
    objc_setAssociatedObject(self, @selector(disableSlidingBackGesture), @(disableSlidingBackGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)customBackGestureEnabel
{
    return [objc_getAssociatedObject(self, _cmd) boolValue] ;
}
- (void)setCustomBackGestureEnabel:(BOOL)customBackGestureEnabel
{
    objc_setAssociatedObject(self, @selector(customBackGestureEnabel), @(customBackGestureEnabel), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)customBackGestureEdge
{
    return [objc_getAssociatedObject(self, _cmd) floatValue] ;
}
- (void)setCustomBackGestureEdge:(CGFloat)customBackGestureEdge
{
    objc_setAssociatedObject(self, @selector(customBackGestureEdge), @(customBackGestureEdge), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (EasyNavigationViewController *)vcEasyNavController
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setVcEasyNavController:(EasyNavigationViewController *)vcEasyNavController
{
    objc_setAssociatedObject(self, @selector(vcEasyNavController), vcEasyNavController, OBJC_ASSOCIATION_ASSIGN);
}


- (EasyNavigationView *)navigationView
{
    return objc_getAssociatedObject(self, _cmd);
    
}
- (void)setNavigationView:(EasyNavigationView *)navigationView
{
    objc_setAssociatedObject(self, @selector(navigationView), navigationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}


@end














