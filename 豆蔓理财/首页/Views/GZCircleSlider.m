//
//  GZCircleSlider.m
//  GZCircleSliderWithPanGuestrue
//
//  Created by armada on 2016/11/29.
//  Copyright © 2016年 com.zlot.gz. All rights reserved.
//

#import "GZCircleSlider.h"

#define kDefaultFontColor [UIColor colorWithWhite:0.5 alpha:0.3]
#define kHighlightedFontColor UIColorFromRGB(0x50f3c0)

#define kDefaultDailLayerColor  UIColorFromRGB(0x487edc)
#define kHighlightedDailLayerColor UIColorFromRGB(0x50f3c0)

#define ToRad(deg) ((M_PI*(deg))/180.00)
#define ToDeg(rad) ((180*rad)/M_PI)
#define SQR(x) ((x)*(x))

#define kImgWidth 270.0f
#define kImgHeight 270.0f

#define kPadding 30.0f

#define kFontSize 15
#define kHighlightedFontSize 18

@interface GZCircleSlider()

{
    int previousIndex;
    
    UIPanGestureRecognizer *panGesture;
    
    UITapGestureRecognizer *tapGesture;
    
}

@property(nonatomic,strong) UIColor *circleColor;
@property(nonatomic,assign) GZCircleHandleStyle handleStyle;

@property(nonatomic,strong) CAShapeLayer *shapeLayer;
@property(nonatomic,strong) UIImageView *handleImgView;
@property(readonly,assign)  float radius;
@property(readonly,assign)  CGPoint centerInSelf;
@property(nonatomic,strong) NSMutableArray<CAShapeLayer *> *dialsLayers;
@property(nonatomic,strong) NSMutableArray<CATextLayer *> *textLayers;
@property(nonatomic,strong) CATextLayer *remarkTextLayer;
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation GZCircleSlider

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth circleColor:(UIColor *)circleColor currentIndex:(int)currentIndex andHandleSytle:(GZCircleHandleStyle)handleStyle{
    
    if(self = [super initWithFrame:frame]) {
        _lineWidth = lineWidth;
        _circleColor = circleColor;
        _handleStyle = handleStyle;
        
        if(currentIndex == 12) {
            _currentIndex = 0;
        }else {
            _currentIndex = currentIndex;
        }
        [self drawCircle];
        [self addDialLayer];
        [self addTextLayers];
        [self setup];
    
        previousIndex = -1;
    }
    return self;
}

- (void)setup {
    
    [self addCircleHandle];
    [self addRemarkTextLayerAt:self.currentIndex];
    [self moveHandleAtIndex:self.currentIndex];
}

- (void)highlightDots {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0/12 target:self selector:@selector(animationInAdvance) userInfo:nil repeats:YES];
}

#pragma mark - Getter/Setter

- (float)radius {
    return self.frame.size.width/2.0-_lineWidth/2-4;
}

