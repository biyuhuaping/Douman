//
//  DMCreditInfoCell.m
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/12.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMCreditInfoCell.h"

@interface DMCreditInfoCell ()


@end


@implementation DMCreditInfoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
    }
    return self;
}


- (void)setupValueWithTitleArray:(NSArray *)titleArray detailArray:(NSArray *)detailArray{
    [self.labelArray removeAllObjects];
    BOOL o = NO;
    if (titleArray.count%2==0) {
        o = YES;
    }
    CGFloat n =  titleArray.count%2==0?(titleArray.count/2):(titleArray.count+1)/2;
    CGFloat h = 30;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 55, DMDeviceWidth-20, h*n)];
    for (int i = 0; i < n; i++) {
        [path moveToPoint:CGPointMake(10, 55+h*i)];
        [path addLineToPoint:CGPointMake(DMDeviceWidth-10, 55+h*i)];
    }
    [path moveToPoint:CGPointMake(DMDeviceWidth/2, 55)];
    [path addLineToPoint:CGPointMake(DMDeviceWidth/2, 55+h*(o?n:(n-1)))];

    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor; ////////////////121b2c
    layer.strokeColor = UIColorFromRGB(0xe6e6e6).CGColor; ////////////////1d293f
    layer.lineWidth = 0.5;
    [self.contentView.layer addSublayer:layer];

    for (int i = 0; i < titleArray.count; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i%2==0?i%2 * DMDeviceWidth/2 + 20:i%2 * DMDeviceWidth/2 + 10,[self getYWithi:i], DMDeviceWidth, 30)];
        label.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        label.textColor = DarkGray; ////////////////86a7e8
        [self.contentView addSubview:label];
        [self.labelArray addObject:label];
    }

    [self.labelArray enumerateObjectsUsingBlock:^(UILabel  *label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.text = [titleArray[idx] stringByAppendingString:detailArray[idx]];
        [self setAttributelabel:label text:titleArray[idx]];
    }];
}

- (void)setCreditInfoWithTitleArray:(NSArray *)titleArray detailArray:(NSArray *)detailArray{
    [self.labelArray removeAllObjects];
    CGFloat h = 30;
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 55, DMDeviceWidth-20, h*2)];
    for (int i = 0; i < 2; i++) {
        [path moveToPoint:CGPointMake(10, 55+h*i)];
        [path addLineToPoint:CGPointMake(DMDeviceWidth-10, 55+h*i)];
    }
    [path moveToPoint:CGPointMake(DMDeviceWidth/2, 55)];
    [path addLineToPoint:CGPointMake(DMDeviceWidth/2, 115)];
    
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor; /////////////////121b2c
    layer.strokeColor = UIColorFromRGB(0xe6e6e6).CGColor; ///////////////1d293f
    layer.lineWidth = 0.5;
    [self.contentView.layer addSublayer:layer];
    
    for (int i = 0; i < titleArray.count; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        label.textColor = DarkGray; ////////////////86a7e8
        if (i < 4) {
            label.frame = CGRectMake(i%2==0?i%2 * DMDeviceWidth/2 + 20:i%2 * DMDeviceWidth/2 + 10,[self getYWithi:i], DMDeviceWidth, 30);
        }else if (i == 4) {
            label.frame = CGRectMake(20, 115, DMDeviceWidth-40, [self getHeightWithText:[titleArray[i] stringByAppendingString:detailArray[i]]]);
            CAShapeLayer *layer1 = [CAShapeLayer layer];
            UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(10, 115, DMDeviceWidth-20, label.frame.size.height)];
            layer1.path = path1.CGPath;
            layer1.fillColor = [UIColor clearColor].CGColor; //////////////121b2c
            layer1.strokeColor = MainLine.CGColor; ///////////////1d293f
            [self.contentView.layer addSublayer:layer1];
        }else if (i == 5){
            label.frame = CGRectMake(20, 115 + [self getHeightWithText:[titleArray[4] stringByAppendingString:detailArray[4]]], DMDeviceWidth-40, [self getHeightWithText:[titleArray[i] stringByAppendingString:detailArray[i]]]);
            CAShapeLayer *layer1 = [CAShapeLayer layer];
            UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(10, 115 + [self getHeightWithText:[titleArray[4] stringByAppendingString:detailArray[4]]], DMDeviceWidth-20, label.frame.size.height)];
            layer1.path = path1.CGPath;
            layer1.fillColor = [UIColor clearColor].CGColor; /////////////121b2c
            layer1.strokeColor = MainLine.CGColor; //////////////1d293f
            [self.contentView.layer addSublayer:layer1];
        }
        [self.contentView addSubview:label];
        [self.labelArray addObject:label];
    }
    
    [self.labelArray enumerateObjectsUsingBlock:^(UILabel  *label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.text = [titleArray[idx] stringByAppendingString:detailArray[idx]];
        [self setAttributelabel:label text:titleArray[idx]];
    }];
}

