//
//  EasyNavigationView+AddView.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 2018/6/29.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationView+Add.h"

@implementation EasyNavigationView (Add)

- (void)addSubview:(UIView *)view callback:(clickCallback)callback
{
    [self addView:view clickCallback:callback type:NavigatioinViewPlaceTypeNone];
}

- (void)addTitleView:(UIView *)titleView
{
    [self addTitleView:titleView callback:nil];
}
- (void)addTitleView:(UIView *)titleView callback:(clickCallback)callback
{
    [self addView:titleView clickCallback:callback type:NavigatioinViewPlaceTypeCenter];
}


#pragma mark - 左添加按钮

- (UIButton *)addLeftButtonWithTitle:(NSString *)title
                            callback:(clickCallback)callback
{
    return [self addLeftButton:^EasyNavigationButton *{
        return [EasyNavigationButton button].setTitle(title);
    } callback:callback] ;
}
- (UIButton *)addLeftButtonWithImageName:(NSString *)imageName
                                callback:(clickCallback)callback
{
    return [self addLeftButton:^EasyNavigationButton *{
        return [EasyNavigationButton button].setImageName(imageName);
    } callback:callback] ;
}

- (UIButton *)addLeftButton:(EasyNavigationButton *(^)(void))button
                   callback:(clickCallback)callback
{
    EasyNavigationButton *btn = [EasyNavigationButton buttonWithConfig:button];
    [self addLeftView:btn callback:callback];
    return btn ;
}

- (void)addLeftView:(UIView *)view
           callback:(clickCallback)callback
{
    [self addView:view clickCallback:callback type:NavigatioinViewPlaceTypeLeft];
}

#pragma mark - 右边添加按钮

- (UIButton *)addRightButtonWithTitle:(NSString *)title
                             callback:(clickCallback)callback
{
    return [self addRightButton:^EasyNavigationButton *{
        return [EasyNavigationButton button].setTitle(title);
    } callback:callback] ;
}
- (UIButton *)addRightButtonWithImageName:(NSString *)imageName
                                 callback:(clickCallback)callback
{
    return [self addRightButton:^EasyNavigationButton *{
        return [EasyNavigationButton button].setImageName(imageName);
    } callback:callback] ;
}

- (UIButton *)addRightButton:(EasyNavigationButton *(^)(void))button
                    callback:(clickCallback)callback
{
    EasyNavigationButton *btn = [EasyNavigationButton buttonWithConfig:button];
    [self addRightView:btn callback:callback];
    return btn ;
}

- (void)addRightView:(UIView *)view
            callback:(clickCallback)callback
{
    [self addView:view clickCallback:callback type:NavigatioinViewPlaceTypeRight];
}

@end
