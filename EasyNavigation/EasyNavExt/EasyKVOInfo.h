//
//  EasyKVOInfo.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/10/19.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EasyKOVCallback)(id kvoObserver , NSString *kvoKey , id oldValue , id newValue );

@interface EasyKVOInfo : NSObject

@property (nonatomic, weak) id observer;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) EasyKOVCallback callback;

@end
