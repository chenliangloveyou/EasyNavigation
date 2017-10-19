//
//  NSObject+EasyKVO.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/10/19.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EasyKVOInfo.h"

@interface NSObject (EasyKVO)

- (void)easyAddObserver:(id)observer key:(NSString *)key callback:(EasyKOVCallback)callback ;
- (void)easyRemoveObserver:(id)observer key:(NSString *)key ;
@end












