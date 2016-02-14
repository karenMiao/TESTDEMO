//
//  YYPopView.m
//  mocha
//
//  Created by MJM on 12/31/15.
//  Copyright © 2015 Yao. All rights reserved.
//

#import "YYPopView.h"

static NSInteger tagValue = 2345;
CGFloat const bottomLineHeight = 3.0;//每个item底部线的高度

@interface YYPopView()

/*
 * 按钮items数组
 */
@property (nonatomic,copy)NSMutableArray * btnArray;
/*
 * 之前选中的按钮
 */
@property (nonatomic,strong)UIButton * preSelectedBtn;

@end

@implementation YYPopView

- (instancetype)initWithWidth:(CGFloat)widthForPopView ItemsInfo:(NSArray *)itemsInfo numberOfItemsInARow:(NSInteger)numberOfItemsInARow heightForItem:(CGFloat)heightForItem{
    self = [super init];
    if (self) {
        self.widthForPopView = widthForPopView;
        self.itemsInfo = itemsInfo;
        self.numberOfItemsInARow = numberOfItemsInARow;
        self.heightForItem = heightForItem;
        [self setDefautValue];
        
        for (NSInteger index = 0; index < [itemsInfo count]; index++) {
            UIButton *tempBtn = self.btnArray[index];
            [self addSubview:tempBtn];
        }
        if ([itemsInfo count]) {
            //默认第一个选中
            _preSelectedBtn = (UIButton *)[self viewWithTag:tagValue];
            _preSelectedBtn.selected = YES;
            UIView *bottomLine = [_preSelectedBtn subviews][1];
            bottomLine.backgroundColor = _titleSelectedColor;
        }
    }
    return self;
}
- (void)layoutSubviews{
    for (NSInteger index = 0; index < [_itemsInfo count]; index++) {
        UIButton *tempBtn = self.btnArray[index];
        CGFloat padding = (index%_numberOfItemsInARow)*(_widthForPopView/_numberOfItemsInARow);
        [tempBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:index/_numberOfItemsInARow*_heightForItem];
        [tempBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:padding];
        [tempBtn autoSetDimension:ALDimensionHeight toSize:_heightForItem];
        [tempBtn autoSetDimension:ALDimensionWidth toSize:_widthForPopView/_numberOfItemsInARow];
    }
}
- (void)setDefautValue{
    _titleNumberOfLines = 2;
    _titleFont = [UIFont systemFontOfSize:9.75];
    _titleSelectedColor = [UIColor colorWithRed:0x85/255.0 green:0xc4/255.0 blue:0x41/255.0 alpha:1];
    _titleNormalColor = [UIColor YYcolorWithHexInt:0x8b8b8b] ;
    _ItemNormalColor = [UIColor clearColor];
    _ItemSelectedColor = [UIColor whiteColor];
    _borderColor = [UIColor YYcolorWithHexInt:0xdedede];
}

-(CGFloat)heightForPopView{
    NSInteger numberOfRows = ceilf((float)[_itemsInfo count]/_numberOfItemsInARow);
    return _heightForItem*numberOfRows;
}

- (void)clickItemAtIndex:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(YYPopView:didSelectItemAtIndex:)]) {
        [self.delegate YYPopView:self didSelectItemAtIndex:sender.tag - tagValue];
    }
    sender.selected = YES;
    UIView * selectedBottomLine = [sender subviews][1];
    selectedBottomLine.backgroundColor = _titleSelectedColor;
    //取消之前选中的按钮状态
    _preSelectedBtn.selected = NO;
    UIView *bottomLine = [_preSelectedBtn subviews][1];
    bottomLine.backgroundColor = [UIColor clearColor];
    _preSelectedBtn = sender;
}
- (void)selectItemAtIndex:(NSInteger)index{
    if (index>0 && index < [self.itemsInfo count]) {
        
        UIButton * tempBtn = [self viewWithTag:tagValue + index];
        tempBtn.selected = YES;
        UIView * selectedBottomLine = [tempBtn subviews][1];
        selectedBottomLine.backgroundColor = _titleSelectedColor;
        //取消之前选中的按钮状态
        _preSelectedBtn.selected = NO;
        UIView *bottomLine = [_preSelectedBtn subviews][1];
        bottomLine.backgroundColor = [UIColor clearColor];
        _preSelectedBtn = tempBtn;
        
        if ([self.delegate respondsToSelector:@selector(YYPopView:didSelectItemAtIndex:)]) {
            [self.delegate YYPopView:self didSelectItemAtIndex:tempBtn.tag - tagValue];
        }
    }
}
- (void)updateItemsInfo:(NSArray *)newIemsInfo{
    _itemsInfo = newIemsInfo;
    _btnArray = nil;
    for (UIView *tempView in self.subviews) {
        [tempView removeFromSuperview];
    }
    for (NSInteger index = 0; index < [newIemsInfo count]; index++) {
        UIButton *tempBtn = self.btnArray[index];
        [self addSubview:tempBtn];
    }
    if ([newIemsInfo count]) {
        //默认第一个选中
        _preSelectedBtn = (UIButton *)[self viewWithTag:tagValue];
        _preSelectedBtn.selected = YES;
        UIView *bottomLine = [_preSelectedBtn subviews][1];
        bottomLine.backgroundColor = _titleSelectedColor;
    }

}
#pragma mark - getter
- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [[NSMutableArray alloc]init];
        //添加每个item按钮
        for (NSInteger index = 0; index < [_itemsInfo count]; index++) {
            UIButton * itemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.widthForPopView/self.numberOfItemsInARow, self.heightForItem)];
            itemBtn.backgroundColor = [UIColor clearColor];
            [itemBtn setTitle:_itemsInfo[index] forState:UIControlStateNormal];
            [itemBtn setTitleColor:_titleSelectedColor forState:UIControlStateSelected];
            [itemBtn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
            itemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            itemBtn.titleLabel.font = _titleFont;
            itemBtn.titleLabel.numberOfLines = _titleNumberOfLines;
            itemBtn.layer.borderColor = _borderColor.CGColor;
            itemBtn.layer.borderWidth = 0.5;
            [itemBtn setTag:tagValue +index];
            [itemBtn addTarget:self action:@selector(clickItemAtIndex:) forControlEvents:UIControlEventTouchUpInside];
            //添加底部选中条
            UIView *bottomLine = [[UIView alloc]init];
            bottomLine.backgroundColor = [UIColor clearColor];
            [itemBtn addSubview:bottomLine];
            [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [bottomLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
            [bottomLine autoSetDimension:ALDimensionHeight toSize:bottomLineHeight];
            [_btnArray addObject:itemBtn];
        }
    }
    return _btnArray;
}
@end
