//
//  EasyNavigationView+Scrolling.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/10/30.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationView+Scrolling.h"

#import "UIScrollView+EasyNavigationExt.h"
#import "UIView+EasyNavigationExt.h"



#define kAnimationDuring 0.3f //动画执行时间

@implementation EasyNavigationView (Scrolling)



#pragma mark - 视图滚动，导航条跟着变化

/**
 * 根据scrollview的滚动，导航条慢慢渐变
 */
- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow
{
    [self navigationAlphaSlowChangeWithScrollow:scrollow start:0 end:self.navigationOrginalHeight*2];
}
- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow start:(CGFloat)startPoint end:(CGFloat)endPoint
{
    self.navigationChangeType = NavigationChangeTypeAlphaChange ;
    
    self.alphaStartChange = startPoint ;
    self.alphaEndChange = endPoint ;
    self.kvoScrollView = scrollow ;
    
    [scrollow addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}

/**
 * 根据scrollview滚动，导航条隐藏或者展示.
 */
- (void)navigationSmoothScroll:(UIScrollView *)scrollow start:(CGFloat)startPoint speed:(CGFloat)speed stopToStatusBar:(BOOL)stopstatusBar
{
    self.navigationChangeType = NavigationChangeTypeSmooth ;
    
    self.kvoScrollView = scrollow ;
    self.scrollSpeed = speed ;
    self.scrollStartPoint = startPoint ;
    self.stopUpstatusBar = stopstatusBar ;
    
    self.kvoScrollView.scrollDistance = startPoint ;
    
    [scrollow addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
}

- (void)navigationAnimationScroll:(UIScrollView *)scrollow criticalPoint:(CGFloat)criticalPoint stopToStatusBar:(BOOL)stopstatusBar
{
    self.navigationChangeType = NavigationChangeTypeAnimation ;
    
    self.kvoScrollView = scrollow ;
    self.criticalPoint = criticalPoint ;
    self.stopUpstatusBar = stopstatusBar ;
    
    [scrollow addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![object isEqual:self.kvoScrollView] || ![keyPath isEqualToString:@"contentOffset"]) {
        EasyLog(@"监听出现异常 -----> object=%@ , keyPath = %@",object ,keyPath);
        return ;
    }
    //scrollView 在y轴上滚动的距离
    CGFloat scrollContentY = self.kvoScrollView.contentInset.top + self.kvoScrollView.contentOffset.y ;
    
    if (self.navigationChangeType == NavigationChangeTypeAlphaChange) {
        if (scrollContentY > self.alphaStartChange){
            CGFloat alpha = scrollContentY / self.alphaEndChange ;
            [self setNavigationBackgroundAlpha:alpha];
        }
        else{
            [self setNavigationBackgroundAlpha:0];
        }
    }
    else{
        
        CGFloat newPointY = [[change objectForKey:@"new"] CGPointValue].y ;
        CGFloat oldPointY = [[change objectForKey:@"old"] CGPointValue].y ;
        
        ScrollDirection currentDuring = ScrollDirectionUnknow ;
        
        if ( newPointY >=  oldPointY ) {// 向上滚动
            currentDuring = ScrollDirectionUp ;
            
            if (self.navigationChangeType == NavigationChangeTypeAnimation) {
                [self animationScrollUpWithContentY:scrollContentY];
            }
            else if (self.navigationChangeType == NavigationChangeTypeSmooth){
                [self smoothScrollUpWithContentY:scrollContentY];
            }
            else{
                EasyLog(@"Attention : the change type is know : %zd",self.navigationChangeType );
            }
        }
        else if ( newPointY < oldPointY ) {// 向下滚动
            currentDuring = ScrollDirectionDown ;
            
            if (self.navigationChangeType == NavigationChangeTypeAnimation) {
                [self animationScrollDownWithContentY:scrollContentY];
            }
            else if (self.navigationChangeType == NavigationChangeTypeSmooth){
                [self smoothScrollDownWithContentY:scrollContentY];
            }
            else{
                EasyLog(@"Attention : the change type is know : %zd",self.navigationChangeType );
            }
            
        }
        
        if (self.kvoScrollView.direction != currentDuring) {
            
            EasyLog(@"方向改变 %ld , 记住位置 %f",currentDuring , scrollContentY );
            
            if (self.kvoScrollView.direction != ScrollDirectionUnknow) {
                if (scrollContentY >= 0) {
                    self.kvoScrollView.scrollDistance = scrollContentY ;
                }
            }
            
            self.kvoScrollView.direction = currentDuring ;
            
        }
        
        //    EasyLog(@"方向：%ld 滚动距离：%f ",self.kvoScrollView.direction,scrollContentY);
        
    }
    
}

#pragma mark 导航条滚动

- (void)animationScrollDownWithContentY:(CGFloat)contentY
{
    if (self.kvoScrollView.scrollDistance - contentY > 20 && self.y!= 0 &&  ! self.isScrollingNavigaiton ) {
        
        self.isScrollingNavigaiton = YES ;
        EasyLog(@"scroll to top %f",self.kvoScrollView.scrollDistance - contentY );
        [UIView animateWithDuration:kAnimationDuring animations:^{
            self.y = 0 ;
        }completion:^(BOOL finished) {
            self.isScrollingNavigaiton = NO ;
            self.y = 0 ;
            
            [self changeSubviewsAlpha:1];
            
        }] ;
    }
}

- (void)animationScrollUpWithContentY:(CGFloat)contentY
{
    //只有大于开始滚动的位置，才开始滚动导航条
    if (contentY > self.criticalPoint && contentY - self.kvoScrollView.scrollDistance > 20 &&  ! self.isScrollingNavigaiton) {//开始移动导航条
        
        self.isScrollingNavigaiton = YES ;
        
        //导航条停留的位置，如果是停留在状态栏下面，则需要让出20
        CGFloat topOfY = self.stopUpstatusBar?STATUSBAR_HEIGHT:0 ;
        
        [UIView animateWithDuration:kAnimationDuring animations:^{
            
            self.y = -(self.height - topOfY );
            
        }completion:^(BOOL finished) {
            self.isScrollingNavigaiton = NO ;
            self.y = -(self.height - topOfY ) ;
            
            [self changeSubviewsAlpha:0];
            
        }] ;
    }
}
- (void)smoothScrollUpWithContentY:(CGFloat)contentY
{
    //只有大于开始滚动的位置，才开始滚动导航条
    if (contentY > self.scrollStartPoint  ) {//开始移动导航条
        
        //需要改变的y值
        CGFloat changeY =(contentY - self.kvoScrollView.scrollDistance)*self.scrollSpeed  ;
        
        if (changeY < 0) {
            return ;
        }
        
        //导航条停留的位置，如果是停留在状态栏下面，则需要让出20
        CGFloat topOfY = self.stopUpstatusBar?STATUSBAR_HEIGHT:0 ;
        
        if ( changeY <= self.height - topOfY ) {
            EasyLog(@"changeY = %F",changeY);
            self.y = - changeY ;
            
            if (!self.stopUpstatusBar) {
                return ;
            }
            
            if (changeY == self.height-STATUSBAR_HEIGHT) {
                [self changeSubviewsAlpha:0];
            }
            else if (changeY < self.height - STATUSBAR_HEIGHT){
                
                CGFloat alpha = 1 - changeY/(self.height-STATUSBAR_HEIGHT) ;
                [self changeSubviewsAlpha:alpha];
            }
            
        }
        else{
            self.y = - (self.height - topOfY) ;
        }
    }
}

- (void)smoothScrollDownWithContentY:(CGFloat)contentY
{
    if (self.kvoScrollView.scrollDistance - contentY > 20 && self.y!= 0 &&  ! self.isScrollingNavigaiton ) {
        
        self.isScrollingNavigaiton = YES ;
        // EasyLog(@"scroll to top %f",self.kvoScrollView.scrollDistance - scrollContentY );
        [UIView animateWithDuration:kAnimationDuring animations:^{
            self.y = 0 ;
        }completion:^(BOOL finished) {
            self.isScrollingNavigaiton = NO ;
            self.y = 0 ;
            
            if (self.stopUpstatusBar) {
                [self changeSubviewsAlpha:1];
            }
            
        }] ;
    }
}

//改变子视图的透明度
- (void)changeSubviewsAlpha:(CGFloat)alpha
{
    for (UIView *subView in self.subviews) {
        if ([subView isEqual:self.backgroundView]) {
            continue ;
        }
        if (self.backgroundImageView && [subView isEqual:self.backgroundImageView]) {
            continue ;
        }
        subView.alpha = alpha ;
    }
}

@end
