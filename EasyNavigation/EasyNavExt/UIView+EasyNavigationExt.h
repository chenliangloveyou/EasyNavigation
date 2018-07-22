//
//  UIView+EasyNavigationExt.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/11.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EasyNavigationExt)


@property (nonatomic) CGFloat Easy_x;
@property (nonatomic) CGFloat Easy_y;
@property(nonatomic) CGFloat Easy_width;
@property(nonatomic) CGFloat Easy_height;

@property(nonatomic) CGFloat Easy_centerX;
@property(nonatomic) CGFloat Easy_centerY;

@property(nonatomic,assign) CGFloat Easy_left;
@property(nonatomic) CGFloat Easy_top;
@property(nonatomic) CGFloat Easy_right;
@property(nonatomic) CGFloat Easy_bottom;

/**
 * 获取当前view所在的控制器
 */
- (UIViewController *)Easy_viewCurrentViewController;

/**
 * addSubview之后的回调
 */
@property (nonatomic, copy) void(^Easy_didAddsubView)(UIView *view);

/**
 * 为视图添加一个事件 
 */
- (void)Easy_addTapCallBack:(id)target sel:(SEL)selector;


@end
