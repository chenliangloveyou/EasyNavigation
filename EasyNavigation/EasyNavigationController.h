//
//  EasyNavigationController.h
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/9/10.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

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


@interface EasyNavigationController : UINavigationController<UIGestureRecognizerDelegate>

@property (nonatomic,assign)BOOL isSystemNavigationBar ;//是否展示自带的导航条

@property (nonatomic,strong,readonly)UIPanGestureRecognizer *customBackGesture ;//自定义侧滑返回

@property (nonatomic,strong,readonly)EasyCustomBackGestureDelegate *customBackGestureDelegate ;//自定义返回的代理


@end
