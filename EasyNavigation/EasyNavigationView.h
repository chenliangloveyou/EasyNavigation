//
//  EasyNavigationView.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EasyNavigationOptions.h"   

/**
 * 创建视图的位置，放在左边还是右边
 */
typedef NS_ENUM(NSUInteger , buttonPlaceType) {
    buttonPlaceTypeLeft ,
    buttonPlaceTypeRight ,
};

/**
 * 导航条改变的类型
 */
typedef NS_ENUM(NSUInteger , NavigationChangeType) {
    NavigationChangeTypeUnKnow ,
    NavigationChangeTypeAlphaChange ,
    NavigationChangeTypeAnimation ,
    NavigationChangeTypeSmooth ,
};

typedef void(^clickCallback)(UIView *view);


@interface EasyNavigationView : UIView

@property (nonatomic,assign) CGFloat scrollingSpeed ;     //导航条滚动速度
@property (nonatomic,strong) UIScrollView *kvoScrollView ;//用于监听scrollview内容高度的改变

@property (nonatomic,strong)UIView *backgroundView ;

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
 * 导航栏初始高度（刚初始化页面，没有对导航条操作是的高度）
 * 竖屏：statusBar的高度 + 正常高度 + 大标题高度(如果显示)
 * 横屏：statusBar的高度(如果显示) + 正常高度
 */
@property (nonatomic,assign,readonly)CGFloat navigationOrginalHeight ;

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
- (void)addTitleView:(UIView *)titleView ;

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



/**
 * 导航条 左边所有视图
 */
@property (nonatomic,strong)NSMutableArray *leftViewArray ;

/**
 * 导航条 右边所有视图
 */
@property (nonatomic,strong)NSMutableArray *rightViewArray ;//右边所有的视图

#pragma mark - 私有方法

/**
 * 创建一个按钮
 */
- (UIButton *)createButtonWithTitle:(NSString *)title
                    backgroundImage:(UIImage *)backgroundImage
                              image:(UIImage *)image
                         hightImage:(UIImage *)hieghtImage
                           callback:(clickCallback)callback
                               type:(buttonPlaceType)type ;

/**
 * 往左右两天添加一个视图
 */
- (void)addView:(UIView *)view
  clickCallback:(clickCallback)callback
           type:(buttonPlaceType)type ;
@end












