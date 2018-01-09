//
//  DMHomeFootView.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/27.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMHomeFootView.h"

@implementation DMHomeFootView



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, DMDeviceWidth, 40)];
        label.text = @"资金存管服务已上线\n市场有风险 投资需谨慎";
        label.numberOfLines = 2;
        label.font = FONT_Regular(10);
        label.textColor = UIColorFromRGB(0xadadad);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(DMDeviceWidth/2 - 60, 11, 11, 14)];
        logoImage.image = [UIImage imageNamed:@"home_botLogo"];
        [self addSubview:logoImage];
        
        
        
    }
    return self;
}






@end
