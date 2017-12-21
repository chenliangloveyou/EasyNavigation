//
//  NavOperateViewController.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/14.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "NavOperateViewController.h"

@interface NavOperateViewController ()

@property (nonatomic,strong)NSArray *dataArray ;

@end

@implementation NavOperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label  =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    label.numberOfLines = 0 ;
    label.backgroundColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter ;
    label.text = @"\n以下操作只会对本导航条起作用。\n如果想改变整个工程中导航条属性，请设置EasyNavigationOptions.h中的属性";
    self.tableView.tableHeaderView = label ;
    self.statusBarStyle = UIStatusBarStyleLightContent ;
//    self.navbigTitleType = NavBigTitleTypeIOS11 ;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellStyleValue1;
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            kWeakSelf(self)
//            UIButton *addButton  =[UIButton buttonWithType:UIButtonTypeCustom];
//            [addButton setImage:kImage(@"nav_btn_back.png") forState:UIControlStateNormal];
//            [addButton setTitle:@" 返回" forState:UIControlStateNormal];
//            [addButton setFrame:CGRectMake(0, 0, 60, 44)];
//            [self.navigationView addLeftView:addButton clickCallback:^(UIView *view) {
//                [weakself.navigationController popViewControllerAnimated:YES];
//            }];
            
            [self.navigationView addLeftButtonWithTitle:@"新增fadd一个" clickCallBack:^(UIView *view) {
                [weakself.navigationController popViewControllerAnimated:YES];
            }];
            
        }break;
        case 1:
        {
            if (!self.navigationView.leftViewArray) {
                return ;
            }
            UIView *leftView = self.navigationView.leftViewArray.firstObject ;
            [self.navigationView removeLeftView:leftView];
        }break;
        case 2:
        {
            [self.navigationView setTitle:@"我是标题"];
        }break;
        case 3:
        {
            [self.navigationView setTitle:@"我是改变后的标题"];
        }break;
        case 4:
        {
           __block UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, -10, SCREEN_WIDTH-180, self.navigationOrginalHeight + 20)];
            view.backgroundColor = [UIColor purpleColor];
            [self.navigationView addSubview:view clickCallback:^(UIView *view) {
                [view removeFromSuperview];
            }];
        }break;
        case 5:
        {
            [self.navigationView setNavigationBackgroundAlpha:0];
        }break;
        case 6:
        {
            [self.navigationView setBackgroundColor:[UIColor orangeColor]];
        }break;
        case 7:
        {
            self.navigationView.hidden = YES ;
//            if (self.navigationView) {
//                [self.navigationView removeFromSuperview];
//                self.navigationView = nil ;
//            }
        }break;
        case 8:
        {
            self.navigationView.hidden = NO ;
//            if (!self.navigationView) {
//                EasyNavigationView *nav = [[EasyNavigationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , NAV_HEIGHT)];
//                [self setNavigationView:nav];
//                [self.view addSubview:nav];
//            }
        }break ;
        default:
            break;
    }
}
- (NSArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = @[
                       @"左边增加一个按钮",
                       @"左边删除一个按钮",
                       @"增加一个标题",
                       @"改变标题的字体",
                       @"增加一个视图",
                       @"导航条透明度改变",
                       @"改变导航条背景颜色",
                       @"移除导航条",
                       @"添加导航条"];
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
