//
//  YYOnlineBusinessTabController.m
//  mocha
//
//  Created by MJM on 12/27/15.
//  Copyright © 2015 Yao. All rights reserved.
//

#import "YYOnlineBusinessTabController.h"
//controller
#import "YYOnlineDetailController.h"
//model
#import "YYOnlineVC.h"
#import "YYOnlinFeed.h"
#import "YYGoodsDetail.h"
//view
#import "YYOnlineSubjectsCell.h"
#import "YYOnlineGoodsCell.h"
#import "YYOnlineHeaderView.h"

static CGFloat const horizontalMargin = 8;
static CGFloat const shoppingCartWidth = 40;//购物车按钮 宽度
static CGFloat const shoppingListCountWidth = 15; //显示购物车内商品数量的lable宽度

@interface YYOnlineBusinessTabController ()<UITableViewDataSource , UITableViewDelegate >
{
    /**
     *  本电商页的数据模型
     */
    YYOnlineVC *_onlineVCModel;
}
/**
 *  屏幕中央加载时动画
 */
@property (nonatomic,strong) MBProgressHUD *HUD;
/**
 *  本电商页的sections的类名数组
 */
@property (nonatomic,copy) NSArray *sectionsClassNameArray;
/**
 * 导航条
 */
@property (nonatomic,strong) UIView  * navView;
/**
 *搜索栏
 */
@property (nonatomic,strong)YYSearchBar *searchBar;
/**
 *  购物车按钮
 */
@property (nonatomic,strong) UIButton * btnShoppingCart;
/**
 * 购物车物品数量
 */
@property (nonatomic,strong) UILabel  * labShoppingListCount;
/**
 *  主table界面
 */
@property (nonatomic , strong) YYTableView *tableView;
/**
 * table的头部
 */
@property (nonatomic,strong) YYOnlineHeaderView * tableHeaderView;

@end

@implementation YYOnlineBusinessTabController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.navView];
    [_navView addSubview:self.searchBar];
    [_navView addSubview: self.btnShoppingCart];
    [_navView addSubview:self.labShoppingListCount];
    [self.view addSubview:self.tableView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_HUD hide:YES];

}
-(void)viewWillLayoutSubviews{
    //整体table布局
    [_tableView topInContainer:navBarHeight+[YYUtil adjustStatusBarHeightForiOS7] shouldResize:YES];
    [_tableView bottomInContainer:0.0 shouldResize:YES];
    [_tableView leftInContainer:0.0 shouldResize:YES];
    [_tableView rightInContainer:0.0 shouldResize:YES];
    
    [ _searchBar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:horizontalMargin];
    [_searchBar autoSetDimensionsToSize:CGSizeMake(kDeviceWidth-shoppingCartWidth-horizontalMargin, navBarHeight)];
    [_searchBar autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:[YYUtil adjustStatusBarHeightForiOS7]];
    
    [_btnShoppingCart autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_searchBar];
    [_btnShoppingCart autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:horizontalMargin];
    [_btnShoppingCart autoSetDimensionsToSize:CGSizeMake(shoppingCartWidth, shoppingCartWidth)];
    
    [_labShoppingListCount autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_btnShoppingCart withOffset:-3];
    [_labShoppingListCount autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_btnShoppingCart  withOffset:3];
    [_labShoppingListCount autoSetDimensionsToSize:CGSizeMake(shoppingCartWidth, shoppingCartWidth)];
    
}

