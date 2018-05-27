//
//  EasyNavButtonConfig.h
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 2018/5/27.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^clickCallback)(UIView *view);


@interface EasyNavButtonConfig : NSObject

+ (instancetype)shared ;


@property (nonatomic,strong)NSString * title ;

@property (nonatomic,strong)UIColor * titleColor ;
@property (nonatomic,strong)UIColor * selectTitleColor ;
@property (nonatomic,strong)UIColor * backgroundColor ;
@property (nonatomic,strong)UIColor * selectBackgroundColor ;

@property (nonatomic,strong)NSString * imageName ;
@property (nonatomic,strong)NSString * hightImageName ;
@property (nonatomic,strong)NSString * backgroundImageName ;

@property (nonatomic,assign)CGRect titleFrame ;
@property (nonatomic,assign)CGRect imageFrame ;

@property (nonatomic,strong)UIFont *titleFont ;


@property (nonatomic,strong)clickCallback callback ;

- (EasyNavButtonConfig *(^)(NSString *))setTitle ;
- (EasyNavButtonConfig *(^)(UIFont *))setTitleFont ;


@end
