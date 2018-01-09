//
//  DMFullPieChartView.m
//  豆蔓理财
//
//  Created by edz on 2016/12/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMFullPieChartView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//内圆和外圆的间隙
#define kPadding 8.0f
//缺口的间隙的弧度
#define kIntervalArc 0.1f
//圆点半径
#define kDotCircleRadius 2.0f
//虚线的斜线部分长度
#define kDashCornerRadius 20.0f


@interface DMFullPieChartView()

@property(readonly,nonatomic,assign) CGPoint centerPoint;

@end

@implementation DMFullPieChartView


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
                       radius:(CGFloat)radius
                    lineWidth:(CGFloat)lineWidth
                  circleColor:(UIColor *)circleColor
                       radian:(CGFloat)radian{
    
    if(self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _radius = radius;
        _lineWidth = lineWidth;
        _circleColor = circleColor;
        _radian = radian;
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

- (void)setRadian:(CGFloat)radian {
    
    _radian = radian;
    [self setNeedsDisplay];
}

#pragma mark - draw methods

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddArc(ctx, self.centerPoint.x, self.centerPoint.y, self.radius, -M_PI_2, M_PI*2-M_PI_2, 0);
    CGContextSetStrokeColorWithColor(ctx, self.circleColor.CGColor);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //中间圆
    CGFloat midRadius = self.radius + self.lineWidth/2 + kPadding;
    CGFloat startRadian = self.radian + kIntervalArc/2;
    CGFloat endRadian = self.radian - kIntervalArc/2;
    
    CGContextAddArc(ctx,self.centerPoint.x,self.centerPoint.y,midRadius,startRadian, endRadian,0);
    
    [UIColorFromRGB(0x4b6ca7) setStroke];
    //CGContextSetStrokeColorWithColor(ctx, (UIColorFromRGB(0x43567b).CGColor));
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //外圆
    CGFloat outerRadius = midRadius + kPadding;
    CGContextAddArc(ctx, self.centerPoint.x, self.centerPoint.y, outerRadius, startRadian, endRadian, 0);
    CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0x4b6ca7).CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    [self drawDashLinePatternWithContext:ctx];
}

- (void)drawDashLinePatternWithContext:(CGContextRef)ctx {
    
    CGFloat dotCenterX = self.centerPoint.x + (self.radius + kPadding + self.lineWidth/2)*sin(self.radian+M_PI_2);
    CGFloat dotCenterY = self.centerPoint.y - (self.radius + kPadding + self.lineWidth/2)*cos(self.radian+M_PI_2);
    CGPoint dotCenter = CGPointMake(dotCenterX, dotCenterY);
    
    CGContextAddArc(ctx, dotCenterX,dotCenterY, kDotCircleRadius, 0, M_PI*2, 0);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, self.circleColor.CGColor);
    CGContextSetFillColorWithColor(ctx, self.circleColor.CGColor);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGFloat pointX = self.centerPoint.x + (self.radius + kPadding + self.lineWidth/2 + kDotCircleRadius)*sin(self.radian+M_PI_2);
    CGFloat pointY = self.centerPoint.y - (self.radius + kPadding + self.lineWidth/2 + kDotCircleRadius)*cos(self.radian+M_PI_2);
    
    
    CGPoint pointInCircle;
    CGPoint cornerPoint;
    CGPoint endPoint;
    
    CGFloat radianPlus = self.radian + M_PI_2;
    if(radianPlus>=0 && radianPlus<M_PI_2) {
        
        pointInCircle = CGPointMake(pointX, pointY);
        
        CGFloat cornerPointX = dotCenter.x + (kDotCircleRadius + kDashCornerRadius)*sin(M_PI/3.0);
        CGFloat cornerPointY = dotCenter.y - (kDotCircleRadius + kDashCornerRadius)*cos(M_PI/3.0);
        cornerPoint = CGPointMake(cornerPointX, cornerPointY);
        
        endPoint = CGPointMake(cornerPoint.x+100, cornerPoint.y);
        
    }else if(radianPlus>=M_PI_2 && radianPlus<M_PI) {
        
        pointInCircle = CGPointMake(pointX, pointY);
        
        CGFloat cornerPointX = dotCenter.x + (kDotCircleRadius + kDashCornerRadius)*sin(M_PI-M_PI/3.0);
        CGFloat cornerPointY = dotCenter.y - (kDotCircleRadius + kDashCornerRadius)*cos(M_PI-M_PI/3.0);
        cornerPoint = CGPointMake(cornerPointX, cornerPointY);
        
        endPoint = CGPointMake(cornerPoint.x+100, cornerPoint.y);
        
    }else if(radianPlus>=M_PI && radianPlus<M_PI_2*3) {
        
        pointInCircle = CGPointMake(pointX, pointY);
        
        CGFloat cornerPointX = dotCenter.x + (kDotCircleRadius + kDashCornerRadius)*sin(M_PI/3.0+M_PI);
        CGFloat cornerPointY = dotCenter.y - (kDotCircleRadius + kDashCornerRadius)*cos(M_PI/3.0+M_PI);
        cornerPoint = CGPointMake(cornerPointX, cornerPointY);
        
        endPoint = CGPointMake(cornerPoint.x-100, cornerPoint.y);
        
    }else {
        
        pointInCircle = CGPointMake(pointX, pointY);
        
        CGFloat cornerPointX = dotCenter.x + (kDotCircleRadius + kDashCornerRadius)*sin(-M_PI/3.0);
        CGFloat cornerPointY = dotCenter.y - (kDotCircleRadius + kDashCornerRadius)*cos(-M_PI/3.0);
        cornerPoint = CGPointMake(cornerPointX, cornerPointY);
        
        endPoint = CGPointMake(cornerPoint.x-100, cornerPoint.y);
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


@end
