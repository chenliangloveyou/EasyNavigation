//
//  EasyWarpNavigationViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/8.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyWarpNavigationViewController.h"

#import "EasyNavigationViewController.h"
#import "EasyWarpViewController.h"
#import "UIViewController+EasyNavigationExt.h"

@interface EasyWarpNavigationViewController ()

@end

@implementation EasyWarpNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    EasyNavigationViewController *easyNavController = viewController.vcEasyNavController;
    NSInteger index = [easyNavController.easyViewControllers indexOfObject:viewController];
    return [self.navigationController popToViewController:easyNavController.viewControllers[index] animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    viewController.vcEasyNavController = (EasyNavigationViewController *)self.navigationController;
    viewController.vcBackGestureEnabled = viewController.vcEasyNavController.vcBackGestureEnabled;
    
    UIImage *backButtonImage = viewController.vcEasyNavController.backButtonImage;
    
    if (!backButtonImage) {
        backButtonImage = [UIImage imageNamed:@"back.png"];
    }
    
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton)];
    
    [self.navigationController pushViewController:[EasyWarpViewController wrapViewController:viewController] animated:animated];
}

- (void)didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self.navigationController dismissViewControllerAnimated:flag completion:completion];
    self.viewControllers.firstObject.vcEasyNavController=nil;
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
