//
//  GZFullPieChartView.m
//  Test
//
//  Created by armada on 2016/12/15.
//  Copyright © 2016年 com.zlot.gz. All rights reserved.
//

#import "DMFullPieChartTwoView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//内圆和外圆的间隙
#define kPadding 8.0f
//缺口的间隙的弧度
#define kIntervalArc 0.1f
//圆点半径
#define kDotCircleRadius 2.0f
//虚线的斜线部分长度
#define kDashCornerRadius 20.0f

#define kHorizontalDashLineLength 60.0f

@interface DMFullPieChartTwoView()

@property(readonly,nonatomic,assign) CGPoint centerPoint;

@property(nonatomic,strong) NSMutableArray<NSValue *>* dashLineCenters;

@end

@implementation DMFullPieChartTwoView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
                       radius:(CGFloat)radius
                    lineWidth:(CGFloat)lineWidth
                  circleColor:(UIColor *)circleColor
               dashLineColors:(NSArray<UIColor *> *)dashLineColors
                       radians:(NSArray<NSNumber *> *)radians
                       titles:(NSArray<NSString *>*)titles
                       values:(NSArray<NSString *>*)values{
    
    if(self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _radius = radius;
        _lineWidth = lineWidth;
        _circleColor = circleColor;
        _dashLineColors = dashLineColors;
        _radians = radians;
        _titles = titles;
        _values = values;
    }
    return self;
}

#pragma mark - getter and setter

