//
//  GZCircleProgressView.m
//  Test
//
//  Created by armada on 2016/12/10.
//  Copyright © 2016年 com.zlot.gz. All rights reserved.
//

#import "GZCircleProgressView.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//#define kDotColors @[[UIColor purpleColor],[UIColor cyanColor],[UIColor purpleColor],[UIColor yellowColor]]

#define kPaddingSpace (iPhone5?6.0f:8.0f)
#define kOuterLineWidth 1.0f

#define kDashLineLength 60.0f

#define kTextLayerFontSize 11

@interface GZCircleProgressView()<CAAnimationDelegate>

/** 层中点 */
@property(readonly,assign) CGPoint layerCenter;
/** 中层圆 */
@property(nonatomic,strong) CAShapeLayer *middleCircleLayer;
/** 外层圆 */
@property(nonatomic,strong) CAShapeLayer *outerCircleLayer;
/** 轨迹层 */
@property(nonatomic,strong) CAShapeLayer *backTrackLayer;
/** 前景层 */
@property(nonatomic,strong) CAShapeLayer *foreTrackLayer;
/** 渐变层  */
@property(nonatomic,strong) CAGradientLayer *gradientLayer;
/** 文字层 */
@property(nonatomic,strong) CATextLayer *textLayer;
/** 笔触动画 */
@property(nonatomic,strong) CABasicAnimation *strokeEndAnimation;
/** 弧颜色 */
@property(nonatomic,strong) UIColor *arcColor;
/** 圆点中心 */
@property(nonatomic,strong) NSMutableArray<NSValue *> *dotsCenter;
/** 缺口半弧度 */
@property(nonatomic,strong) NSMutableArray<NSNumber *> *radiansOfHalfIntactArc;
/** 折线中点 */
@property(nonatomic,strong) NSMutableArray<NSValue *> *midPointOfDashLines;

/** 标题 */
@property(readonly,nonatomic,strong) NSArray<NSString *> *titles;
/** 值 */
@property(readonly,nonatomic,strong) NSArray<NSString *> *values;
/** 颜色 */
@property(readonly,nonatomic,strong) NSArray<UIColor *> *dotColors;
/** 半径 */
@property(readonly,nonatomic,assign) CGFloat radius;
/** 圆环颜色 */
@property(readonly,nonatomic,assign) CGFloat circleLineWidth;
/** 标签定时器 */
@property(nonatomic,strong) NSTimer *timer;
/** 百分比数字 */
@property(nonatomic,assign) int percentNumber;

@end

@implementation GZCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame
                 circleRadius:(CGFloat)radius
              circleLineWidth:(CGFloat)circleLineWidth
                       titles:(NSArray<NSString *> *)titles
                       values:(NSArray<NSString *> *)values
                    dotColors:(NSArray<UIColor *> *)dotColors{
    
    if(self = [super initWithFrame:frame]) {
        
        _radius = radius;
        _circleLineWidth = circleLineWidth;
        _titles = titles;
        _values = values;
        _dotColors = dotColors;
        
        self.progress = 1;
        
//        [self createOuterCircleLayer];
        [self createMiddleCircleLayer];
        [self createBackTrackLayer];
        [self createForeTrackLayer];
        [self createGradientLayer];
        [self createTextLayer];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/10 target:self selector:@selector(labelIncreaseAnimation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (CGPoint)layerCenter {
    return CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)createBackTrackLayer {
    
    self.backTrackLayer = [CAShapeLayer layer];
    self.backTrackLayer.bounds = self.bounds;
    self.backTrackLayer.fillColor = [UIColor clearColor].CGColor;
    self.backTrackLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.backTrackLayer.position = self.layerCenter;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:self.layerCenter radius:self.radius startAngle:-M_PI_2 endAngle:M_PI*2-M_PI_2 clockwise:YES];
    bezierPath.lineCapStyle = kCGLineCapRound;
    
    self.backTrackLayer.strokeColor = DarkGray.CGColor;
    self.backTrackLayer.lineWidth = self.circleLineWidth;
    self.backTrackLayer.path = bezierPath.CGPath;
    
    [self.layer addSublayer:self.backTrackLayer];
}

- (void)createGradientLayer {
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.bounds = self.backTrackLayer.bounds;
    self.gradientLayer.position = self.layerCenter;
    self.gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0xff7255).CGColor,
                                  (__bridge id)UIColorFromRGB(0x4ffb16b).CGColor
                                  ];
    self.gradientLayer.startPoint = CGPointMake(0.5,0.3);
    self.gradientLayer.endPoint = CGPointMake(0.5,0.7);
    
    self.gradientLayer.mask = self.foreTrackLayer;
    [self.layer addSublayer:self.gradientLayer];
}

