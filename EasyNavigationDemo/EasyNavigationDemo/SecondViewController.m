//
//  SecondViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "EasyNavigationController.h"
#import "UIViewController+EasyNavigationExt.h"

@interface SecondViewController ()

@property (nonatomic,strong)UIView *backgroundView ;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UIView *redViewe =[[UIView alloc]initWithFrame:CGRectMake(20, 40, 100, 30)];
    redViewe.backgroundColor = [UIColor redColor];
    [self.navigationView addtitleView:redViewe];

    [self.navigationView removeAllLeftButton];
    
    self.navigationView.backgroundColor = [UIColor darkGrayColor];
    self.view.backgroundColor = [UIColor purpleColor];
    
    UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [self.view addSubview:tempButton ];
    [tempButton setFrame:CGRectMake(20, 100, 40, 40)];
    [tempButton addTarget:self action:@selector(temClick) forControlEvents:UIControlEventTouchUpInside];
    
//    UIScreenEdgePanGestureRecognizer *leftEdge =  [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(leftTap: )];
//    leftEdge.edges = UIRectEdgeLeft ;
//    [self.view addGestureRecognizer:leftEdge];
//    
//    _backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
//    _backgroundView.backgroundColor = [UIColor darkTextColor];
//    [self.view addSubview:_backgroundView];
//    
//    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
//    showView.tag = 1 ;
//    showView.backgroundColor = [UIColor blueColor];
//    [_backgroundView addSubview:showView];
    // Do any additional setup after loading the view.
}
- (void)leftTap:(UIScreenEdgePanGestureRecognizer *)gesture
{
    UIView *view = [self.view hitTest:[gesture locationInView:gesture.view] withEvent:nil];
    NSLog(@"tag = %ld",view.tag);
    
    CGPoint translation = [gesture translationInView:gesture.view];

    if (UIGestureRecognizerStateBegan==gesture.state || UIGestureRecognizerStateChanged==gesture.state) {
        
        NSLog(@"进行中。。。%@",NSStringFromCGPoint(translation)) ;
        
        _backgroundView.center = CGPointMake(self.view.frame.size.width/2+translation.x , self.view.frame.size.height/2);
        
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            
            double pointX = translation.x>self.view.frame.size.width/2 ? self.view.frame.size.width*2 : self.view.frame.size.width/2 ;
            _backgroundView.center= CGPointMake(pointX, self.view.frame.size.height/2);
        }];
    }
}
- (void)temClick
{
    ThirdViewController *secondVC =[[ThirdViewController alloc]init];
//    EasyNavigationController *tempNva = (EasyNavigationController *)self.navigationController ;
    [self.navigationController pushViewController:secondVC animated:YES ];
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
