//
//  DMCreditBaseCell.m
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/12.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMCreditBaseCell.h"



@interface DMCreditBaseCell ()


@end


@implementation DMCreditBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleImage];
        [self.contentView addSubview:self.titleLabel];
//        [self.contentView addSubview:self.line];
    }
    return self;
}

- (UIImageView *)titleImage{
    if (_titleImage == nil) {
        self.titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 27, 7,6)];
        _titleImage.image = [UIImage imageNamed:@"_"];
    }
    return _titleImage;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        self.titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(20, 22, DMDeviceWidth/2, 14)];
        _titleLabel.text = @"基本信息";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        _titleLabel.textColor = DarkGray; //////////////86a7e8
    }
    return _titleLabel;
}

- (UIView *)line{
    if (_line == nil) {
        self.line = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+8, DMDeviceWidth-20, 0.5)];
        _line.backgroundColor = UIColorFromRGB(0x223a60);
    }
    return _line;
}

@end
