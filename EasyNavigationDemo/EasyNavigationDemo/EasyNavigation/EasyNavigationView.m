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


#define kTitleViewEdge 50.0f //title左右边距

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

/**
 * 导航条改变的类型
 */
typedef NS_ENUM(NSUInteger , NavigationChangeType) {
    NavigationChangeTypeUnKnow ,
    NavigationChangeTypeAlphaChange ,
    NavigationChangeTypeAnimation ,
    NavigationChangeTypeSmooth ,
};

@interface EasyNavigationView()
{
    clickCallback _statusBarTapCallback ;//导航栏点击回到
    
    CGFloat _alphaStartChange ;//alpha改变的开始位置
    CGFloat _alphaEndChange   ;//alpha停止改变的位置
    
    CGFloat _scrollStartPoint ;//导航条滚动的起始点
    CGFloat _scrollSpeed ;     //导航条滚动速度
    
    CGFloat _criticalPoint ;//导航条动画隐藏的临界点
    BOOL _stopUpstatusBar ;//动画后是否需要停止在statusBar下面
    
    UIScrollView *_kvoScrollView ;//用于监听scrollview内容高度的改变
    
}
@property (nonatomic,strong)EasyNavigationOptions *options ;

@property (nonatomic,assign)CGFloat backGroundAlpha ;

@property (nonatomic,strong)UIView *backgroundView ;
@property (nonatomic,strong)UIImageView *backgroundImageView ;


@property (nonatomic,strong) UILabel *titleLabel ;
@property (nonatomic,strong) UIView *titleView ;

@property (nonatomic,strong)UIButton *leftButton ;

@property (nonatomic,strong)UIButton *rightButton ;

@property (nonatomic,strong)UIViewController *viewController ;//navigation所在的控制器

@property (nonatomic,strong)UIView *lineView ;//导航条最下面的一条线

@property (nonatomic,strong)NSMutableArray *leftViewArray ;//左边所有的视图
@property (nonatomic,strong)NSMutableArray *rightViewArray ;//右边所有的视图

@property (nonatomic,strong)NSMutableDictionary *callbackDictionary ;//回调的数组


@property (nonatomic,assign)BOOL isScrollingNavigaiton ;//是否正在滚动导航条

@property (nonatomic,assign)NavigationChangeType navigationChangeType ;//导航条改变的类型

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
        _isScrollingNavigaiton = NO ;
        _navigationChangeType = NavigationChangeTypeUnKnow ;
        
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
}

- (void)layoutSubviews
{
    [self layoutSubviewsWithType:buttonPlaceTypeLeft];
    [self layoutSubviewsWithType:buttonPlaceTypeRight];
    [self layoutTitleviews];
    EasyLog(@"self = %@ backview = %@ backImagev = %@  line = %@",NSStringFromCGRect(self.bounds),NSStringFromCGRect(self.backgroundView.bounds),NSStringFromCGRect(self.backgroundImageView.bounds),NSStringFromCGRect(self.lineView.bounds) );
}

