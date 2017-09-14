//
//  NavSlidingControlViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/14.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "NavSlidingControlViewController.h"

@interface NavSlidingControlViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *slidingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *customSlidingSwitch;
@property (weak, nonatomic) IBOutlet UITextField *customTextField;
@property (weak, nonatomic) IBOutlet UIView *coverView;

@end

@implementation NavSlidingControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationView setTitle:@"自定义侧滑返回手势"];
    
    self.customTextField.delegate = self ;
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.customTextField]) {
        self.customBackGestureEdge = textField.text.floatValue ;
    }
    return YES ;
}
- (IBAction)switchTap:(id)sender {
    
    if ([sender isEqual:self.slidingSwitch]) {
        
        self.disableSlidingBackGesture = !self.slidingSwitch.isOn ;
        
        self.coverView.hidden = self.slidingSwitch.isOn ;
        if (!self.slidingSwitch.isOn) {
            [self.customSlidingSwitch setOn:NO];
            self.customBackGestureEnabel = NO ;
            self.customBackGestureEdge = 0 ;
            self.customTextField.text = @"";
        }
    }
    else if ([sender isEqual:self.customSlidingSwitch]){
    
        self.customBackGestureEnabel = self.customSlidingSwitch.isOn ;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
