//
//  EasyNavigationView+RightButton.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/10/30.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationView.h"

@interface EasyNavigationView (RightButton)


/**
 * 往右边视图上加一个view。调用此方法把view加到视图的右边，将会和创建的按钮一同计算排列位置
 * view 需要添加到右视图的控件
 */
- (void)addRightView:(UIView *)view
      clickCallback:(clickCallback)callback ;

/**
 * 创建一个按钮并放到导航条的右边。会按照添加顺序，一个一个排列
 * title           按钮上的文字
 * image           按钮上的图片
 * hightImage      按钮按下(高亮)时的图片
 * backgroundImage 按钮的背景图片
 * callback        按钮的点击回调事件
 * return  创建的按钮指针,可以继续用来操作按钮
 */
- (UIButton *)addRightButtonWithTitle:(NSString *)title
                       clickCallBack:(clickCallback)callback ;

- (UIButton *)addRightButtonWithTitle:(NSString *)title
                               image:(UIImage *)image
                       clickCallBack:(clickCallback)callback ;

- (UIButton *)addRightButtonWithImage:(UIImage *)image
                       clickCallBack:(clickCallback)callback ;

- (UIButton *)addRightButtonWithTitle:(NSString *)title
                     backgroundImage:(UIImage *)backgroundImage
                       clickCallBack:(clickCallback)callback ;


- (UIButton *)addRightButtonWithImage:(UIImage *)image
                          hightImage:(UIImage *)hightImage
                       clickCallBack:(clickCallback)callback ;

- (UIButton *)addRightButtonWithTitle:(NSString *)title
                               image:(UIImage *)image
                          hightImage:(UIImage *)hightImage
                     backgroundImage:(UIImage *)backgroundImage
                       clickCallBack:(clickCallback)callback ;

/**
 * 从右边视图移除掉一个视图
 */
- (void)removeRightView:(UIView *)view ;

/**
 * 右边所有的视图全部移除
 */
- (void)removeAllRightButton ;
@end
