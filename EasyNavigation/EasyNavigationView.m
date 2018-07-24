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
#import "EasyNavigationButton.h"
#import "NSObject+EasyKVO.h"

#import "EasyNavigationOptions.h"

@interface EasyNavTitleLabel : UILabel

@end

@implementation EasyNavTitleLabel

- (void)layoutSubviews
{
    [super layoutSubviews];
}
- (void)setText:(NSString *)text
{
    [super setText:text];
    if (self.superview) {
        [self.superview setNeedsLayout];
    }
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    if (self.superview) {
        [self.superview setNeedsLayout];
    }
}
@end


@interface EasyNavDeprecateButton : UIButton

@property (nonatomic,strong)NSString *title ;
@property (nonatomic,strong)UIImage *image;

+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image ;
@end

@implementation EasyNavDeprecateButton
#define kButtonInsetsH 10.0f //按钮上下图文距按钮边缘的距离
#define kButtonInsetsW 5.0f //按钮左右局边缘的距离
+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image
{
    EasyNavDeprecateButton *button  = [super buttonWithType:UIButtonTypeCustom] ;

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



static void *const kScorllViewObservingKVO = @"kScorllViewObservingKVO" ;
static NSString *const easyNav_contentOffset = @"contentOffset" ;

static NSInteger easynavigation_button_tag = 527527 ; //视图放到数组中的唯一标示
static CGFloat easynavigation_animation_during = 0.3f ;//导航条的动画时间

@interface EasyNavigationView()<UIScrollViewDelegate>
{
}

@property (nonatomic,strong)EasyNavigationOptions *options ;

//@property (nonatomic,assign)CGFloat backGroundAlpha ;

//@property (nonatomic,strong)UIView *backgroundView ;
//@property (nonatomic,strong) UIView *titleView ;

@property (nonatomic,strong) UIImageView *backgroundView ;
@property (nonatomic,strong) EasyNavTitleLabel *titleLabel ;
@property (nonatomic,strong) UIView *lineView ;

@property (nonatomic,strong)NSMutableArray *leftViewArray ;
@property (nonatomic,strong)NSMutableArray *rightViewArray ;


@property (nonatomic,weak)UIViewController *currentViewController ;//navigation所在的控制器
@property (nonatomic,strong)NSMutableDictionary *callbackDictionary ;//回调的数组

@property (nonatomic,strong)EasyNavigationScroll  *navigationScroll ;
@property (nonatomic,strong)UIScrollView *kvoScrollView ;//用于监听scrollview内容高度的改变
@property (nonatomic,assign)CGFloat isScrollingNavigaiton  ;//是否正在滚动导航条



@end

@implementation EasyNavigationView


#pragma mark - life cycle

- (void)dealloc
{
    EasyLog_N(@"dealoc %@",self );
    if (self.kvoScrollView) {
        @try{
            [self.kvoScrollView removeObserver:self forKeyPath:easyNav_contentOffset context:kScorllViewObservingKVO];
        }@catch (NSException * e) {
            EasyLog_N(@"scroview kvo has problem : %@",e);
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.lineView];
        [self addSubview:self.titleLabel] ;

        if (self.options.navBackgroundImage) {
            self.backgroundView.image = self.options.navBackgroundImage ;
        }
        
        _viewEdgeSpece = 5 ;
    }
    return self;
}

- (void)willMoveToWindow:(nullable UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    [self layoutNavSubViews];
}
- (void)didMoveToWindow{
    [super didMoveToWindow];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    __weak typeof(self)weakSelf = self;
    self.currentViewController.view.Easy_didAddsubView = ^(UIView *view) {
        if (![view isEqual:weakSelf]) {
            [weakSelf.currentViewController.view bringSubviewToFront:weakSelf];
        }
    };
//    self.didAddsubView = ^(UIView *view) {
//        [weakSelf bringSubviewToFront:weakSelf.titleLabel];
//    };
    
    [self layoutNavSubViews] ;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.Easy_width != self.currentViewController.view.Easy_width) {
        self.Easy_width = self.currentViewController.view.Easy_width ;
    }
    
    [self layoutNavSubViews];
    EasyLog_N(@"self = %@ backImagev = %@  line = %@",NSStringFromCGRect(self.bounds),NSStringFromCGRect(self.backgroundView.bounds),NSStringFromCGRect(self.lineView.bounds));
}


