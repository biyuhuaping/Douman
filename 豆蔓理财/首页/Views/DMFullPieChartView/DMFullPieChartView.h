//
//  DMFullPieChartView.h
//  豆蔓理财
//
//  Created by edz on 2016/12/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMFullPieChartView : UIView

/** 圆环颜色 */
@property(nonatomic,strong) UIColor *circleColor;

/** 圆环线宽 */
@property(nonatomic,assign) CGFloat lineWidth;

/** 圆环半径 */
@property(nonatomic,assign) CGFloat radius;

/** 缺口所在弧度 */
@property(nonatomic,assign) CGFloat radian;

- (instancetype)initWithFrame:(CGRect)frame
                       radius:(CGFloat)radius
                    lineWidth:(CGFloat)lineWidth
                  circleColor:(UIColor *)circleColor
                       radian:(CGFloat)radian;


@end
