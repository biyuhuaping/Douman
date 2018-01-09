//
//  UILabel+init.m
//  ProductDetail
//
//  Created by wujianqiang on 16/10/18.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "UILabel+init.h"

@implementation UILabel (init)

+ (UILabel *)initWithFrame:(CGRect)frame Font:(CGFloat)font Text:(NSString *)text Alignment:(NSTextAlignment)aligent TextColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = aligent;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    label.text = text;
    return label;
}

@end
