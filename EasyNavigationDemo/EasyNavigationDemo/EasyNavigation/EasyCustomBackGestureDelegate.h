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

@property (nonatomic,weak)EasyNavigationController *navController ;

@property (nonatomic,weak)id systemGestureTarget ;

@end
