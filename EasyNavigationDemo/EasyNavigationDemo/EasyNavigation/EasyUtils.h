//
//  EasyUtils.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//屏幕宽度
#define  SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
//屏幕高度
#define  SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

//导航栏高度
#define NAV_HEIGHT 64.0f


//去除状体栏的屏幕高度
#define  SCREEN_HEIGHT_EXCEPTSTATUS (SCREEN_HEIGHT - 20.0f)
//去除状体栏和顶部导航栏之后的屏幕高度
#define  SCREEN_HEIGHT_EXCEPTNAV (SCREEN_HEIGHT - NAV_HEIGHT)
//去除状体栏,顶部导航栏和底部工具栏之后的屏幕高度
#define  SCREEN_HEIGHT_EXCEPTNAVANDTAB (SCREEN_HEIGHT - 110.0f)

//ipad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//retain屏
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
//屏幕的高度
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))


#define isIphone4 (IS_IPHONE && SCREEN_MAX_LENGTH == 480.0f)// 4/4s     3.5寸   320*480
#define isIphone5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0) // 5/5s/se  4寸     320*568
#define isIphone6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0) // 6/6s     4.7寸   375*667
#define isIphone6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)// 6p/6ps   5.5寸   414*736

#define VERSION_IOS10_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0
#define VERSION_IOS9_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0
#define VERSION_IOS8_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define VERSION_IOS7_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

//去掉导航栏后的view的frame
#define TABLE_FRAME CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT_EXCEPTNAV)

//IOS7以上状态栏高度
#define   TOP_DICTANCE ((SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))?20:0)




//强弱引用
#define kWeakSelf(type)__weak typeof(type)weak##type = type;
#define kStrongSelf(type)__strong typeof(type)type = weak##type;


@interface EasyUtils : NSObject

//根据颜色创建一个图片
+ (UIImage *)createImageWithColor:(UIColor *)color ;

// 改变图片的颜色
+ (UIImage *) imageWithTintColor:(UIImage *)image color:(UIColor *)tintColor ;

@end







