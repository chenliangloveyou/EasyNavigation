//
//  BaseViewController.h
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/14.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EasyNavigation.h"

#define kWeakSelf(type)__weak typeof(type)weak##type = type;

@interface BaseViewController : UIViewController

@property (nonatomic,strong,readonly)UITableView *tableView ;

@end
