//
//  EasyNavigationView+Scrolling.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/10/30.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationView.h"

@interface EasyNavigationView (Scrolling)


#pragma mark - 视图滚动，导航条跟着变化

@property (nonatomic,assign) CGFloat alphaStartChange ;//alpha改变的开始位置
@property (nonatomic,assign) CGFloat alphaEndChange   ;//alpha停止改变的位置
@property (nonatomic,assign) CGFloat scrollStartPoint ;//导航条滚动的起始点
@property (nonatomic,assign) CGFloat criticalPoint ;//导航条动画隐藏的临界点
@property (nonatomic,assign) BOOL stopUpstatusBar ;//动画后是否需要停止在statusBar下面


/**
 * 根据scrollview的滚动，导航条慢慢变透明
 * startPoint alpha开始改变的坐标
 * endPoint alpha停止改变的坐标
 */
- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow ;

- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow start:(CGFloat)startPoint end:(CGFloat)endPoint ;

/**
 *  导航条随scrollview滚动而慢慢隐藏
 *
 * scrollow 为支持导航条渐变的scrollview，
 * startPoint 开始渐变scrollow需要滚动的距离，也就是说，只有在self.tableView滚动NAV_HEIGHT后导航条才开始移动。
 * speed 它的值为:导航条滚动距离/scrollow滚动距离
 * stopStatusBar 到了状态栏下面的时候是否需要停止
 */
- (void)navigationSmoothScroll:(UIScrollView *)scrollow start:(CGFloat)startPoint speed:(CGFloat)speed stopToStatusBar:(BOOL)stopStatusBar ;

/**
 * 超过临界点 隐藏导航栏
 *
 * scrollow 为支持导航条渐变的scrollview
 * criticalPoint 为触发导航条隐藏的点。也就是当scrollview的contentOffset.y值操作这个数的时候，导航条就会隐藏
 * stopStatusBar 停止到startBar下面
 */
- (void)navigationAnimationScroll:(UIScrollView *)scrollow criticalPoint:(CGFloat)criticalPoint stopToStatusBar:(BOOL)stopStatusBar ;



@end