#pragma mark - titleview
- (void)setTitle:(NSString *)title 
{
    self.titleLabel.text = title;
    
    [self.titleLabel sizeToFit];
    
    if (self.titleLabel.width > self.width-kTitleViewEdge*2) {
        self.titleLabel.width = self.width-kTitleViewEdge*2 ;
    }
    self.titleLabel.center = CGPointMake(self.center.x, self.center.y+NAV_STATE_HEIGHT/2);

}
- (void)addtitleView:(UIView *)titleView
{
    self.titleView = titleView ;

    [self addSubview:titleView];
    
    if (titleView.width > self.width-kTitleViewEdge*2) {
        titleView.width = self.width-kTitleViewEdge*2 ;
    }
    titleView.center = CGPointMake(self.center.x, self.center.y+NAV_STATE_HEIGHT/2);
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
    [self navigationAlphaSlowChangeWithScrollow:scrollow start:0 end:NAV_HEIGHT*2];
}
- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow start:(CGFloat)startPoint end:(CGFloat)endPoint
{
    _navigationChangeType = NavigationChangeTypeAlphaChange ;
    
    _alphaStartChange = startPoint ;
    _alphaEndChange = endPoint ;
    _kvoScrollView = scrollow ;
    
    [scrollow addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}

/**
 * 根据scrollview滚动，导航条隐藏或者展示.
 */
- (void)navigationSmoothScroll:(UIScrollView *)scrollow start:(CGFloat)startPoint speed:(CGFloat)speed stopToStatusBar:(BOOL)stopstatusBar
{
    _navigationChangeType = NavigationChangeTypeSmooth ;
    
    _kvoScrollView = scrollow ;
    _scrollSpeed = speed ;
    _scrollStartPoint = startPoint ;
    _stopUpstatusBar = stopstatusBar ;
    
    _kvoScrollView.scrollDistance = startPoint ;

    [scrollow addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

}

- (void)navigationAnimationScroll:(UIScrollView *)scrollow criticalPoint:(CGFloat)criticalPoint stopToStatusBar:(BOOL)stopstatusBar
{
    _navigationChangeType = NavigationChangeTypeAnimation ;

    _kvoScrollView = scrollow ;
    _criticalPoint = criticalPoint ;
    _stopUpstatusBar = stopstatusBar ;
    
    [scrollow addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![object isEqual:_kvoScrollView] || ![keyPath isEqualToString:@"contentOffset"]) {
        EasyLog(@"监听出现异常 -----> object=%@ , keyPath = %@",object ,keyPath);
        return ;
    }
    //scrollView 在y轴上滚动的距离
    CGFloat scrollContentY = _kvoScrollView.contentInset.top + _kvoScrollView.contentOffset.y ;
    
    if (_navigationChangeType == NavigationChangeTypeAlphaChange) {
        if (scrollContentY > _alphaStartChange){
            CGFloat alpha = scrollContentY / _alphaEndChange ;
             [self setNavigationBackgroundAlpha:alpha];
        }
        else{
             [self setNavigationBackgroundAlpha:0];
        }
    }
    else{
    
        CGFloat newPointY = [[change objectForKey:@"new"] CGPointValue].y ;
        CGFloat oldPointY = [[change objectForKey:@"old"] CGPointValue].y ;
        
        ScrollDirection currentDuring = ScrollDirectionUnknow ;
        
        if ( newPointY >=  oldPointY ) {// 向上滚动
            currentDuring = ScrollDirectionUp ;
            
            if (_navigationChangeType == NavigationChangeTypeAnimation) {
                [self animationScrollUpWithContentY:scrollContentY];
            }
            else if (_navigationChangeType == NavigationChangeTypeSmooth){
                [self smoothScrollUpWithContentY:scrollContentY];
            }
            else{
                EasyLog(@"Attention : the change type is know : %zd",_navigationChangeType );
            }
        }
        else if ( newPointY < oldPointY ) {// 向下滚动
            currentDuring = ScrollDirectionDown ;
            
            if (_navigationChangeType == NavigationChangeTypeAnimation) {
                [self animationScrollDownWithContentY:scrollContentY];
            }
            else if (_navigationChangeType == NavigationChangeTypeSmooth){
                [self smoothScrollDownWithContentY:scrollContentY];
            }
            else{
                EasyLog(@"Attention : the change type is know : %zd",_navigationChangeType );
            }
            
        }
        
        if (_kvoScrollView.direction != currentDuring) {
            
            EasyLog(@"方向改变 %ld , 记住位置 %f",currentDuring , scrollContentY );
            
            if (_kvoScrollView.direction != ScrollDirectionUnknow) {
                if (scrollContentY >= 0) {
                    _kvoScrollView.scrollDistance = scrollContentY ;
                }
            }
            
            _kvoScrollView.direction = currentDuring ;
            
        }
        
        //    EasyLog(@"方向：%ld 滚动距离：%f ",_kvoScrollView.direction,scrollContentY);
        
    }

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

- (void)layoutTitleviews
{
    if (_titleLabel) {
        [self.titleLabel sizeToFit];
        
        if (self.titleLabel.width > self.width-kTitleViewEdge*2) {
            self.titleLabel.width = self.width-kTitleViewEdge*2 ;
        }
        self.titleLabel.center = CGPointMake(self.center.x, self.center.y+NAV_STATE_HEIGHT/2);
    }
    
    if (_titleView) {
        
        if (_titleView.width > self.width-kTitleViewEdge*2) {
            _titleView.width = self.width-kTitleViewEdge*2 ;
        }
        _titleView.center = CGPointMake(self.center.x, self.center.y+NAV_STATE_HEIGHT/2);

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
            
            if (tempButton.imageView.image) {
                viewWidth += 20 ;
            }
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

#pragma mark 导航条滚动

- (void)animationScrollDownWithContentY:(CGFloat)contentY
{
    if (_kvoScrollView.scrollDistance - contentY > 20 && self.y!= 0 &&  ! self.isScrollingNavigaiton ) {
        
        self.isScrollingNavigaiton = YES ;
        EasyLog(@"scroll to top %f",_kvoScrollView.scrollDistance - contentY );
        [UIView animateWithDuration:kAnimationDuring animations:^{
            self.y = 0 ;
        }completion:^(BOOL finished) {
            self.isScrollingNavigaiton = NO ;
            self.y = 0 ;
            
            [self changeSubviewsAlpha:1];
            
        }] ;
    }
}

- (void)animationScrollUpWithContentY:(CGFloat)contentY
{
    //只有大于开始滚动的位置，才开始滚动导航条
    if (contentY > _criticalPoint && contentY - _kvoScrollView.scrollDistance > 20 &&  ! self.isScrollingNavigaiton) {//开始移动导航条
        
        self.isScrollingNavigaiton = YES ;
        
        //导航条停留的位置，如果是停留在状态栏下面，则需要让出20
        CGFloat topOfY = _stopUpstatusBar?NAV_STATE_HEIGHT:0 ;
        
        [UIView animateWithDuration:kAnimationDuring animations:^{
            
            self.y = -(self.height - topOfY );
            
        }completion:^(BOOL finished) {
            self.isScrollingNavigaiton = NO ;
            self.y = -(self.height - topOfY ) ;
            
            [self changeSubviewsAlpha:0];
            
        }] ;
    }
}
- (void)smoothScrollUpWithContentY:(CGFloat)contentY
{
    //只有大于开始滚动的位置，才开始滚动导航条
    if (contentY > _scrollStartPoint  ) {//开始移动导航条
        
        //需要改变的y值
        CGFloat changeY =(contentY - _kvoScrollView.scrollDistance)*_scrollSpeed  ;
        
        if (changeY < 0) {
            return ;
        }

        //导航条停留的位置，如果是停留在状态栏下面，则需要让出20
        CGFloat topOfY = _stopUpstatusBar?NAV_STATE_HEIGHT:0 ;
        
        if ( changeY <= self.height - topOfY ) {
            EasyLog(@"changeY = %F",changeY);
            self.y = - changeY ;
            
            if (!_stopUpstatusBar) {
                return ;
            }

            if (changeY == self.height-NAV_STATE_HEIGHT) {
                    [self changeSubviewsAlpha:0];
            }
            else if (changeY < self.height - NAV_STATE_HEIGHT){
                    
                CGFloat alpha = 1 - changeY/(self.height-NAV_STATE_HEIGHT) ;
                [self changeSubviewsAlpha:alpha];
            }
            
        }
        else{
            self.y = - (self.height - topOfY) ;
        }
    }
}

- (void)smoothScrollDownWithContentY:(CGFloat)contentY
{
    if (_kvoScrollView.scrollDistance - contentY > 20 && self.y!= 0 &&  ! self.isScrollingNavigaiton ) {
        
        self.isScrollingNavigaiton = YES ;
        // EasyLog(@"scroll to top %f",_kvoScrollView.scrollDistance - scrollContentY );
        [UIView animateWithDuration:kAnimationDuring animations:^{
            self.y = 0 ;
        }completion:^(BOOL finished) {
            self.isScrollingNavigaiton = NO ;
            self.y = 0 ;
            
            if (_stopUpstatusBar) {
                [self changeSubviewsAlpha:1];
            }
            
        }] ;
    }
}

//改变子视图的透明度
- (void)changeSubviewsAlpha:(CGFloat)alpha
{
    for (UIView *subView in self.subviews) {
        if ([subView isEqual:self.backgroundView]) {
            continue ;
        }
        if (_backgroundImageView && [subView isEqual:self.backgroundImageView]) {
            continue ;
        }
        subView.alpha = alpha ;
    }
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


- (CGFloat)navHeigth
{
    return self.height ;
}



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
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kTitleViewEdge, NAV_STATE_HEIGHT, self.width-kTitleViewEdge*2 , self.height - NAV_STATE_HEIGHT)];
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
        _lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

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
