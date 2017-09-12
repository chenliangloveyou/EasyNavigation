//
//  EasyNavigationView.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EasyNavigationOptions.h"   

typedef void(^clickCallback)(UIView *view);


@interface EasyNavigationView : UIView


@property (nonatomic,strong,readonly)UIImageView *backgroundImageView ;


@property (nonatomic,assign)BOOL lineHidden ;

@property (nonatomic,strong,readonly)UILabel *titleLabel ;

@property (nonatomic,strong,readonly)UIView *titleView ;

/**
 * 第一个加到导航栏左(右)边的按钮。（如果删除第一个，会替换成第二个，以此类推）
 * 如果想拿到第二个加上去的，在创建的时候返回。
 */
@property (nonatomic,strong,readonly)UIButton *leftButton ;
@property (nonatomic,strong,readonly)UIButton *rightButton ;

/**
 * 导航栏高度
 */
@property (nonatomic,assign,readonly)CGFloat navHeigth ;


- (void)setBackgroundImage:(UIImage *)backgroundImage ;

- (void)setBackgroundAlpha:(CGFloat)alpha ;

- (void)setTitle:(NSString *)title ;
- (void)addtitleView:(UIView *)titleView ;

- (void)addSubview:(UIView *)view clickCallback:(clickCallback)callback ;



#pragma mark - 视图滚动，导航条跟着变化
/**
 * 根据scrollview的滚动，导航条慢慢渐变
 * startPoint alpha开始改变的坐标
 * endPoint alpha停止改变的坐标
 */
- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow ;

- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow start:(CGFloat)startPoint end:(CGFloat)endPoint ;
/**
 * 根据scrollview滚动，导航条隐藏或者展示.
 */
- (void)navigationScrollStopStateBarWithScrollow:(UIScrollView *)scrollow ;

/**
 * scorllow滚动，导航栏跟着滚动，最终停在状态栏下
 */
- (void)navigationScrollWithScrollow:(UIScrollView *)scrollow ;



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


- (void)removeLeftView:(UIView *)view ;

- (void)removeAllLeftButton ;



#pragma mark - 右边视图

- (void)addRightView:(UIView *)view clickCallback:(clickCallback)callback ;

- (UIButton *)addRightButtonWithTitle:(NSString *)title clickCallBack:(clickCallback)callback ;

- (UIButton *)addRightButtonWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage clickCallBack:(clickCallback)callback ;


- (UIButton *)addRightButtonWithImage:(UIImage *)image clickCallBack:(clickCallback)callback ;

- (UIButton *)addRightButtonWithImage:(UIImage *)image hightImage:(UIImage *)hightImage clickCallBack:(clickCallback)callback ;


- (void)removeRightView:(UIView *)view ;

- (void)removeAllRightButton ;



@end












