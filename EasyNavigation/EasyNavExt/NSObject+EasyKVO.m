//
//  NSObject+EasyKVO.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/10/19.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "NSObject+EasyKVO.h"

#import <objc/runtime.h>
#import <objc/message.h>

#define EasyKVOPrefix @"EasyKVO_"
#define EasyAssociateArrayKey @"EasyAssociateArrayKey"

@implementation NSObject (EasyKVO)

- (void)easyAddObserver:(id)observer key:(NSString *)key callback:(EasyKOVCallback)callback
{
    
    // 1. 检查对象的类有没有相应的 setter 方法。如果没有抛出异常
    SEL setterSelector = NSSelectorFromString([self setterForGetter:key]);
    
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    
    if (!setterMethod) {
        NSLog(@"找不到该方法");
        return;
    }
    
    // 2. 检查对象 isa 指向的类是不是一个 KVO 类。如果不是，新建一个继承原来类的子类，并把 isa 指向这个新建的子类
    Class clazz = object_getClass(self);
    NSString *className = NSStringFromClass(clazz);
    
    if (![className hasPrefix:EasyKVOPrefix]) {
        clazz = [self jr_KVOClassWithOriginalClassName:className];
        object_setClass(self, clazz);
    }
    
    // 3. 为kvo class添加setter方法的实现
    const char *types = method_getTypeEncoding(setterMethod);
    class_addMethod(clazz, setterSelector, (IMP)jr_setter, types);
    
    // 4. 添加该观察者到观察者列表中
    // 4.1 创建观察者的信息
    EasyKVOInfo *info = [[EasyKVOInfo alloc] init];
    info.observer = observer ;
    info.key = key ;
    info.callback = callback ;
    // 4.2 获取关联对象(装着所有监听者的数组)
    NSMutableArray *observers = objc_getAssociatedObject(self, EasyAssociateArrayKey);
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, EasyAssociateArrayKey, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [observers addObject:info];
    
}

- (Class)jr_KVOClassWithOriginalClassName:(NSString *)className
{
    NSString *kvoClassName = [EasyKVOPrefix stringByAppendingString:className];
    Class kvoClass = NSClassFromString(kvoClassName);
    
    // 如果kvo class存在则返回
    if (kvoClass) {
        return kvoClass;
    }
    
    // 如果kvo class不存在, 则创建这个类
    Class originClass = object_getClass(self);
    kvoClass = objc_allocateClassPair(originClass, kvoClassName.UTF8String, 0);
    
    // 修改kvo class方法的实现
    Method clazzMethod = class_getInstanceMethod(kvoClass, @selector(class));
    const char *types = method_getTypeEncoding(clazzMethod);
    class_addMethod(kvoClass, @selector(class), (IMP)jr_class, types);
    
    objc_registerClassPair(kvoClass);
    
    return kvoClass;
    
}

/**
 *  模仿Apple的做法, 欺骗人们这个kvo类还是原类
 */
Class jr_class(id self, SEL cmd)
{
    Class clazz = object_getClass(self);
    Class superClazz = class_getSuperclass(clazz);
    return superClazz;
}

/**
 *  重写setter方法, 新方法在调用原方法后, 通知每个观察者(调用传入的block)
 */
static void jr_setter(id self, SEL _cmd, id newValue)
{
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = [self getterForSetter:setterName];
    
    
    if (!getterName) {
        NSLog(@"找不到getter方法");
    }
    
    // 获取旧值
    id oldValue = [self valueForKey:getterName];
    
    // 调用原类的setter方法
    
    struct objc_super superClazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
    ((void (*)(void *, SEL, id))objc_msgSendSuper)(&superClazz, _cmd, newValue);
    
    // 为什么不能用下面方法代替上面方法?
    //    ((void (*)(id, SEL, id))objc_msgSendSuper)(self, _cmd, newValue);
    
    
    // 找出观察者的数组, 调用对应对象的callback
    NSMutableArray *observers = objc_getAssociatedObject(self, EasyAssociateArrayKey);
    // 遍历数组
    for (EasyKVOInfo *info in observers) {
        if ([info.key isEqualToString:getterName]) {
            // gcd异步调用callback
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                info.callback(info.observer, getterName, oldValue, newValue);
            });
        }
    }
}

- (void)easyRemoveObserver:(id)observer key:(NSString *)key
{
    NSMutableArray *observers = objc_getAssociatedObject(self, EasyAssociateArrayKey);
    if (!observers) return;
    
    for (EasyKVOInfo *info in observers) {
        if([info.key isEqualToString:key]) {
            [observers removeObject:info];
            break;
        }
    }
}


#pragma mark - 私有方法

/**
 *  根据getter方法名返回setter方法名
 */
- (NSString *)setterForGetter:(NSString *)key
{
    // name -> Name -> setName:
    
    // 1. 首字母转换成大写
    unichar c = [key characterAtIndex:0];
    NSString *str = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%c", c-32]];
    
    // 2. 最前增加set, 最后增加:
    NSString *setter = [NSString stringWithFormat:@"set%@:", str];
    
    return setter;
    
}

/**
 *  根据setter方法名返回getter方法名
 */
- (NSString *)getterForSetter:(NSString *)key
{
    // setName: -> Name -> name
    
    // 1. 去掉set
    NSRange range = [key rangeOfString:@"set"];
    
    NSString *subStr1 = [key substringFromIndex:range.location + range.length];
    
    // 2. 首字母转换成大写
    unichar c = [subStr1 characterAtIndex:0];
    NSString *subStr2 = [subStr1 stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%c", c+32]];
    
    // 3. 去掉最后的:
    NSRange range2 = [subStr2 rangeOfString:@":"];
    NSString *getter = [subStr2 substringToIndex:range2.location];
    
    return getter;
}

@end














