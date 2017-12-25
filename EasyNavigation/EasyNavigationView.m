//
//  EasyNavigationView.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationView.h"

#import "EasyNavigationUtils.h"
#import "UIView+EasyNavigationExt.h"
#import "UIScrollView+EasyNavigationExt.h"
#import "UIViewController+EasyNavigationExt.h"
#import "NSObject+EasyKVO.h"

#import "EasyNavigationOptions.h"
static void *const kScorllViewObservingKVO = @"kScorllViewObservingKVO" ;

#define kAnimationDuring 0.3f //动画执行时间

#define kTitleViewEdge 60.0f //title左右边距

#define kButtonInsetsWH 5.0f //按钮图文距按钮边缘的距离

static int easynavigation_button_tag = 1 ; //视图放到数组中的唯一标示


@interface EasyNavigationView()<UIScrollViewDelegate>
{
    clickCallback _statusBarTapCallback ;//导航栏点击回到
}

@property (nonatomic,strong)EasyNavigationOptions *options ;

@property (nonatomic,assign)CGFloat backGroundAlpha ;

@property (nonatomic,strong)UIImageView *backgroundImageView ;


@property (nonatomic,strong) UILabel *titleLabel ;
@property (nonatomic,strong) UIView *titleView ;


@property (nonatomic,weak)UIViewController *viewController ;//navigation所在的控制器

@property (nonatomic,strong)NSMutableDictionary *callbackDictionary ;//回调的数组

@property (nonatomic,assign)CGFloat alphaStartChange; //alpha改变的开始位置
@property (nonatomic,assign)CGFloat alphaEndChange  ;//alpha停止改变的位置
@property (nonatomic,assign)CGFloat scrollStartPoint ;//导航条滚动的起始点
@property (nonatomic,assign)CGFloat criticalPoint ;        //导航条动画隐藏的临界点
@property (nonatomic,assign)CGFloat stopUpstatusBar ;    //动画后是否需要停止在statusBar下面
@property (nonatomic,assign)CGFloat isScrollingNavigaiton  ;//是否正在滚动导航条
@property (nonatomic,assign)CGFloat navigationChangeType ;//导航条改变的类型
@property (nonatomic,assign)CGFloat scrollingSpeed ;     //导航条滚动速度
@property (nonatomic,strong)UIScrollView *kvoScrollView ;//用于监听scrollview内容高度的改变

@end

@implementation EasyNavigationView


#pragma mark - life cycle

- (void)dealloc
{
    NSLog(@"dealoc %@",self );
    if (self.kvoScrollView) {
        @try{
            [self.kvoScrollView removeObserver:self forKeyPath:@"contentOffset" context:kScorllViewObservingKVO];
        }@catch (NSException * e) {
            EasyLog(@"scroview kvo has problem : %@",e);
        }
    }
}
#warning ------库刚出来不久，很多同学跟我也反馈了问题，我也一直在改进。所以还希望能关注GitHub上我的更新。如果遇到问题欢迎提issue和也可以跟我探讨(qq:455158249)
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
    
    [self layoutNavSubViews] ;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    EasyLog(@"self = %@ backview = %@ backImagev = %@  line = %@",NSStringFromCGRect(self.bounds),NSStringFromCGRect(self.backgroundView.bounds),NSStringFromCGRect(self.backgroundImageView.bounds),NSStringFromCGRect(self.lineView.bounds) );
}


- (void)layoutNavSubViews
{
    //三个视图全部刷新位置。左边--->右边--->中间
    self.height = self.viewController.navigationOrginalHeight ;
    
    //如果是iPhone X的横屏状态，让出安全区域的距离
    __block CGFloat leftEdge = 10 + ((ISIPHONE_X&&ISHORIZONTALSCREEM)? 20 : 0);
    [self.leftViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *tempView = (UIView *)obj ;
        tempView.frame = CGRectMake(leftEdge, STATUSBAR_HEIGHT, tempView.width , tempView.height);
        leftEdge += tempView.width ;
    }];
    
    __block CGFloat rightEdge = 10 + ((ISIPHONE_X&&ISHORIZONTALSCREEM)? 20 : 0) ;
    [self.rightViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *tempView = (UIView *)obj ;
        CGFloat tempViewX = self.width - rightEdge - tempView.width ;
        tempView.frame = CGRectMake(tempViewX, STATUSBAR_HEIGHT, tempView.width , tempView.height);
        rightEdge += tempView.width ;
    }];
    
    if (_titleView) {//如果有titleview 就不显示标题
        
        [self layoutNacCenterView:_titleView leftEdge:leftEdge rightEdge:rightEdge];

        if (_titleLabel) {
            _titleLabel.hidden = YES ;
        }
        
        return ;
    }
    
    if (!_titleLabel) return ;
    
    _titleLabel.hidden = NO ;
    [self layoutNacCenterView:_titleLabel leftEdge:leftEdge rightEdge:rightEdge];
}

