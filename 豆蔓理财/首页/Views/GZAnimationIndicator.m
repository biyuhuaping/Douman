//
//  GZAnimationIndicator.m
//  GZAnimationIndicator
//
//  Created by armada on 2016/11/17.
//  Copyright © 2016年 com.zlot.gz. All rights reserved.
//

#import "GZAnimationIndicator.h"

@interface GZAnimationIndicator ()

@property(nonatomic,strong) CAShapeLayer                *shapeLayer;
@property(nonatomic,strong) CAShapeLayer                *dotShapeLayer;

@property(nonatomic,strong) NSMutableArray<CALayer *>   *dotLayers;
@property(nonatomic,strong) CAGradientLayer             *gradientLayer;
@property(nonatomic,strong) CAGradientLayer             *dotGradientLayer;

@property(nonatomic,strong) CABasicAnimation            *strokeEndAnimation;
@property(nonatomic,strong) UIColor                     *circleColor;
@property(nonatomic,strong) UIColor                     *dotColor;
@property(nonatomic,strong) UIColor                     *lightedDotColor;

@end

@implementation GZAnimationIndicator

- (instancetype)initWithFrame:(CGRect)frame
                  circleColor:(UIColor *)circleColor
                     dotColor:(UIColor *)dotColor
              lightedDotColor:(UIColor *)lightedDotColor {
    
    if(self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = circleColor;
        self.dotColor = dotColor;
        self.lightedDotColor = lightedDotColor;
        
        [self createBackgroundCircleLayer];
        [self createLayer];
        [self createDotShapeLayer];
        [self beginAnimation];
    }
    return self;
}

#pragma mark - create layers

- (void)createBackgroundCircleLayer {
    
    CAShapeLayer *trackingLayer = [CAShapeLayer layer];
    trackingLayer.frame = self.bounds;
    trackingLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:trackingLayer.position radius:self.bounds.size.width/2-30 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    trackingLayer.path = bezierPath.CGPath;
    
    trackingLayer.lineWidth = 10;
    trackingLayer.lineCap = kCALineCapRound;
    [trackingLayer setStrokeColor:UIColorFromRGB(0x323b4a).CGColor];
    [trackingLayer setFillColor:[UIColor clearColor].CGColor];
    [self.layer addSublayer:trackingLayer];
}

- (void)createLayer {
    
    _shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.bounds;
    self.shapeLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.width/2-30 startAngle:-M_PI_2 endAngle:M_PI*2-M_PI_2 clockwise:YES];
    
    self.shapeLayer.lineWidth = 10;
    self.shapeLayer.lineCap = kCALineJoinRound;
    [self.shapeLayer setStrokeColor:[UIColor redColor].CGColor];
    [self.shapeLayer setFillColor:[UIColor clearColor].CGColor];
    self.shapeLayer.path = bezierPath.CGPath;
    [self.layer addSublayer:self.shapeLayer];
    
    //create GradientLayer
    _gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    
    [self.gradientLayer setColors:[NSArray arrayWithObjects:
                                   (id)[UIColorFromRGB(0x4378df) CGColor],
                                   (id)[UIColorFromRGB(0x4ecee9) CGColor], nil]];
    self.gradientLayer.mask = self.shapeLayer;
    [self.layer addSublayer:self.gradientLayer];
    
    self.shapeLayer.strokeStart = 0.0f;
    self.shapeLayer.strokeEnd = 0.0f;
}

- (void)createDotShapeLayer {
    
    _dotShapeLayer = [CAShapeLayer layer];
    self.dotShapeLayer.frame = self.bounds;
    self.dotShapeLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    //根据宽度改变radius
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.width/2-10 startAngle:-M_PI_2 endAngle:M_PI*2-M_PI_2 clockwise:YES];
    
    self.dotShapeLayer.lineWidth = 10;
    self.dotShapeLayer.lineCap = kCALineJoinRound;
    [self.dotShapeLayer setStrokeColor:[UIColor redColor].CGColor];
    [self.dotShapeLayer setFillColor:[UIColor clearColor].CGColor];
    self.dotShapeLayer.path = bezierPath.CGPath;
    [self.layer addSublayer:self.dotShapeLayer];
    
    //create GradientLayer
    _dotGradientLayer = [CAGradientLayer layer];
    self.dotGradientLayer.frame = self.bounds;
    [self createDotLayers];
    
    self.dotGradientLayer.mask = self.dotShapeLayer;
    [self.layer addSublayer:self.dotGradientLayer];
    
    self.dotShapeLayer.strokeStart = 0.0f;
    self.dotShapeLayer.strokeEnd = 0.0f;
}

- (void)createDotLayers {
    
    double unit = M_PI*2/24;
    
    for(int i=0;i<24;i++) {
        
        double arch = unit*i;
        
        CGPoint circleCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        CGFloat radius = self.bounds.size.width/2-10;
        CALayer *dotLayer = [CALayer layer];
        dotLayer.frame = CGRectMake( 0, 0, 4, 4);
        dotLayer.position = CGPointMake(radius*sin(arch)+circleCenter.x, circleCenter.y-radius*cos(arch));
        dotLayer.cornerRadius = dotLayer.frame.size.width/2;
        dotLayer.masksToBounds = YES;
        dotLayer.backgroundColor = UIColorFromRGB(0x50f3c0).CGColor;
        [self.dotGradientLayer addSublayer:dotLayer];
    }
}


#pragma mark - animation operation

- (void)beginAnimation {
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.shapeLayer.strokeEnd = 0.0;
    self.dotShapeLayer.strokeEnd = 0.0;
    [CATransaction commit];
    
    [self.shapeLayer addAnimation:self.strokeEndAnimation forKey:@"circleStrokeEnd"];
    [self.dotShapeLayer addAnimation:self.strokeEndAnimation forKey:@"dotStrokeEnd"];
}

- (void)stopAnimation {
    
    [self.shapeLayer removeAllAnimations];
    [self.dotShapeLayer removeAllAnimations];
}

#pragma mark - animation
- (CABasicAnimation *)strokeEndAnimation {
    
    if(!_strokeEndAnimation) {
        _strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _strokeEndAnimation.fromValue = @0;
        _strokeEndAnimation.toValue = @1;
        _strokeEndAnimation.duration = 2.0f;
        _strokeEndAnimation.beginTime = CACurrentMediaTime();
        _strokeEndAnimation.repeatCount = HUGE;
        _strokeEndAnimation.removedOnCompletion = NO;
    }
    return _strokeEndAnimation;
}



@end