- (void)setPolicyWithTitleArray:(NSArray *)titleArray detailArray:(NSArray *)detailArray{
    [self.labelArray removeAllObjects];
    CGFloat h = 30;
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 55, DMDeviceWidth-20, h*4)];
    for (int i = 0; i < 4; i++) {
        [path moveToPoint:CGPointMake(10, 55+h*i)];
        [path addLineToPoint:CGPointMake(DMDeviceWidth-10, 55+h*i)];
    }
    [path moveToPoint:CGPointMake(DMDeviceWidth/2, 145)];
    [path addLineToPoint:CGPointMake(DMDeviceWidth/2, 175)];
    
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor; ////////////121b2c
    layer.strokeColor = UIColorFromRGB(0xe6e6e6).CGColor; /////////////1d293f
    layer.lineWidth = 0.5;
    [self.contentView.layer addSublayer:layer];
    
    for (int i = 0; i < titleArray.count; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i!=4?20:(DMDeviceWidth/2)+20,i!=4?(55+i *30):145, DMDeviceWidth, 30)];
        label.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        label.textColor = DarkGray; ////////////////86a7e8
        [self.contentView addSubview:label];
        [self.labelArray addObject:label];
    }
    
    [self.labelArray enumerateObjectsUsingBlock:^(UILabel  *label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.text = [titleArray[idx] stringByAppendingString:detailArray[idx]];
        [self setAttributelabel:label text:titleArray[idx]];
    }];

}

- (void)setCompanyBaseInfoTitleArray:(NSArray *)titleArray detailArray:(NSArray *)detailArray{
    [self.labelArray removeAllObjects];
    CGFloat h = 30;
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 55, DMDeviceWidth-20, h*4)];
    for (int i = 0; i < 4; i++) {
        [path moveToPoint:CGPointMake(10, 55+h*i)];
        [path addLineToPoint:CGPointMake(DMDeviceWidth-10, 55+h*i)];
    }
    [path moveToPoint:CGPointMake(DMDeviceWidth/2, 85)];
    [path addLineToPoint:CGPointMake(DMDeviceWidth/2, 115)];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor; //////////////121b2c
    layer.strokeColor = UIColorFromRGB(0xe6e6e6).CGColor; //////////////1d293f
    layer.lineWidth = 0.5;
    [self.contentView.layer addSublayer:layer];

    for (int i = 0; i < titleArray.count; i ++) {
        UILabel *label = [[UILabel alloc] init];
        if (i < 2) {
            label.frame = CGRectMake(20, (i)*30+55, DMDeviceWidth, 30);
        }else if (i == 2){
            label.frame = CGRectMake(10 + DMDeviceWidth/2, 85, DMDeviceWidth/2, 30);
        }else{
            label.frame = CGRectMake(20, (i-1)*30 + 55, DMDeviceWidth, 30);
        }
        label.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        label.textColor = DarkGray; ////////////////86a7e8
        [self.contentView addSubview:label];
        [self.labelArray addObject:label];
    }
    
    [self.labelArray enumerateObjectsUsingBlock:^(UILabel  *label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.text = [titleArray[idx] stringByAppendingString:detailArray[idx]];
        [self setAttributelabel:label text:titleArray[idx]];
    }];

}

- (void)setAttributelabel:(UILabel *)label text:(NSString *)text{
    NSMutableAttributedString *labelStr=[[NSMutableAttributedString alloc]initWithString:label.text];
    NSRange range = [label.text rangeOfString:text];
    [labelStr addAttribute:NSForegroundColorAttributeName value:LightGray range:range]; //////////////4b6ca7
    label.attributedText = labelStr;
}

- (NSMutableArray *)labelArray{
    if (!_labelArray) {
        self.labelArray = [@[] mutableCopy];
    }
    return _labelArray;
}

- (int)getYWithi:(int)i{
    if (i<2) {
        return 55;
    }else if(i>=2&&i<4){
        return 85;
    }else if(i>=4&&i<6){
        return 115;
    }else{
        return 145;
    }
}

- (CGFloat)getHeightWithText:(NSString *)text{
    if (text.length > 0) {
        CGRect rect = [text boundingRectWithSize:CGSizeMake(DMDeviceWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:13]} context:nil];

        return rect.size.height + 17;
    }else{
        return 30;
    }
}

@end