- (void)layoutNavSubViews
{
    NSAssert([NSThread isMainThread], @"the thread should a main thread !");

    //三个视图全部刷新位置。左边--->右边--->中间
    if (self.Easy_height != NavigationHeight_N()) {
        self.Easy_height = NavigationHeight_N() ;
    }
    
    CGFloat subViewY = self.Easy_height - NavigationNorlmalHeight_N() ;
    
    //如果是iPhone X的横屏状态，让出安全区域的距离
    CGFloat iphoneXSafeWidth = IsIphoneX_N()&&ScreenIsHorizontal_N() ? 20 : 0 ;
    
    __block CGFloat leftEdge = self.viewEdgeSpece + iphoneXSafeWidth ;
    
    [self.leftViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *tempView = (UIView *)obj ;
        if (tempView.superview) {
            tempView.frame = CGRectMake(leftEdge, subViewY, tempView.Easy_width , tempView.Easy_height);
            leftEdge += tempView.Easy_width ;
        }
    }];
    
    __block CGFloat rightEdge = self.viewEdgeSpece + iphoneXSafeWidth ;
    
    [self.rightViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *tempView = (UIView *)obj ;
        if (tempView.superview) {
            CGFloat tempViewX = self.Easy_width - rightEdge - tempView.Easy_width ;
            tempView.frame = CGRectMake(tempViewX, subViewY, tempView.Easy_width , tempView.Easy_height);
            rightEdge += tempView.Easy_width ;
        }
    }];
    

    if (!self.titleLabel) {
        return ;
    }
    //获取控件的宽度
    CGFloat titleLabelWidth = self.titleLabel.Easy_width ;
    if ([self.titleLabel isKindOfClass:[UILabel class]]) {
        titleLabelWidth = [((UILabel *)self.titleLabel).text sizeWithAttributes:@{NSFontAttributeName: _titleLabel.font}].width ;
    }
    
    CGFloat titleLabelX = leftEdge ;
    if (self.Easy_width-leftEdge-rightEdge < titleLabelWidth) {//title显示不下。
        titleLabelWidth = self.Easy_width-leftEdge-rightEdge ;
    }
    else{
        if (((self.Easy_width-titleLabelWidth)/2 > leftEdge) && ((self.Easy_width-titleLabelWidth)/2 > rightEdge)) {
            titleLabelX = (self.Easy_width-titleLabelWidth)/2 ;
        }
        else if((self.Easy_width-titleLabelWidth)/2 > leftEdge){
            titleLabelX = self.Easy_width - rightEdge - titleLabelWidth ;
        }
    }
    if (self.titleLabel.Easy_height == 0) {
        self.titleLabel.Easy_height = NavigationNorlmalHeight_N() ;
    }
    CGFloat titleLabelY = self.Easy_height - NavigationNorlmalHeight_N() + (NavigationNorlmalHeight_N()-self.titleLabel.Easy_height)/2 ;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelWidth, self.titleLabel.Easy_height) ;

}


- (void)addView:(UIView *)view clickCallback:(clickCallback)callback type:(NavigatioinViewPlaceType)type
{

    switch (type) {
        case NavigatioinViewPlaceTypeNone:{
            
        }break ;
        case NavigatioinViewPlaceTypeCenter:{
            
            if (_titleLabel) {
                [_titleLabel removeFromSuperview];
                _titleLabel = nil ;
            }
            self.titleLabel = (UILabel *)view ;
        
        }break ;
        case NavigatioinViewPlaceTypeLeft:{
            @synchronized(self.leftViewArray){
                [self.leftViewArray addObject:view];
                __block NSInteger tidx =-1;
                [self.leftViewArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isEqual:self.navigationBackButton]) {
                        tidx= idx;
                        *stop =YES;
                    }
                }];
                if(tidx>0){
                    [self.leftViewArray exchangeObjectAtIndex:0 withObjectAtIndex:tidx];
                }
            }
        }break ;
        case NavigatioinViewPlaceTypeRight:{
            [self.rightViewArray addObject:view];
        }break ;
        default:
            break;
    }
    
    if (callback) {
        view.tag = ++easynavigation_button_tag ;
        [self.callbackDictionary setObject:[callback copy] forKey:@(view.tag)];
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [view Easy_addTapCallBack:self sel:@selector(viewClick:)];
        }
    }
    
    [self addSubview:view];
    
    [self layoutNavSubViews];
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

