//
//  SecondViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "EasyNavigationController.h"
@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"secondVC";
    self.view.backgroundColor = [UIColor purpleColor];
    
    UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [self.view addSubview:tempButton ];
    [tempButton setFrame:CGRectMake(20, 100, 40, 40)];
    [tempButton addTarget:self action:@selector(temClick) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)temClick
{
    ThirdViewController *secondVC =[[ThirdViewController alloc]init];
    EasyNavigationController *tempNva = (EasyNavigationController *)self.navigationController ;
    [tempNva pushViewController:secondVC animated:YES sysNavBar:NO];
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
