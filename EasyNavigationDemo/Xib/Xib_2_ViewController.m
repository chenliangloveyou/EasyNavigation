//
//  Xib_2_ViewController.m
//  EasyNavigationDemo
//
//  Created by bjhl on 2018/9/14.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import "Xib_2_ViewController.h"
#import "EasyNavigation.h"
@interface Xib_2_ViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

@end

@implementation Xib_2_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO ;

    self.navigationView.title = @"xib可以滚动";
    self.navigationView.backgroundView.alpha = 0.2 ;
    [self.navigationView navigationScrollWithScrollView:self.bgScrollView config:^EasyNavigationScroll *{
        return [EasyNavigationScroll scroll].setScrollType(EasyNavScrollTypeAlphaChange).setStartPoint(0).setStopPoint(200);
    }];
    
    self.contentHeight.constant = 1000;
    self.bgScrollView.contentInset = UIEdgeInsetsMake(NavigationHeight_N(), 0, 0, 0);
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
