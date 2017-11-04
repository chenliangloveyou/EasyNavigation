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


/**
 * 导航条滚动，大标题(如果有) 改变的驱动力。会根据这个scrollview的滚动而滚动
 * 
 */
@property (nonatomic,strong)UIScrollView *scrollview ;

/**
 * 导航栏的背景视图
 */
@property (nonatomic,strong)UIView *backgroundView ;

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


//改变导航条的高度
- (void)changeNavigationHeight ;

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





/**
 * 第一个加到导航栏左(右)边的按钮。（如果删除第一个，会替换成第二个，以此类推）
 * 如果想拿到第二个加上去的，在创建的时候返回。
 */
@property (nonatomic,strong,readonly)UIButton *leftButton ;
@property (nonatomic,strong,readonly)UIButton *rightButton ;

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












