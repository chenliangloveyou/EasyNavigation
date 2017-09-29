//
//  EasyCustomBackGestureDelegate.h
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/9/14.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class EasyNavigationController  ;

@interface EasyCustomBackGestureDelegate : NSObject<UIGestureRecognizerDelegate>

/**
 * 当前当行控制器
 */
@property (nonatomic,weak)EasyNavigationController *navController ;

/**
 * 用来替换的系统手势事件
 */
@property (nonatomic,weak)id systemGestureTarget ;

@end
