//
//  UIViewController+EasyNavigationExt.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EasyNavigationViewController ;

#import "EasyNavigationView.h"
#import "EasyUtils.h"

@interface UIViewController (EasyNavigationExt)

/**
 * 当前的导航控制器
 */
@property (nonatomic, weak) EasyNavigationViewController *vcEasyNavController ;

/**
 * 当前的导航条
 */
@property (nonatomic,strong)EasyNavigationView *navigationView ;

/**
 * 当前控制器大标题类型
 */
@property (assign)NavBigTitleType navbigTitleType ;
/**
 * 当前控制器大标题移动动画类型
 */
@property (assign)NavTitleAnimationType navTitleAnimationType ;

/**
 * 当前控制器 是否 禁止侧滑返回
 */
@property (nonatomic,assign)BOOL disableSlidingBackGesture ;

/**
 * 是否开始 手势侧滑返回
 */
@property (nonatomic,assign)BOOL customBackGestureEnabel ;

/**
 * 如果开启了手势侧滑，那么侧滑距离左边最大的距离
 */
@property (nonatomic,assign)CGFloat customBackGestureEdge ;

/**
 * 当为scrollview的时候是否开启侧滑返回
 */
//@property (nonatomic,assign)BOOL scrollViewBackEnable ;

/**
 * 当前控制器状态栏类型
 */
@property (nonatomic,assign)UIStatusBarStyle statusBarStyle;

/**
 * 当前控制器的状态栏是否隐藏
 */
@property (nonatomic,assign)BOOL statusBarHidden ;

/**
 * 横屏的时候是否显示状态栏 (默认为不显示)
 */
@property (nonatomic,assign)BOOL horizontalScreenShowStatusBar ;

/**
 * 处理侧滑返回手势
 */
- (void)dealSlidingGestureDelegate ;

@end
