//
//  EasyNavigationButton.m
//  EFDoctorHealth
//
//  Created by nf on 2017/12/28.
//  Copyright © 2017年 NF. All rights reserved.
//

#import "EasyNavigationButton.h"
#import "EasyNavigationOptions.h"
#import "EasyNavigationUtils.h"
#import "UIView+EasyNavigationExt.h"

#define kButtonImageTopEdge 5  //按钮中图片，距离按钮上下边缘的距离
#define kButtonImageMaxWidth 60 //按钮中图片最大的宽度
#define kButtonTitleMaxWidth 100 //按钮中文字最大的宽度

@interface EasyNavigationButton()

@end

/**
 * 高度：永远是NavigationNorlmalHeight_N:44不会变化
 * 宽度：宽度 = 文字宽度+图片宽度（如果titleFrame,imageFrame不为0，则会根据它们直接算出。）
              文字宽度会根据
 */
@implementation EasyNavigationButton


+ (instancetype)buttonWithConfig:(EasyNavigationButton *(^)(void))button
{
    return button()  ;
}

+ (instancetype)button
{
    return [EasyNavigationButton buttonWithType:UIButtonTypeCustom];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
      
        EasyNavigationOptions *options = [EasyNavigationOptions shareInstance];

        [self setTitleColor:options.buttonTitleColor forState:UIControlStateNormal];
        [self setTitleColor:options.buttonTitleColorHieght forState:UIControlStateHighlighted];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail; //省略号在最右边
        self.imageView.contentMode = UIViewContentModeScaleAspectFit ;//imageview需要放到中间

        [self.titleLabel setFont:options.buttonTitleFont] ;
//        self.titleLabel.numberOfLines = 0 ;
//        self.titleLabel.backgroundColor = [UIColor redColor];
//        self.imageView.backgroundColor = [UIColor blueColor];
//        self.backgroundColor = [UIColor purpleColor];
        
    }
    return self ;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.imageView.frame = CGRectZero ;
    if (_imageName || _highImageName) {
        if (!(CGRectIsNull(_imageFrame) || CGRectIsEmpty(_imageFrame))) {
            self.imageView.frame = _imageFrame ;
        }
        else{
            self.imageView.x = 0;
            self.imageView.y = kButtonImageTopEdge ;
            self.imageView.height = self.height-kButtonImageTopEdge*2 ;
            
            CGFloat imageW = self.imageView.height ;
            UIImage *tempImage = nil ;
            if (_imageName) {
                tempImage = [UIImage imageNamed:_imageName];
            }else if (_highImageName){
                tempImage = [UIImage imageNamed:_highImageName] ;
            }else{
                NSAssert(NO, @"imageName is illegal !") ;
            }
            if (tempImage) {
                imageW = (tempImage.size.width*self.imageView.height)/tempImage.size.height ;
                if (imageW > kButtonImageMaxWidth) {
                    imageW = kButtonImageMaxWidth ;
                }
            }
            
            self.imageView.width = imageW ;
        }
    }

    self.titleLabel.frame = CGRectZero ;
    if (_title) {
        if (!(CGRectIsNull(_titleFrame) || CGRectIsEmpty(_titleFrame))) {
            self.titleLabel.frame = _titleFrame ;
        }
        else{
            self.titleLabel.x = CGRectGetMaxX(self.imageView.frame);
            self.titleLabel.y = 0 ;
            self.titleLabel.height = self.height;
            
            CGFloat titleW = [_title sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}].width ;
            if (titleW > kButtonTitleMaxWidth) {
                titleW = kButtonTitleMaxWidth ;
            }
            self.titleLabel.width = titleW ;
        }
    }
  
    [self setFrame:CGRectMake(self.x, self.y, self.titleLabel.right, NavigationNorlmalHeight_N())] ;
}

- (void)setTitle:(NSString *)title
{
    _title = title ;
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor ;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}
- (void)setTitleSelectColor:(UIColor *)titleSelectColor
{
    _titleSelectColor = titleSelectColor ;
#warning  ---heightlight
    [self setTitleColor:titleSelectColor forState:UIControlStateSelected];
}
- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont ;
    [self.titleLabel setFont:titleFont];
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName ;
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
- (void)setHighImageName:(NSString *)highImageName
{
    _highImageName = highImageName ;
    [self setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
}
- (void)setBackgroundImageName:(NSString *)backgroundImageName
{
    _backgroundImageName = backgroundImageName ;
    [self setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
}

- (void)setTitleFrame:(CGRect)titleFrame
{
    _titleFrame = titleFrame ;
}
- (void)setImageFrame:(CGRect)imageFrame
{
    _imageFrame = imageFrame ;
}


- (EasyNavigationButton *(^)(NSString *))setTitle
{
    return ^EasyNavigationButton *(NSString *title){
        self.title = title ;
        return self;
    };
}
- (EasyNavigationButton *(^)(UIColor *))setTitleColor
{
    return ^EasyNavigationButton *(UIColor *titleColor){
        self.titleColor = titleColor ;
        return self;
    };
}
- (EasyNavigationButton *(^)(UIColor *))setTitleSelectColor
{
    return ^EasyNavigationButton *(UIColor *titleSelectColor){
        self.titleSelectColor = titleSelectColor ;
        return self;
    };
}
- (EasyNavigationButton *(^)(UIFont *))setTitleFont
{
    return ^EasyNavigationButton *(UIFont *titleFont){
        self.titleFont = titleFont;
        return self;
    };
}

- (EasyNavigationButton *(^)(NSString *))setImageName
{
    return ^EasyNavigationButton *(NSString *imageName){
        self.imageName = imageName;
        return self;
    };
}
- (EasyNavigationButton *(^)(NSString *))setHighImageName
{
    return ^EasyNavigationButton *(NSString *highImageName){
        self.highImageName = highImageName;
        return self;
    };
}
- (EasyNavigationButton *(^)(NSString *))setBackgroundImageName
{
    return ^EasyNavigationButton *(NSString *backgroundImageName){
        self.backgroundImageName = backgroundImageName;
        return self;
    };
}

- (EasyNavigationButton *(^)(CGRect))setTitleFrame
{
    return ^EasyNavigationButton *(CGRect titleFrame){
        self.titleFrame = titleFrame;
        return self;
    };
}
- (EasyNavigationButton *(^)(CGRect))setImageFrame
{
    return ^EasyNavigationButton *(CGRect ImageFrame){
        self.imageFrame = ImageFrame;
        return self;
    };
}


@end
