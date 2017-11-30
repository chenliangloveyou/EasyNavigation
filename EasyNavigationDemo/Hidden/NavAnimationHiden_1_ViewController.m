//
//  NavAnimationHiden_1_ViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/14.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "NavAnimationHiden_1_ViewController.h"

@interface NavAnimationHiden_1_ViewController ()

@end

@implementation NavAnimationHiden_1_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationView setTitle:@"导航条动画隐藏(statusBar下停止)"];

    [self.navigationView navigationAnimationScroll:self.tableView criticalPoint:self.navigationOrginalHeight stopToStatusBar:YES];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];

    [self.navigationView addRightButtonWithTitle:@"添加按钮" clickCallBack:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
