//
//  HomeViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "HomeViewController.h"

#import "SecondViewController.h"
#import "UIViewController+EasyNavigationExt.h"
#import "EasyNavigationController.h"
#import "EasyUtils.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView ;
@property (nonatomic,strong)NSArray *dataArray ;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationView setTitle:@"首页"];
    [self.navigationView removeAllLeftButton];
 
    
    kWeakSelf(self)
    [self.navigationView addLeftButtonWithTitle:@"更多" clickCallBack:^(UIView *view) {
        [weakself.navigationView setTitle:@"点击了更多"];
    }];
    
//    UIView *asV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
//    asV.backgroundColor = [UIColor blueColor];
//    [self.navigationView addSubview:asV clickCallback:^(UIView *view) {
//        [weakself.navigationView setTitle:@"hongshe"];
//    }];
    
//    __block UIView *tempV = [self.navigationView addLeftButtonWithTitle:@"错误了" clickCallBack:^(UIView *view) {
////        [weakself.navigationView addtitleView:asV];
////        [weakself.navigationView removeAllLeftButton];
//    }];
    
//    UIView *tempv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 2, 100)];
//    tempv.backgroundColor = [UIColor redColor];
//    [self.navigationView addLeftView:tempv clickCallback:^(UIView *view) {
//        [weakself.navigationView removeLeftView:tempV];
////        [tempV removeFromSuperview];
//    }];
    
    [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"button_normal.png"] hightImage:[UIImage imageNamed:@"button_select.png"] clickCallBack:^(UIView *view) {
        
    }];
    
    [self.navigationView addRightButtonWithImage:[UIImage imageNamed:@"default.png"] clickCallBack:nil];
    
    [self.navigationView addRightButtonWithTitle:@"可惜好啊" clickCallBack:nil];
    
    [self.view addSubview:self.tableView];

    // Do any additional setup after loading the view.
}
- (void)backclick
{

}

#pragma mark - Tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SecondViewController *secondVC =[[SecondViewController alloc]init];
    EasyNavigationController *tempNva = (EasyNavigationController *)self.navigationController ;
    [tempNva pushViewController:secondVC animated:YES];
//    [self presentViewController:secondVC animated:YES completion:nil];

//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT_EXCEPTNAV)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO ;
        _tableView.dataSource = self ;
        _tableView.delegate = self ;
    }
    return _tableView ;
}

- (NSArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = @[@"无导航条",@"渐变"];
    }
    return _dataArray ;
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
