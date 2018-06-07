//
//  main.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/8/31.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
//2018-05-29 23:53:03.826683+0800 EasyNavigationDemo[26593:2745554] dealoc <EasyNavigationView: 0x7f8554095c80; frame = (0 0; 375 88); autoresize = W; layer = <CALayer: 0x604001633d00>>
//2018-05-29 23:53:03.828819+0800 EasyNavigationDemo[26593:2745554] *** -[EasyNavigationView retain]: message sent to deallocated instance 0x7f8554095c80

