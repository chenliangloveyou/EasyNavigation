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

#import "Xib_1_ViewController.h"
#import "Xib_2_ViewController.h"
#import "PresentViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView ;
@property (nonatomic,strong)NSArray *dataArray ;
@property (nonatomic,strong)NSArray *navDataArray ;

@end

@implementation ViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO ;

    [self.navigationView setTitle:@"EasyNavigation示例"];
    
    self.navigationView.backgroundView.image = nil ;
    self.navigationView.backgroundView.backgroundColor = [UIColor blueColor];
    self.navigationView.backgroundView.alpha = 0.5 ;
    kWeakSelf(self)
    [self.navigationView addLeftButtonWithTitle:@"演示1" clickCallBack:^(UIView *view) {
        [weakself.navigationController pushViewController:PresentViewController.new animated:YES];
    }];
    [self.navigationView addRightButtonWithTitle:@"演示2" callback:^(UIView *view) {
        [weakself.navigationController pushViewController:PresentViewController.new animated:YES];
    }];
   
    self.statusBarStyle = UIStatusBarStyleLightContent;

    [self.view addSubview:self.tableView];
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth_N(), 160)];
    img.backgroundColor = [UIColor yellowColor];
    self.tableView.tableFooterView =img ;
    
    self.tableView.contentInset = UIEdgeInsetsMake(NavigationHeight_N(), 0,0, 0);

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
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
    if ([vc isKindOfClass:PresentViewController.class]) {
        EasyNavigationController *nav = [[EasyNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30 ;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth_N(), 30)];
    view.backgroundColor = [UIColor cyanColor];
    return view;
}
#pragma mark - getter/setter
- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.contentInset = UIEdgeInsetsMake(NavigationHeight_N(), 0, 0, 0);
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cellID"];
        _tableView.dataSource = self ;
        _tableView.delegate = self ;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever ;
        }

        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth_N(), 60)];
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
                       @[@"statusBar状态改变"],
                       @[@"xib不能滚动",@"xib能滚动",@"present示例"]];
    }
    return _dataArray ;
}
- (NSArray *)navDataArray
{
    if (nil == _navDataArray) {
        _navDataArray = @[
                          @[NavOperateViewController.class],
                          @[NavTransparentViewController.class,
                            NavAlphaChangeViewController.class],
                          @[NavEmptyViewController.class,
                            NavSmoothHidenViewController.class,
                            NavSmoothHiden_1_ViewController.class,
                            NavAnimationHidenViewController.class,
                            NavAnimationHiden_1_ViewController.class],
                          @[NavSystemSlidingViewController.class,
                            NavCustomSlidingViewController.class,
                            NavScrollIncludeViewController.class],
                          @[NavStatusBarViewController.class],
                          @[Xib_1_ViewController.class,
                            Xib_2_ViewController.class,
                            PresentViewController.class]
                          ];
    }
    return _navDataArray ;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
