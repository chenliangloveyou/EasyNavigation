//
//  UITableViewController+EasyNavigationExt.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 2018/7/6.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import "UITableViewController+EasyNavigationExt.h"
#import <objc/runtime.h>

//static char easynav_tableview = 'c';

@implementation UITableViewController (EasyNavigationExt)


//- (UITableView *)tableView
//{
//    UITableView *tableView = objc_getAssociatedObject(self, &easynav_tableview);
//    if (tableView == nil) {
//        tableView = [super performSelector:@selector(tableView)];
//    }
//    if (tableView == nil) {
//        tableView = UITableView.new  ;
//    }
//    return tableView ;
//}
//- (void)setTableView:(UITableView *)tableView
//{
//    objc_setAssociatedObject(self, &easynav_tableview, tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}


@end
