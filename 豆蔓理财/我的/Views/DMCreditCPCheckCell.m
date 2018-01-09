//
//  DMCreditCPCheckCell.m
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/13.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMCreditCPCheckCell.h"

@interface DMCreditCPCheckCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIImageView *checkImage;
@property (nonatomic, strong) UILabel *checkLabel;

@end


@implementation DMCreditCPCheckCell

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
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(10, 0)];
        [path addLineToPoint:CGPointMake(10, 30)];
        [path addLineToPoint:CGPointMake(DMDeviceWidth-10, 30)];
        [path addLineToPoint:CGPointMake(DMDeviceWidth-10, 0)];
        for (int i = 0; i < 2; i ++) {
            CGFloat x = (DMDeviceWidth-20)/3+(DMDeviceWidth-20)*i/3 + 10;
            [path moveToPoint:CGPointMake(x, 0)];
            [path addLineToPoint:CGPointMake(x, 30)];
        }
        layer.path = path.CGPath;
        layer.fillColor = mainBack.CGColor;
        layer.strokeColor = MainLine.CGColor;
        [self.contentView.layer addSublayer:layer];

        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.dayLabel];
        [self.contentView addSubview:self.checkImage];
        [self.contentView addSubview:self.checkLabel];

    }
    return self;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        self.titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(10, 0, (DMDeviceWidth-20)/3, 30)];
        _titleLabel.text = @"基本信息";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = DarkGray;
    }
    return _titleLabel;
}

- (UILabel *)dayLabel{
    if (_dayLabel == nil) {
        self.dayLabel= [[UILabel alloc] initWithFrame:CGRectMake(10+(DMDeviceWidth-20)*2/3, 0, (DMDeviceWidth-20)/3, 30)];
        _dayLabel.text = @"2000-01-01";
        _dayLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.textColor = DarkGray;
    }
    return _dayLabel;
}
- (UIImageView *)checkImage{
    if (!_checkImage) {
        self.checkImage = [[UIImageView alloc] initWithFrame:CGRectMake(DMDeviceWidth/2-20, 9, 12, 12)];
        _checkImage.image = [UIImage imageNamed:@"certification_ok_icon"]; //////////////审核通过
    }
    return _checkImage;
}

- (UILabel *)checkLabel{
    if (_checkLabel == nil) {
        self.checkLabel= [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth/2, 0, (DMDeviceWidth-20)/6, 30)];
        _checkLabel.text = @"通过";
        _checkLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _checkLabel.textColor = UIColorFromRGB(0x58AB92);
    }
    return _checkLabel;
}

- (void)setTitleWithString:(NSString *)str checkdate:(NSString *)date{
    self.titleLabel.text = str;
    self.dayLabel.text = date;
}

@end
