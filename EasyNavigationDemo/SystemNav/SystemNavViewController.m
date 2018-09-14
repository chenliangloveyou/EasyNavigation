//
//  SystemNavViewController.m
//  EasyNavigationDemo
//
//  Created by bjhl on 2018/9/14.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import "SystemNavViewController.h"

@interface SystemNavViewController ()

@end

@implementation SystemNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.title = @"这里是系统导航栏";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"点击" style:UIBarButtonItemStylePlain target:self action:@selector(navclick)];
}
- (void)navclick
{
    [self.navigationController pushViewController:SystemNavViewController.new animated:YES];
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
