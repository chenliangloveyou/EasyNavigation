//
//  EasyNavigationView+RightButton.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/10/30.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationView.h"

@interface EasyNavigationView (RightButton)

#pragma mark - 右边视图

- (void)addRightView:(UIView *)view clickCallback:(clickCallback)callback ;

- (UIButton *)addRightButtonWithTitle:(NSString *)title clickCallBack:(clickCallback)callback ;

- (UIButton *)addRightButtonWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage clickCallBack:(clickCallback)callback ;


- (UIButton *)addRightButtonWithImage:(UIImage *)image clickCallBack:(clickCallback)callback ;

- (UIButton *)addRightButtonWithImage:(UIImage *)image hightImage:(UIImage *)hightImage clickCallBack:(clickCallback)callback ;


- (void)removeRightView:(UIView *)view ;

- (void)removeAllRightButton ;

@end
