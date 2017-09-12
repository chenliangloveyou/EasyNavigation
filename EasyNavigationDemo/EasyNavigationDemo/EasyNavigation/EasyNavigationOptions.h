//
//  EasyNavigationOptions.h
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/9/11.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface EasyNavigationOptions : NSObject

+ (instancetype)shareInstance ;

@property (nonatomic,assign)CGFloat backGroundAlpha ;

@property (nonatomic,strong)UIColor *navBackGroundColor ;
@property (nonatomic,strong)UIColor *navLineColor ;

@property (nonatomic,strong)UIFont  *titleFont ;//title的字体大小
@property (nonatomic,strong)UIColor *titleColor ;//title的字体颜色

@property (nonatomic,strong)UIFont  *buttonTitleFont ;//按钮上字体大小
@property (nonatomic,strong)UIColor *buttonBackgroundColor ;//按钮的背景色
@property (nonatomic,strong)UIColor *buttonTitleColor ;//按钮字体颜色
@property (nonatomic,strong)UIColor *buttonTitleColorHieght ;//按钮高亮时的颜色



@end
