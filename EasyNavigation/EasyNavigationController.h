//
//  EasyNavigationController.h
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/9/10.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EasyCustomBackGestureDelegate.h"

@interface EasyNavigationController : UINavigationController<UIGestureRecognizerDelegate>

@property (nonatomic,assign)BOOL isSystemNavigationBar ;//是否展示自带的导航条

@property (nonatomic,strong,readonly)UIPanGestureRecognizer *customBackGesture ;//自定义侧滑返回

@property (nonatomic,strong,readonly)EasyCustomBackGestureDelegate *customBackGestureDelegate ;//自定义返回的代理


@end