- (CGPoint)centerInSelf {
    
    return CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

#pragma mark - Setup

- (void)drawCircle {
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.bounds = self.bounds;
    
    CGPoint circleCenter = self.centerInSelf;
    
    circleLayer.position = circleCenter;
    circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:self.radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    circleLayer.lineWidth = self.lineWidth;
    circleLayer.lineJoin = kCALineCapRound;
    circleLayer.strokeColor = self.circleColor.CGColor;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.path = bezierPath.CGPath;
    
    [self.layer addSublayer:circleLayer];
}

//draw the dial
- (void)addDialLayer {
    
    _dialsLayers = [NSMutableArray array];
    
    for(int i=0;i<12;i++) {
        
        CGFloat radian = M_PI/6.0*i;
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = CGRectMake(0, 0, 4, 4);
        
        CGFloat centerX;
        CGFloat centerY;
        
        if(iPhone5) {
            
            centerX = self.centerInSelf.x + (self.radius - 8 - _lineWidth/2)*sin(radian);
            centerY = self.centerInSelf.y - (self.radius - 8 - _lineWidth/2)*cos(radian);
        }else {
            
            centerX = self.centerInSelf.x + (self.radius - 11 -_lineWidth/2)*sin(radian);
            centerY = self.centerInSelf.y - (self.radius - 11 - _lineWidth/2)*cos(radian);
        }
        
        shapeLayer.position = CGPointMake(centerX, centerY);
        shapeLayer.backgroundColor = kDefaultDailLayerColor.CGColor;
        shapeLayer.cornerRadius = shapeLayer.bounds.size.width/2.0;
        shapeLayer.masksToBounds = YES;
        
        [self.layer addSublayer:shapeLayer];
        
        [_dialsLayers addObject:shapeLayer];
    }
}

- (void)addTextLayers {
    
    _textLayers = [NSMutableArray array];
    
    for(int i=0;i<12;i++) {
        
        CGFloat radian = M_PI/6.0*i;
        
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.frame = CGRectMake(0, 0, 30, 18);
        textLayer.contentsScale = [UIScreen mainScreen].scale;
       
        CGFloat centerX;
        CGFloat centerY;
        
        if(iPhone5) {
            
            centerX = self.centerInSelf.x + (self.radius - 25)*sin(radian);
            centerY = self.centerInSelf.y - (self.radius - 25)*cos(radian);
        }else {
            
            centerX = self.centerInSelf.x + (self.radius - 35)*sin(radian);
            centerY = self.centerInSelf.y - (self.radius - 35)*cos(radian);
        }


        textLayer.position = CGPointMake(centerX, centerY);
        
        if(i==0){
            textLayer.string = @"12";
        }else {
            textLayer.string = [NSString stringWithFormat:@"%d",i];
        }
        textLayer.fontSize = 13;
        textLayer.foregroundColor = kDefaultFontColor.CGColor;
        textLayer.alignmentMode = @"center";
        
        [self.layer addSublayer:textLayer];
        
        [_textLayers addObject:textLayer];
    }
}

- (void)addCircleHandle {
    
    if(self.handleStyle == GZCircleHandleNone) {
        
        if(iPhone5){
            
            _handleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"400-400"]];
            self.handleImgView.frame = CGRectMake(0, 0, 200, 200);
            
        }else {
            
            _handleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"540-540"]];
            self.handleImgView.frame = CGRectMake(0, 0, 270,270);
        }
        
    }else {
        
        if(iPhone5){
            
            _handleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iphone-5"]];
            self.handleImgView.frame = CGRectMake(0, 0, 200, 200);
            
        }else {
            
            _handleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circleHandle"]];
            self.handleImgView.frame = CGRectMake(0, 0, 270,270);
        }
    }
    
    self.handleImgView.center = self.centerInSelf;
    self.handleImgView.userInteractionEnabled = YES;
    
    //add pan guesture
    panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    [self.handleImgView addGestureRecognizer:panGesture];
    
    //add tap gesture
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    [self.handleImgView addGestureRecognizer:tapGesture];
    
    [self.self addSubview:self.handleImgView];
}

