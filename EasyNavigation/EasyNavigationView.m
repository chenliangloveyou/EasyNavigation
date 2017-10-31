//
//  EasyNavigationView.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationView.h"

#import "EasyUtils.h"
#import "UIView+EasyNavigationExt.h"
#import "UIScrollView+EasyNavigationExt.h"
#import "UIViewController+EasyNavigationExt.h"
#import "NSObject+EasyKVO.h"

#import "EasyNavigationOptions.h"


#define kTitleViewEdge 60.0f //title左右边距


#define kButtonInsetsWH 5.0f //按钮图文距按钮边缘的距离
#define kButtonMaxW  60.0f //按钮文字最大的长度

static int easynavigation_button_tag = 1 ; //视图放到数组中的唯一标示


@interface EasyNavigationView()
{
    clickCallback _statusBarTapCallback ;//导航栏点击回到
}

@property (nonatomic,strong)EasyNavigationOptions *options ;

@property (nonatomic,assign)CGFloat backGroundAlpha ;

@property (nonatomic,strong)UIImageView *backgroundImageView ;


@property (nonatomic,strong) UILabel *titleLabel ;
@property (nonatomic,strong) UIView *titleView ;

@property (nonatomic,strong)UIButton *leftButton ;

@property (nonatomic,strong)UIButton *rightButton ;

@property (nonatomic,strong)UIViewController *viewController ;//navigation所在的控制器

@property (nonatomic,strong)NSMutableDictionary *callbackDictionary ;//回调的数组

@end

@implementation EasyNavigationView


#pragma mark - life cycle

