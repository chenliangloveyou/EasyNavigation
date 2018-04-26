//
//  NavSystemSlidingViewController.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/9/15.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "NavSystemSlidingViewController.h"

#import "EasyNavigation.h"

@interface NavSystemSlidingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UISwitch *changeSwitch;

@end

@implementation NavSystemSlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationView setTitle:@"系统返回手势"];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
}
- (IBAction)changeSwitchClick:(id)sender {
    
    UISwitch *cSwitch = (UISwitch *)sender;

    self.disableSlidingBackGesture = !cSwitch.isOn ;
    self.alertLabel.text = cSwitch.isOn ? @"侧滑返回已打开":@"侧滑返回已关闭";
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
