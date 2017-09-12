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
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.navigationView setTitle:@"首页"];
    
    kWeakSelf(self)
    [self.navigationView addLeftButtonWithTitle:@"更多" clickCallBack:^(UIView *view) {
        [weakself.navigationView setTitle:@"点击了更多"];
    }];
    
    [self.navigationView addRightButtonWithImage:kImage(@"button_normal.png") hightImage:kImage(@"button_select.png") clickCallBack:nil];
    
    [self.navigationView setBackgroundImage:kImage(@"nav_background_image.png")];
    
    [self.navigationView setBackgroundAlpha:0.0];
    [self.navigationView navigationAlphaSlowChangeWithScrollow:self.tableView start:NAV_HEIGHT end:NAV_HEIGHT*4];
    
    [self.navigationView navigationScrollStopStateBarWithScrollow:self.tableView];
    __block int ddd = 100 ;//加上  static __week 结果会是 103 不加是3
    long (^sum)(int a , int b) = ^long(int a, int b){
        return ddd+a+b ;
    };
    ddd = 0 ;
    NSLog(@"========== %ld",sum(1,2));
    
    [self.view addSubview:self.tableView];

}


#pragma mark - Tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count*20 ;
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
    cell.textLabel.text = self.dataArray[indexPath.row%2];
    
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
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO ;
        _tableView.dataSource = self ;
        _tableView.delegate = self ;
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
        img.backgroundColor = [UIColor lightGrayColor];
        _tableView.tableHeaderView =img ;
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
