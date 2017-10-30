//
//  EasyNavigationView+LeftButton.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/10/30.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationView.h"

@interface EasyNavigationView (LeftButton)

#pragma mark - 左边视图

/**
 * 往左边视图上加一个view
 */
- (void)addLeftView:(UIView *)view clickCallback:(clickCallback)callback ;

/**
 * 创建一个按钮并放到左边视图上
 */
- (UIButton *)addLeftButtonWithTitle:(NSString *)title clickCallBack:(clickCallback)callback ;

- (UIButton *)addLeftButtonWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage clickCallBack:(clickCallback)callback ;

- (UIButton *)addLeftButtonWithImage:(UIImage *)image clickCallBack:(clickCallback)callback ;

- (UIButton *)addLeftButtonWithImage:(UIImage *)image hightImage:(UIImage *)hightImage clickCallBack:(clickCallback)callback ;

- (UIButton *)addLeftButtonWithTitle:(NSString *)title image:(UIImage *)image hightImage:(UIImage *)hightImage backgroundImage:(UIImage *)backgroundImage clickCallBack:(clickCallback)callback ;


- (void)removeLeftView:(UIView *)view ;

- (void)removeAllLeftButton ;

@end
