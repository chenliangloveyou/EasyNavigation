//
//  UIScrollView+EasyNavigationExt.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/13.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger ,EasyScrollDirection) {
    EasyScrollDirectionUnknow=0,
    EasyScrollDirectionUp,//向上滚动
    EasyScrollDirectionDown,//向下滚动
    
};

@interface UIScrollView (EasyNavigationExt)

/**
 * 开始改变方向标
 */
@property (nonatomic, assign)EasyScrollDirection Easy_direction;

/**
 * 开始改变方向时scrollview的距离
 */
@property (nonatomic, assign)float Easy_scrollDistance ;

/**
 *  是否正在动画
 */
//@property (nonatomic , assign)BOOL isScrolling ;


@property (nonatomic, assign) BOOL Easy_enableDirection;

@end
