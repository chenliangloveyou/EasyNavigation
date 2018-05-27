//
//  EasyNavButton.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 2018/5/28.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import "EasyNavButton.h"

@implementation EasyNavButton

+ (instancetype)buttonWithConfig:(EasyNavButtonConfig *)config
{
    EasyNavButton *button = [EasyNavButton buttonWithType:UIButtonTypeCustom];
   
    if (config.title) {
        [button setTitle:config.title forState:UIControlStateNormal];
        [button.titleLabel setFont:config.titleFont] ;
    }
    
    
    return button ;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