- (void)addRemarkTextLayerAt:(int)index {
    
    if(self.remarkTextLayer) {
        [_remarkTextLayer removeFromSuperlayer];
        _remarkTextLayer = nil;
    }
    
    NSAttributedString *str_1;
    NSAttributedString *str_2 = [[NSAttributedString alloc]initWithString:@"个月" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
    if(index == 0){
        str_1 = [[NSAttributedString alloc]initWithString:@"12" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
    }else {
        //[NSString stringWithFormat:@"%d个月",index];
        str_1 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d",index] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:UIColorFromRGB(0xffd542)}];
    }
    
    CGSize size = CGSizeOfString(@"12个月", kFontSize);
    
    _remarkTextLayer = [CATextLayer layer];
    _remarkTextLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    float angle = index * 30.0f;
    float radian = ToRad(angle);
    CGFloat positionX = self.centerInSelf.x + (self.radius+kPadding)*sin(radian);
    CGFloat positionY = self.centerInSelf.y - (self.radius+kPadding)*cos(radian);
    _remarkTextLayer.position = CGPointMake(positionX, positionY);
    
    _remarkTextLayer.backgroundColor = [UIColor clearColor].CGColor;
    _remarkTextLayer.foregroundColor = UIColorFromRGB(0xffd542).CGColor;
    _remarkTextLayer.alignmentMode = @"center";
    _remarkTextLayer.contentsScale = [UIScreen mainScreen].scale;
    _remarkTextLayer.string = CombineAttributedStrings(str_1,str_2);
    
    [self.layer addSublayer:_remarkTextLayer];
}

#pragma mark - Animation
- (void)animationInAdvance {
    
    if(previousIndex == 11) {
        
        self.dialsLayers[previousIndex].backgroundColor = kHighlightedDailLayerColor.CGColor;
        self.textLayers[previousIndex].foregroundColor = kHighlightedFontColor.CGColor;
        
        //destory timer and skip
        [self.timer invalidate];
        self.timer = nil;
        
        self.dialsLayers[previousIndex].backgroundColor = kDefaultDailLayerColor.CGColor;
        self.textLayers[previousIndex].foregroundColor = kDefaultFontColor.CGColor;
        
        self.dialsLayers[self.currentIndex].backgroundColor = kHighlightedDailLayerColor.CGColor;
        self.textLayers[self.currentIndex].foregroundColor = kHighlightedFontColor.CGColor;
        
        return;
    }
    
    if(previousIndex != -1) {
        self.dialsLayers[previousIndex].backgroundColor = kDefaultDailLayerColor.CGColor;
        
        self.textLayers[previousIndex].foregroundColor = kDefaultFontColor.CGColor;
    }
    
    previousIndex += 1;
    
    self.dialsLayers[previousIndex].backgroundColor =  kHighlightedDailLayerColor.CGColor;
    
    self.textLayers[previousIndex].foregroundColor = kHighlightedFontColor.CGColor;
}

#pragma mark - Operation

- (void)moveHandleAtIndex:(int)index {
    
    CGFloat radian = ToRad(index*30.0f);
    self.handleImgView.transform = CGAffineTransformMakeRotation(radian);
    
    if(index==12) {
        index = 0;
    }
    //change dialLayer background color
    self.dialsLayers[self.currentIndex].backgroundColor = kDefaultDailLayerColor.CGColor;
    CAShapeLayer *currentDialLayer = self.dialsLayers[index];
    currentDialLayer.backgroundColor = kHighlightedDailLayerColor.CGColor;
    
    //change textLayer forground color
    self.textLayers[self.currentIndex].foregroundColor = kDefaultFontColor.CGColor;
    self.textLayers[self.currentIndex].fontSize = kFontSize;
    
    CATextLayer *currentTextLayer = self.textLayers[index];
    currentTextLayer.contentsScale = [UIScreen mainScreen].scale;
    currentTextLayer.foregroundColor = kHighlightedFontColor.CGColor;
    currentTextLayer.fontSize = kHighlightedFontSize;
    
    self.currentIndex = index;
    
     [self addRemarkTextLayerAt:index];
}

#pragma mark PanGestureAction

- (void)handlePanEnable:(BOOL)enable {
    
    if(enable) {
        
        if(panGesture == nil) {
            panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
            [self.handleImgView addGestureRecognizer:panGesture];
            
            tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
            [self.handleImgView addGestureRecognizer:tapGesture];
        }
    }else {
        
        [self.handleImgView removeGestureRecognizer:panGesture];
        panGesture = nil;
        
        [self.handleImgView removeGestureRecognizer:tapGesture];
        tapGesture = nil;
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)pan {
    
    _isDraggedOrTapped = YES;
    
    CGPoint currentPoint = [pan locationInView:self];
    CGFloat ang = AngleFromNorth(self.centerInSelf, currentPoint);
    
    // CGFloat radians = ToRad(ang+90);
    int index = round((double)((int)(ang+90)%(int)360)/30);
    
    if(pan.state == UIGestureRecognizerStateBegan) {
        //when pan gesture begun
        [self.remarkTextLayer removeFromSuperlayer];
        self.remarkTextLayer = nil;
        
    }else if(pan.state == UIGestureRecognizerStateChanged){
        
        [self moveHandleAtIndex:index];
        
    }else if(pan.state ==  UIGestureRecognizerStateEnded){
        
        float radians = ToRad(round((double)((int)(ang+90)%(int)360)/30)*30.0);
        
        self.handleImgView.transform = CGAffineTransformMakeRotation(radians);
        
        if(index == 0) {
            [self.delegate circleSliderChangeToIndex:12];
        }else {
            [self.delegate circleSliderChangeToIndex:index];
        }
    
        [self addRemarkTextLayerAt:index];
        
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap {
    
    _isDraggedOrTapped = YES;
    
    CGPoint currentPoint = [tap locationInView:self];
    CGFloat ang = AngleFromNorth(self.centerInSelf, currentPoint);
    
    CGFloat innerRadius = self.radius - self.lineWidth/2;
    CGFloat outerRadius = self.radius + self.lineWidth/2;
    
    CGFloat distance = DistanceBetweenPoints(currentPoint, self.centerInSelf);
    if(distance < innerRadius-15 || distance > outerRadius+15) {
        return;
    }
    // CGFloat radians = ToRad(ang+90);
    int index = round((double)((int)(ang+90)%(int)360)/30);
    
    if(tap.state == UIGestureRecognizerStateBegan) {
        //when pan gesture begun
        [self.remarkTextLayer removeFromSuperlayer];
        self.remarkTextLayer = nil;
        
    }else if(tap.state ==  UIGestureRecognizerStateEnded){
        
        float radians = ToRad(round((double)((int)(ang+90)%(int)360)/30)*30.0);
        
        self.handleImgView.transform = CGAffineTransformMakeRotation(radians);
        
        [self moveHandleAtIndex:index];
        
        if(index == 0) {
            [self.delegate circleSliderChangeToIndex:12];
        }else {
            [self.delegate circleSliderChangeToIndex:index];
        }
        
    }
}

#pragma mark - Helper Functions
static inline float AngleFromNorth(CGPoint p1, CGPoint p2) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y));
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    CGFloat result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

static inline CGSize CGSizeOfString(NSString *str, int fontSize) {
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(999, 999) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return CGSizeMake(rect.size.width, rect.size.height);
}

@end
