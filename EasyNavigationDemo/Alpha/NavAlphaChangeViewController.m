//
//  NavAlphaChangeViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/14.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "NavAlphaChangeViewController.h"

@interface NavAlphaChangeViewController ()

@end

@implementation NavAlphaChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationView setTitle:@"导航条颜色渐变"];
    self.tableView.contentInset = UIEdgeInsetsMake(-StatusBarHeight_N(), 0, 0, 0);

//    [self.navigationView setNavigationBackgroundAlpha:0.0];
    
#if 1//以下两个2选1
    [self.navigationView navigationAlphaSlowChangeWithScrollow:self.tableView];
#else
    [self.navigationView navigationAlphaSlowChangeWithScrollow:self.tableView start:NAV_HEIGHT end:NAV_HEIGHT*4];
#endif
    
    // Do any additional setup after loading the view.
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