- (void)createForeTrackLayer {
    
    self.foreTrackLayer = [CAShapeLayer layer];
    self.foreTrackLayer.bounds = self.bounds;
    self.foreTrackLayer.position = self.layerCenter;
    self.foreTrackLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.foreTrackLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:self.layerCenter radius:self.radius startAngle:-M_PI_2 endAngle:M_PI*2*self.progress-M_PI_2 clockwise:YES];
    
    self.foreTrackLayer.strokeColor = DarkGray.CGColor;
    self.foreTrackLayer.lineWidth= self.circleLineWidth;
    self.foreTrackLayer.path = bezierPath.CGPath;
    self.foreTrackLayer.lineCap = kCALineCapRound;
    self.foreTrackLayer.strokeStart = 0.0f;
    self.foreTrackLayer.strokeEnd = 0.0f;
    
    [self.layer addSublayer:self.foreTrackLayer];
    
    [self.foreTrackLayer addAnimation:self.strokeEndAnimation forKey:@"strokeEndAnimation"];
}

- (void)createTextLayer {
    
    self.textLayer = [CATextLayer layer];
    if(iPhone5) {
        self.textLayer.bounds = CGRectMake(0,0,120,60);
    }else {
       self.textLayer.bounds = CGRectMake(0,0,120,80);
    }
    self.textLayer.position = self.layerCenter;
    self.textLayer.alignmentMode = @"center";
    self.textLayer.foregroundColor = MainRed.CGColor;
    self.textLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.textLayer.string = GetInterestRatePercentString(@"90");
    self.textLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.textLayer.contentsScale = [UIScreen mainScreen].scale;
    self.textLayer.wrapped = YES;
    [self.layer addSublayer:self.textLayer];
    
    CATextLayer *progressText = [CATextLayer layer];
    progressText.bounds = CGRectMake(0, 0, 80, 50);
    progressText.position = CGPointMake(self.layerCenter.x,self.layerCenter.y+50);
    progressText.alignmentMode = @"center";
    progressText.foregroundColor = DarkGray.CGColor;
    progressText.backgroundColor = [UIColor clearColor].CGColor;
    progressText.wrapped = YES;
    progressText.fontSize = 10;
    progressText.contentsScale = [UIScreen mainScreen].scale;
    progressText.string = @"RS智能投顾正在为您配标...";
    [self.layer addSublayer:progressText];
}