- (void)setNavigationBackButton:(UIButton *)navigationBackButton
{
    if ([_navigationBackButton isEqual:navigationBackButton]) {
        return ;
    }
    if (!navigationBackButton) {
        return ;
    }
    if (_navigationBackButton) {
        [_navigationBackButton removeFromSuperview];
        if ([self.leftViewArray containsObject:_navigationBackButton]) {
            [self.leftViewArray removeObject:_navigationBackButton];
        }else{
            NSAssert(NO, @"destroy problem，please connect author!");
        }
        _navigationBackButton = nil ;
    }
    
    _navigationBackButton = navigationBackButton ;
    
    __block NSInteger backButtonIndex = -1 ;
    [self.leftViewArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:navigationBackButton]) {
            backButtonIndex = idx;
            *stop =YES;
        }
    }];
    @synchronized(self.leftViewArray){
        if (backButtonIndex == -1) {//表示数组中不存在
            [self.leftViewArray insertObject:navigationBackButton atIndex:0];
        }else{
            [self.leftViewArray exchangeObjectAtIndex:0 withObjectAtIndex:backButtonIndex];
        }
    }
   
    if (!navigationBackButton.superview) {
        [self addSubview:navigationBackButton];
    }else if(![navigationBackButton.superview isEqual:self]){
        [navigationBackButton removeFromSuperview];
        [self addSubview:navigationBackButton];
    }
    
    [self layoutNavSubViews];
    
}
- (void)setNavigationBackButtonCallback:(clickCallback)navigationBackButtonCallback
{
    if (!navigationBackButtonCallback) {
        NSAssert(NO, @"you can't  add a empty callback ! : %@",self.currentViewController);
        return ;
    }
    
    dispatch_delay_easyN(0.01, ^{
        UIButton *backBtn = self.navigationBackButton ;
        if (!backBtn) {
            NSAssert(NO, @"you should add a back button before add a callback ! : %@",self.currentViewController);
            return ;
        }
        clickCallback callback = [self.callbackDictionary objectForKey:@(backBtn.tag)];
        if (!callback) {
            EasyLog_N(@"attention: this contoller's back button is empty ! : %@",self.currentViewController);
        }
        
        [self.callbackDictionary removeObjectForKey:@(backBtn.tag)];
        [self.callbackDictionary setObject:[navigationBackButtonCallback copy] forKey:@(backBtn.tag)];
    });
   
}


#pragma mark - 导航条滚动

- (void)navigationScrollWithScrollView:(UIScrollView *)scrollowView config:(EasyNavigationScroll *(^)(void))config
{
    self.navigationScroll = config();
    [self addObserveForScrollview:scrollowView];
}

