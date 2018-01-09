//
//  GZPurchaseProgressView.m
//  豆蔓首页分解
//
//  Created by armada on 2016/12/5.
//  Copyright © 2016年 com.zlot.gz. All rights reserved.
//

#import "GZPurchaseProgressView.h"

@interface GZPurchaseProgressView()

@property(nonatomic,strong) UIView *foregroundView;

@property(nonatomic,strong) UIImageView *circleHandleImgView;
@end

@implementation GZPurchaseProgressView

+ (GZPurchaseProgressView *)purchaseProgressView {
    return [[GZPurchaseProgressView alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    CGRect newRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 3);
    
    if(self = [super initWithFrame:newRect]) {
        
        UIImageView *backgroundImgView = [[UIImageView alloc]initWithFrame:newRect];
        backgroundImgView.image = [UIImage imageNamed:@"进度条灰色"];
        [self addSubview:backgroundImgView];
        
        _foregroundView = [[UIView alloc]initWithFrame:newRect];
        UIImage *originalImg = [UIImage imageNamed:@"进度条"];
        
        //begin image context to stretch image
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.foregroundView.bounds.size.width,self.foregroundView.bounds.size.height), YES, 0.0f);
  
        [originalImg drawInRect:CGRectMake(0, 0, self.foregroundView.bounds.size.width, 3)];
        UIImage *stretchedImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.foregroundView.backgroundColor = [UIColor colorWithPatternImage:stretchedImg];
        [self addSubview:self.foregroundView];
        
        //add circle handle
        _circleHandleImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"进度条圆"]];
        self.circleHandleImgView.frame = CGRectMake(0, 0, 10, 10);
        self.circleHandleImgView.center = CGPointMake(newRect.size.width-5, self.foregroundView.center.y);
        [self addSubview:self.circleHandleImgView];
    }
    return self;
}

- (void)setProgress:(float)progress {
    NSLog(@"----%f",progress);
    CGRect newRect = CGRectMake(0, 0, self.frame.size.width*progress, 3);
    self.foregroundView.frame = newRect;
    
    CGPoint newCenter = CGPointMake(newRect.size.width-5, self.circleHandleImgView.center.y);
    self.circleHandleImgView.center = newCenter;
}


@end
