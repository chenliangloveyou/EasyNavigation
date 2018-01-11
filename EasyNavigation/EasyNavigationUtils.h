//
//  EasyNavigationUtils.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



//屏幕宽度
CG_INLINE CGFloat ScreenWidth_N(void){
    return [[UIScreen mainScreen] bounds].size.width ;
}

//屏幕高度
CG_INLINE CGFloat ScreenHeight_N(void){
    return [[UIScreen mainScreen] bounds].size.height ;
}

//屏幕最大的宽度
CG_INLINE CGFloat ScreenMaxWidth_N(void){
    return MAX(ScreenWidth_N(),ScreenHeight_N()) ;
}

//状态栏最大的宽度
CG_INLINE CGFloat StatusBarMaxWidth_N(void){
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    return MAX(CGRectGetMaxX(statusBarFrame), CGRectGetMaxY(statusBarFrame)) ;
}

//屏幕是否处于横屏状态
CG_INLINE BOOL ScreenIsHorizontal_N(void){
    return StatusBarMaxWidth_N == ScreenMaxWidth_N ;
}

//导航栏原始高度 （导航栏高度除去satatusbar后的高度）
CG_INLINE CGFloat NavigationNorlmalHeight_N(void){
    return 44.0f ;
}

//导航栏大标题增加出来的高度
CG_INLINE CGFloat NavigationBigTitleAdditionHeight_N(void){
    return 55.0f ;
}

//状态栏初始高度
CG_INLINE CGFloat StatusBarOrginalHeight_N(void){
    
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    CGFloat statusBarOffset = MIN(CGRectGetMaxX(statusBarFrame), CGRectGetMaxY(statusBarFrame));
    if (statusBarOffset == 40.0f) {
        statusBarOffset -= 20.0f;
    }
    return statusBarOffset ;
}

//是否是iPhoneX
CG_INLINE BOOL IsIphoneX_N(void){
    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)&&(ScreenMaxWidth_N()==812.0f) ;
}
//状态栏高度
CG_INLINE CGFloat StatusBarHeight_N(void){
    return (ScreenIsHorizontal_N()&&IsIphoneX_N()) ? 0 : StatusBarOrginalHeight_N() ;
}
//导航栏高度
CG_INLINE CGFloat NavigationHeight_N(void){
    return NavigationNorlmalHeight_N() + StatusBarHeight_N();
}

/*
 *
 *
 *
 **** **********************************************
 * 以下注释掉的内容，如果在工程中其他地方用到，可以用上面的inline函数，给您带来不便，请谅解。
 **********************************************
 *
 *
 *
 *
 */
//屏幕宽高
//#define  SCREEN_WIDTH_N [[UIScreen mainScreen] bounds].size.width
//#define  SCREEN_HEIGHT_N [[UIScreen mainScreen] bounds].size.height
//
////屏幕的最大高度
//#define SCREEN_MAX_LENGTH_N (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
////状态栏的宽度
//#define STATUSBAR_MAX_LENGTH_N  MAX([UIApplication sharedApplication].statusBarFrame.size.height, [UIApplication sharedApplication].statusBarFrame.size.width)
//
////是否处于横屏状态
//#define ISHORIZONTA_N  (STATUSBAR_MAX_LENGTH_N == SCREEN_MAX_LENGTH_N)
//
////导航栏原始高度
//#define kNavNormalHeight_N 44.0f
//
////大标题增加出来的高度
//#define kNavBigTitleHeight_N 55.0f
//
////状态栏初始高度
//#define kStatusBarHeight_N  ([UIApplication sharedApplication].statusBarFrame.size.height)
////状态栏高度
//#define kStatusBarHeight_N ((ISHORIZONTA_N&&ISIPHONE_X) ? 0 : kStatusBarHeight_N )


//retain屏
//#define ISRETAIN ([[UIScreen mainScreen] scale] >= 2.0)
//屏幕尺寸判断
//#define ISIPHONE_4  (ISIPHONE && SCREEN_MAX_LENGTH == 480.0f)  // 4/4s            3.5寸   320*480
//#define ISIPHONE_5  (ISIPHONE && SCREEN_MAX_LENGTH == 568.0f)  // 5/5s/se           4寸   320*568
//#define ISIPHONE_6  (ISIPHONE && SCREEN_MAX_LENGTH == 667.0f)  // 6/6s/7/8        4.7寸   375*667
//#define ISIPHONE_6P (ISIPHONE && SCREEN_MAX_LENGTH == 736.0f)  // 6p/6ps/7p/8p    5.5寸   414*736

//iOS版本判断
//#define SYSTEM_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
//#define IS_IOS7_OR_LATER (SYSTEM_VERSION >= 7.0)
//#define IS_IOS8_OR_LATER (SYSTEM_VERSION >= 8.0)
//#define IS_IOS9_OR_LATER (SYSTEM_VERSION >= 9.0)
//#define IS_IOS10_OR_LATER (SYSTEM_VERSION >= 10.0)
//#define IS_IOS11_OR_LATER (SYSTEM_VERSION >= 11.0)


//bundle中的图片
#define EasyImageFile_N(file) [@"EasyNavButton.bundle" stringByAppendingPathComponent:file]


//强弱引用
//#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
//#define kStrongSelf(type) __strong typeof(type) type = weak##type;

// 是否为空
#define ISEMPTY_N(_v) (_v == nil || _v.length == 0)

/**打印****/
#define ISSHOWNAVIGATIONLOG 0
#define EasyLog_N(fmt, ...) if(ISSHOWNAVIGATIONLOG) { NSLog(fmt,##__VA_ARGS__); }


/*随机颜色*/
#define kColorRandom_N kColor_N(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define kColor_N(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


/**
 * 显示大标题的条件
 */
typedef NS_ENUM(NSUInteger , NavBigTitleType) {
    NavBigTitleTypeUnknow  = 0 ,     //没有设置大标题属性
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


@interface EasyNavigationUtils : NSObject


//根据颜色创建一个图片
+ (UIImage *)createImageWithColor:(UIColor *)color ;

// 改变图片的颜色
+ (UIImage *) imageWithTintColor:(UIImage *)image color:(UIColor *)tintColor ;

//调整图片大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size ;
@end