- (void)addObserveForScrollview:(UIScrollView *)scrollview
{
    [self.kvoScrollView removeObserver:self
                            forKeyPath:easyNav_contentOffset
                               context:kScorllViewObservingKVO];
    [scrollview addObserver:self
                 forKeyPath:easyNav_contentOffset
                    options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                    context:kScorllViewObservingKVO];
    
    self.kvoScrollView = scrollview ;
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if (context != kScorllViewObservingKVO) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return ;
    }
    
    if (![object isEqual:self.kvoScrollView] || ![keyPath isEqualToString:easyNav_contentOffset]) {
        EasyLog_N(@"监听出现异常 -----> object=%@ , keyPath = %@",object ,keyPath);
        return ;
    }
    
    //scrollView 在y轴上滚动的距离
    CGFloat scrollContentY = self.kvoScrollView.contentInset.top + self.kvoScrollView.contentOffset.y ;
    
    //        CGFloat orginalHeight = self.viewController.navigationOrginalHeight ;
    //        NSLog(@"=== %f",scrollContentY);
    //        if (scrollContentY <= 0) {
    //            if (self.Easy_height != orginalHeight) {
    //                self.Easy_height = orginalHeight ;
    //            }
    //            self.titleLabel.centerY = orginalHeight-kNavBigTitleHeight/2 ;
    ////            self.titleLabel.left = 20 ;
    ////            self.titleLabel.font = self.options.titleBigFount ;
    //        }
    //        else if(scrollContentY < kNavBigTitleHeight){
    //            if (self.Easy_height != orginalHeight - scrollContentY) {
    //                self.Easy_height = orginalHeight - scrollContentY ;
    //            }
    //
    //            self.titleLabel.centerY = orginalHeight-kNavBigTitleHeight/2 - scrollContentY ;
    //            NSLog(@"ff %f",orginalHeight-kNavBigTitleHeight/2 - scrollContentY);
    ////            CGFloat changeX = ((self.Easy_width-self.titleLabel.Easy_width)/2 - 20)/kNavBigTitleHeight*kNavBigTitleHeight ;
    ////            self.titleLabel.left= 20 + 40 ;
    //
    ////            CGFloat fountF = 18 + (35-18)*scrollContentY/(kNavBigTitleHeight) ;
    ////            NSLog(@"%f  -=== %f",changeX,fountF);
    ////            self.titleLabel.font = [UIFont boldSystemFontOfSize: fountF ] ;
    //
    //        }
    //        else{
    //            if (self.Easy_height != orginalHeight - kNavBigTitleHeight ) {
    //                self.Easy_height = orginalHeight - kNavBigTitleHeight ;
    //            }
    //
    //            self.titleLabel.centerY = kStatusBarHeight + kNavNormalHeight_N/2 ;
    ////            self.titleLabel.left= (self.Easy_width-self.titleLabel.Easy_width)/2 ;
    ////            self.titleLabel.font = self.options.titleFont ;
    //
    //        }
    
    
    if (self.navigationScroll.scrollType == EasyNavScrollTypeAlphaChange) {
        if (scrollContentY > self.navigationScroll.startPoint){
            CGFloat alpha = scrollContentY / self.navigationScroll.stopPoint ;
            [self setNavigationBackgroundAlpha:alpha];
        }
        else{
            [self setNavigationBackgroundAlpha:0];
        }
    }
    else{
        
        CGFloat newPointY = [[change objectForKey:@"new"] CGPointValue].y ;
        CGFloat oldPointY = [[change objectForKey:@"old"] CGPointValue].y ;
        
        EasyScrollDirection currentDuring = EasyScrollDirectionUnknow ;
        
        if ( newPointY >=  oldPointY ) {// 向上滚动
            currentDuring = EasyScrollDirectionUp ;
            
            if (self.navigationScroll.scrollType == EasyNavScrollTypeAnimation) {
                [self animationScrollUpWithContentY:scrollContentY];
            }
            else if (self.navigationScroll.scrollType == EasyNavScrollTypeSmooth){
                [self smoothScrollUpWithContentY:scrollContentY];
            }
            else{
                EasyLog_N(@"Attention : the change type is know : %zd",self.navigationScroll.scrollType );
            }
            
        }
        else if ( newPointY < oldPointY ) {// 向下滚动
            
            currentDuring = EasyScrollDirectionDown ;
            
            if (self.navigationScroll.scrollType == EasyNavScrollTypeAnimation) {
                [self animationScrollDownWithContentY:scrollContentY];
            }
            else if (self.navigationScroll.scrollType == EasyNavScrollTypeSmooth){
                [self smoothScrollDownWithContentY:scrollContentY];
            }
            else{
                EasyLog_N(@"Attention : the change type is know : %zd",self.navigationScroll.scrollType );
            }
            
        }
        
        if (self.kvoScrollView.Easy_direction != currentDuring) {
            
            EasyLog_N(@"方向改变 %zd , 记住位置 %f",currentDuring , scrollContentY );
            
            if (self.kvoScrollView.Easy_direction != EasyScrollDirectionUnknow) {
                if (scrollContentY >= 0) {
                    self.kvoScrollView.Easy_scrollDistance = scrollContentY ;
                }
            }
            
            self.kvoScrollView.Easy_direction = currentDuring ;
            
        }
        
        //    EasyLog_N(@"方向：%ld 滚动距离：%f ",self.kvoScrollView.direction,scrollContentY);
        
    }
    
}

