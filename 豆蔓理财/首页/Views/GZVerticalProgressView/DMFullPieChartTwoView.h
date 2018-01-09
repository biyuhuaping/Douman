//
//  GZFullPieChartView.h
//  Test
//
//  Created by armada on 2016/12/15.
//  Copyright © 2016年 com.zlot.gz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMFullPieChartTwoView : UIView

/** 圆环颜色 */
@property(nonatomic,strong) UIColor *circleColor;

/** 圆环线宽 */
@property(nonatomic,assign) CGFloat lineWidth;

/** 圆环半径 */
@property(nonatomic,assign) CGFloat radius;

/** 缺口所在弧度 */
@property(nonatomic,strong) NSArray<NSNumber *>* radians;

/** 引线颜色 */
@property(nonatomic,strong) NSArray<UIColor *>* dashLineColors;

/** 标题域 */
@property(nonatomic,strong) NSArray<NSString *>* titles;

/** 值域 */
@property(nonatomic,strong) NSArray<NSString *>* values;

- (instancetype)initWithFrame:(CGRect)frame
                       radius:(CGFloat)radius
                    lineWidth:(CGFloat)lineWidth
                  circleColor:(UIColor *)circleColor
               dashLineColors:(NSArray<UIColor *> *)dashLineColors
                      radians:(NSArray<NSNumber *> *)radians
                       titles:(NSArray<NSString *>*)titles
                       values:(NSArray<NSString *>*)values;

@end
