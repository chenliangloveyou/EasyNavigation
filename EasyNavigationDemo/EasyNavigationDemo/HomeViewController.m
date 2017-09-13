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
    
//    [self.navigationView setBackgroundAlpha:0.0];
//    [self.navigationView navigationAlphaSlowChangeWithScrollow:self.tableView start:NAV_HEIGHT end:NAV_HEIGHT*4];
    
//    [self.navigationView navigationScrollWithScrollow:self.tableView start:NAV_HEIGHT speed:1];
//    [self.navigationView navigationAnimationScroll:self.tableView criticalPoint:NAV_HEIGHT stopToStateBar:NO];
    
    [self.navigationView navigationSmoothScroll:self.tableView start:NAV_HEIGHT speed:0.5 stopToStateBar:NO];
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
    cell.textLabel.text = self.dataArray[indexPath.row%self.dataArray.count];
    
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
        _dataArray = @[@"无导航条",
                       @"渐变",
                       @"导航条滚动",
                       @"导航条滚动(到statebar下面停止)",
                       @"导航条超过一定距离动画滚动",
                       @"导航条超过一定距离动画滚动(到statebar下面停止)"];
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
