//
//  NavEmptyViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/14.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "NavEmptyViewController.h"

@interface NavEmptyViewController ()

@end

@implementation NavEmptyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#if 0//以下两个2选1
    if (self.navigationView) {
        [self.navigationView removeFromSuperview];
    }
#else
    self.navigationView.hidden = YES ;
#endif
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
