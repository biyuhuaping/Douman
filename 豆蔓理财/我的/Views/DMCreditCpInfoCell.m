//
//  DMCreditCpInfoCell.m
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/13.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMCreditCpInfoCell.h"



@implementation DMCreditCpInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 20, DMDeviceWidth-20, 120)];
        for (int i = 0; i < 3; i++) {
            [path moveToPoint:CGPointMake(10, 50 + 30 *i)];
            [path addLineToPoint:CGPointMake(DMDeviceWidth-10, 50 + 30*i)];
        }
        [path moveToPoint:CGPointMake(DMDeviceWidth/2, 20)];
        [path addLineToPoint:CGPointMake(DMDeviceWidth/2, 140)];
        layer.path = path.CGPath;
        layer.fillColor = UIColorFromRGB(0x121b2c).CGColor;
        layer.strokeColor = UIColorFromRGB(0x1d293f).CGColor;
        [self.contentView.layer addSublayer:layer];

        
        for (int i = 0; i < 7; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i%2==0?i%2 * DMDeviceWidth/2 + 20:i%2 * DMDeviceWidth/2 + 10,[self getYWithi:i], DMDeviceWidth/2-10, 30)];
            label.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
            label.text = @"123123";
            label.textColor = UIColorFromRGB(0x86a7e8);
            [self.contentView addSubview:label];
            [self.labelArray addObject:label];
        }

    }
    return self;
}

- (int)getYWithi:(int)i{
    if (i<2) {
        return 20;
    }else if(i>=2&&i<4){
        return 50;
    }else if(i>=4&&i<6){
        return 80;
    }else{
        return 110;
    }
}

- (void)setupValueWithTitleArray:(NSArray *)titleArray detailArray:(NSArray *)detailArray{
    [self.labelArray enumerateObjectsUsingBlock:^(UILabel  *label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.text = [titleArray[idx] stringByAppendingString:detailArray[idx]];
        [self setAttributelabel:label text:titleArray[idx]];
    }];
}

- (void)setAttributelabel:(UILabel *)label text:(NSString *)text{
    NSMutableAttributedString *labelStr=[[NSMutableAttributedString alloc]initWithString:label.text];
    NSRange range = [label.text rangeOfString:text];
    [labelStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4b6ca7) range:range];
    label.attributedText = labelStr;
}

- (NSMutableArray *)labelArray{
    if (!_labelArray) {
        self.labelArray = [@[] mutableCopy];
    }
    return _labelArray;
}


@end