- (void)createMiddleCircleLayer{
    
    _middleCircleLayer = [CAShapeLayer layer];
    self.middleCircleLayer.bounds = self.bounds;
    self.middleCircleLayer.position = self.layerCenter;
    self.middleCircleLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    CGFloat startArc = -M_PI_2 + M_PI/3.0;
    CGFloat intervalArc = 0.15;
    CGFloat unitArc = (M_PI*2-intervalArc*self.titles.count)/self.titles.count;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc]init];
    bezierPath.usesEvenOddFillRule = YES;
    
    CGFloat radius = self.radius+self.circleLineWidth/2+kPaddingSpace;
    
    self.dotsCenter = [NSMutableArray array];
    
    _radiansOfHalfIntactArc = [NSMutableArray array];
    
    for(int i=0;i<self.titles.count;i++) {
        
        //Calculate and store the center of dots
        CGFloat dotCenterX = self.layerCenter.x + radius*sin(startArc+M_PI_2-intervalArc/2.0);
        CGFloat dotCenterY = self.layerCenter.y - radius*cos(startArc+M_PI_2-intervalArc/2.0);
        [self.dotsCenter addObject:[NSValue valueWithCGPoint:CGPointMake(dotCenterX, dotCenterY)]];
        
        [bezierPath addArcWithCenter:self.layerCenter radius:radius startAngle:startArc endAngle:startArc+unitArc clockwise:YES];
        
        [self.radiansOfHalfIntactArc addObject:[NSNumber numberWithFloat:startArc-intervalArc/2]];
        startArc += (unitArc + intervalArc);
        
        CGFloat x = self.layerCenter.x + radius*sin(startArc+M_PI_2);
        CGFloat y = self.layerCenter.y - radius*cos(startArc+M_PI_2);
        [bezierPath moveToPoint:CGPointMake(x, y)];
    }
    
    self.middleCircleLayer.lineWidth = kOuterLineWidth;
    self.middleCircleLayer.lineJoin = kCALineCapRound;
    self.middleCircleLayer.lineCap = kCALineCapRound;
    self.middleCircleLayer.fillColor = [UIColor clearColor].CGColor;
    self.middleCircleLayer.strokeColor = [UIColor clearColor].CGColor;
    self.middleCircleLayer.path = bezierPath.CGPath;
    
    [self.layer addSublayer:self.middleCircleLayer];
}

- (void)createDotsLayer {
    
    for(int i=0;i<self.dotColors.count;i++) {
        
        CAShapeLayer *dotLayer = [CAShapeLayer layer];
        dotLayer.bounds = CGRectMake(0,0,8,8);
        dotLayer.position = [self.dotsCenter objectAtIndex:i].CGPointValue;
        
        if(i<self.dotColors.count) {
            dotLayer.backgroundColor = [self.dotColors[i] CGColor];
        }else {
            dotLayer.backgroundColor = [UIColor blackColor].CGColor;
        }
        
        dotLayer.cornerRadius = dotLayer.bounds.size.height/2.0;
        dotLayer.masksToBounds = YES;
        
        [self.layer addSublayer:dotLayer];
    }
}

- (void)createOuterCircleLayer {
    
    _outerCircleLayer = [CAShapeLayer layer];
    self.outerCircleLayer.bounds = self.bounds;
    self.outerCircleLayer.position = self.layerCenter;
    self.outerCircleLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    CGFloat startArc = -M_PI_2 + M_PI/3.0;
    CGFloat intervalArc = 0.15;
    CGFloat unitArc = (M_PI*2-intervalArc*self.titles.count)/self.titles.count;
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc]init];
    bezierPath.usesEvenOddFillRule = YES;
    
    CGFloat radius = self.radius+self.circleLineWidth/2+kPaddingSpace*2;
    
    for(int i=0;i<self.titles.count;i++) {
        
        [bezierPath addArcWithCenter:self.layerCenter radius:radius startAngle:startArc endAngle:startArc+unitArc clockwise:YES];
        
        startArc += (unitArc + intervalArc);
        
        CGFloat x = self.layerCenter.x + radius*sin(startArc+M_PI_2);
        CGFloat y = self.layerCenter.y - radius*cos(startArc+M_PI_2);
        [bezierPath moveToPoint:CGPointMake(x, y)];
    }
    
    self.outerCircleLayer.lineWidth = kOuterLineWidth;
    self.outerCircleLayer.lineJoin = kCALineCapRound;
    self.outerCircleLayer.lineCap = kCALineCapRound;
    self.outerCircleLayer.fillColor = [UIColor clearColor].CGColor;
    self.outerCircleLayer.strokeColor = DarkGray.CGColor;
    self.outerCircleLayer.path = bezierPath.CGPath;
    
    [self.layer addSublayer:self.outerCircleLayer];
}

