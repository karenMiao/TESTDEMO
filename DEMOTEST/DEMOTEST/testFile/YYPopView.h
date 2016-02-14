//
//  YYPopView.h
//  mocha
//
//  Created by MJM on 12/31/15.
//  Copyright © 2015 Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYPopView;
@protocol YYPopViewDelegate <NSObject>

@optional

- (void)YYPopView:(YYPopView*)popView didSelectItemAtIndex:(NSInteger)index;

@end

@interface YYPopView : UIView
#pragma mark - basic property
@property (nonatomic, weak)     id  <YYPopViewDelegate>delegate;
/*
 * 整个view的宽度，默认为整个屏幕的宽度
 */
@property (nonatomic,assign)CGFloat widthForPopView;
/*
 *需在每个按钮上显示的信息数组
 */
@property (nonatomic,copy) NSArray * itemsInfo;
/*
 *一排显示几个item
 */
@property (nonatomic,assign) NSInteger numberOfItemsInARow;
/*
 *一个item的高度
 */
@property (nonatomic,assign)  CGFloat heightForItem;

#pragma mark - UI property
/*
 * 每个item显示的字体大小
 */
@property (nonatomic,strong)UIFont * titleFont;
/*
 *每个item显示的行数
 */
@property (nonatomic,assign)NSInteger titleNumberOfLines;
/*
 *每个item选中时显示的字体颜色
 */
@property (nonatomic,copy)UIColor * titleSelectedColor;
/*
 *每个item未选中时显示的字体颜色
 */
@property (nonatomic,copy)UIColor * titleNormalColor;
/*
 *每个item选中时显示的背景颜色
 */
@property (nonatomic,copy)UIColor * ItemSelectedColor;
/*
 *每个item未选中时显示的字体颜色
 */
@property (nonatomic,copy)UIColor * ItemNormalColor;
/*
 *每个item边框颜色
 */
@property (nonatomic,copy)UIColor * borderColor;

#pragma mark - methods
/*
 * 根据制定的显示内容数组，一排显示多少个，一个需要的高度初始化视图
 */
- (instancetype)initWithWidth:(CGFloat)widthForPopView
                             ItemsInfo:(NSArray *)itemsInfo
        numberOfItemsInARow:(NSInteger)numberOfItemsInARow
                      heightForItem:(CGFloat)heightForItem;
/*
 * 返回该视图的高度
 */
- (CGFloat)height;
@end