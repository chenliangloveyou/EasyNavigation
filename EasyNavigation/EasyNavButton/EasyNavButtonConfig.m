//
//  EasyNavButtonConfig.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 2018/5/27.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import "EasyNavButtonConfig.h"

@implementation EasyNavButtonConfig

+ (instancetype)shared
{
    return [[self alloc]init];
}

- (EasyNavButtonConfig *(^)(NSString *))setTitle
{
    return ^EasyNavButtonConfig *(NSString *title){
        self.title = title ;
        return self ;
    };
}
- (EasyNavButtonConfig *(^)(UIFont *))setTitleFont
{
    return ^EasyNavButtonConfig *(UIFont *titleFont){
        self.titleFont = titleFont ;
        return self ;
    };
}
@end

