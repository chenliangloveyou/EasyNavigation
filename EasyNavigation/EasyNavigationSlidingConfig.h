//
//  EasyNavigationSlidingConfig.h
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 2018/6/28.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 * 导航条改变的类型
 */
typedef NS_ENUM(NSUInteger , EasyNavSlidingType) {
    EasyNavSlidingTypeAlphaChange ,
    EasyNavSlidingTypeSmooth ,
    EasyNavSlidingTypeAnimation ,
};


@interface EasyNavigationSlidingConfig : NSObject


/**
 * 导航条的alpha跟随 scrollview 的滚动而改变。
 *
 * startPoint/endPoint  alpha 开始/停止 改变alpha的坐标。  中间会根据这个end-start区间均匀变化。
 */
//- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow ;
//
//- (void)navigationAlphaSlowChangeWithScrollow:(UIScrollView *)scrollow
//                                        start:(CGFloat)startPoint
//                                          end:(CGFloat)endPoint ;
//

@property (nonatomic,assign)BOOL isStopSatusBar ;//是否在statusBar下面停止
@property (nonatomic,assign)float startPoint ;//为触发导航条隐藏的点。也就是当scrollview的contentOffset.y值操作这个数的时候，导航条就会隐藏
@property (nonatomic,assign)float stopPoint ;//停止变化的点。
@end





