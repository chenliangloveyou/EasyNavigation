//
//  EasyNavigationView.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickCallback)(UIView *view);


@interface EasyNavigationView : UIView

@property (nonatomic,strong,readonly)UIImageView *backgroundImageView ;


@property (nonatomic,assign)BOOL lineHidden ;

@property (nonatomic,strong,readonly)UILabel *titleLabel ;

@property (nonatomic,strong,readonly)UIView *titleView ;

/**
 * 第一个加到导航栏左边的按钮。
 * 如果想拿到第二个加上去的，在创建的时候返回。
 */
@property (nonatomic,strong,readonly)UIButton *leftButton ;

@property (nonatomic,strong,readonly)UIButton *rightButton ;

/**
 * 导航栏高度
 */
@property (nonatomic,assign,readonly)CGFloat navHeigth ;


- (void)setBackgroundImage:(UIImage *)backgroundImage ;

- (void)setBackgroundClearColor ;

- (void)setTitle:(NSString *)title ;
- (void)addtitleView:(UIView *)titleView ;

- (void)addSubview:(UIView *)view clickCallback:(clickCallback)callback ;


- (UIView *)addLeftView:(UIView *)view clickCallback:(clickCallback)callback ;

- (UIButton *)addLeftButtonWithTitle:(NSString *)title clickCallBack:(clickCallback)callback ;

- (UIButton *)addLeftButtonWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage clickCallBack:(clickCallback)callback ;

- (UIButton *)addLeftButtonWithImage:(UIImage *)image clickCallBack:(clickCallback)callback ;

- (UIButton *)addLeftButtonWithImage:(UIImage *)image backgroundImage:(UIImage *)backgroundImage clickCallBack:(clickCallback)callback ;

- (UIButton *)addLeftButtonWithImage:(UIImage *)image hightImage:(UIImage *)hightImage clickCallBack:(clickCallback)callback ;

- (void)removeLeftView:(UIView *)view ;

- (void)removeAllLeftButton ;



- (UIView *)addRightView:(UIView *)view clickCallback:(clickCallback)callback ;

- (UIButton *)addRightButtonWithTitle:(NSString *)title clickCallBack:(clickCallback)callback ;

- (UIButton *)addRightButtonWithImage:(UIImage *)image clickCallBack:(clickCallback)callback ;

- (void)removeRightView:(UIView *)view ;

- (void)removeAllRightButton ;


- (void)scrollowNavigationBarWithScrollow:(UIScrollView *)scrollow stopPoint:(CGPoint)point ;

- (void)clearBackGroundColorWithScrollow:(UIScrollView *)scrollow ;



@end












