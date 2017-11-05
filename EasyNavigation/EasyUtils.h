//
//  EasyUtils.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//屏幕宽高
#define  SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define  SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
//屏幕的高度
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))

//屏幕是否是横屏状态
#define ISHORIZONTALSCREEM UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)
//retain屏
#define ISRETAIN ([[UIScreen mainScreen] scale] >= 2.0)
//屏幕尺寸判断
#define ISIPHONE   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define ISIPHONE_4  (ISIPHONE && SCREEN_MAX_LENGTH == 480.0f)  // 4/4s            3.5寸   320*480
#define ISIPHONE_5  (ISIPHONE && SCREEN_MAX_LENGTH == 568.0f)  // 5/5s/se           4寸   320*568
#define ISIPHONE_6  (ISIPHONE && SCREEN_MAX_LENGTH == 667.0f)  // 6/6s/7/8        4.7寸   375*667
#define ISIPHONE_6P (ISIPHONE && SCREEN_MAX_LENGTH == 736.0f)  // 6p/6ps/7p/8p    5.5寸   414*736
#define ISIPHONE_X  (ISIPHONE && SCREEN_MAX_LENGTH == 812.0f)  // iPhonex         5.8寸   375*812

//iOS版本判断
#define SYSTEM_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IS_IOS7_OR_LATER (SYSTEM_VERSION >= 7.0)
#define IS_IOS8_OR_LATER (SYSTEM_VERSION >= 8.0)
#define IS_IOS9_OR_LATER (SYSTEM_VERSION >= 9.0)
#define IS_IOS10_OR_LATER (SYSTEM_VERSION >= 10.0)
#define IS_IOS11_OR_LATER (SYSTEM_VERSION >= 11.0)


//statusbar默认高度 orginal
#define STATUSBAR_ORGINAL_HEIGHT  ([UIApplication sharedApplication].statusBarFrame.size.height)

//导航栏原始高度
#define kNavNormalHeight 44.0f

//大标题增加出来的高度
#define kNavBigTitleHeight 55.0f

//状态栏高度
#define STATUSBAR_HEIGHT (ISHORIZONTALSCREEM ? (ISIPHONE_X ? 0 : STATUSBAR_ORGINAL_HEIGHT) : STATUSBAR_ORGINAL_HEIGHT )



//去掉导航栏后的view的frame
#define TABLE_FRAME CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH,SCREEN_HEIGHT-NAV_HEIGHT )


/****图片****/
#define kImage(image)   [UIImage imageNamed:image]
//bundle中的图片
#define EasyImageFile(file) [@"EasyNavButton.bundle" stringByAppendingPathComponent:file]


//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

// 是否为空
#define ISEMPTY(_v) (_v == nil || _v.length == 0)

/**打印****/
#define ISSHOWLOG 0
#define EasyLog(fmt, ...) if(ISSHOWLOG) { NSLog(fmt,##__VA_ARGS__); }


/*随机颜色*/
#define kColorRandom kColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define kColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

/***通知***/
#define EasyNotificaiotn [NSNotificationCenter defaultCenter]
#define EasyNotificationAdd(kSelector,kName) [EasyNotificaiotn addObserver:self selector:@selector(kSelector) name:kName object:nil];
#define EasyNotificationPost(kName) [EasyNotificaiotn postNotificationName:kName object:nil];
#define EasyNotificationRemove(kName) [EasyNotificaiotn removeObserver:self name:kName object:nil];



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


@interface EasyUtils : NSObject


//根据颜色创建一个图片
+ (UIImage *)createImageWithColor:(UIColor *)color ;

// 改变图片的颜色
+ (UIImage *) imageWithTintColor:(UIImage *)image color:(UIColor *)tintColor ;

//调整图片大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size ;
@end







