//
//  EasyNavigationView+AddView.h
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 2018/6/29.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationView.h"

@interface EasyNavigationView (Add)


#pragma mark - 添加一个单纯的view，不会布局该控件

//其实和 addsubview：相比  就多了一个 callback的点击回调方法。
- (void)addSubview:(UIView *)view callback:(clickCallback)callback ;


#pragma mark - 添加一个titleview，和titlelabel互斥，永远只会有一个存在

//中间视图永远只有一个，并且和leftbutton，rightbutton会有为位置的排列。
- (void)addTitleView:(UIView *)titleView ;
- (void)addTitleView:(UIView *)titleView callback:(clickCallback)callback ;


#pragma mark - 往左边添加一个button或者view

- (UIButton *)addLeftButtonWithTitle:(NSString *)title
                            callback:(clickCallback)callback ;

- (UIButton *)addLeftButtonWithImageName:(NSString *)imageName
                                callback:(clickCallback)callback ;

- (UIButton *)addLeftButton:(EasyNavigationButton *(^)(void))button
                   callback:(clickCallback)callback ;

- (void)addLeftView:(UIView *)view
           callback:(clickCallback)callback ;


#pragma mark - 往又边添加一个button或者view

- (UIButton *)addRightButtonWithTitle:(NSString *)title
                             callback:(clickCallback)callback ;

- (UIButton *)addRightButtonWithImageName:(NSString *)imageName
                                 callback:(clickCallback)callback ;

- (UIButton *)addRightButton:(EasyNavigationButton *(^)(void))button
                    callback:(clickCallback)callback ;

- (void)addRightView:(UIView *)view
            callback:(clickCallback)callback ;



@end
