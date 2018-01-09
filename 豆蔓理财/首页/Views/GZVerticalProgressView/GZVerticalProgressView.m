//
//  GZVerticalProgressView.m
//  demo
//
//  Created by armada on 2016/11/30.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "GZVerticalProgressView.h"

#define kCornerLength 20.0f
#define kDashWidth 1.0f
#define kHorizontalLength 40.0f
#define kTextLayerFontSize 10.0f

@interface GZVerticalProgressView()

{
    float lineWidth;
    float lineHeight;
}

@property(nonatomic,strong) NSArray<NSNumber *> *values;
@property(nonatomic,strong) NSArray<UIColor *> *colors;
@property(nonatomic,strong) NSArray<NSNumber *> *contents;
@property(nonatomic,strong) NSArray<NSString *> *titles;

@property(nonatomic,strong) NSMutableArray<NSNumber *> *percentages;
@property(nonatomic,strong) NSMutableArray<NSValue *> *pointsOfMids;
@property(nonatomic,strong) NSMutableArray<NSValue *> *midOfHorizontalLines;

@end

@implementation GZVerticalProgressView

- (instancetype)initWithFrame:(CGRect)frame values:(NSArray *)values colors:(NSArray *)colors contents:(NSArray *)contents titles:(NSArray *)titles{
    
    if(self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _values = values;
        _colors = colors;
        _contents = contents;
        _titles = titles;
        
        lineWidth = 1;
        lineHeight = frame.size.height*0.7;
    }
        return self;
}



#pragma mark - Some calculations
//calculate percentage for portions
- (void)calculatePercentages {
    
    //calculate the total
    float total = 0;
    for(int index=0;index<self.values.count;index++) {
        total += self.values[index].floatValue;
    }
    
    _percentages = [NSMutableArray array];
    
    //calculate the percentage of every portion
    for(int index=0;index<self.values.count;index++) {
        float percent = self.values[index].floatValue/total;
        [self.percentages addObject:[NSNumber numberWithFloat:percent]];
    }
}

