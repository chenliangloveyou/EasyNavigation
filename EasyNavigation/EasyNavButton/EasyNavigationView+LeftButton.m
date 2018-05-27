//
//  EasyNavigationView+LeftButton.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/10/30.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationView+LeftButton.h"

@implementation EasyNavigationView (LeftButton)


- (void)addLeftView:(UIView *)view clickCallback:(clickCallback)callback
{
    [self addView:view
    clickCallback:callback
             type:buttonPlaceTypeLeft];
}

- (UIButton *)addLeftButtonWithTitle:(NSString *)title
                       clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:title
                       backgroundImage:nil
                                 image:nil
                            hightImage:nil
                              callback:callback
                                  type:buttonPlaceTypeLeft];
}
- (UIButton *)addLeftButtonWithTitle:(NSString *)title
                               image:(UIImage *)image
                       clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:title
                       backgroundImage:nil
                                 image:image
                            hightImage:nil
                              callback:callback
                                  type:buttonPlaceTypeLeft];
}
- (UIButton *)addLeftButtonWithTitle:(NSString *)title
                     backgroundImage:(UIImage *)backgroundImage
                       clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:title
                       backgroundImage:backgroundImage
                                 image:nil
                            hightImage:nil
                              callback:callback
                                  type:buttonPlaceTypeLeft];
}

- (UIButton *)addLeftButtonWithImage:(UIImage *)image
                       clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:nil
                       backgroundImage:nil
                                 image:image
                            hightImage:nil
                              callback:callback
                                  type:buttonPlaceTypeLeft];
}

- (UIButton *)addLeftButtonWithImage:(UIImage *)image
                          hightImage:(UIImage *)hightImage
                       clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:nil
                       backgroundImage:nil
                                 image:image
                            hightImage:hightImage
                              callback:callback
                                  type:buttonPlaceTypeLeft];
}
- (UIButton *)addLeftButtonWithTitle:(NSString *)title
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
                                  type:buttonPlaceTypeLeft];
}


- (void)removeLeftView:(UIView *)view
{
    [self removeView:view type:buttonPlaceTypeLeft];
}

- (void)removeAllLeftButton
{
    for (UIView *tempView in self.leftViewArray) {
        [self removeView:tempView type:buttonPlaceTypeLeft];
    }
}

@end



