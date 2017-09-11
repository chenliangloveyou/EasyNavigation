//
//  UIViewController+EasyNavigationExt.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EasyNavigationViewController ;

#import "EasyNavigationView.h"

@interface UIViewController (EasyNavigationExt)

//返回手势是否可用
@property (nonatomic,assign)BOOL vcBackGestureEnabled ;

@property (nonatomic, weak) EasyNavigationViewController *vcEasyNavController ;


@property (nonatomic,strong)EasyNavigationView *navigationView ;


@end