- (void)dealloc
{
    if (_kvoScrollView) {
        [_kvoScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        _backGroundAlpha = self.options.backGroundAlpha ;
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.titleLabel] ;
        [self addSubview:self.lineView];
        
        if (self.options.navBackgroundImage) {
            self.backgroundImageView.image = self.options.navBackgroundImage ;
        }
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    kWeakSelf(self)
    self.viewController.view.didAddsubView = ^(UIView *view) {
      
        if (![view isEqual:weakself]) {
            [weakself.viewController.view bringSubviewToFront:weakself];
        }
    };
    self.didAddsubView = ^(UIView *view) {
        
        [weakself bringSubviewToFront:weakself.titleLabel];
        
        if (weakself.titleView) {
            [weakself bringSubviewToFront:weakself.titleView];
        }
    };
    
//    if (self.isShowBigTitle) {
//        [self setNeedsDisplay];
//    }
    
//    NSLog(@"%@ = %d",self.viewController,self.viewController.navbigTitleType) ;
//    [self.viewController easyAddObserver:self key:@"navbigTitleType" callback:^(id kvoObserver, NSString *kvoKey, id oldValue, id newValue) {
//
//        NSLog(@"%@ == %@ == %@",kvoObserver,kvoKey ,newValue);
//    }];
}



- (void)layoutSubviews
{
    
    [self layoutSubviewsWithType:buttonPlaceTypeLeft];
    [self layoutSubviewsWithType:buttonPlaceTypeRight];
    [self layoutTitleviews];
    EasyLog(@"self = %@ backview = %@ backImagev = %@  line = %@",NSStringFromCGRect(self.bounds),NSStringFromCGRect(self.backgroundView.bounds),NSStringFromCGRect(self.backgroundImageView.bounds),NSStringFromCGRect(self.lineView.bounds) );
}
- (void)changeNavigationHeight
{
    self.height = self.viewController.navigationOrginalHeight ;
    [self layoutSubviews];
}
- (void)layoutTitleviews
{
    if (_titleLabel) {
        
        if (self.viewController.isShowBigTitle) {
            self.titleLabel.frame = CGRectMake(20, self.viewController.navigationOrginalHeight-kNavBigTitleHeight, 0, 0) ;
            self.titleLabel.font = self.options.titleBigFount ;
            [self.titleLabel sizeToFit];
            
        }
        else{
            if (self.titleLabel.width > self.width-kTitleViewEdge*2) {
                self.titleLabel.width = self.width-kTitleViewEdge*2 ;
            }
            self.titleLabel.center = CGPointMake(self.center.x, self.center.y+STATUSBAR_HEIGHT/2);
            
            self.titleLabel.font = self.options.titleFont ;
        }
        
    }
    
    if (_titleView) {
        
        if (_titleView.width > self.width-kTitleViewEdge*2) {
            _titleView.width = self.width-kTitleViewEdge*2 ;
        }
        _titleView.height = (self.height - STATUSBAR_HEIGHT);
        _titleView.center = CGPointMake(self.center.x, STATUSBAR_HEIGHT+(self.height-STATUSBAR_HEIGHT)/2 );
    }
}
#pragma mark - titleview
- (void)setTitle:(NSString *)title 
{
    self.titleLabel.text = title;
    
    [self.titleLabel sizeToFit];
    
    if (self.titleLabel.width > self.width-kTitleViewEdge*2) {
        self.titleLabel.width = self.width-kTitleViewEdge*2 ;
    }
    self.titleLabel.center = CGPointMake(self.center.x, self.center.y+STATUSBAR_HEIGHT/2);

}
- (void)addTitleView:(UIView *)titleView
{
    self.titleView = titleView ;

    [self addSubview:titleView];
    
    if (titleView.width > self.width-kTitleViewEdge*2) {
        titleView.width = self.width-kTitleViewEdge*2 ;
    }
    titleView.center = CGPointMake(self.center.x, self.center.y+STATUSBAR_HEIGHT/2);
}


- (void)addSubview:(UIView *)view clickCallback:(clickCallback)callback
{
    
    view.tag = ++easynavigation_button_tag ;
    
    [view addTapCallBack:self sel:@selector(viewClick:)];
    [self addSubview:view];
    
    if (callback) {
        [self.callbackDictionary setObject:[callback copy] forKey:@(view.tag)];
    }
}




#pragma mark - private

- (UIButton *)createButtonWithTitle:(NSString *)title
                    backgroundImage:(UIImage *)backgroundImage
                              image:(UIImage *)image
                         hightImage:(UIImage *)hieghtImage
                           callback:(clickCallback)callback
                               type:(buttonPlaceType)type
{
    
    if (hieghtImage) {
        NSAssert(image, @"you should set a image when hava a heightimage !") ;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:self.options.buttonTitleColor forState:UIControlStateNormal];
    [button setTitleColor:self.options.buttonTitleColorHieght forState:UIControlStateHighlighted];
    [button.titleLabel setFont:self.options.buttonTitleFont] ;
    [button setContentEdgeInsets:UIEdgeInsetsMake(0, -kButtonInsetsWH, 0, 0)];

    CGFloat buttonW = kButtonInsetsWH ;
    if (image) {
        CGFloat imageHeight = kNavNormalHeight-2*kButtonInsetsWH ;
        if (image.size.height > imageHeight ) {
            CGFloat imageWidth = (image.size.width/image.size.height)*imageHeight ;
            image = [EasyUtils scaleToSize:image size:CGSizeMake(imageWidth, imageHeight)] ;
        }
        buttonW +=  image.size.width + kButtonInsetsWH;
//        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -kButtonInsetsWH, 0, 0)];
    }
    if (!ISEMPTY(title)) {
        CGFloat titleW = [title sizeWithAttributes:@{NSFontAttributeName: self.options.buttonTitleFont}].width ;
        if (titleW > kButtonMaxW) {
            titleW = kButtonMaxW ;
        }
        buttonW += titleW + kButtonInsetsWH ;
//        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -kButtonInsetsWH)];
    }
    [button setFrame:CGRectMake(0, 0, buttonW, kNavNormalHeight)];
    
    if (!ISEMPTY(title)) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (backgroundImage) {
        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (hieghtImage) {
        [button setImage:hieghtImage forState:UIControlStateHighlighted];
    }
    [self addSubview:button];
    
    if (type == buttonPlaceTypeLeft) {
        [self.leftViewArray addObject:button];
    }
    else{
        [self.rightViewArray addObject:button];
    }
    
    button.tag = ++easynavigation_button_tag ;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (callback) {
        [self.callbackDictionary setObject:[callback copy] forKey:@(button.tag)];
    }
    
//    button.titleLabel.backgroundColor = [UIColor yellowColor];
//    button.imageView.backgroundColor = [UIColor blueColor];
//    [button setBackgroundColor:[UIColor redColor]];
    return button ;
}

- (void)addView:(UIView *)view clickCallback:(clickCallback)callback type:(buttonPlaceType)type
{
    
    view.tag = ++easynavigation_button_tag ;
    [view addTapCallBack:self sel:@selector(viewClick:)];
    
    [self addSubview:view];
    
    if (type == buttonPlaceTypeLeft) {
        [self.leftViewArray addObject:view];
    }
    else{
        [self.rightViewArray addObject:view];
    }
    
    if (callback) {
        [self.callbackDictionary setObject:[callback copy] forKey:@(view.tag)];
    }
}

- (void)buttonClick:(UIButton *)button
{
    clickCallback callback = [self.callbackDictionary objectForKey:@(button.tag)];
    if (callback) {
        callback(button);
    }
}
- (void)viewClick:(UITapGestureRecognizer *)tapgesture
{
    clickCallback callback = [self.callbackDictionary objectForKey:@(tapgesture.view.tag)];
    if (callback) {
        callback(tapgesture.view);
    }
}

- (void)layoutSubviewsWithType:(buttonPlaceType)type
{
    NSMutableArray *tempArray = nil ;
    if (type == buttonPlaceTypeLeft) {
        tempArray = self.leftViewArray ;
    }
    else{
        tempArray = self.rightViewArray ;
    }
    
    CGFloat leftEdge = 10 + ((ISIPHONE_X&&ISHORIZONTALSCREEM)? 20 : 0);//如果是iPhone X的横屏状态，让出安全区域的距离
    for (int i = 0 ; i < tempArray.count; i++) {
        UIView *tempView = tempArray[i];
        
        if (i == 0) {
            if (type == buttonPlaceTypeLeft) {
                self.leftButton = (UIButton *)tempView ;
            }
            else{
                self.rightButton = (UIButton *)tempView ;
            }
        }
        
        CGFloat tempViewX = type==buttonPlaceTypeLeft ? leftEdge : self.width-leftEdge-tempView.width ;
        tempView.frame = CGRectMake(tempViewX, STATUSBAR_HEIGHT, tempView.width , tempView.height);
        
        leftEdge += tempView.width ;
    }
    
}

- (void)statusBarTapWithCallback:(clickCallback)callback
{
    NSAssert(callback, @"you should deal with this callback");
    
    if (callback) {
        _statusBarTapCallback = [callback copy];
    }
    
}
- (void)removestatusBarCallback
{
    if (nil == _statusBarTapCallback) {
        _statusBarTapCallback = nil ;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject ;
    CGPoint tapLocation = [touch locationInView:self];
    EasyLog(@"moved = %f  == %f",tapLocation.x,tapLocation.y);
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject ;
    CGPoint tapLocation = [touch locationInView:self];
    EasyLog(@"%f  == %f",tapLocation.x,tapLocation.y);
}


#pragma mark - getter / setter

- (void)setNavigationBackgroundImage:(UIImage *)backgroundImage
{
    self.backgroundImageView.image = backgroundImage ;
}
- (void)setNavigationBackgroundAlpha:(CGFloat)alpha
{
    _backGroundAlpha = alpha ;
    
    self.backgroundView.alpha = alpha ;
    self.lineView.alpha = alpha;
    
    if (_backgroundImageView) {
        self.backgroundImageView.alpha = alpha ;
    }
}
- (void)setNavigationBackgroundColor:(UIColor *)color
{
    [self.backgroundView setBackgroundColor:color];
    
    if (_backgroundView) {
        [_backgroundView setBackgroundColor:color];
    }
    self.backgroundColor = color ;
}

- (void)setLineHidden:(BOOL)lineHidden
{
    _lineHidden = lineHidden ;
    self.lineView.hidden = lineHidden ;
}

#pragma mark  getter


- (UIView *)backgroundView
{
    if (nil == _backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:self.bounds];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _backgroundView.backgroundColor = self.options.navBackGroundColor ;
        _backgroundView.alpha = _backGroundAlpha ;
    }
    return _backgroundView ;
}
- (UIImageView *)backgroundImageView
{
    if (nil == _backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _backgroundImageView.backgroundColor = [UIColor clearColor];
        _backgroundImageView.alpha = _backGroundAlpha ;
        
        [self insertSubview:_backgroundImageView aboveSubview:self.backgroundView];
    }
    return _backgroundImageView ;
}
- (void)statusBarTap
{

}

- (UILabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.font = self.options.titleFont ;
        _titleLabel.textColor = self.options.titleColor ;
        _titleLabel.textAlignment = NSTextAlignmentCenter ;
    }
    return _titleLabel ;
}

- (UIViewController *)viewController
{
    if (nil == _viewController) {
        _viewController = [self currentViewController] ;
        if (nil == _viewController) {
            EasyLog(@"attention: the viewController is empty !") ;
        }
    }
    return _viewController ;
}

- (UIView *)lineView
{
    if (nil == _lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        _lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;

        _lineView.backgroundColor = self.options.navLineColor ;//[UIColor redColor];//
    }
    return _lineView ;
}

- (NSMutableDictionary *)callbackDictionary
{
    if (nil == _callbackDictionary) {
        _callbackDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    return _callbackDictionary ;
}
- (NSMutableArray *)leftViewArray
{
    if (nil == _leftViewArray) {
        _leftViewArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _leftViewArray ;
}
- (NSMutableArray *)rightViewArray
{
    if (nil == _rightViewArray) {
        _rightViewArray = [NSMutableArray arrayWithCapacity:3];
    }
    return _rightViewArray ;
}

- (EasyNavigationOptions *)options
{
    if (nil == _options) {
        _options  = [EasyNavigationOptions shareInstance];
    }
    return _options ;
}

//- (void)drawRect:(CGRect)rect
//{
//    [[EasyUtils createImageWithColor:[UIColor redColor]] drawInRect:rect];
//}
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    if (self.statusView) {
//        self.statusView.frame = CGRectMake(0, 0 - kSpaceToCoverStatusBars, CGRectGetWidth(self.bounds), kSpaceToCoverStatusBars);
//    }
//}
@end
