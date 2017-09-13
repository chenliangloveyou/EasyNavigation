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

#import "EasyNavigationOptions.h"


#define kTitleViewEdge 100.0f //title左右边距

#define kViewMaxWidth 100.0f //左右两边按钮，视图，最大的的宽度
#define kViewMinWidth  44.0f //左右两边按钮，视图，最小的的宽度
#define kViewEdge   2.0f //按钮之间的间距

#define kAnimationDuring 0.3f //动画执行时间

static int easynavigation_button_tag = 1 ; //视图放到数组中的唯一标示


/**
 * 创建视图的位置，放在左边还是右边
 */
typedef NS_ENUM(NSUInteger , buttonPlaceType) {
    buttonPlaceTypeLeft ,
    buttonPlaceTypeRight ,
};

@interface EasyNavigationView()
{
    clickCallback _stateBarTapCallback ;//导航栏点击回到
    
    CGFloat _alphaStartChange ;//alpha改变的开始位置
    CGFloat _alphaEndChange   ;//alpha停止改变的位置
    
    CGFloat _scrollStartPoint ;//导航条滚动的起始点
    CGFloat _scrollSpeed ;     //导航条滚动速度
    
    CGFloat _criticalPoint ;//导航条动画隐藏的临界点
    BOOL _stopToStateBar ;//动画后是否需要停止在stateBar下面
    
    UIScrollView *_kvoScrollView ;//用于监听scrollview内容高度的改变
}
@property (nonatomic,strong)EasyNavigationOptions *options ;

@property (nonatomic,assign)CGFloat backGroundAlpha ;

@property (nonatomic,strong)UIView *backgroundView ;
@property (nonatomic,strong)UIImageView *backgroundImageView ;


@property (nonatomic,strong) UILabel *titleLabel ;

@property (nonatomic,strong)UIButton *leftButton ;

@property (nonatomic,strong)UIButton *rightButton ;

@property (nonatomic,strong)UIViewController *viewController ;//navigation所在的控制器

@property (nonatomic,strong)UIView *lineView ;//导航条最下面的一条线

@property (nonatomic,strong)NSMutableArray *leftViewArray ;//左边所有的视图
@property (nonatomic,strong)NSMutableArray *rightViewArray ;//右边所有的视图

@property (nonatomic,strong)NSMutableDictionary *callbackDictionary ;//回调的数组


@property (nonatomic,assign)BOOL isScrollingNavigaiton ;//是否正在滚动导航条
@end

@implementation EasyNavigationView


#pragma mark - life cycle

- (void)dealloc
{
    [_kvoScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _isScrollingNavigaiton = NO ;
        
        _backGroundAlpha = self.options.backGroundAlpha ;
        
        [self addSubview:self.backgroundView];
        
        [self addSubview:self.titleLabel] ;
        [self addSubview:self.lineView];
        
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
    };
}

- (void)layoutSubviews
{
    [self layoutSubviewsWithType:buttonPlaceTypeLeft];
    [self layoutSubviewsWithType:buttonPlaceTypeRight];
    
}

#pragma mark - titleview
- (void)setTitle:(NSString *)title 
{
    self.titleLabel.text = title;
}
- (void)addtitleView:(UIView *)titleView
{
    [self addSubview:titleView];
    titleView.center = CGPointMake(self.bounds.size.width/2 , NAV_STATE_HEIGHT+(self.bounds.size.height-NAV_STATE_HEIGHT)/2);
}

