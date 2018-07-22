//
//  EasyNavigationScroll.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 2018/7/1.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationScroll.h"

@implementation EasyNavigationScroll

+ (instancetype)scroll
{
    return self.new ;
}

- (EasyNavigationScroll *(^)(EasyNavScrollType))setScrollType
{
    return ^EasyNavigationScroll *(EasyNavScrollType type){
        self.scrollType = type ;
        return self;
    };
}
- (EasyNavigationScroll *(^)(BOOL))setIsStopSatusBar
{
    return ^EasyNavigationScroll *(BOOL isStop){
        self.isStopSatusBar = isStop ;
        return self;
    };
}
- (EasyNavigationScroll *(^)(float))setStartPoint
{
    return ^EasyNavigationScroll *(float point){
        self.startPoint = point ;
        return self;
    };
}
- (EasyNavigationScroll *(^)(float))setStopPoint
{
    return ^EasyNavigationScroll *(float point){
        self.stopPoint = point ;
        return self;
    };
}
@end