#pragma mark 导航条滚动


- (void)animationScrollDownWithContentY:(CGFloat)contentY
{
    if (self.kvoScrollView.Easy_scrollDistance - contentY > 20 && self.Easy_y!= 0 &&  ! self.isScrollingNavigaiton ) {
        
        self.isScrollingNavigaiton = YES ;
        EasyLog_N(@"scroll to top %f",self.kvoScrollView.Easy_scrollDistance - contentY );
        [UIView animateWithDuration:easynavigation_animation_during animations:^{
            self.Easy_y = 0 ;
        }completion:^(BOOL finished) {
            self.isScrollingNavigaiton = NO ;
            self.Easy_y = 0 ;
            
            [self changeSubviewsAlpha:1];
            
        }] ;
    }
}

- (void)animationScrollUpWithContentY:(CGFloat)contentY
{
    //只有大于开始滚动的位置，才开始滚动导航条
    if (contentY > self.navigationScroll.startPoint && contentY - self.kvoScrollView.Easy_scrollDistance > 20 &&  ! self.isScrollingNavigaiton) {//开始移动导航条
        
        self.isScrollingNavigaiton = YES ;
        
        //导航条停留的位置，如果是停留在状态栏下面，则需要让出20
        CGFloat topOfY = self.navigationScroll.isStopSatusBar ?StatusBarHeight_N():0 ;
        
        [UIView animateWithDuration:easynavigation_animation_during animations:^{
            
            self.Easy_y = -(self.Easy_height - topOfY );
            
        }completion:^(BOOL finished) {
            self.isScrollingNavigaiton = NO ;
            self.Easy_y = -(self.Easy_height - topOfY ) ;
            
            [self changeSubviewsAlpha:0];
            
        }] ;
    }
}
- (void)smoothScrollUpWithContentY:(CGFloat)contentY
{
    //只有大于开始滚动的位置，才开始滚动导航条
    if (contentY > self.navigationScroll.startPoint  ) {//开始移动导航条
        
        //需要改变的y值
        CGFloat scrollSpeed = (self.navigationScroll.stopPoint-self.navigationScroll.startPoint)/self.navigationScroll.startPoint ;//导航条滚动的速度
        CGFloat changeY =(contentY - self.kvoScrollView.Easy_scrollDistance)*scrollSpeed  ;
        
        if (changeY < 0) {//表明方向有问题
            return ;
        }
        
        //导航条停留的位置，如果是停留在状态栏下面，则需要让出20
        CGFloat topOfY = self.navigationScroll.isStopSatusBar?StatusBarHeight_N():0 ;
        
        if ( changeY <= self.Easy_height - topOfY ) {
            EasyLog_N(@"changeY = %F",changeY);
            self.Easy_y = - changeY ;
            
            if (changeY > (self.Easy_height-StatusBarHeight_N())-5) {//这个地方有待考虑
                [self changeSubviewsAlpha:0];
            }
            else if (changeY < self.Easy_height - StatusBarHeight_N()){
                
                CGFloat alpha = 1 - changeY/(self.Easy_height-StatusBarHeight_N()) ;
                [self changeSubviewsAlpha:alpha];
                
            }
            
        }
        else{
            self.Easy_y = - (self.Easy_height - topOfY) ;
        }
    }
}

- (void)smoothScrollDownWithContentY:(CGFloat)contentY
{
    if (self.kvoScrollView.Easy_scrollDistance - contentY > 20 && self.Easy_y!= 0 &&  ! self.isScrollingNavigaiton ) {
        
        self.isScrollingNavigaiton = YES ;
        // EasyLog_N(@"scroll to top %f",self.kvoScrollView.scrollDistance - scrollContentY );
        [UIView animateWithDuration:easynavigation_animation_during animations:^{
            self.Easy_y = 0 ;
        }completion:^(BOOL finished) {
            self.isScrollingNavigaiton = NO ;
            self.Easy_y = 0 ;
            
            //            if (self.navigationScroll.isStopSatusBar) {
            [self changeSubviewsAlpha:1];
            //            }
            
        }] ;
    }
}
//改变子视图的透明度
- (void)changeSubviewsAlpha:(CGFloat)alpha
{
    for (UIView *subView in self.subviews) {
        //        if ([subView isEqual:self.backgroundView]) {
        //            continue ;
        //        }
        if (self.backgroundView && [subView isEqual:self.backgroundView]) {
            continue ;
        }
        
        BOOL isBackground = subView == self.subviews.firstObject ;
        //bool isViewHidden = subView.alpha < FLT_EPSILON;
        if (!isBackground ){
            subView.alpha = alpha;
        }
    }
}


