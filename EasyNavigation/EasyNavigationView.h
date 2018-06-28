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
@property (nonatomic,strong,readonly)UIImageView *backgroundImageView ;

//下面的线条设置
@property (nonatomic,strong,readonly)UIView *lineView ;

//title设置
@property (nonatomic,strong,readonly)UILabel *titleLabel ;

//返回按钮设置
@property (nonatomic,strong)UIButton *navigationBackButton ;


/**
 * 导航条 左边/右边 所有视图
 */
@property (nonatomic,strong,readonly)NSMutableArray *leftViewArray ;
@property (nonatomic,strong,readonly)NSMutableArray *rightViewArray ;

//重新布局导航条控件
- (void)layoutNavSubViews ;




#pragma mark - 私有方法
/**
 * 创建一个按钮
 */
- (UIButton *)createButtonWithTitle:(NSString *)title
                    backgroundImage:(UIImage *)backgroundImage
                              image:(UIImage *)image
                         hightImage:(UIImage *)hieghtImage
                           callback:(clickCallback)callback
                               type:(NavigatioinViewPlaceType)type ;
/**
 * 往左右两边 添加/删除 一个视图
 */
- (void)addView:(UIView *)view
  clickCallback:(clickCallback)callback
           type:(NavigatioinViewPlaceType)type ;
- (void)removeView:(UIView *)view
              type:(NavigatioinViewPlaceType)type ;


#pragma mark - 导航条滚动

/**
 * 导航条的alpha跟随 scrollview 的滚动而改变。
 *
 * startPoint/endPoint  alpha 开始/停止 改变alpha的坐标。  中间会根据这个end-start区间均匀变化。
 */
- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow ;

- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow
                                        start:(CGFloat)startPoint
                                          end:(CGFloat)endPoint ;

/**
 *  导航条随scrollview滚动而慢慢隐藏
 *
 * scrollow      为支持导航条渐变的scrollview，
 * startPoint    开始渐变scrollow需要滚动的距离，也就是说，只有在self.tableView滚动NAV_HEIGHT后导航条才开始移动。
 * speed         它的值为:导航条滚动距离/scrollow滚动距离
 * stopStatusBar 到了状态栏下面的时候是否需要停止
 */
- (void)navigationSmoothScroll:(UIScrollView *)scrollow
                         start:(CGFloat)startPoint
                         speed:(CGFloat)speed
               stopToStatusBar:(BOOL)stopStatusBar ;

/**
 * 超过临界点用一个UIview动画来 隐藏/显示 导航栏
 *
 * scrollow      为支持导航条渐变的scrollview
 * criticalPoint 为触发导航条隐藏的点。也就是当scrollview的contentOffset.y值操作这个数的时候，导航条就会隐藏
 * stopStatusBar 停止到startBar下面
 */
- (void)navigationAnimationScroll:(UIScrollView *)scrollow
                    criticalPoint:(CGFloat)criticalPoint
                  stopToStatusBar:(BOOL)stopStatusBar ;



#pragma mark - 废弃方法

//背景设备
@property (nonatomic,strong,readonly)UIView *backgroundView ;

@property (nonatomic,strong)NSString *title ;
/**
 * 导航栏返回按钮 （左上角）
 * 可以用来改变外观，改变事件请用下面的navigationBackButtonCallback。
 *
 * 导航栏返回按钮的事件 （左上角的返回按钮，如果实现了它将不会调用库里面的popViewControllerAnimated：）
 */
@property (nonatomic,strong)clickCallback navigationBackButtonCallback ;




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
- (void)statusBarTapWithCallback:(clickCallback)callback ;
//移除导航栏上的手势
//- (void)removeStatusBarCallback ;




@end
















