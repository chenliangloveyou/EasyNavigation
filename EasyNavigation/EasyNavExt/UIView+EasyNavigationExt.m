//
//  UIView+EasyNavigationExt.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/11.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "UIView+EasyNavigationExt.h"

#import <objc/runtime.h>

@implementation UIView (EasyNavigationExt)


- (CGFloat)Easy_x {
    return self.frame.origin.x;
}
- (void)setEasy_x:(CGFloat)Easy_x {
    CGRect frame = self.frame;
    frame.origin.x = Easy_x;
    self.frame = frame;
}
- (CGFloat)Easy_y {
    return self.frame.origin.y;
}

- (void)setEasy_y:(CGFloat)Easy_y {
    CGRect frame = self.frame;
    frame.origin.y = Easy_y;
    self.frame = frame;
}
- (CGFloat)Easy_width {
    return self.frame.size.width;
}

- (void)setEasy_width:(CGFloat)Easy_width {
    CGRect frame = self.frame;
    frame.size.width = Easy_width;
    self.frame = frame;
}

- (CGFloat)Easy_height {
    return self.frame.size.height;
}

- (void)setEasy_height:(CGFloat)Easy_height {
    CGRect frame = self.frame;
    frame.size.height = Easy_height;
    self.frame = frame;
}


- (CGFloat)Easy_centerX {
    return self.center.x;
}

- (void)setEasy_centerX:(CGFloat)Easy_centerX {
    self.center = CGPointMake(Easy_centerX, self.center.y);
}

- (CGFloat)Easy_centerY {
    return self.center.y;
}

- (void)setEasy_centerY:(CGFloat)Easy_centerY {
    self.center = CGPointMake(self.center.x, Easy_centerY);
}



- (CGFloat)Easy_left {
    return self.frame.origin.x;
}

- (void)setEasy_left:(CGFloat)Easy_x {
    CGRect frame = self.frame;
    frame.origin.x = Easy_x;
    self.frame = frame;
}

- (CGFloat)Easy_top {
    return self.frame.origin.y;
}

- (void)setEasy_top:(CGFloat)Easy_y {
    CGRect frame = self.frame;
    frame.origin.y = Easy_y;
    self.frame = frame;
}

- (CGFloat)Easy_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setEasy_right:(CGFloat)Easy_right {
    CGRect frame = self.frame;
    frame.origin.x = Easy_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)Easy_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setEasy_bottom:(CGFloat)Easy_bottom {
    CGRect frame = self.frame;
    frame.origin.y = Easy_bottom - frame.size.height;
    self.frame = frame;
}


- (void (^)(UIView *))Easy_didAddsubView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEasy_didAddsubView:(void (^)(UIView *))Easy_didAddsubView
{
    objc_setAssociatedObject(self, @selector(Easy_didAddsubView), Easy_didAddsubView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //方法交换。当有视图加到这个view上时，得到通知
        Class viewClass = [UIView class];
        
        SEL originalSelector = @selector(addSubview:);
        SEL swizzledSelector = @selector(Easy_easyAddSubview:);
        
        Method originalMethod = class_getInstanceMethod(viewClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(viewClass, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(viewClass,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(viewClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}


- (void)Easy_easyAddSubview:(UIView *)view
{
    [self Easy_easyAddSubview:view];
    
    if (self.Easy_didAddsubView) {
        self.Easy_didAddsubView(view);
    }
}


- (UIViewController *)Easy_viewCurrentViewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return [self topViewController];
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (void)Easy_addTapCallBack:(id)target sel:(SEL)selector
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:tap];
}

@end
