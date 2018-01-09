//
//  DMCreditCPHeadView.m
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/13.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMCreditCPHeadView.h"


@implementation DMCreditCPHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat wide = (DMDeviceWidth-20)/3;
        CAShapeLayer *layer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, DMDeviceWidth-20, 30)];
        [path moveToPoint:CGPointMake(wide, 0)];
        [path addLineToPoint:CGPointMake(wide, 30)];
        [path moveToPoint:CGPointMake(wide*2, 0)];
        [path addLineToPoint:CGPointMake(wide*2, 30)];
        layer.path = path.CGPath;
        layer.fillColor = mainBack.CGColor;
        layer.strokeColor = MainLine.CGColor;
        [self.layer addSublayer:layer];
        
        NSArray *textArray = @[@"审核项目",@"状态",@"上标日期"];
        for (int i = 0; i < 3; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(wide * i,0, wide, 30)];
            label.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
            label.text = textArray[i];
            label.textColor = DarkGray;
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
        }
        
    }
    return self;
}


@end
