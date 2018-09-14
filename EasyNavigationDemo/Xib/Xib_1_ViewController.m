//
//  Xib_1_ViewController.m
//  EasyNavigationDemo
//
//  Created by bjhl on 2018/9/14.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import "Xib_1_ViewController.h"
#import "EasyNavigation.h"
@interface Xib_1_ViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NavigationTopEdge;
@end

@implementation Xib_1_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationView.backgroundView.alpha = 0.2 ;
    self.NavigationTopEdge.constant = NavigationHeight_N();
    // Do any additional setup after loading the view from its nib.
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