- (CGPoint)centerPoint {
    return CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)setCircleColor:(UIColor *)circleColor {
    
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setRadius:(CGFloat)radius {
    
    _radius = radius;
    [self setNeedsDisplay];
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    
    _titles = titles;
    [self setNeedsDisplay];
}

- (void)setValues:(NSArray<NSString *> *)values {
    
    _values = values;
    [self setNeedsDisplay];
}

- (void)setRadians:(NSArray<NSNumber *> *)radians {
    
    _radians = radians;
    [self setNeedsDisplay];
}

- (void)setDashLineColors:(NSArray<UIColor *> *)dashLineColors {
    
    _dashLineColors = dashLineColors;
    [self setNeedsDisplay];
}

#pragma mark - draw methods

// 一共三个圆弧（外面两个大约1像素的灰色圆弧，中间一个MainRed颜色的圆弧）
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddArc(ctx, self.centerPoint.x, self.centerPoint.y, self.radius, -M_PI_2, M_PI*2-M_PI_2, 0);
    CGContextSetStrokeColorWithColor(ctx, self.circleColor.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //画中间圆弧(第二个圆弧)
//    CGFloat midRadius = self.radius + self.lineWidth/2 + kPadding;
//    CGFloat startRadian = 0;
//    CGFloat endRadian = 0;
//    
//    for(int index = 0; index<=self.radians.count;index++) {
//        
//        if(index == 0) {
//            startRadian = 0;
//        }else {
//            startRadian = endRadian + kIntervalArc;
//        }
//        
//        if(index != self.radians.count) {
//            endRadian = self.radians[index].floatValue - kIntervalArc/2;
//        }else {
//            endRadian = M_PI*2;
//        }
    
//        CGContextAddArc(ctx,self.centerPoint.x,self.centerPoint.y,midRadius,startRadian-M_PI_2, endRadian-M_PI_2,0);
//        [UIColorFromRGB(0x43567b) setStroke];
    

        //CGContextSetStrokeColorWithColor(ctx, (UIColorFromRGB(0x43567b).CGColor));
        CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
        CGContextSetLineCap(ctx, kCGLineCapSquare);
        CGContextSetLineWidth(ctx, 1.0);
        CGContextDrawPath(ctx, kCGPathStroke);
//
//        //外圆(第三个圆弧)
//        CGFloat outerRadius = midRadius + kPadding;
//        CGContextAddArc(ctx, self.centerPoint.x, self.centerPoint.y, outerRadius, startRadian-M_PI_2, endRadian-M_PI_2, 0);
//        CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0x25334d).CGColor);
//        CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
//        CGContextSetLineCap(ctx, kCGLineCapSquare);
//        CGContextSetLineWidth(ctx, 1.0);
//        CGContextDrawPath(ctx, kCGPathStroke);
//    }
    
    [self drawDashLinePatternWithContext:ctx];
}

- (void)drawDashLinePatternWithContext:(CGContextRef)ctx {

    _dashLineCenters = [NSMutableArray array];
    
    for(int index=0; index<self.radians.count; index++) {
        
        CGFloat radian = [self.radians objectAtIndex:index].floatValue - M_PI_2;
        
        CGFloat dotCenterX = self.centerPoint.x + (self.radius + kPadding + self.lineWidth/2)*sin(radian+M_PI_2);
        CGFloat dotCenterY = self.centerPoint.y - (self.radius + kPadding + self.lineWidth/2)*cos(radian+M_PI_2);
        CGPoint dotCenter = CGPointMake(dotCenterX, dotCenterY);
        
        CGContextAddArc(ctx, dotCenterX,dotCenterY, kDotCircleRadius, 0, M_PI*2, 0);
        CGContextSetLineWidth(ctx, 1.0);
        CGContextSetStrokeColorWithColor(ctx, self.dashLineColors[index].CGColor);
        CGContextSetFillColorWithColor(ctx, self.dashLineColors[index].CGColor);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        CGFloat pointX = self.centerPoint.x + (self.radius + kPadding + self.lineWidth/2 + kDotCircleRadius)*sin(radian+M_PI_2);
        CGFloat pointY = self.centerPoint.y - (self.radius + kPadding + self.lineWidth/2 + kDotCircleRadius)*cos(radian+M_PI_2);
        
        CGPoint pointInCircle;
        CGPoint cornerPoint;
        CGPoint endPoint;
        
        CGFloat radianPlus = radian + M_PI_2;
        
        if(radianPlus>=0 && radianPlus<M_PI_2) {
            
            pointInCircle = CGPointMake(pointX, pointY);
            
            CGFloat cornerPointX = dotCenter.x + (kDotCircleRadius + kDashCornerRadius)*sin(M_PI/3.0);
            CGFloat cornerPointY = dotCenter.y - (kDotCircleRadius + kDashCornerRadius)*cos(M_PI/3.0);
            cornerPoint = CGPointMake(cornerPointX, cornerPointY);
            
            endPoint = CGPointMake(cornerPoint.x+kHorizontalDashLineLength, cornerPoint.y);
            
            [_dashLineCenters addObject:[NSValue valueWithCGPoint:CGPointMake(cornerPointX+kHorizontalDashLineLength/2, cornerPointY)]];
            
        }else if(radianPlus>=M_PI_2 && radianPlus<M_PI) {
            
            pointInCircle = CGPointMake(pointX, pointY);
            
            CGFloat cornerPointX = dotCenter.x + (kDotCircleRadius + kDashCornerRadius)*sin(M_PI-M_PI/3.0);
            CGFloat cornerPointY = dotCenter.y - (kDotCircleRadius + kDashCornerRadius)*cos(M_PI-M_PI/3.0);
            cornerPoint = CGPointMake(cornerPointX, cornerPointY);
            
            endPoint = CGPointMake(cornerPoint.x+kHorizontalDashLineLength, cornerPoint.y);
            
            [_dashLineCenters addObject:[NSValue valueWithCGPoint:CGPointMake(cornerPointX+kHorizontalDashLineLength/2, cornerPointY)]];
            
        }else if(radianPlus>=M_PI && radianPlus<M_PI_2*3) {
            
            pointInCircle = CGPointMake(pointX, pointY);
            
            CGFloat cornerPointX = dotCenter.x + (kDotCircleRadius + kDashCornerRadius)*sin(M_PI/3.0+M_PI);
            CGFloat cornerPointY = dotCenter.y - (kDotCircleRadius + kDashCornerRadius)*cos(M_PI/3.0+M_PI);
            cornerPoint = CGPointMake(cornerPointX, cornerPointY);
            
            endPoint = CGPointMake(cornerPoint.x-kHorizontalDashLineLength, cornerPoint.y);
            
            [_dashLineCenters addObject:[NSValue valueWithCGPoint:CGPointMake(cornerPointX-kHorizontalDashLineLength/2, cornerPointY)]];
            
        }else {
            
            pointInCircle = CGPointMake(pointX, pointY);
            
            CGFloat cornerPointX = dotCenter.x + (kDotCircleRadius + kDashCornerRadius)*sin(-M_PI/3.0);
            CGFloat cornerPointY = dotCenter.y - (kDotCircleRadius + kDashCornerRadius)*cos(-M_PI/3.0);
            cornerPoint = CGPointMake(cornerPointX, cornerPointY);
            
            endPoint = CGPointMake(cornerPoint.x-kHorizontalDashLineLength, cornerPoint.y);
            
            [_dashLineCenters addObject:[NSValue valueWithCGPoint:CGPointMake(cornerPointX-kHorizontalDashLineLength/2, cornerPointY)]];
        }
        
        CGFloat lengths[] = {4,4};
        CGContextSetLineDash(ctx, 0, lengths, 2);
        
        CGContextMoveToPoint(ctx, pointInCircle.x, pointInCircle.y);
        CGContextAddLineToPoint(ctx, cornerPoint.x, cornerPoint.y);
        CGContextStrokePath(ctx);
        
        CGContextMoveToPoint(ctx, cornerPoint.x, cornerPoint.y);
        CGContextAddLineToPoint(ctx,endPoint.x, endPoint.y);
        CGContextStrokePath(ctx);
        
    }
    
    [self drawTexts];
}


- (void)drawTexts {
    
    for(int index=0; index<self.dashLineCenters.count; index++) {
        
        CGPoint dashLineCenter = [self.dashLineCenters objectAtIndex:index].CGPointValue;
        
        [self.titles[index] drawAtPoint:CGPointMake(dashLineCenter.x-15, dashLineCenter.y-18) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:self.dashLineColors[index]}];
        
        [self.values[index] drawAtPoint:CGPointMake(dashLineCenter.x-15, dashLineCenter.y+2) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:self.dashLineColors[index]}];
    }

}

@end
