//
//  UIScrollView+EasyNavigationExt.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/13.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "UIScrollView+EasyNavigationExt.h"
#import <objc/runtime.h>


@implementation UIScrollView (EasyNavigationExt)

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

- (ScrollDirection)direction
{
    NSNumber *tempDirection = objc_getAssociatedObject(self, _cmd);
    return tempDirection.integerValue ;
}
- (void)setDirection:(ScrollDirection)direction
{
    objc_setAssociatedObject(self, @selector(direction), @(direction), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)scrollDistance
{
    NSNumber *tempDistance = objc_getAssociatedObject(self, _cmd);
    return tempDistance.floatValue ;
}
- (void)setScrollDistance:(float)scrollDistance
{
    objc_setAssociatedObject(self, @selector(scrollDistance), @(scrollDistance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setEnableDirection:(BOOL)enableDirection{
    
    objc_setAssociatedObject(self, @selector(enableDirection), @(enableDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   
}
- (BOOL)enableDirection{
    
    NSNumber * number = objc_getAssociatedObject(self, _cmd);
    
    return number.integerValue;
}

@end
