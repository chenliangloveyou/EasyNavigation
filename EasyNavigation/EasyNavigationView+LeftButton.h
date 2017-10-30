//
//  EasyNavigationView+LeftButton.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/10/30.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationView.h"

@interface EasyNavigationView (LeftButton)


/**
 * 往左边视图上加一个view。调用此方法把view加到视图的左边，将会和创建的按钮一同计算排列位置
 * view 需要添加到左视图的控件
 */
- (void)addLeftView:(UIView *)view
      clickCallback:(clickCallback)callback ;

/**
 * 创建一个按钮并放到导航条的左边。会按照添加顺序，一个一个排列
 * title           按钮上的文字
 * image           按钮上的图片
 * hightImage      按钮按下(高亮)时的图片
 * backgroundImage 按钮的背景图片
 * callback        按钮的点击回调事件
 * return  创建的按钮指针,可以继续用来操作按钮
 */
- (UIButton *)addLeftButtonWithTitle:(NSString *)title
                       clickCallBack:(clickCallback)callback ;

- (UIButton *)addLeftButtonWithTitle:(NSString *)title
                               image:(UIImage *)image
                       clickCallBack:(clickCallback)callback ;

- (UIButton *)addLeftButtonWithImage:(UIImage *)image
                       clickCallBack:(clickCallback)callback ;

- (UIButton *)addLeftButtonWithTitle:(NSString *)title
                     backgroundImage:(UIImage *)backgroundImage
                       clickCallBack:(clickCallback)callback ;


- (UIButton *)addLeftButtonWithImage:(UIImage *)image
                          hightImage:(UIImage *)hightImage
                       clickCallBack:(clickCallback)callback ;

- (UIButton *)addLeftButtonWithTitle:(NSString *)title
                               image:(UIImage *)image
                          hightImage:(UIImage *)hightImage
                     backgroundImage:(UIImage *)backgroundImage
                       clickCallBack:(clickCallback)callback ;

/**
 * 从左边视图移除掉一个视图
 */
- (void)removeLeftView:(UIView *)view ;

/**
 * 左边所有的视图全部移除
 */
- (void)removeAllLeftButton ;

@end