- (void)createDashLineLayer {
    
    _midPointOfDashLines = [NSMutableArray array];
    
    for(int i=0;i<self.dotsCenter.count;i++) {
        
        CGPoint center = self.dotsCenter[i].CGPointValue;
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.bounds = self.bounds;
        shapeLayer.position = self.layerCenter;
        shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        
        CGFloat radius = 20;
        
        CGFloat radians = self.radiansOfHalfIntactArc[i].floatValue;
        
        if(radians>=-M_PI_2 && radians<0) {
            
            CGPoint pointInCircle = CGPointMake(center.x+10*sin(M_PI_4), center.y-10*cos(M_PI_4));
            [bezierPath moveToPoint:pointInCircle];
            CGPoint cornerPoint = CGPointMake(center.x+radius*sin(M_PI_4), center.y-radius*cos(M_PI_4));
            [bezierPath addLineToPoint:cornerPoint];
            CGPoint endPoint = CGPointMake(cornerPoint.x+kDashLineLength, cornerPoint.y);
            [bezierPath addLineToPoint:endPoint];
            
            [self.midPointOfDashLines addObject:[NSValue valueWithCGPoint:GetMiddlePointBetweenPoints(cornerPoint, endPoint)]];
            
        }else if(radians>=0 && radians<M_PI_2) {
            CGPoint pointInCircle = CGPointMake(center.x+10*sin(M_PI_4), center.y+10*cos(M_PI_4));
            [bezierPath moveToPoint:pointInCircle];
            CGPoint cornerPoint = CGPointMake(center.x+radius*sin(M_PI_4), center.y+radius*cos(M_PI_4));
            [bezierPath addLineToPoint:cornerPoint];
            CGPoint endPoint = CGPointMake(cornerPoint.x+kDashLineLength, cornerPoint.y);
            [bezierPath addLineToPoint:endPoint];
            [self.midPointOfDashLines addObject:[NSValue valueWithCGPoint:GetMiddlePointBetweenPoints(cornerPoint, endPoint)]];
            
        }else if(radians>=M_PI_2 && radians<M_PI) {
            CGPoint pointInCircle = CGPointMake(center.x-10*sin(M_PI_4), center.y+10*cos(M_PI_4));
            [bezierPath moveToPoint:pointInCircle];
            CGPoint cornerPoint = CGPointMake(center.x-radius*sin(M_PI_4), center.y+radius*cos(M_PI_4));
            [bezierPath addLineToPoint:cornerPoint];
            CGPoint endPoint = CGPointMake(cornerPoint.x-kDashLineLength, cornerPoint.y);
            [bezierPath addLineToPoint:endPoint];
            [self.midPointOfDashLines addObject:[NSValue valueWithCGPoint:GetMiddlePointBetweenPoints(cornerPoint, endPoint)]];
            
        }else {
            CGPoint pointInCircle = CGPointMake(center.x-10*sin(M_PI_4), center.y-10*cos(M_PI_4));
            [bezierPath moveToPoint:pointInCircle];
            CGPoint cornerPoint = CGPointMake(center.x-radius*sin(M_PI_4), center.y-radius*cos(M_PI_4));
            [bezierPath addLineToPoint:cornerPoint];
            CGPoint endPoint = CGPointMake(cornerPoint.x-kDashLineLength, cornerPoint.y);
            [bezierPath addLineToPoint:endPoint];
            [self.midPointOfDashLines addObject:[NSValue valueWithCGPoint:GetMiddlePointBetweenPoints(cornerPoint, endPoint)]];
        }
        
        shapeLayer.lineWidth = kOuterLineWidth;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        
        if(i<self.dotColors.count) {
           shapeLayer.strokeColor = [self.dotColors[i] CGColor];
        }else {
            shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        }
        shapeLayer.lineJoin = kCALineCapSquare;
        shapeLayer.lineCap = kCALineCapSquare;
        shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInteger:4],[NSNumber numberWithInteger:4],nil];
        shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:shapeLayer];
    }
}

