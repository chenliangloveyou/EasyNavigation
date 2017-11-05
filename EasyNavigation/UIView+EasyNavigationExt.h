//
//  UIView+EasyNavigationExt.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/11.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EasyNavigationExt)


@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property(nonatomic,assign) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

/**
 * 获取当前view所在的控制器
 */
- (UIViewController *)currentViewController;

/**
 * addSubview之后的回调
 */
@property (nonatomic, copy) void(^didAddsubView)(UIView *view);

/**
 * 为视图添加一个事件 
 */
- (void)addTapCallBack:(id)target sel:(SEL)selector;

@end