- (void)stateBarTapWithCallback:(clickCallback)callback
{
    NSAssert(callback, @"you should deal with this callback");
    
    if (callback) {
        _stateBarTapCallback = [callback copy];
    }
    
}
- (void)removeStateBarCallback
{
    if (nil == _stateBarTapCallback) {
        _stateBarTapCallback = nil ;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject ;
    CGPoint tapLocation = [touch locationInView:self];
    NSLog(@"moved = %f  == %f",tapLocation.x,tapLocation.y);
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject ;
    CGPoint tapLocation = [touch locationInView:self];
    NSLog(@"%f  == %f",tapLocation.x,tapLocation.y);
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


#pragma mark - 左边视图

- (void)addLeftView:(UIView *)view clickCallback:(clickCallback)callback
{
    [self addView:view clickCallback:callback type:buttonPlaceTypeLeft];
}

- (UIButton *)addLeftButtonWithTitle:(NSString *)title clickCallBack:(clickCallback)callback
{
   return [self createButtonWithTitle:title
                      backgroundImage:nil
                                image:nil
                           hightImage:nil
                             callback:callback
                                 type:buttonPlaceTypeLeft];
}

- (UIButton *)addLeftButtonWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:title
                       backgroundImage:backgroundImage
                                 image:nil
                            hightImage:nil
                              callback:callback
                                  type:buttonPlaceTypeLeft];
}

- (UIButton *)addLeftButtonWithImage:(UIImage *)image clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:nil
                       backgroundImage:nil
                                 image:image
                            hightImage:nil
                              callback:callback
                                  type:buttonPlaceTypeLeft];
}

- (UIButton *)addLeftButtonWithImage:(UIImage *)image hightImage:(UIImage *)hightImage clickCallBack:(clickCallback)callback
{
    return [self createButtonWithTitle:nil
                       backgroundImage:nil
                                 image:image
                            hightImage:hightImage
                              callback:callback
                                  type:buttonPlaceTypeLeft];
}


- (void)removeLeftView:(UIView *)view
{
    for (UIView *tempView in self.leftViewArray) {
        if ([tempView isEqual:view]) {
            [view removeFromSuperview];
        }
    }
    [self.leftViewArray removeObject:view];
}

- (void)removeAllLeftButton
{
    for (UIView *tempView in self.leftViewArray) {
        [tempView removeFromSuperview];
    }
    [self.leftViewArray removeAllObjects];
}


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



#pragma mark - 视图滚动，导航条跟着变化

/**
 * 根据scrollview的滚动，导航条慢慢渐变
 */
- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow
{
    _alphaStartChange = 0 ;
    _alphaEndChange = NAV_HEIGHT*2.0 ;
    _kvoScrollView = scrollow ;
    
    [scrollow addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow start:(CGFloat)startPoint end:(CGFloat)endPoint
{
    _alphaStartChange = startPoint ;
    _alphaEndChange = endPoint ;
    _kvoScrollView = scrollow ;
    [scrollow addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}

/**
 * 根据scrollview滚动，导航条隐藏或者展示.
 */
- (void)navigationSmoothScroll:(UIScrollView *)scrollow start:(CGFloat)startPoint speed:(CGFloat)speed stopToStateBar:(BOOL)stopStateBar
{
    _kvoScrollView = scrollow ;
    _scrollSpeed = speed ;
    _scrollStartPoint = startPoint ;
    _stopToStateBar = stopStateBar ;
    _kvoScrollView.scrollDistance = startPoint ;

    [scrollow addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

}

- (void)navigationAnimationScroll:(UIScrollView *)scrollow criticalPoint:(CGFloat)criticalPoint stopToStateBar:(BOOL)stopStateBar
{
    _kvoScrollView = scrollow ;
    _criticalPoint = criticalPoint ;
    _stopToStateBar = stopStateBar ;
    
    [scrollow addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    CGFloat scrollContentY = _kvoScrollView.contentInset.top + _kvoScrollView.contentOffset.y ;//scrollView 在y轴上滚动的距离
    
    if (scrollContentY > _alphaStartChange){
        CGFloat alpha = scrollContentY / _alphaEndChange ;
        
//        [self setBackgroundAlpha:alpha];
    }
    else{
//        [self setBackgroundAlpha:0];
    }
    /*

    CGFloat newPointY = [change[@"new"] CGPointValue].y ;
    CGFloat oldPointY = [change[@"old"] CGPointValue].y ;
    
    ScrollDirection currentDuring = ScrollDirectionUnknow ;
    
    if ( newPointY >=  oldPointY ) {// 向上滚动
        currentDuring = ScrollDirectionUp ;
        
        //只有大于开始滚动的位置，才开始滚动导航条
        if (scrollContentY > _criticalPoint && scrollContentY - _kvoScrollView.scrollDistance > 20 &&  ! self.isScrollingNavigaiton) {//开始移动导航条
          
            self.isScrollingNavigaiton = YES ;
            
            [UIView animateWithDuration:kAnimationDuring animations:^{
              
                self.y = -(self.height - (_stopToStateBar?20:0));
                
            }completion:^(BOOL finished) {
                self.isScrollingNavigaiton = NO ;
                self.y = -(self.height - (_stopToStateBar?20:0)) ;
                
                for (UIView *subView in self.subviews) {
                    if ([subView isEqual:self.backgroundView]) {
                        continue ;
                    }
                    if (_backgroundImageView && [subView isEqual:self.backgroundImageView]) {
                        continue ;
                    }
                    subView.alpha = 0 ;
                }
                
            }] ;
        }
    }
    else if ( newPointY < oldPointY ) {// 向下滚动
        currentDuring = ScrollDirectionDown ;
        
        if (_kvoScrollView.scrollDistance - scrollContentY > 20 && self.y!= 0 &&  ! self.isScrollingNavigaiton ) {
           
            self.isScrollingNavigaiton = YES ;
            NSLog(@"scroll to top %f",_kvoScrollView.scrollDistance - scrollContentY );
            [UIView animateWithDuration:kAnimationDuring animations:^{
                self.y = 0 ;
//                self.alpha = 1 ;

            }completion:^(BOOL finished) {
                self.isScrollingNavigaiton = NO ;
                self.y = 0 ;
//                self.alpha = 1 ;

                for (UIView *subView in self.subviews) {
                    if ([subView isEqual:self.backgroundView]) {
                        continue ;
                    }
                    if (_backgroundImageView && [subView isEqual:self.backgroundImageView]) {
                        continue ;
                    }
                    subView.alpha = 1 ;
                }
            }] ;
        }
    }
    
    if (_kvoScrollView.direction != currentDuring) {
        
        NSLog(@"方向改变 %ld , 记住位置 %f",currentDuring , scrollContentY );
        
        if (_kvoScrollView.direction != ScrollDirectionUnknow) {
            if (scrollContentY >= 0) {
                _kvoScrollView.scrollDistance = scrollContentY ;
            }
        }
        
        _kvoScrollView.direction = currentDuring ;

    }
    
    NSLog(@"方向：%ld 滚动距离：%f ",_kvoScrollView.direction,scrollContentY);
    */

    
    CGFloat newPointY = [change[@"new"] CGPointValue].y ;
    CGFloat oldPointY = [change[@"old"] CGPointValue].y ;
    
    ScrollDirection currentDuring = ScrollDirectionUnknow ;
    
    if ( newPointY >=  oldPointY ) {// 向上滚动
        currentDuring = ScrollDirectionUp ;
        
        //只有大于开始滚动的位置，才开始滚动导航条
        if (scrollContentY > _scrollStartPoint  ) {//开始移动导航条
            CGFloat changeY =(scrollContentY - _kvoScrollView.scrollDistance)*_scrollSpeed  ;
            NSLog(@"\n changeY = %f scrollDistance=%f ",changeY , _kvoScrollView.scrollDistance );
            if (changeY >= 0) {
                self.y = - changeY ;
            }
        }
    }
    else if ( newPointY < oldPointY ) {// 向下滚动
        currentDuring = ScrollDirectionDown ;
        
        if (_kvoScrollView.scrollDistance - scrollContentY > 20 && self.y!= 0 &&  ! self.isScrollingNavigaiton ) {
            
            self.isScrollingNavigaiton = YES ;
            NSLog(@"scroll to top %f",_kvoScrollView.scrollDistance - scrollContentY );
            [UIView animateWithDuration:kAnimationDuring animations:^{
                self.y = 0 ;
            }completion:^(BOOL finished) {
                self.isScrollingNavigaiton = NO ;
                self.y = 0 ;
            }] ;
        }
    }
    
    if (_kvoScrollView.direction != currentDuring) {
        
        NSLog(@"方向改变 %ld , 记住位置 %f",currentDuring , scrollContentY );
        
        if (_kvoScrollView.direction != ScrollDirectionUnknow) {
            if (scrollContentY >= 0) {
                _kvoScrollView.scrollDistance = scrollContentY ;
            }
        }
        
        _kvoScrollView.direction = currentDuring ;
    }
    
    NSLog(@"方向：%ld 滚动距离：%f ",_kvoScrollView.direction,scrollContentY);
    
    
}

#pragma mark - private

- (UIButton *)createButtonWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage image:(UIImage *)image hightImage:(UIImage *)hieghtImage callback:(clickCallback)callback type:(buttonPlaceType)type
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (title.length) {
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
    
    [button setTitleColor:self.options.buttonTitleColor forState:UIControlStateNormal];
    [button setTitleColor:self.options.buttonTitleColorHieght forState:UIControlStateHighlighted];
    [button setBackgroundColor:self.options.buttonBackgroundColor];
    button.titleLabel.font = self.options.buttonTitleFont ;
    [button setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    
    button.tag = ++easynavigation_button_tag ;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
    if (type == buttonPlaceTypeLeft) {
        [self.leftViewArray addObject:button];
    }
    else{
        [self.rightViewArray addObject:button];
    }
    
    if (callback) {
        [self.callbackDictionary setObject:[callback copy] forKey:@(button.tag)];
    }
    
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
    
    CGFloat leftEdge = 10 ;
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
        
        CGFloat viewWidth = 0 ;
        if ([tempView isKindOfClass:[UIButton class]]) {
            
            UIButton *tempButton = (UIButton *)tempView ;

            viewWidth = [tempButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:tempButton.titleLabel.font.fontName size:tempButton.titleLabel.font.pointSize]}].width + 5 ;
        }
        else{
            viewWidth = tempView.width ;
        }
        
        if (viewWidth < kViewMinWidth) {
            viewWidth = kViewMinWidth ;
        }
        if (viewWidth > kViewMaxWidth) {//36 - 20
            viewWidth = kViewMaxWidth ;
        }
        
        CGFloat tempViewX = type==buttonPlaceTypeLeft ? leftEdge : self.width-leftEdge-viewWidth ;
        tempView.frame = CGRectMake(tempViewX, NAV_STATE_HEIGHT, viewWidth , self.height-NAV_STATE_HEIGHT-self.lineView.height);
        
        leftEdge += viewWidth+kViewEdge  ;
        
    }
    
}


#pragma mark - getter / setter

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.backgroundImageView.image = backgroundImage ;

}
- (void)setBackgroundAlpha:(CGFloat)alpha
{
    _backGroundAlpha = alpha ;
    
    self.backgroundView.alpha = alpha ;
    self.lineView.alpha = alpha;
    
    if (_backgroundImageView) {
        self.backgroundImageView.alpha = alpha ;
    }
  
}


- (void)setLineHidden:(BOOL)lineHidden
{
    _lineHidden = lineHidden ;
    self.lineView.hidden = lineHidden ;
}


- (CGFloat)navHeigth
{
    return self.height ;
}



- (UIView *)backgroundView
{
    if (nil == _backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:self.bounds];
        _backgroundView.backgroundColor = self.options.navBackGroundColor ;
        _backgroundView.alpha = _backGroundAlpha ;
    }
    return _backgroundView ;
}
- (UIImageView *)backgroundImageView
{
    if (nil == _backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _backgroundImageView.backgroundColor = [UIColor clearColor];
        _backgroundImageView.alpha = _backGroundAlpha ;
        
        [self insertSubview:_backgroundImageView aboveSubview:self.backgroundView];
    }
    return _backgroundImageView ;
}
- (void)stateBarTap
{

}

- (UILabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kTitleViewEdge, NAV_STATE_HEIGHT, SCREEN_WIDTH-kTitleViewEdge*2 , self.height - NAV_STATE_HEIGHT)];
        _titleLabel.backgroundColor = [UIColor clearColor];
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
    }
    return _viewController ;
}

- (UIView *)lineView
{
    if (nil == _lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        _lineView.backgroundColor = self.options.navLineColor;
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
