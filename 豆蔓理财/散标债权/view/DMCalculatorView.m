//
//  DMCalculatorView.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/9/11.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMCalculatorView.h"

@implementation DMCalculatorView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.image = [UIImage imageNamed:@"calcularBtn"];
        self.userInteractionEnabled = true;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer *)pan{
    CGPoint translationPoint = [pan translationInView:pan.view];
    pan.view.center = CGPointMake(pan.view.center.x + translationPoint.x, pan.view.center.y + translationPoint.y);
    [pan setTranslation:CGPointMake(0, 0) inView:pan.view];
    [pan setTranslation:CGPointZero inView:pan.view];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat centerX = pan.view.center.x ;
        CGFloat centerY = pan.view.center.y ;
        CGFloat square = pan.view.frame.size.width;
        CGFloat viewX = pan.view.frame.origin.x ;
        CGFloat viewY = pan.view.frame.origin.y ;

        CGFloat left = centerX*centerX;
        CGFloat right = (DMDeviceWidth - centerX)*(DMDeviceWidth - centerX);
        CGFloat top = centerY*centerY;
        CGFloat bot = (DMDeviceHeight - 64 - centerY)*(DMDeviceHeight - 64 - centerY);
        if (left < right) {
            if (top < bot) {
                if (left < top) {
                    viewX = 0;
                }else{
                    viewY = 0;
                }
            }else{
                if (left < bot) {
                    viewX = 0;
                }else{
                    viewY = DMDeviceHeight - 64 - square;
                }
            }
        }else{
            if (top < bot) {
                if (right < top) {
                    viewX = DMDeviceWidth - square;
                }else{
                    viewY = 0;
                }
            }else{
                if (right < bot) {
                    viewX = DMDeviceWidth - square;
                }else{
                    viewY = DMDeviceHeight - 64 - square;
                }
            }
        }
        
        if (viewX < 0) {
            viewX = 0;
        }
        if (viewY > DMDeviceHeight - 64 - square){
            viewY = DMDeviceHeight - 64 - square;
        }
        if (viewY < 0){
            viewY = 0;
        }
        if(viewX > DMDeviceWidth - square){
            viewX = DMDeviceWidth - square;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            pan.view.frame = CGRectMake(viewX, viewY, square, square);
        }];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.TouchAction) {
        self.TouchAction();
    }
}
@end