- (void)calculateMidCenterOfLineForPortions {
    
    _pointsOfMids = [NSMutableArray array];
    
    CGFloat midX = self.frame.size.width/2;
    CGFloat y = self.frame.size.height;
    
    for(int index=0;index<self.percentages.count;index++) {
        
        y -= self.percentages[index].floatValue*lineHeight;
        
        [self.pointsOfMids addObject:[NSValue valueWithCGPoint:CGPointMake(midX,y+self.percentages[index].floatValue*lineHeight/2.0)]];
    }
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    [self calculatePercentages];
    [self calculateMidCenterOfLineForPortions];
    
    //draw the progressLine
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetLineWidth(ctx, lineWidth);
    
    CGPoint start = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height);
    CGContextMoveToPoint(ctx, start.x, start.y);
    
    CGFloat y = self.bounds.size.height;
    
    for(int index=0;index<self.percentages.count;index++) {
        
        y -= self.percentages[index].floatValue*lineHeight;
        CGPoint end = CGPointMake(start.x, y);
        
        CGContextAddLineToPoint(ctx, end.x, end.y);
        CGContextSetStrokeColorWithColor(ctx, self.colors[index].CGColor);
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextMoveToPoint(ctx, end.x, end.y);
        CGContextSaveGState(ctx);
    }
    
    _midOfHorizontalLines = [NSMutableArray array];
    
    //draw the dash lines
    for(int index=0;index<self.pointsOfMids.count;index++) {
        
        CGPoint currentMid = self.pointsOfMids[index].CGPointValue;
       
        CGContextSetFillColorWithColor(ctx, self.colors[index].CGColor);
        CGContextSetStrokeColorWithColor(ctx, self.colors[index].CGColor);
        CGContextSetLineWidth(ctx, kDashWidth);
        
        if(index%2==0) {
            
            CGContextMoveToPoint(ctx, currentMid.x-lineWidth/2.0-5, currentMid.y);
            CGContextAddArc(ctx, currentMid.x-lineWidth/2.0-5, currentMid.y, 2, 0, M_PI*2, 0);
            CGContextDrawPath(ctx, kCGPathFill);
            
            
            CGFloat cornerX = currentMid.x - lineWidth/2.0 - kCornerLength*sin(M_PI/3.0);
            CGFloat cornerY = currentMid.y - lineWidth/2.0 - kCornerLength*cos(M_PI/3.0);
            
            CGContextMoveToPoint(ctx, currentMid.x-lineWidth/2.0-5, currentMid.y);
            CGFloat lengths[] = {1,2};
            CGContextSetLineDash(ctx, 0, lengths, 2);
            CGContextAddLineToPoint(ctx, cornerX, cornerY);
            CGContextDrawPath(ctx, kCGPathStroke);
            
            CGContextMoveToPoint(ctx, cornerX, cornerY);
            CGFloat endX = cornerX - kHorizontalLength;
            CGFloat endY = cornerY;
            CGContextAddLineToPoint(ctx, endX, endY);
            CGContextStrokePath(ctx);
            
            CGPoint corner = CGPointMake(cornerX, cornerY);
            CGPoint end = CGPointMake(endX, endY);
            
            [self.midOfHorizontalLines addObject:[NSValue valueWithCGPoint:getMiddlePointBetween(corner, end)]];
        }else {
            
            CGContextMoveToPoint(ctx, currentMid.x+lineWidth/2.0+5, currentMid.y);
            CGContextAddArc(ctx, currentMid.x+lineWidth/2.0+5, currentMid.y, 2, 0, M_PI*2, 0);
            CGContextDrawPath(ctx, kCGPathFill);
            
            CGFloat cornerX = currentMid.x + lineWidth/2.0 + kCornerLength*sin(M_PI/3.0);
            CGFloat cornerY = currentMid.y - lineWidth/2.0 - kCornerLength*cos(M_PI/3.0);
            
            CGContextMoveToPoint(ctx, currentMid.x+lineWidth/2.0+5, currentMid.y);
            CGFloat lengths[] = {1,2};
            CGContextSetLineDash(ctx, 0, lengths, 2);
            CGContextAddLineToPoint(ctx, cornerX, cornerY);
            CGContextDrawPath(ctx, kCGPathStroke);
            
            CGContextMoveToPoint(ctx, cornerX, cornerY);
            CGFloat endX = cornerX + kHorizontalLength;
            CGFloat endY = cornerY;
            CGContextAddLineToPoint(ctx, endX, endY);
            CGContextStrokePath(ctx);
            
            CGPoint corner = CGPointMake(cornerX, cornerY);
            CGPoint end = CGPointMake(endX, endY);
            
            [self.midOfHorizontalLines addObject:[NSValue valueWithCGPoint:getMiddlePointBetween(corner, end)]];
        }
        
         CGContextSaveGState(ctx);
    }
    
    [self addTextLayers];
}

//add the text layers about the explanation of portions
- (void)addTextLayers {
    
    for(int index=0;index<self.midOfHorizontalLines.count;index++) {
        
        //add content text layers
        CATextLayer *contentLayer = [CATextLayer layer];
        contentLayer.bounds = CGRectMake(0, 0, 50, kTextLayerFontSize+2);
        CGPoint center = self.midOfHorizontalLines[index].CGPointValue;
        contentLayer.position = CGPointMake(center.x, center.y-8);
        
        contentLayer.alignmentMode = @"center";
        contentLayer.fontSize = kTextLayerFontSize;
        contentLayer.foregroundColor = self.colors[index].CGColor;
        contentLayer.backgroundColor = [UIColor clearColor].CGColor;
        contentLayer.string = self.contents[index].stringValue;
        contentLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:contentLayer];
        
        //add title text layers
        CATextLayer *titleLayer = [CATextLayer layer];
        titleLayer.bounds = CGRectMake(0, 0, 50, kTextLayerFontSize+2);
        titleLayer.position = CGPointMake(center.x, center.y+8);
        
        titleLayer.alignmentMode = @"center";
        titleLayer.fontSize = kTextLayerFontSize;
        titleLayer.foregroundColor = self.colors[index].CGColor;
        titleLayer.backgroundColor = [UIColor clearColor].CGColor;
        titleLayer.contentsScale = [UIScreen mainScreen].scale;
        titleLayer.string = self.titles[index];
        [self.layer addSublayer:titleLayer];
    }
}

static inline CGPoint getMiddlePointBetween(CGPoint start, CGPoint end) {
    
    CGFloat midX = start.x + (end.x-start.x)/2.0;
    CGFloat midY = start.y + (end.y-start.y)/2.0;
    return CGPointMake(midX, midY);
}


        



@end
