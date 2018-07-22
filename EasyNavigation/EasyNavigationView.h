//
//  EasyNavigationView.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EasyNavigationOptions.h"
#import "EasyNavigationButton.h"
#import "EasyNavigationScroll.h"

typedef void (^clickCallback)(UIView *view) ;

/**
 * 创建视图的位置，放在左边还是右边
 */
typedef NS_ENUM(NSUInteger , NavigatioinViewPlaceType) {
    NavigatioinViewPlaceTypeNone ,
    NavigatioinViewPlaceTypeLeft ,
    NavigatioinViewPlaceTypeRight ,
    NavigatioinViewPlaceTypeCenter ,
};

@class EasyNavigationButton ;

@interface EasyNavigationView : UIView


//背景视图，可以改变透明度，改变图片，
@property (nonatomic,strong,readonly)UIImageView *backgroundView ;

//下面的线条设置
@property (nonatomic,strong,readonly)UIView *lineView ;

//title设置
@property (nonatomic,strong,readonly)UILabel *titleLabel ;

//返回按钮设置
@property (nonatomic,strong)UIButton *navigationBackButton ;
/**
 * 导航栏返回按钮的事件（左上角的返回按钮，如果实现了它将不会调用库里面的pop或dismiss）
 */
@property (nonatomic,strong)clickCallback navigationBackButtonCallback ;



//可以加一大堆简便方法
//控件之间的距离
//比如两个按钮之前的间隔，titleview很长的时候，与左右两边按钮的间隔
//按钮与左右边缘的间隔
@property (nonatomic,assign)CGFloat viewEdgeSpece ;

//增加是否把view向下平移
//@property (nonatomic,assign)BOOL titleViewCenterFixed ;//titleVie永远居中显示。默认为yes。（当为No的时候，左边按钮特别多的时候，会把titleview往右边挤，导致不居中）


//重新布局导航条控件
- (void)layoutNavSubViews ;



#pragma mark - 添加视图
/**
 * 往导航栏上添加一个视图  NOTE:请使用”EasyNavigationView+Add“中的方法
 */
- (void)addView:(UIView *)view clickCallback:(clickCallback)callback type:(NavigatioinViewPlaceType)type ;


#pragma mark - 导航条滚动

- (void)navigationScrollWithScrollView:(UIScrollView *)scrollowView
                                config:(EasyNavigationScroll *(^)(void))config ;



#pragma mark - 废弃方法

//背景设备
//@property (nonatomic,strong,readonly)UIView *backgroundView ;
//@property (nonatomic,strong,readonly)UIImageView *backgroundImageView ;

@property (nonatomic,strong)NSString *title ;
/**
 * 导航条 左边/右边 所有视图
 */
@property (nonatomic,strong,readonly)NSMutableArray *leftViewArray ;
@property (nonatomic,strong,readonly)NSMutableArray *rightViewArray ;





//- (void)setTitle:(NSString *)title ;
/**
 * 设置导航栏的背景图片
 * 设置导航栏的透明度
 * 设置导航栏的背景颜色
 */
- (void)setNavigationBackgroundImage:(UIImage *)backgroundImage  ;
- (void)setNavigationBackgroundAlpha:(CGFloat)alpha  ;
- (void)setNavigationBackgroundColor:(UIColor *)color  ;

/**
 * 导航栏点击事件
 */
//- (void)statusBarTapWithCallback:(clickCallback)callback ;
//移除导航栏上的手势
//- (void)removeStatusBarCallback ;


/**
 * 创建一个按钮
 */
- (UIButton *)createButtonWithTitle:(NSString *)title
                    backgroundImage:(UIImage *)backgroundImage
                              image:(UIImage *)image
                         hightImage:(UIImage *)hieghtImage
                           callback:(clickCallback)callback
                               type:(NavigatioinViewPlaceType)type ;

- (void)removeView:(UIView *)view
              type:(NavigatioinViewPlaceType)type ;


@end
















