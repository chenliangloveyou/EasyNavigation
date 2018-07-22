//
//  EasyNavigationView+Scroll.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 2018/5/29.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationView+Scroll.h"
//#import <objc/runtime.h>
//#import "UIView+EasyNavigationExt.h"
//#import "UIScrollView+EasyNavigationExt.h"

@implementation EasyNavigationView (Scroll)

/**
 * 根据scrollview的滚动，导航条慢慢渐变
 */
- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow
{
    [self navigationAlphaSlowChangeWithScrollow:scrollow
                                          start:0
                                            end:100];
}
- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow
                                        start:(CGFloat)startPoint
                                          end:(CGFloat)endPoint
{
    [self navigationScrollWithScrollView:scrollow config:^EasyNavigationScroll *{
        return [EasyNavigationScroll scroll]
        .setScrollType(EasyNavScrollTypeAlphaChange)
        .setStartPoint(startPoint)
        .setStopPoint(endPoint);
    }];
}
/**
 * 根据scrollview滚动，导航条隐藏或者展示.
 */
- (void)navigationSmoothScroll:(UIScrollView *)scrollow
                         start:(CGFloat)startPoint
                         speed:(CGFloat)speed
               stopToStatusBar:(BOOL)stopstatusBar
{
    [self navigationScrollWithScrollView:scrollow config:^EasyNavigationScroll *{
        return [EasyNavigationScroll scroll]
        .setScrollType(EasyNavScrollTypeSmooth)
        .setStartPoint(startPoint)
        .setStopPoint(startPoint + startPoint*speed)
        .setIsStopSatusBar(stopstatusBar);
    }];
    
//    self.kvoScrollView.scrollDistance = startPoint ;
    
}

- (void)navigationAnimationScroll:(UIScrollView *)scrollow
                    criticalPoint:(CGFloat)criticalPoint
                  stopToStatusBar:(BOOL)stopstatusBar
{
    
    [self navigationScrollWithScrollView:scrollow config:^EasyNavigationScroll *{
        return [EasyNavigationScroll scroll]
        .setScrollType(EasyNavScrollTypeAnimation)
        .setStartPoint(criticalPoint)
        .setIsStopSatusBar(stopstatusBar);
    }];
}

@end



