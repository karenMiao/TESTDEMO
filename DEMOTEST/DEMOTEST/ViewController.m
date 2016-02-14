//
//  ViewController.m
//  DEMOTEST
//
//  Created by MJM on 1/1/16.
//  Copyright © 2016 MJM. All rights reserved.
//

#import "ViewController.h"
#import "YYPopView.h"

@interface ViewController ()<YYPopViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.text = @"left";
    leftLabel.backgroundColor = [UIColor grayColor];
    UILabel *rightLabel = [[UILabel alloc]init];
    rightLabel.text = @"right";
    rightLabel.backgroundColor = [UIColor grayColor];
    UILabel *middleLabel = [[UILabel alloc]init];
    middleLabel.text = @"middle";
    middleLabel.backgroundColor = [UIColor grayColor];
    [self.view addSubview:leftLabel];
    [self.view addSubview:middleLabel];
    [self.view addSubview:rightLabel];

    [leftLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:200];
    [leftLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    
    [middleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:leftLabel withOffset:20];
    [middleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:leftLabel];
    
    [rightLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:leftLabel];
    [rightLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
}

#pragma mark - delegate

# pragma  mark - getter


@end
