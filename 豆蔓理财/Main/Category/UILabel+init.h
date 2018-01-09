//
//  UILabel+init.h
//  ProductDetail
//
//  Created by wujianqiang on 16/10/18.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (init)

+ (UILabel *)initWithFrame:(CGRect)frame
                      Font:(CGFloat)font
                      Text:(NSString *)text
                 Alignment:(NSTextAlignment)aligent
                 TextColor:(UIColor *)color;
@end
