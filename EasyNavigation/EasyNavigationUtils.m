//
//  EasyNavigationUtils.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationUtils.h"

@implementation EasyNavigationUtils

#pragma mark - 根据颜色创建图片
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 改变图片的颜色
+ (UIImage *) imageWithTintColor:(UIImage *)image color:(UIColor *)tintColor
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(bounds);
    
    [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

#pragma mark - 改变图片大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }else if([[UIScreen mainScreen] scale] == 3.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 3.0);
    }else {
        UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    }
    
//    CGFloat x = (size.width - size.width*size)/2;
//    CGFloat y = (size.height - size.height*heightScale)/2;
//    [image drawInRect:CGRectMake(x, y, size.width*widthScale, size.height*heightScale)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
//    // 并把它设置成为当前正在使用的context
//     UIGraphicsBeginImageContext(size);
//     // 绘制改变大小的图片
//     [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
//     // 从当前context中创建一个改变大小后的图片
//     UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//     // 使当前的context出堆栈
//     UIGraphicsEndImageContext();
//     // 返回新的改变大小后的图片
//     return scaledImage;
}
@end
