//
//  NavStatusBarViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/19.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "NavStatusBarViewController.h"

#import "EasyNavigation.h"


@interface NavStatusBarViewController ()



@end

@implementation NavStatusBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationView setTitle:@"statusBar状态改变"];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)statusBarSwitchClick:(id)sender {
    UISwitch *barSwitch = (UISwitch *)sender ;
    self.statusBarHidden = !barSwitch.isOn ;
}
- (IBAction)statusBarStyleSwitchClick:(id)sender {
    
    UISwitch *barSwitch = (UISwitch *)sender ;
    self.statusBarStyle = barSwitch.isOn ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent ;
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
