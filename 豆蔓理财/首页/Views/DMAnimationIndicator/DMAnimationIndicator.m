//
//  DMAnimationIndicator.m
//  豆蔓理财
//
//  Created by edz on 2016/12/7.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMAnimationIndicator.h"

@interface DMAnimationIndicator()
{
    UILabel *label;
}

@property(nonatomic,strong) CAShapeLayer *shapeLayer;

@property(nonatomic,strong) CAShapeLayer *backLayer;

@property(nonatomic,strong) CAGradientLayer *gradientLayer;


@end

@implementation DMAnimationIndicator

- (instancetype)initWithFrame:(CGRect)frame totalBidpercent:(CGFloat )totalBidpercent{
    
    if(self = [super initWithFrame:frame]) {

        [self createLayer];
        
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, 100, 100);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = MainRed; //////////////ffd542
        label.font = [UIFont systemFontOfSize:25];
        label.center = CGPointMake(self.shapeLayer.bounds.size.width/2, self.shapeLayer.bounds.size.height/2);
        [self addSubview:label];
        
        
        UILabel *total = [[UILabel alloc] init];
        total.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y + 80, 100, 12);
        total.textColor = LightGray; /////////////4b6ca7
        total.textAlignment = NSTextAlignmentCenter;
        total.text =@"筹标进度";
        total.font = SYSTEMFONT(14);
        [self addSubview:total];

    }
    return self;
}




- (void)setTotalBidpercent:(CGFloat )totalBidpercent{
    
    _totalBidpercent = totalBidpercent;
    float a = _totalBidpercent;
    label.text = [NSString stringWithFormat:@"%.2f%%",a];
    
    NSNumber * nums = @(_totalBidpercent/100);
    
    
    [self strokeEndAnimationaddValue:nums];
    [self.shapeLayer addAnimation:self.strokeEndAnimation forKey:@"strokeEnd"];
}


- (void)createLayer {
    
    
    self.backLayer = [CAShapeLayer layer];
    self.backLayer.frame = self.bounds;
    CGPoint center = CGPointMake(self.backLayer.bounds.size.width/2, self.backLayer.bounds.size.height/2);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:self.bounds.size.width/2-50 startAngle:-M_PI_2 endAngle:(M_PI*2-M_PI_2) clockwise:YES];
    
    [self.backLayer setStrokeColor:UIColorFromRGB(0xf5f5f5).CGColor];
    [self.backLayer setFillColor:[UIColor clearColor].CGColor];
    self.backLayer.lineWidth = 12.0f;
    self.backLayer.lineJoin = kCALineCapButt;
    self.backLayer.lineCap = kCALineCapButt;
    self.backLayer.path = bezierPath.CGPath;
    [self.layer addSublayer:self.backLayer];
    

    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.bounds;
//    CGPoint center = CGPointMake(self.shapeLayer.bounds.size.width/2, self.shapeLayer.bounds.size.height/2);
//    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:self.bounds.size.width/2-50 startAngle:-M_PI_2 endAngle:(M_PI*2-M_PI_2) clockwise:YES];
    
    [self.shapeLayer setStrokeColor:[UIColor cyanColor].CGColor];
    [self.shapeLayer setFillColor:[UIColor clearColor].CGColor];
    self.shapeLayer.lineWidth = 12.0f;
    self.shapeLayer.lineJoin = kCALineCapSquare;
    self.shapeLayer.lineCap = kCALineCapSquare;
    self.shapeLayer.path = bezierPath.CGPath;
    [self.layer addSublayer:self.shapeLayer];
    
    //create GradientLayer
    _gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    
    [self.gradientLayer setColors:[NSArray arrayWithObjects:
                                   (id)[MainRed CGColor],
                                   (id)[MainRed CGColor], nil]];
    self.gradientLayer.mask = self.shapeLayer;


    
    
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 0);
    [self.layer addSublayer:self.gradientLayer];
    
    self.shapeLayer.strokeStart = 0.0f;
    self.shapeLayer.strokeEnd = 0.0f;
    
//    [self strokeEndAnimationaddValue:0];
//    [self.shapeLayer addAnimation:self.strokeEndAnimation forKey:@"strokeEnd"];
    

}


- (void )strokeEndAnimationaddValue:(NSNumber *)nums {
    
   
    _strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    _strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    _strokeEndAnimation.fillMode = kCAFillModeForwards;
    _strokeEndAnimation.fromValue = @0;
    
    if(nums.doubleValue<0.99999 && nums.doubleValue>0.975) {
        _strokeEndAnimation.toValue = @0.975;
    }else {
        _strokeEndAnimation.toValue = nums;
    }
    _strokeEndAnimation.duration = 2.0;
    _strokeEndAnimation.repeatCount = 1;
    _strokeEndAnimation.removedOnCompletion = NO;
        

    
}


@end
