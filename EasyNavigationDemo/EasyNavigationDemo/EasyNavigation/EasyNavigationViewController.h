//
//  EasyNavigationViewController.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 需求：
 * 1）有系统渐变返回 ，无系统渐变返回
 * 2）是否有系统侧滑返回
 * 3）滚动scrollview会改变导航条的透明度
 * 4）滚动scrollview导航条也跟着滚动，最后停在20的位置
 * 5）动画翻页
 * 
 */
@interface EasyNavigationViewController : UINavigationController







@property (nonatomic, strong) UIImage *backButtonImage;

@property (nonatomic, assign) BOOL backGestureEnabled;

@property (nonatomic, copy, readonly) NSArray *easyViewControllers;


@end








