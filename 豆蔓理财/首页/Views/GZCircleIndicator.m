//
//  GZCircleIndicator.m
//  GZCircleIndicator
//
//  Created by armada on 2016/12/2.
//  Copyright © 2016年 com.zlot.gz. All rights reserved.
//

#import "GZCircleIndicator.h"

@interface GZCircleIndicator()

@property(readonly,assign) CGFloat radius;

@property(readonly,assign) float lineWidth;

@property(readonly,assign) CGPoint centerPoint;

@property(nonatomic,strong) CAShapeLayer *shapeLayer;

@property(nonatomic,strong) CAGradientLayer *gradientLayer;

@end


@implementation GZCircleIndicator

- (instancetype)initWithFrame:(CGRect)frame radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth{
    
    if(self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _lineWidth = lineWidth;
        _radius = radius;
        
        [self drawShapeLayer];
        [self drawGradientLayer];
    }
    return self;
}

- (CGPoint)centerPoint {
    return CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
}

- (void)drawShapeLayer {
    
        _shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.position = self.centerPoint;
        [self.shapeLayer setFillColor:[UIColor clearColor].CGColor];
        [self.shapeLayer setStrokeColor:[UIColor redColor].CGColor];
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.lineWidth = self.lineWidth;
    
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:self.radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
        self.shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:self.shapeLayer];
}

- (void)drawGradientLayer {
    
    _gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.position = self.centerPoint;
    
    [self.gradientLayer setColors:@[(__bridge id)UIColorFromRGB(0x4378df).CGColor,
                                    (__bridge id)UIColorFromRGB(0x4ecee9).CGColor]];
    [self.gradientLayer setLocations:@[@0.5,@1]];
    self.gradientLayer.mask = self.shapeLayer;
    self.gradientLayer.startPoint = CGPointMake(0.5,0.0);
    self.gradientLayer.endPoint = CGPointMake(0.5, 0.5);
    
    [self.layer addSublayer:self.gradientLayer];
}

- (void)drawDots {
    
    
    
}


@end
