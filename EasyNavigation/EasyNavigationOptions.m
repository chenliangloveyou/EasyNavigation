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
        
        _navbigTitleType = NavBigTitleTypeDefault ;
        _navTitleAnimationType = NavTitleAnimationTypeStiffFade ;
        
        _backGroundAlpha = 0.9 ;
        
        _navBackGroundColor = [UIColor whiteColor];
        _navLineColor = [UIColor groupTableViewBackgroundColor];
        
        _titleFont = [UIFont boldSystemFontOfSize:18];
        _titleBigFount = [UIFont boldSystemFontOfSize:35] ;
        _titleColor = [UIColor darkTextColor];
        
        _buttonTitleFont = [UIFont systemFontOfSize:16];
        _buttonTitleColor = [UIColor blueColor] ;
        _buttonTitleColorHieght = [UIColor darkTextColor];
        
    }
    return self ;
}


- (void)setBackGroundAlpha:(CGFloat)backGroundAlpha
{
    if (_backGroundAlpha < 0) {
        _backGroundAlpha = 0 ;
        NSAssert(NO, @"backGroundAlpha is illegal");
    }
    _backGroundAlpha = backGroundAlpha ;
}

- (void)setNavBackGroundColor:(UIColor *)navBackGroundColor
{
    if ([navBackGroundColor isKindOfClass:[UIColor class]]) {
        _navBackGroundColor = navBackGroundColor ;
    }
    else{
        NSAssert(NO, @"navBackGroundColor is illegal");
    }
}

- (void)setNavLineColor:(UIColor *)navLineColor
{
    if ([navLineColor isKindOfClass:[UIColor class]]) {
        _navLineColor = navLineColor ;
    }
    else{
        NSAssert(NO, @"navLineColor is illegal");
    }
}

- (void)setNavBackgroundImage:(UIImage *)navBackgroundImage
{
    if ([navBackgroundImage isKindOfClass:[UIImage class]]) {
        _navBackgroundImage = navBackgroundImage ;
    }
    else{
        NSAssert(NO, @"navBackgroundImage is illegal");
    }
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if ([titleFont isKindOfClass:[UIFont class]]) {
        _titleFont = titleFont ;
    }
    else{
        NSAssert(NO, @"titleFont is illegal");
    }
}
    
- (void)setTitleColor:(UIColor *)titleColor
{
    if ([titleColor isKindOfClass:[UIColor class]]) {
        _titleColor = titleColor ;
    }
    else{
        NSAssert(NO, @"titleColor is illegal");
    }
}

- (void)setButtonTitleFont:(UIFont *)buttonTitleFont
{
    if ([buttonTitleFont isKindOfClass:[UIFont class]]) {
        _buttonTitleFont = buttonTitleFont ;
    }
    else{
        NSAssert(NO, @"buttonTitleFont is illegal");
    }
}

- (void)setButtonTitleColor:(UIColor *)buttonTitleColor
{
    if ([buttonTitleColor isKindOfClass:[UIColor class]]) {
        _buttonTitleColor = buttonTitleColor ;
    }
    else{
        NSAssert(NO, @"buttonTitleColor is illegal");
    }
}

- (void)setButtonTitleColorHieght:(UIColor *)buttonTitleColorHieght
{
    if ([buttonTitleColorHieght isKindOfClass:[UIColor class]]) {
        _buttonTitleColorHieght = buttonTitleColorHieght ;
    }
    else{
        NSAssert(NO, @"buttonTitleColorHieght is illegal");
    }
}


@end
