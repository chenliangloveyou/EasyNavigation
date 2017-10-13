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


//statusbar默认高度
#define STATUS_H  ([UIApplication sharedApplication].statusBarFrame.size.height)

//状态栏高度
#define NAV_STATE_HEIGHT (ISHORIZONTALSCREEM ? (ISIPHONE_X ? 0 : STATUS_H) : STATUS_H )

//导航栏高度
#define NAV_HEIGHT (NAV_STATE_HEIGHT + 44.0f)



//去掉导航栏后的view的frame
#define TABLE_FRAME CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH,SCREEN_HEIGHT-NAV_HEIGHT )


/****图片****/
#define kImage(image)   [UIImage imageNamed:image]
//bundle中的图片
#define EasyImageFile(file) [@"EasyNavButton.bundle" stringByAppendingPathComponent:file]


//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;


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



@interface EasyUtils : NSObject


//根据颜色创建一个图片
+ (UIImage *)createImageWithColor:(UIColor *)color ;

// 改变图片的颜色
+ (UIImage *) imageWithTintColor:(UIImage *)image color:(UIColor *)tintColor ;


@end







