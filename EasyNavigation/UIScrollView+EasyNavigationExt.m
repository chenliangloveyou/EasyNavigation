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

//- (void)dealloc
//{
//}

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



//是否产生一个新的touch对象来响应手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}


// 当scrollview上产生一个手势 是否相应事件
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer) {
      
        CGPoint point = [self.panGestureRecognizer translationInView:self];
      
        UIGestureRecognizerState state = gestureRecognizer.state;

        CGFloat locationDistance = [UIScreen mainScreen].bounds.size.width;
        
        if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStatePossible) {
            CGPoint location = [gestureRecognizer locationInView:self];
            if (point.x > 0 && location.x < locationDistance && self.contentOffset.x <= 0) {
                return NO;
            }
        }
    }
    return YES;

}


@end