#pragma mark  getter

- (UIImageView *)backgroundView
{
    if (nil == _backgroundView) {
        _backgroundView = [[UIImageView alloc]initWithFrame:self.bounds];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _backgroundView.alpha = self.options.backGroundAlpha ;
        _backgroundView.backgroundColor = self.options.navBackGroundColor ;
    }
    return _backgroundView ;
}

- (EasyNavTitleLabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [[EasyNavTitleLabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor]; //[UIColor yellowColor]; //
        _titleLabel.font = self.options.titleFont ;
        _titleLabel.textColor = self.options.titleColor ;
        _titleLabel.textAlignment = NSTextAlignmentCenter ;
//        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
   
//    if (![_titleLabel isKindOfClass:[UILabel class]]) {
//        EasyLog_N(@"\n\nattention:you has change the titlelabel , you shoud get a error !\n\n  ") ;
//        return nil ;
//    }
    
    return _titleLabel ;
}

- (UIViewController *)currentViewController
{
    if (nil == _currentViewController) {
        _currentViewController = [self Easy_viewCurrentViewController] ;
        if (nil == _currentViewController) {
            EasyLog_N(@"attention: the viewController is empty !") ;
        }
    }
    return _currentViewController ;
}

- (UIView *)lineView
{
    if (nil == _lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.Easy_height-0.5, self.Easy_width, 0.5)];
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

- (EasyNavigationScroll *)navigationScroll
{
    if (nil == _navigationScroll) {
        _navigationScroll = EasyNavigationScroll.new ;
    }
    return _navigationScroll ;
}


#pragma mark - 废弃方法

- (UIButton *)createButtonWithTitle:(NSString *)title
                    backgroundImage:(UIImage *)backgroundImage
                              image:(UIImage *)image
                         hightImage:(UIImage *)hieghtImage
                           callback:(clickCallback)callback
                               type:(NavigatioinViewPlaceType)type
{
    
    if (hieghtImage) {
        NSAssert(image, @"you should set a image when hava a heightimage !") ;
    }
//    return nil;
    EasyNavDeprecateButton *button = [EasyNavDeprecateButton buttonWithTitle:title image:image];

    if (backgroundImage) {
        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    if (hieghtImage) {
        [button setImage:hieghtImage forState:UIControlStateHighlighted];
    }
    [self addView:button clickCallback:callback type:type];
    return button ;
}

- (void)removeView:(UIView *)view type:(NavigatioinViewPlaceType)type
{
    
    if (type == NavigatioinViewPlaceTypeLeft) {
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
#pragma mark - titleview

- (void)setTitle:(NSString *)title
{
    if (![self.titleLabel isKindOfClass:[UILabel class]]) {
        return ;
    }
    self.titleLabel.text = title;
    
    [self layoutNavSubViews];
}
- (NSString *)title {
    if (![self.titleLabel isKindOfClass:[UILabel class]]) {
        return @"     " ;
    }
    return self.titleLabel.text;
}

- (void)setNavigationBackgroundImage:(UIImage *)backgroundImage
{
    self.backgroundView.image = backgroundImage ;
}
- (void)setNavigationBackgroundAlpha:(CGFloat)alpha
{
    //    _backGroundAlpha = alpha ;
    
    //    self.backgroundView.alpha = alpha ;
    self.lineView.alpha = alpha;
    
    //    if (_backgroundImageView) {
    self.backgroundView.alpha = alpha ;
    //    }
}
- (void)setNavigationBackgroundColor:(UIColor *)color
{
    [self.backgroundView setBackgroundColor:color];
    
    //    if (_backgroundView) {
    //        [_backgroundView setBackgroundColor:color];
    //    }
    self.backgroundColor = color ;
}


@end

