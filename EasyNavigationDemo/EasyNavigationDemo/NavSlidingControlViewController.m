//
//  NavSlidingControlViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/14.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "NavSlidingControlViewController.h"

@interface NavSlidingControlViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *slidingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *customSlidingSwitch;
@property (weak, nonatomic) IBOutlet UITextField *customTextField;

@end

@implementation NavSlidingControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationView setTitle:@"自定义侧滑返回手势"];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)switchTap:(id)sender {
    
    if ([sender isEqual:self.slidingSwitch]) {
        
        self.disableSlidingBackGesture = !self.slidingSwitch.isOn ;
    }
    else if ([sender isEqual:self.customSlidingSwitch]){
    
        self.customBackGestureEnabel = self.customSlidingSwitch.isOn ;
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
