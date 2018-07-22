//
//  EasyNavButtonConfig.h
//  EFDoctorHealth
//
//  Created by nf on 2017/12/28.
//  Copyright © 2017年 NF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EasyNavigationButton : UIButton

@property (nonatomic,strong)NSString * title ;
@property (nonatomic,strong)UIColor * titleColor ;
@property (nonatomic,strong)UIColor * titleSelectColor ;
@property (nonatomic,strong)UIFont  * titleFont ;

@property (nonatomic,strong)NSString * imageName ;
@property (nonatomic,strong)NSString * highImageName ;
@property (nonatomic,strong)NSString * backgroundImageName ;

@property (nonatomic,assign)CGRect titleFrame ;//注意：一定是相对于button内部的
@property (nonatomic,assign)CGRect imageFrame ;//注意：一定是相对于button内部的


- (EasyNavigationButton *(^)(NSString *))setTitle ;
- (EasyNavigationButton *(^)(UIColor *))setTitleColor ;
- (EasyNavigationButton *(^)(UIColor *))setTitleSelectColor ;
- (EasyNavigationButton *(^)(UIFont *))setTitleFont ;

- (EasyNavigationButton *(^)(NSString *))setImageName ;
- (EasyNavigationButton *(^)(NSString *))setHighImageName ;
- (EasyNavigationButton *(^)(NSString *))setBackgroundImageName ;

- (EasyNavigationButton *(^)(CGRect))setTitleFrame ;
- (EasyNavigationButton *(^)(CGRect))setImageFrame;


+ (instancetype)button ;

+ (instancetype)buttonWithConfig:(EasyNavigationButton *(^)(void))button ;


@end
