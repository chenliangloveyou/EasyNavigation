//
//  NavCustomSlidingViewController.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/9/15.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "NavCustomSlidingViewController.h"

#import "EasyNavigation.h"

@interface NavCustomSlidingViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation NavCustomSlidingViewController
- (void)dealloc
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationView setTitle:@"自定义手势返回"];
    
    self.textField.delegate = self ;
    
    self.customBackGestureEnabel = YES ;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.textField.text = @"100" ;
        [self.textField becomeFirstResponder];
    });
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.customBackGestureEdge = textField.text.floatValue ;
    [textField resignFirstResponder];
    return YES ;
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