- (void)createExplainationTextLayers {
    
    for(int i=0;i<self.midPointOfDashLines.count;i++) {
        
        CGPoint middle = self.midPointOfDashLines[i].CGPointValue;
        
        //Upper Text Layer
        CATextLayer *upperTextLayer = [CATextLayer layer];
        upperTextLayer.frame = CGRectMake(0, 0, 80, kTextLayerFontSize+5);
        upperTextLayer.position = CGPointMake(middle.x,middle.y-kTextLayerFontSize);
        upperTextLayer.backgroundColor = [UIColor clearColor].CGColor;
        upperTextLayer.fontSize = kTextLayerFontSize;
        upperTextLayer.contentsScale = [UIScreen mainScreen].scale;
        upperTextLayer.alignmentMode = @"center";
        
        if(i<self.dotColors.count) {
            upperTextLayer.foregroundColor = self.dotColors[i].CGColor;
        }else {
            upperTextLayer.foregroundColor = [UIColor blackColor].CGColor;
        }
        
        if(i<self.titles.count) {
            upperTextLayer.string = self.titles[i];
        }else {
            upperTextLayer.string = @"";
        }
        
        [self.layer addSublayer:upperTextLayer];
        
        //Lower Text Layer
        CATextLayer *lowerTextLayer = [CATextLayer layer];
        lowerTextLayer.frame = CGRectMake(0, 0, 80, kTextLayerFontSize+5);
        lowerTextLayer.position = CGPointMake(middle.x, middle.y+kTextLayerFontSize);
        lowerTextLayer.backgroundColor = [UIColor clearColor].CGColor;
        lowerTextLayer.fontSize = kTextLayerFontSize;
        lowerTextLayer.contentsScale = [UIScreen mainScreen].scale;
        lowerTextLayer.alignmentMode = @"center";
        
        if(i<self.dotColors.count) {
            lowerTextLayer.foregroundColor = self.dotColors[i].CGColor;
        }else {
            lowerTextLayer.foregroundColor = [UIColor blackColor].CGColor;
        }
        
        if(i<self.values.count) {
            lowerTextLayer.string = self.values[i];
        }else {
            lowerTextLayer.string = @"";
        }
        [self.layer addSublayer:lowerTextLayer];
    }
}   

#pragma mark - NSTimer Selector

- (void)labelIncreaseAnimation {
    
    if(self.percentNumber == 100){
        [self.timer invalidate];
        self.timer = nil;
        
        [self createDotsLayer];
        [self createDashLineLayer];
        [self createExplainationTextLayers];
    
        [(UIViewController *)self.delegate performSelector:@selector(allMasksFadeAnimation) withObject:nil afterDelay:0];
    
        return;
    }
    self.percentNumber += 10;
    self.textLayer.string = GetInterestRatePercentString([NSString stringWithFormat:@"%d",self.percentNumber]);
}

- (void)removeLabelCountTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Animation
- (CABasicAnimation *)strokeEndAnimation
{
    if(!_strokeEndAnimation) {
        
        _strokeEndAnimation = [CABasicAnimation animation];
        _strokeEndAnimation.keyPath = @"strokeEnd";
        _strokeEndAnimation.duration = 1.0f;
        _strokeEndAnimation.toValue = @1;
        _strokeEndAnimation.repeatCount = 1;
        _strokeEndAnimation.removedOnCompletion = NO;
        _strokeEndAnimation.fillMode = kCAFillModeForwards;
    }
    return _strokeEndAnimation;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.foreTrackLayer.strokeEnd = 1.0f;
    [CATransaction commit];
}


#pragma mark Helper Function

static inline NSMutableAttributedString* GetInterestRatePercentString(NSString *str){
    
    NSMutableAttributedString *mutableAttributedStr;
    
    if(iPhone5) {
        mutableAttributedStr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:45],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
        
        NSAttributedString *percentSymbol = [[NSAttributedString alloc]initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
        [mutableAttributedStr appendAttributedString:percentSymbol];
    }else {
        mutableAttributedStr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:60],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
        
        NSAttributedString *percentSymbol = [[NSAttributedString alloc]initWithString:@"%" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
        [mutableAttributedStr appendAttributedString:percentSymbol];
    }
    return mutableAttributedStr;
}

static inline CGPoint GetMiddlePointBetweenPoints(CGPoint startPoint, CGPoint endPoint) {
    return CGPointMake(startPoint.x+(endPoint.x-startPoint.x)/2, endPoint.y+(endPoint.y-startPoint.y)/2);
}

@end
