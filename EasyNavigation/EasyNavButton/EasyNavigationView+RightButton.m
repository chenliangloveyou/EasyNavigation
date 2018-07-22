//
//  EasyNavigationView+RightButton.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/10/30.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationView+RightButton.h"

@implementation EasyNavigationView (RightButton)


- (void)addRightView:(UIView *)view clickCallback:(clickCallback)callback
{
    [self addView:view
    clickCallback:callback
             type:NavigatioinViewPlaceTypeRight];
}

- (UIButton *)addRightButtonWithTitle:(NSString *)title
                       clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:title
                       backgroundImage:nil
                                 image:nil
                            hightImage:nil
                              callback:callback
                                  type:NavigatioinViewPlaceTypeRight];
}
- (UIButton *)addRightButtonWithTitle:(NSString *)title
                               image:(UIImage *)image
                       clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:title
                       backgroundImage:nil
                                 image:image
                            hightImage:nil
                              callback:callback
                                  type:NavigatioinViewPlaceTypeRight];
}
- (UIButton *)addRightButtonWithTitle:(NSString *)title
                     backgroundImage:(UIImage *)backgroundImage
                       clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:title
                       backgroundImage:backgroundImage
                                 image:nil
                            hightImage:nil
                              callback:callback
                                  type:NavigatioinViewPlaceTypeRight];
}

- (UIButton *)addRightButtonWithImage:(UIImage *)image
                       clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:nil
                       backgroundImage:nil
                                 image:image
                            hightImage:nil
                              callback:callback
                                  type:NavigatioinViewPlaceTypeRight];
}

- (UIButton *)addRightButtonWithImage:(UIImage *)image
                          hightImage:(UIImage *)hightImage
                       clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:nil
                       backgroundImage:nil
                                 image:image
                            hightImage:hightImage
                              callback:callback
                                  type:NavigatioinViewPlaceTypeRight];
}
- (UIButton *)addRightButtonWithTitle:(NSString *)title
                               image:(UIImage *)image
                          hightImage:(UIImage *)hightImage
                     backgroundImage:(UIImage *)backgroundImage
                       clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:title
                       backgroundImage:backgroundImage
                                 image:image
                            hightImage:hightImage
                              callback:callback
                                  type:NavigatioinViewPlaceTypeRight];
}




- (void)removeRightView:(UIView *)view
{
    [self removeView:view type:NavigatioinViewPlaceTypeRight];
}

//- (void)removeAllRightButton
//{
//    for (UIView *tempView in self.rightViewArray) {
//        [self removeView:tempView type:NavigatioinViewPlaceTypeRight];
//    }
//}



@end
