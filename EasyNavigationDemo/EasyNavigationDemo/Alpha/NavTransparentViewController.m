//
//  NavTransparentViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/14.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "NavTransparentViewController.h"

@interface NavTransparentViewController ()

@end

@implementation NavTransparentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationView setTitle:@"透明导航条"];
    [self.navigationView setNavigationBackgroundAlpha:0];
    
    self.customBackGestureEnabel = YES ;
    self.customBackGestureEdge = 300 ;
    
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
