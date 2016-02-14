//
//  UIColor+YY.m
//  mocha
//
//  Created by 何鑫 on 15/8/14.
//  Copyright (c) 2015年 Yao. All rights reserved.
//

#import "UIColor+YY.h"

@implementation UIColor (YY)
+ (UIColor *)YYcolorWithHexInt:(NSUInteger)hexInt alpha:(CGFloat)alpha {
    if (alpha > 1 || alpha < 0) {
        alpha = 1;
    }
    if (hexInt > 0xffffff) {
        hexInt = 0xffffff;
    }
    
    NSUInteger red = hexInt>>16;
    NSUInteger green = hexInt>>8 & 0x00ff;
    NSUInteger blue = hexInt & 0x0000ff;
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

+ (UIColor *)YYcolorWithHexInt:(NSUInteger)hexInt {
    return [UIColor YYcolorWithHexInt:hexInt alpha:1];
}
@end
