//
//  EasyNavigationButton.m
//  EFDoctorHealth
//
//  Created by nf on 2017/12/28.
//  Copyright © 2017年 NF. All rights reserved.
//

#import "EasyNavigationButton.h"
#import "EasyNavigationOptions.h"

#define kButtonInsetsH 10.0f //按钮上下图文距按钮边缘的距离
#define kButtonInsetsW 5.0f //按钮左右局边缘的距离

@interface EasyNavigationButton()

@property (nonatomic,strong)NSString *title ;
@property (nonatomic,strong)UIImage *image;

@end

@implementation EasyNavigationButton


+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image
{
    EasyNavigationButton *button  = [super buttonWithType:UIButtonTypeCustom] ;
    
    if (button) {
        
        button.title = title ;
        button.image = image ;
        EasyNavigationOptions *options = [EasyNavigationOptions shareInstance];
        
        CGFloat buttonW = kButtonInsetsW*2 ;
        if (image) {
           CGFloat imageHeight = NavigationNorlmalHeight_N()-2*kButtonInsetsH ;
            buttonW +=  (imageHeight) ;
        }
        if (!ISEMPTY_N(title)) {
            CGFloat titleW = [title sizeWithAttributes:@{NSFontAttributeName: options.buttonTitleFont}].width ;
            buttonW += titleW ;
        }
        if (image && !ISEMPTY_N(title)) {
            buttonW += kButtonInsetsW ;
        }
        [button setFrame:CGRectMake(0, 0, buttonW, NavigationNorlmalHeight_N())];
        
       
        if (!ISEMPTY_N(title)) {
            [button setTitle:title forState:UIControlStateNormal];
        }
        if (image) {
            [button setImage:image forState:UIControlStateNormal];
            button.imageView.contentMode = UIViewContentModeScaleAspectFit ;//imageview需要放到中间
        }

        [button setTitleColor:options.buttonTitleColor forState:UIControlStateNormal];
        [button setTitleColor:options.buttonTitleColorHieght forState:UIControlStateHighlighted];
        [button.titleLabel setFont:options.buttonTitleFont] ;
        
//        button.titleLabel.backgroundColor = [UIColor cyanColor];
//        button.imageView.backgroundColor = [UIColor blueColor];
//        [button setBackgroundColor:kColorRandom];
    };
    
    return button ;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if (_image) {
        CGFloat imageX = kButtonInsetsW ;
        CGFloat imageY = kButtonInsetsH ;
        CGFloat imageWH = NavigationNorlmalHeight_N() - 2*kButtonInsetsH ;
        return CGRectMake(imageX, imageY, imageWH, imageWH);
    }
    else{
        return CGRectZero ;
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if (ISEMPTY_N(_title)) {
        return CGRectZero ;
    }

    CGFloat x = kButtonInsetsW ;
    CGFloat w = CGRectGetWidth(contentRect) - 2*kButtonInsetsW ;
    if (_image){
        x = 2*kButtonInsetsW+ NavigationNorlmalHeight_N() - 2*kButtonInsetsH ;
        w = CGRectGetWidth(contentRect) - (3*kButtonInsetsW+NavigationNorlmalHeight_N() - 2*kButtonInsetsH ) ;
    }

    CGFloat y = kButtonInsetsH ;
    CGFloat h = NavigationNorlmalHeight_N() - 2*kButtonInsetsH ;
    return CGRectMake(x, y, w, h) ;

}



@end