#pragma mark - requestData
- (void)requestDataForTable:(UITableView *)tableView isReload:(BOOL)isReloading{
    __weak typeof(self) weakSelf = self;
    __weak typeof(_tableView) weakTableView = _tableView;
    if (isReloading) {                                       
        [YYHttpUtil httpPostWithAuthInfo:nil withUrl:@"/v5/market/home" withHttpSuccessBlock:^(id data) {
            _onlineVCModel = [YYOnlineVC objectWithKeyValues:data];
            
            [weakTableView reloadData];
        } withHttpExceptionBlock:^(NSUInteger code, NSString *msg) {
        } withFailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }else{
        
    }
}
#pragma  mark - action methods
- (void)onClickShopCart
{
    if ([YYUser isLogin]) {
        [TalkingData trackEvent:@"购物车点击次数" label:@"" parameters:nil];
        YYOnlineCartController *cartController = [[YYOnlineCartController alloc]init];
        [self.navigationController pushViewController:cartController animated:YES];
    }else{
        YYLoginViewController *loginViewController = [YYLoginViewController sharedInstance];
        YYNavigationController *nav = [YYLoginViewController loginView:self withController:loginViewController];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _onlineVCModel ? 2: 0;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!_onlineVCModel) {
        return 0;
    }
    return  section == 0?[self subjectCountWithModel:_onlineVCModel] : [self goodsCountWithModel:_onlineVCModel];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * subjectCellIdentifier = @"subjectCell";
    static NSString * goodsCellIdentifier = @"goodsCell";
    NSArray *sectionsIndentifier = [NSArray arrayWithObjects:subjectCellIdentifier,goodsCellIdentifier,nil];
    Class cellClass = NSClassFromString(self.sectionsClassNameArray[indexPath.section]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sectionsIndentifier[indexPath.section]];
    if (!cell) {
        cell = [[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sectionsIndentifier[indexPath.section]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0;
    if (indexPath.section == 1) {
        height = [YYOnlineGoodsCell v_heightWithModel:_onlineVCModel indexPath:indexPath rowCount:2];
    }else{
        height = 100;
    }
    return height;
}

#pragma mark - others
/*
 * 返回专题，商品cell数
 */
- (NSInteger ) goodsCountWithModel:(YYOnlineVC *) onlineVCModel{
    NSInteger goodsCount = 0;
    for (int i =0;i< [onlineVCModel.feedList count] ;i++) {
        YYOnlinFeed *tempObj = onlineVCModel.feedList[i];
        goodsCount += tempObj.dataCommodity? 1:0;
    }
    return goodsCount;
}
- (NSInteger ) subjectCountWithModel:(YYOnlineVC *)onlineVCModel{
    NSInteger subjectCount = 0;
    for (int i =0;i< [onlineVCModel.feedList count] ;i++) {
        YYOnlinFeed *tempObj = onlineVCModel.feedList[i];
        subjectCount += tempObj.dataSubject ? 1:0;
    }
    return subjectCount;
}
/*
 * 刷新表头部
 */
- (void)refreshHeaderView{
    
}
#pragma mark - getter

- (MBProgressHUD *)HUD{
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc]initWithView:self.view];
        _HUD.labelText = waitingText;
    }
    return _HUD;
}
- (NSArray *)sectionsClassNameArray{
    if (!_sectionsClassNameArray) {
        _sectionsClassNameArray = [NSArray arrayWithObjects:@"YYOnlineSubjectsCell",@"YYOnlineGoodsCell", nil];
    }
    return _sectionsClassNameArray;
}
- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, navBarHeight+[YYUtil adjustStatusBarHeightForiOS7])];
        _navView.backgroundColor = mochaColorGreen2;
    }
    return _navView;
}
- (YYSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[YYSearchBar alloc]initWithSearchTab];
        _searchBar.backgroundColor = mochaColorGreen2;
        _searchBar.placeString = @"搜索妆品／功效";
    }
    return _searchBar;
}
- (UIButton *)btnShoppingCart
{
    if (!_btnShoppingCart) {
        _btnShoppingCart = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnShoppingCart setImage:[UIImage imageNamed:@"shopping_cart_white"] forState:UIControlStateNormal];
        [_btnShoppingCart setImage:[UIImage imageNamed:@"shopping_cart_white"] forState:UIControlStateHighlighted];
        [_btnShoppingCart addTarget:self action:@selector(onClickShopCart) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return  _btnShoppingCart;
}
- (UILabel *) labShoppingListCount{
    if (!_labShoppingListCount) {
        _labShoppingListCount = [[UILabel alloc]init];
        _labShoppingListCount.layer.cornerRadius = shoppingListCountWidth/2;
        _labShoppingListCount.clipsToBounds = YES;
        _labShoppingListCount.textAlignment = NSTextAlignmentCenter;
        _labShoppingListCount.font = [UIFont systemFontOfSize:9.0];
        _labShoppingListCount.textColor = [UIColor whiteColor];
        _labShoppingListCount.backgroundColor = [UIColor colorWithRed:0.957 green:0.596 blue:0.145 alpha:1.000];
        _labShoppingListCount.layer.masksToBounds = YES;
        _labShoppingListCount.hidden = YES;
        
    }
    return _labShoppingListCount;
}
- (YYTableView *) tableView {
    if (!_tableView) {
        _tableView = [[YYTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableHeaderView = self.tableHeaderView;
        [self requestDataForTable:_tableView isReload:NO];
    }
    return _tableView;
}
- (YYOnlineHeaderView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[YYOnlineHeaderView alloc]init];
    }
    return _tableHeaderView;
}
@end
