//
//  NavSmoothHidenViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/14.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "NavSmoothHidenViewController.h"

@interface NavSmoothHidenViewController ()

@end

@implementation NavSmoothHidenViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationView setTitle:@"导航条滚动隐藏"];

    [self.navigationView navigationSmoothScroll:self.tableView start:self.navigationView.navigationOrginalHeight speed:0.5f stopToStatusBar:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
