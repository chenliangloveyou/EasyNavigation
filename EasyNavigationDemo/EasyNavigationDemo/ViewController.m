//
//  ViewController.m
//  EasyNavigationDemo
//
//  Created by Mr_Chen on 17/8/31.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "ViewController.h"

#import "SecondViewController.h"
#import "UIViewController+EasyNavigationExt.h"
#import "EasyNavigationController.h"
#import "EasyUtils.h"

#import "NavEmptyViewController.h"
#import "NavTransparentViewController.h"
#import "NavAlphaChangeViewController.h"
#import "NavSmoothHidenViewController.h"
#import "NavSmoothHiden_1_ViewController.h"
#import "NavAnimationHidenViewController.h" 
#import "NavAnimationHiden_1_ViewController.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView ;
@property (nonatomic,strong)NSArray *dataArray ;

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
    
    [self.navigationView setBackgroundImage:kImage(@"nav_background_image.png")];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellStyleValue1;
    cell.textLabel.text = self.dataArray[indexPath.row%self.dataArray.count];
    
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            NavEmptyViewController *firstVC = [[NavEmptyViewController alloc ]init];
            [self.navigationController pushViewController:firstVC animated:YES];
        }break;
        case 1:
        {
            NavTransparentViewController  *transVC =[[NavTransparentViewController alloc]init];
            [self.navigationController pushViewController:transVC animated:YES];
        }break ;
        case 2:
        {
            NavAlphaChangeViewController *alphaVC = [[NavAlphaChangeViewController alloc]init];
            [self.navigationController pushViewController:alphaVC animated:YES];
        }break ;
        case 3:
        {
            NavSmoothHidenViewController *alphaVC = [[NavSmoothHidenViewController alloc]init];
            [self.navigationController pushViewController:alphaVC animated:YES];
        }break ;
        case 4:
        {
            NavSmoothHiden_1_ViewController *alphaVC = [[NavSmoothHiden_1_ViewController alloc]init];
            [self.navigationController pushViewController:alphaVC animated:YES];
        }break ;
        case 5:
        {
            NavAnimationHidenViewController *alphaVC = [[NavAnimationHidenViewController alloc]init];
            [self.navigationController pushViewController:alphaVC animated:YES];
        }break ;
        case 6:
        {
            NavAnimationHiden_1_ViewController *alphaVC = [[NavAnimationHiden_1_ViewController alloc]init];
            [self.navigationController pushViewController:alphaVC animated:YES];
        }break ;
        case 7:
        {
            NavAlphaChangeViewController *alphaVC = [[NavAlphaChangeViewController alloc]init];
            [self.navigationController pushViewController:alphaVC animated:YES];
        }break ;
        default:
        {
            SecondViewController *secondVC =[[SecondViewController alloc]init];
            EasyNavigationController *tempNva = (EasyNavigationController *)self.navigationController ;
            [tempNva pushViewController:secondVC animated:YES];
        }
            break;
    }
   
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
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
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
    //自动以返回
    //返回的时候 页面视图下沉。
    //拖动屏幕返回
    //uiscrollview拖动返回
    if (nil == _dataArray) {
        _dataArray = @[@"无导航条",
                       @"透明",
                       @"导航条渐变",
                       @"导航条滚动隐藏",
                       @"导航条滚动隐藏(stateBar下停止)",
                       @"导航条动画隐藏",
                       @"导航条动画隐藏(stateBar下停止)",];
    }
    return _dataArray ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
