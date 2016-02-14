//
//  KMTabBarController.m
//  DEMOTEST
//
//  Created by MJM on 2/2/16.
//  Copyright © 2016 MJM. All rights reserved.
//

#import "KMTabBarController.h"
#import "ViewController.h"
@interface KMTabBarController ()

@end

@implementation KMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 1.添加第一个控制器
    // 1.1 初始化
    ViewController *oneVC = [[ViewController alloc]init];
    // 1.2 把oneVC添加为UINavigationController的根控制器
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:oneVC];
    // 设置tabBar的标题
    nav1.title = @"首页(下)";
    [nav1.navigationBar setBackgroundColor:[UIColor yellowColor]];
 //   [nav1.navigationBar setBackgroundImage:[UIImage imageNamed:@"commentary_num_bg"] forBarMetrics:UIBarMetricsDefault];
    // 设置tabBar的图标
    nav1.tabBarItem.image = [UIImage imageNamed:@"share_white"];
    // 设置navigationBar的标题
    oneVC.navigationItem.title = @"首页";
    // 设置背景色（这些操作可以交给每个单独子控制器去做）
    oneVC.view.backgroundColor = [UIColor whiteColor];
    // 1.3 把UINavigationController交给UITabBarController管理
    [self addChildViewController:nav1];

}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self setUpAllChildViewController];
//}/**
//  * 添加所有子控制器方法
//  */
//- (void)setUpAllChildViewController{ // 1.添加第一个控制器
//      CYXOneViewController *oneVC = [[CYXOneViewController alloc]init];
//      [self setUpOneChildViewController:oneVC image:[UIImage imageNamed:@"tab_home_icon"] title:@"首页"]; // 2.添加第2个控制器
//      CYXTwoViewController *twoVC = [[CYXTwoViewController alloc]init];
//      [self setUpOneChildViewController:twoVC image:[UIImage imageNamed:@"js"] title:@"技术"]; // 3.添加第3个控制器
//      CYXThreeViewController *threeVC = [[CYXThreeViewController alloc]init];
//      [self setUpOneChildViewController:threeVC image:[UIImage imageNamed:@"qw"] title:@"博文"]; // 4.添加第4个控制器
//      CYXFourViewController *fourVC = [[CYXFourViewController alloc]init];
//      [self setUpOneChildViewController:fourVC image:[UIImage imageNamed:@"user"] title:@"我的江湖"];
//  }
/**
 * 添加一个子控制器的方法
 */
- (void)setUpOneChildViewController:(UIViewController *)viewController image:(UIImage *)image title:(NSString *)title{
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:viewController];
    navC.title = title;
    navC.tabBarItem.image = image;
    [navC.navigationBar setBackgroundImage:[UIImage imageNamed:@"commentary_num_bg"] forBarMetrics:UIBarMetricsDefault];
    viewController.navigationItem.title = title;
    [self addChildViewController:navC];
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
