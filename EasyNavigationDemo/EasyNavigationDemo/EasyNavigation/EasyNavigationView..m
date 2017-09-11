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

#define kTitleViewEdge 100.0f //title左右边距

#define kViewMaxWidth 100.0f //左右两边按钮，视图，最大的的宽度
#define kViewMinWidth  20.0f //左右两边按钮，视图，最小的的宽度

static int easynavigation_button_tag = 1 ; //视图放到数组中的唯一标示


/**
 * 创建视图的位置，放在左边还是右边
 */
typedef NS_ENUM(NSUInteger , buttonPlaceType) {
    buttonPlaceTypeLeft ,
    buttonPlaceTypeRight ,
};

@interface EasyNavigationView()

@property (nonatomic,strong)UIImageView *backgroundImageView ;

@property (nonatomic,strong) UILabel *titleLabel ;

@property (nonatomic,strong)UIButton *leftButton ;

@property (nonatomic,strong)UIButton *rightButton ;

@property (nonatomic,strong)UIViewController *viewController ;//navigation所在的控制器

@property (nonatomic,strong)UIView *lineView ;//导航条最下面的一条线

@property (nonatomic,strong)NSMutableArray *leftViewArray ;//左边所有的视图
@property (nonatomic,strong)NSMutableArray *rightViewArray ;//右边所有的视图

@property (nonatomic,strong)NSMutableDictionary *callbackDictionary ;//回调的数组
@end

@implementation EasyNavigationView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.titleLabel];

        [self addSubview:self.lineView];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{

}
- (void)willMoveToSuperview:(UIView *)newSuperview
{

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


- (void)setBackgroundImage:(UIImage *)backgroundImage
{

}
- (void)setBackgroundClearColor
{

}

- (void)setTitle:(NSString *)title 
{
    self.titleLabel.text = title;
}
- (void)addtitleView:(UIView *)titleView
{
    [self addSubview:titleView];
    titleView.center = CGPointMake(self.bounds.size.width/2 , NAV_STATE_HEIGHT+(self.bounds.size.height-NAV_STATE_HEIGHT)/2);
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



- (void)layoutSubviews
{
    CGFloat leftEdge = 10 ;
    for (int i = 0 ; i < self.leftViewArray.count; i++) {
        UIView *tempView = self.leftViewArray[i];
        
        if (i == 0) {
            self.leftButton = (UIButton *)tempView ;
        }
        
        if ([tempView isKindOfClass:[UIButton class]]) {
           
            UIButton *tempButton = (UIButton *)tempView ;
            NSString *str = tempButton.titleLabel.text ;
            CGFloat titleWidth = [str sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:tempButton.titleLabel.font.fontName size:tempButton.titleLabel.font.pointSize]}].width + 20;
            
            if (titleWidth > kViewMaxWidth) {
                titleWidth = kViewMaxWidth ;
            }
            if (titleWidth < kViewMinWidth) {
                titleWidth = kViewMinWidth ;
            }
            tempView.frame = CGRectMake(leftEdge, NAV_STATE_HEIGHT, titleWidth , self.bounds.size.height-NAV_STATE_HEIGHT);
            
            leftEdge += titleWidth+ 5 ;
        }
        else{
            
            CGFloat viewWidth = tempView.bounds.size.width ;
            
            if (viewWidth > kViewMaxWidth) {
                viewWidth = kViewMaxWidth ;
            }
            if (viewWidth < kViewMinWidth) {
                viewWidth = kViewMinWidth ;
            }
            
            tempView.frame = CGRectMake(leftEdge, tempView.bounds.origin.y, viewWidth , tempView.bounds.size.height);
            
            leftEdge += tempView.bounds.size.width+5 ;
        }
       
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
- (UIButton *)createButtonWithContent:(id)content type:(long)type
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([content isKindOfClass:[NSString class]]) {
        [button setTitle:content forState:UIControlStateNormal];
    }
    else{
        [button setImage:content forState:UIControlStateNormal];
    }

    [button setBackgroundColor:[UIColor lightGrayColor]];
    button.tag = ++easynavigation_button_tag ;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
 
    
//    _rightButton.frame = CGRectMake(SCREEN_WIDTH-90, 20.0f,80.0f, KNavHeight-21.0f);
//    //        _rightButton.backgroundColor = [UIColor redColor];
//    [_rightButton setTitleColor:kColorDefultCell forState:UIControlStateNormal];
//    _rightButton.titleLabel.font = kFontBig ;
//    _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight ;
//    [self addSubview:_rightButton];
    return button ;
}


- (UIView *)addLeftView:(UIView *)view clickCallback:(clickCallback)callback
{
    
    for (UIView *tempView in self.leftViewArray) {
        if ([tempView isEqual:view]) {
            return view ;
        }
    }
    
    view.tag = ++easynavigation_button_tag ;
    
    [view addTapCallBack:self sel:@selector(viewClick:)];
    [self addSubview:view];
    
    [self.leftViewArray addObject:view];
    
    if (callback) {
        [self.callbackDictionary setObject:[callback copy] forKey:@(view.tag)];
    }
    
    return view ;
}

- (UIButton *)addLeftButtonWithTitle:(NSString *)title clickCallBack:(clickCallback)callback
{
    for (UIView *tempView in self.leftViewArray) {
        if ([tempView isEqual:title]) {
            return tempView   ;
        }
    }
    
    UIButton *button = [self createButtonWithContent:title type:1];
    [self addSubview:button];
    
    [self.leftViewArray addObject:button];

    if (callback) {
        [self.callbackDictionary setObject:[callback copy] forKey:@(button.tag)];
    }
    
    return button ;
}

- (UIButton *)addLeftButtonWithImage:(UIImage *)image clickCallBack:(clickCallback)callback
{
    
    for (UIView *tempView in self.leftViewArray) {
        if ([tempView isEqual:image]) {
            return tempView   ;
        }
    }
    
    UIButton *button = [self createButtonWithContent:image type:1];
    [self addSubview:button];
    
    [self.leftViewArray addObject:button];
    
    if (callback) {
        [self.callbackDictionary setObject:[callback copy] forKey:@(button.tag)];
    }
    
    return button ;
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



- (UIView *)addRightView:(UIView *)view clickCallback:(clickCallback)callback
{
    return nil;
}

- (UIButton *)addRightButtonWithTitle:(NSString *)title clickCallBack:(clickCallback)callback
{
    return nil;
}

- (UIButton *)addRightButtonWithImage:(UIImage *)image clickCallBack:(clickCallback)callback
{
    return nil;
}

- (void)removeRightView:(UIView *)view
{

}

- (void)removeAllRightButton
{

}


- (void)scrollowNavigationBarWithScrollow:(UIScrollView *)scrollow stopPoint:(CGPoint)point
{

}

- (void)clearBackGroundColorWithScrollow:(UIScrollView *)scrollow
{

}


- (void)setLineHidden:(BOOL)lineHidden
{
    _lineHidden = lineHidden ;
    self.lineView.hidden = lineHidden ;
}

#pragma mark - getter 

- (CGFloat)navHeigth
{
    return self.bounds.size.height ;
}

- (UILabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kTitleViewEdge, NAV_STATE_HEIGHT, SCREEN_WIDTH-kTitleViewEdge*2 , self.bounds.size.height - NAV_STATE_HEIGHT)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor] ;
        _titleLabel.textAlignment = NSTextAlignmentCenter ;
    }
    return _titleLabel ;
}
- (UIImageView *)backgroundImageView
{
    if (nil == _backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _backgroundImageView.backgroundColor = [UIColor clearColor];
    }
    return _backgroundImageView ;
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
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
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
