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

/**
 * 导航栏的背景视图
 */
@property (nonatomic,strong,readonly)UIImageView *backgroundImageView ;

/**
 * 是否隐藏导航栏下面的细线
 */
@property (nonatomic,assign)BOOL lineHidden ;

/**
 * 导航栏的标题
 */
@property (nonatomic,strong,readonly)UILabel *titleLabel ;

/**
 * 导航条下的细线
 */
@property (nonatomic,strong)UIView *lineView ;//导航条最下面的一条线

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

/**
 * 是否正在展示大标题
 */
@property (nonatomic,assign,readonly)BOOL isShowBigTitle ;

#pragma mark - 设置属性

/**
 * 设置导航栏的背景图片
 */
- (void)setNavigationBackgroundImage:(UIImage *)backgroundImage ;

/**
 * 设置导航栏的透明度
 */
- (void)setNavigationBackgroundAlpha:(CGFloat)alpha ;

/**
 * 设置导航栏的背景颜色
 */
- (void)setNavigationBackgroundColor:(UIColor *)color ;

/**
 * 设置导航栏的title
 */
- (void)setTitle:(NSString *)title ;

/**
 * 设置导航栏的titleview
 */
- (void)addtitleView:(UIView *)titleView ;

/**
 * 向导航栏上添加一个视图
 */
- (void)addSubview:(UIView *)view clickCallback:(clickCallback)callback ;

/**
 * 导航栏点击事件
 */
- (void)statusBarTapWithCallback:(clickCallback)callback ;
//移除导航栏上的手势
//- (void)removeStatusBarCallback ;


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



#pragma mark - 视图滚动，导航条跟着变化

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












