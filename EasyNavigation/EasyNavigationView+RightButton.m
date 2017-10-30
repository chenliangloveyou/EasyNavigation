//
//  EasyNavigationView+RightButton.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/10/30.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationView+RightButton.h"

@implementation EasyNavigationView (RightButton)


#pragma mark - 右边视图

- (void)addRightView:(UIView *)view clickCallback:(clickCallback)callback
{
    [self addView:view clickCallback:callback type:buttonPlaceTypeRight];
}

- (UIButton *)addRightButtonWithTitle:(NSString *)title clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:title
                       backgroundImage:nil
                                 image:nil
                            hightImage:nil
                              callback:callback
                                  type:buttonPlaceTypeRight];
}

- (UIButton *)addRightButtonWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:title
                       backgroundImage:backgroundImage
                                 image:nil
                            hightImage:nil
                              callback:callback
                                  type:buttonPlaceTypeRight];
}

- (UIButton *)addRightButtonWithImage:(UIImage *)image clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:nil
                       backgroundImage:nil
                                 image:image
                            hightImage:nil
                              callback:callback
                                  type:buttonPlaceTypeRight];
}

- (UIButton *)addRightButtonWithImage:(UIImage *)image hightImage:(UIImage *)hightImage clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:nil
                       backgroundImage:nil
                                 image:image
                            hightImage:hightImage
                              callback:callback
                                  type:buttonPlaceTypeRight];
}


- (void)removeRightView:(UIView *)view
{
    for (UIView *tempView in self.rightViewArray) {
        if ([tempView isEqual:view]) {
            [view removeFromSuperview];
        }
    }
    [self.rightViewArray removeObject:view];
}

- (void)removeAllRightButton
{
    for (UIView *tempView in self.rightViewArray) {
        [tempView removeFromSuperview];
    }
    [self.rightViewArray removeAllObjects];
}


@end
