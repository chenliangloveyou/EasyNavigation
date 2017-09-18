//
//  NavTransparentViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/14.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "NavTransparentViewController.h"

@interface NavTransparentViewController ()<UIScrollViewDelegate>

@end

@implementation NavTransparentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationView setTitle:@"透明导航条"];
    [self.navigationView setNavigationBackgroundAlpha:0];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  
    UIImage *btnImage = nil ;
    if (scrollView.contentOffset.y > 100){
        btnImage = kImage(@"nav_back_btn_blue.png") ;
    }
    else{
        btnImage = kImage(@"nav_back_btn.png") ;
    }
    
    [self.navigationView.leftButton setImage:btnImage forState:UIControlStateNormal];
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