- (void)layoutNacCenterView:(UIView *)tempView leftEdge:(CGFloat)leftEdge rightEdge:(CGFloat)rightEdge
{
    //获取控件的宽度
    CGFloat tempWidth = tempView.width ;
    if ([tempView isKindOfClass:[UILabel class]]) {
        tempWidth = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName: _titleLabel.font}].width ;
    }
    
    CGFloat tempX = leftEdge ;
    if (self.width-leftEdge-rightEdge < tempWidth) {//title显示不下。
        tempWidth = self.width-leftEdge-rightEdge ;
    }
    else{
        if (((self.width-tempWidth)/2 > leftEdge) && ((self.width-tempWidth)/2 > rightEdge)) {
            tempX = (self.width-tempWidth)/2 ;
        }
        else if((self.width-tempWidth)/2 > leftEdge){
            tempX = self.width - rightEdge - tempWidth ;
        }
    }
    
    if (tempView.height == 0) {
        tempView.height = kNavNormalHeight ;
    }
    CGFloat tempY = STATUSBAR_HEIGHT + (self.height-STATUSBAR_HEIGHT-tempView.height)/2 ;
    tempView.frame = CGRectMake(tempX, tempY, tempWidth, tempView.height) ;
    
}

#pragma mark - titleview
- (void)setTitle:(NSString *)title 
{
    self.titleLabel.text = title;
    
    [self layoutNavSubViews];
}
- (void)addTitleView:(UIView *)titleView
{
    self.titleView = titleView ;
    [self addSubview:titleView];
    
    [self layoutNavSubViews];
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

- (void)setScrollview:(UIScrollView *)scrollview
{
    _scrollview = scrollview ;
    [self addObserveForScrollview:scrollview];
    
    self.kvoScrollView = scrollview ;
    //    self.kvoScrollView.delegate= self ;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"==============") ;
}
/**
 * 根据scrollview的滚动，导航条慢慢渐变
 */
- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow
{
    [self navigationAlphaSlowChangeWithScrollow:scrollow
                                          start:0
                                            end:100];
}
- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow
                                        start:(CGFloat)startPoint
                                          end:(CGFloat)endPoint
{
    [self addObserveForScrollview:scrollow];
    
    self.navigationChangeType = NavigationChangeTypeAlphaChange ;
    
    self.alphaStartChange = startPoint ;
    self.alphaEndChange = endPoint ;
    self.kvoScrollView = scrollow ;
    
    
}

/**
 * 根据scrollview滚动，导航条隐藏或者展示.
 */
- (void)navigationSmoothScroll:(UIScrollView *)scrollow
                         start:(CGFloat)startPoint
                         speed:(CGFloat)speed
               stopToStatusBar:(BOOL)stopstatusBar
{
    [self addObserveForScrollview:scrollow];
    
    self.navigationChangeType = NavigationChangeTypeSmooth ;
    
    self.kvoScrollView = scrollow ;
    self.scrollingSpeed = speed ;
    self.scrollStartPoint = startPoint ;
    self.stopUpstatusBar = stopstatusBar ;
    
    self.kvoScrollView.scrollDistance = startPoint ;
    
}

- (void)navigationAnimationScroll:(UIScrollView *)scrollow
                    criticalPoint:(CGFloat)criticalPoint
                  stopToStatusBar:(BOOL)stopstatusBar
{
    [self addObserveForScrollview:scrollow];
    
    self.navigationChangeType = NavigationChangeTypeAnimation ;
    
    self.kvoScrollView = scrollow ;
    self.criticalPoint = criticalPoint ;
    self.stopUpstatusBar = stopstatusBar ;
    
}

- (void)addObserveForScrollview:(UIScrollView *)scrollview
{
    [self.kvoScrollView removeObserver:self
                            forKeyPath:@"contentOffset"
                               context:kScorllViewObservingKVO];
    [scrollview addObserver:self
                 forKeyPath:@"contentOffset"
                    options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                    context:kScorllViewObservingKVO];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if (context == kScorllViewObservingKVO) {
        if (![object isEqual:self.kvoScrollView] || ![keyPath isEqualToString:@"contentOffset"]) {
            EasyLog(@"监听出现异常 -----> object=%@ , keyPath = %@",object ,keyPath);
            return ;
        }
        
        //scrollView 在y轴上滚动的距离
        CGFloat scrollContentY = self.kvoScrollView.contentInset.top + self.kvoScrollView.contentOffset.y ;
        
        //        CGFloat orginalHeight = self.viewController.navigationOrginalHeight ;
        //        NSLog(@"=== %f",scrollContentY);
        //        if (scrollContentY <= 0) {
        //            if (self.height != orginalHeight) {
        //                self.height = orginalHeight ;
        //            }
        //            self.titleLabel.centerY = orginalHeight-kNavBigTitleHeight/2 ;
        ////            self.titleLabel.left = 20 ;
        ////            self.titleLabel.font = self.options.titleBigFount ;
        //        }
        //        else if(scrollContentY < kNavBigTitleHeight){
        //            if (self.height != orginalHeight - scrollContentY) {
        //                self.height = orginalHeight - scrollContentY ;
        //            }
        //
        //            self.titleLabel.centerY = orginalHeight-kNavBigTitleHeight/2 - scrollContentY ;
        //            NSLog(@"ff %f",orginalHeight-kNavBigTitleHeight/2 - scrollContentY);
        ////            CGFloat changeX = ((self.width-self.titleLabel.width)/2 - 20)/kNavBigTitleHeight*kNavBigTitleHeight ;
        ////            self.titleLabel.left= 20 + 40 ;
        //
        ////            CGFloat fountF = 18 + (35-18)*scrollContentY/(kNavBigTitleHeight) ;
        ////            NSLog(@"%f  -=== %f",changeX,fountF);
        ////            self.titleLabel.font = [UIFont boldSystemFontOfSize: fountF ] ;
        //
        //        }
        //        else{
        //            if (self.height != orginalHeight - kNavBigTitleHeight ) {
        //                self.height = orginalHeight - kNavBigTitleHeight ;
        //            }
        //
        //            self.titleLabel.centerY = STATUSBAR_HEIGHT + kNavNormalHeight/2 ;
        ////            self.titleLabel.left= (self.width-self.titleLabel.width)/2 ;
        ////            self.titleLabel.font = self.options.titleFont ;
        //
        //        }
        
        
        if (self.navigationChangeType == NavigationChangeTypeAlphaChange) {
            if (scrollContentY > self.alphaStartChange){
                CGFloat alpha = scrollContentY / self.alphaEndChange ;
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
                
                if (self.navigationChangeType == NavigationChangeTypeAnimation) {
                    [self animationScrollUpWithContentY:scrollContentY];
                }
                else if (self.navigationChangeType == NavigationChangeTypeSmooth){
                    [self smoothScrollUpWithContentY:scrollContentY];
                }
                else{
                    EasyLog(@"Attention : the change type is know : %zd",self.navigationChangeType );
                }
                
            }
            else if ( newPointY < oldPointY ) {// 向下滚动
                
                currentDuring = ScrollDirectionDown ;
                
                if (self.navigationChangeType == NavigationChangeTypeAnimation) {
                    [self animationScrollDownWithContentY:scrollContentY];
                }
                else if (self.navigationChangeType == NavigationChangeTypeSmooth){
                    [self smoothScrollDownWithContentY:scrollContentY];
                }
                else{
                    EasyLog(@"Attention : the change type is know : %zd",self.navigationChangeType );
                }
                
            }
            
            if (self.kvoScrollView.direction != currentDuring) {
                
                EasyLog(@"方向改变 %zd , 记住位置 %f",currentDuring , scrollContentY );
                
                if (self.kvoScrollView.direction != ScrollDirectionUnknow) {
                    if (scrollContentY >= 0) {
                        self.kvoScrollView.scrollDistance = scrollContentY ;
                    }
                }
                
                self.kvoScrollView.direction = currentDuring ;
                
            }
            
            //    EasyLog(@"方向：%ld 滚动距离：%f ",self.kvoScrollView.direction,scrollContentY);
            
        }
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 导航条滚动

- (void)animationScrollDownWithContentY:(CGFloat)contentY
{
    if (self.kvoScrollView.scrollDistance - contentY > 20 && self.y!= 0 &&  ! self.isScrollingNavigaiton ) {
        
        self.isScrollingNavigaiton = YES ;
        EasyLog(@"scroll to top %f",self.kvoScrollView.scrollDistance - contentY );
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
    if (contentY > self.criticalPoint && contentY - self.kvoScrollView.scrollDistance > 20 &&  ! self.isScrollingNavigaiton) {//开始移动导航条
        
        self.isScrollingNavigaiton = YES ;
        
        //导航条停留的位置，如果是停留在状态栏下面，则需要让出20
        CGFloat topOfY = self.stopUpstatusBar?STATUSBAR_HEIGHT:0 ;
        
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
    if (contentY > self.scrollStartPoint  ) {//开始移动导航条
        
        //需要改变的y值
        CGFloat scrollSpeed = self.scrollingSpeed ;//导航条滚动的速度
        CGFloat changeY =(contentY - self.kvoScrollView.scrollDistance)*scrollSpeed  ;
        
        if (changeY < 0) {//表明方向有问题
            return ;
        }
        
        //导航条停留的位置，如果是停留在状态栏下面，则需要让出20
        CGFloat topOfY = self.stopUpstatusBar?STATUSBAR_HEIGHT:0 ;
        
        if ( changeY <= self.height - topOfY ) {
            EasyLog(@"changeY = %F",changeY);
            self.y = - changeY ;
            
            if (changeY > (self.height-STATUSBAR_HEIGHT)-5) {//这个地方有待考虑
                [self changeSubviewsAlpha:0];
            }
            else if (changeY < self.height - STATUSBAR_HEIGHT){
                
                CGFloat alpha = 1 - changeY/(self.height-STATUSBAR_HEIGHT) ;
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
    if (self.kvoScrollView.scrollDistance - contentY > 20 && self.y!= 0 &&  ! self.isScrollingNavigaiton ) {
        
        self.isScrollingNavigaiton = YES ;
        // EasyLog(@"scroll to top %f",self.kvoScrollView.scrollDistance - scrollContentY );
        [UIView animateWithDuration:kAnimationDuring animations:^{
            self.y = 0 ;
        }completion:^(BOOL finished) {
            self.isScrollingNavigaiton = NO ;
            self.y = 0 ;
            
            //            if (self.stopUpstatusBar) {
            [self changeSubviewsAlpha:1];
            //            }
            
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
        if (self.backgroundImageView && [subView isEqual:self.backgroundImageView]) {
            continue ;
        }
        
        BOOL isBackground = subView == self.subviews.firstObject ;
        //        bool isViewHidden = subView.alpha < FLT_EPSILON;
        if (!isBackground ){
            subView.alpha = alpha;
        }
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
            image = [EasyNavigationUtils scaleToSize:image size:CGSizeMake(imageWidth, imageHeight)] ;
        }
        buttonW +=  image.size.width + kButtonInsetsWH;
        //        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -kButtonInsetsWH, 0, 0)];
    }
    if (!ISEMPTY(title)) {
        CGFloat titleW = [title sizeWithAttributes:@{NSFontAttributeName: self.options.buttonTitleFont}].width ;
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
    
    [self addView:button clickCallback:callback type:type];
    //    button.titleLabel.backgroundColor = [UIColor yellowColor];
    //    button.imageView.backgroundColor = [UIColor blueColor];
    //    [button setBackgroundColor:[UIColor redColor]];
    return button ;
}


- (void)addView:(UIView *)view clickCallback:(clickCallback)callback type:(buttonPlaceType)type
{
    view.tag = ++easynavigation_button_tag ;
    
    if ([view isKindOfClass:[UIButton class]]) {
        [(UIButton *)view addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [view addTapCallBack:self sel:@selector(viewClick:)];
    }
   
    if (type == buttonPlaceTypeLeft) {
        @synchronized(self.leftViewArray){
            [self.leftViewArray addObject:view];
            __block NSInteger tidx =-1;
            [self.leftViewArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //@" "
                if ([obj isKindOfClass:[UIButton class]]) {
                    UIButton * btn = (UIButton *)obj;
                    if ([btn.titleLabel.text isEqualToString:@"     "]) {
                        //is back button
                        tidx= idx;
                        *stop =YES;
                    }
                }
            }];
            if(tidx>0){
                [self.leftViewArray exchangeObjectAtIndex:0 withObjectAtIndex:tidx];
            }
        }
    }
    else{
        [self.rightViewArray addObject:view];
    }
    
    if (callback) {
        [self.callbackDictionary setObject:[callback copy] forKey:@(view.tag)];
    }
    
    [self addSubview:view];
    [self layoutNavSubViews];
}

- (void)removeView:(UIView *)view type:(buttonPlaceType)type
{
    
    if (type == buttonPlaceTypeLeft) {
        for (UIView *tempView in self.leftViewArray) {
            if ([tempView isEqual:view]) {
                [view removeFromSuperview];
            }
        }
        [self.leftViewArray removeObject:view];
        [self layoutNavSubViews];
        
    }
    else{
        for (UIView *tempView in self.rightViewArray) {
            if ([tempView isEqual:view]) {
                [view removeFromSuperview];
            }
        }
        [self.rightViewArray removeObject:view];
        [self layoutNavSubViews];
        
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
        _titleLabel.backgroundColor = [UIColor clearColor]; //[UIColor yellowColor]; //
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
//    [[EasyNavigationUtils createImageWithColor:[UIColor redColor]] drawInRect:rect];
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
