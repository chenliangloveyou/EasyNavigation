//
//  EasyNavigationScroll.h
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 2018/7/1.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 * 导航条改变的类型
 */
typedef NS_ENUM(NSUInteger , EasyNavScrollType) {
    EasyNavScrollTypeUnKnow ,
    EasyNavScrollTypeAlphaChange ,  //alpha改变
    EasyNavScrollTypeSmooth ,       //跟着scrollview慢慢平滑滚动
    EasyNavScrollTypeAnimation ,    //到达一个点后 突然一个动画滑上去，滑下来
};


@interface EasyNavigationScroll : NSObject

//
@property (nonatomic,assign)EasyNavScrollType scrollType ;//导航条滚动类型

@property (nonatomic,assign)BOOL isStopSatusBar ;//是否在statusBar下面停止

@property (nonatomic,assign)float startPoint ;//为触发导航条隐藏的点。也就是当scrollview的contentOffset.y值操作这个数的时候，导航条就会隐藏

@property (nonatomic,assign)float stopPoint ;//停止变化的点。

+ (instancetype)scroll ;

- (EasyNavigationScroll *(^)(EasyNavScrollType))setScrollType ;
- (EasyNavigationScroll *(^)(BOOL))setIsStopSatusBar ;
- (EasyNavigationScroll *(^)(float))setStartPoint ;
- (EasyNavigationScroll *(^)(float))setStopPoint ;

@end







