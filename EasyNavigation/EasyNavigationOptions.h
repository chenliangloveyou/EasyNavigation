//
//  EasyNavigationOptions.h
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/9/11.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

/**
 * 显示大标题的条件
 */
typedef NS_ENUM(NSUInteger , NavBigTitleType) {
    NavBigTitleTypeDefault = 1 << 0, //所有情况下都不使用大标题 (默认情况)
    NavBigTitleTypeIOS11   = 1 << 1 ,   //在iOS11系统上使用大标题
    NavBigTitleTypePlus    = 1 << 2 ,    //在plus尺寸上使用大标题（iphone6plus,iphone7plus,iphone8plus）
    NavBigTitleTypeIphoneX = 1 << 3 , //在iPhoneX上使用大标题
    NavBigTitleTypeAll     = 1 << 4 ,     //在所有尺寸和版本上都是用大标题
    NavBigTitleTypePlusOrX = NavBigTitleTypePlus | NavBigTitleTypeIphoneX , //在plus和X上使用大标题

};

/**
 * 显示大标题后，标题移动的动画类型
 */
typedef NS_ENUM(NSUInteger , NavTitleAnimationType) {
    NavTitleAnimationTypeLeftScale = 0,     //从左边缩放
    NavTitleAnimationTypeCenterScale = 1 ,  //从中间缩放
    NavTitleAnimationTypeSmoothFade = 2,    //流畅的动画
    NavTitleAnimationTypeStiffFade = 3 ,    //僵硬的动画
    
};

@interface EasyNavigationOptions : NSObject

/**
 * 导航条基本设置的单例，用来设置全局导航条属性。(当需要改变导航条属性时，需要对改变的导航条单独设置)
 * 只需在APPdelegate里面设置一次，全局适用。
 */
+ (instancetype)shareInstance ;

/**
 * 导航条是否使用大标题（如果在单个控制器中没有设置类型，就是使用这里设置的类型）
 */
@property (assign)NavBigTitleType navbigTitleType ;

/**
 * 导航条的透明度
 */
@property (nonatomic,assign)CGFloat backGroundAlpha ;

/**
 * 导航条的背景色
 */
@property (nonatomic,strong)UIColor *navBackGroundColor ;

/**
 * 导航条细线下的颜色
 */
@property (nonatomic,strong)UIColor *navLineColor ;

/**
 * 导航条的背景图片
 */
@property (nonatomic,strong)UIImage *navBackgroundImage ;


/**
 * titleLabel 字体大小
 */
@property (nonatomic,strong)UIFont  *titleFont ;
/**
 * titleLabel 字体颜色
 */
@property (nonatomic,strong)UIColor *titleColor ;


/**
 * 左右两边按钮字体大小
 */
@property (nonatomic,strong)UIFont  *buttonTitleFont ;

/**
 * 按钮字体颜色
 */
@property (nonatomic,strong)UIColor *buttonTitleColor ;

/**
 * 按钮高亮时的字体颜色
 */
@property (nonatomic,strong)UIColor *buttonTitleColorHieght ;


@end
