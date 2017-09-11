//
//  EasyNavigationOptions.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/9/11.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationOptions.h"

@implementation EasyNavigationOptions

+ (instancetype)shareInstance
{
    static EasyNavigationOptions *share = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[EasyNavigationOptions alloc]init];
    });
    return share;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _navBackGroundColor = [UIColor whiteColor];
        _navLineColor = [UIColor lightGrayColor];
        
        _titleFont = [UIFont boldSystemFontOfSize:18];
        _titleColor = [UIColor darkTextColor];
        
        _buttonTitleFont = [UIFont systemFontOfSize:16];
        _buttonBackgroundColor = [UIColor lightTextColor];
        _buttonTitleColor = [UIColor blueColor] ;
        _buttonTitleColorHieght = [UIColor darkTextColor];
        
    }
    return self ;
}
@end
