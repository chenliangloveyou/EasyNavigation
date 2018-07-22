//
//  NavScrollIncludeViewController.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/9/14.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "NavScrollIncludeViewController.h"
#import "EasyNavigation.h"

@interface NavScrollIncludeViewController ()

@end

@implementation NavScrollIncludeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationView setTitle:@"嵌套scrollview返回"];

    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollview.contentSize = CGSizeMake(self.view.Easy_width*3, 0) ;
    scrollview.pagingEnabled = YES ;
    [self.view addSubview:scrollview];
    self.navigationView.navigationBackButtonCallback = ^(UIView *view) {
        NSLog(@"kkk");
    };

    for (int i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake( scrollview.Easy_width*i, 0, scrollview.Easy_width, scrollview.Easy_height)];
        view.backgroundColor = kColorRandom_N ;
        [scrollview addSubview:view];
        
    }
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
