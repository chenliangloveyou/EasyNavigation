//
//  ViewController.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/8/31.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "ViewController.h"

#import "EasyNavigation.h"


#import "NavEmptyViewController.h"
#import "NavTransparentViewController.h"
#import "NavAlphaChangeViewController.h"
#import "NavOperateViewController.h"

#import "NavSmoothHidenViewController.h"
#import "NavSmoothHiden_1_ViewController.h"
#import "NavAnimationHidenViewController.h" 
#import "NavAnimationHiden_1_ViewController.h"

#import "NavCustomSlidingViewController.h"
#import "NavSystemSlidingViewController.h"
#import "NavScrollIncludeViewController.h"

#import "NavStatusBarViewController.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView ;
@property (nonatomic,strong)NSArray *dataArray ;
@property (nonatomic,strong)NSArray *navDataArray ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationView setTitle:@"首页"];
    
    kWeakSelf(self)
    [self.navigationView addLeftButtonWithTitle:@"更多" clickCallBack:^(UIView *view) {
        [weakself.navigationView setTitle:@"点击了更多"];
    }];
    
    [self.navigationView addRightButtonWithImage:kImage(@"button_normal.png") hightImage:kImage(@"button_select.png") clickCallBack:nil];

    self.statusBarStyle = UIStatusBarStyleLightContent ;
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tableView];
    
    
    /*
     由于这个库的原理是隐藏系统导航条，自定义一个view作为导航条，
     1，self.automaticallyAdjustsScrollViewInsets = NO ;用来
     2，控制器中的view会从左上角的{0,0}开始计算。
     在添加视图的时候，可以重导航条高度的下面开始添加。
     当为scrollview的时候可以设置。
     scrollview.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
     也就是向下收缩导航条高度的距离。
     
     
     这个库是隐藏了系统的导航栏，但是没有
     
     这个库的原理是隐藏系统提供的导航栏，在ViewController加到导航栏控制器的桟上时加上一个自定的view作为导航栏。加上的这个view用控制器的分类来保存。所以可以直接作为UIViewController的属性使用。
     
     */
    
}


#pragma mark - Tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellStyleValue1;
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    
    return cell ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class tempVC = self.navDataArray[indexPath.section][indexPath.row] ;
    BaseViewController *vc = [[tempVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10 ;
}

#pragma mark - getter/setter
- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        _tableView.dataSource = self ;
        _tableView.delegate = self ;
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        img.backgroundColor = [UIColor lightGrayColor];
        _tableView.tableHeaderView =img ;
    }
    return _tableView ;
}

- (NSArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = @[
                       @[@"导航栏操作"],
                       @[ @"透明", @"导航条渐变"],
                       @[@"无导航条",@"导航条滚动隐藏", @"导航条滚动隐藏(statusBar下停止)", @"导航条动画隐藏",  @"导航条动画隐藏(statusBar下停止)"],
                       @[@"禁用系统返回手势", @"自定义返回手势", @"嵌套scrollview返回"],
                       @[@"statusBar状态改变"]];
    }
    return _dataArray ;
}
- (NSArray *)navDataArray
{
    if (nil == _navDataArray) {
        _navDataArray = @[
                          @[[NavOperateViewController class]],
                          @[[NavTransparentViewController class],
                            [NavAlphaChangeViewController class]],
                          @[[NavEmptyViewController class],
                            [NavSmoothHidenViewController class],
                            [NavSmoothHiden_1_ViewController class],
                            [NavAnimationHidenViewController class],
                            [NavAnimationHiden_1_ViewController class]],
                          @[[NavSystemSlidingViewController class],
                            [NavCustomSlidingViewController class],
                            [NavScrollIncludeViewController class]],
                          @[[NavStatusBarViewController class]]
                          ];
    }
    return _navDataArray ;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
