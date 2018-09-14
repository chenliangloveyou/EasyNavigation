//
//  PresentViewController.m
//  EasyNavigationDemo
//
//  Created by bjhl on 2018/9/14.
//  Copyright © 2018年 chenliangloveyou. All rights reserved.
//

#import "PresentViewController.h"
#import "EasyNavigation.h"
@interface PresentViewController ()

@end

@implementation PresentViewController
- (void)dealloc
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    if (!self.navigationView.navigationBackButton) {
        [self.navigationView addLeftButton:^EasyNavigationButton *{
            return [EasyNavigationButton button].setTitle(@"返回");
        } callback:^(UIView *view) {
            [EasyNavigationUtils navigationBack:weakSelf];
        }];
    }
    
    [self.navigationView addRightButtonWithTitle:@"下一页" callback:^(UIView *view) {
        if (weakSelf.navigationController.viewControllers.count > 1) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }else{
            [weakSelf.navigationController pushViewController:PresentViewController.new animated:YES];
        }
    }];
    
    static int index = 0 ;
    NSString *url = [NSString stringWithFormat:@"https://github.com/chenliangloveyou/%@",++index%2 ? @"EasyShowView":@"EasyNavigation"];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:FrameExceptNav_N()];
    [webView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.view addSubview:webView];
  
    self.navigationView.titleLabel.text = [NSString stringWithFormat:@"示例_%d",index%2+1];

    // Do any additional setup after loading the view.
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
