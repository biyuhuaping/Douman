//
//  DMCalculateCell.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/2/16.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMCalculateCell.h"

@interface DMCalculateCell ()

@property (nonatomic, strong) UIView *botView;


@end

@implementation DMCalculateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews{
    [self addSubview:self.spectorLine];
    [self addSubview:self.botView];
    [self.botView addSubview:self.monthLabel];
    [self.botView addSubview:self.baseMoney];
    [self.botView addSubview:self.profitLabel];
    [self.botView addSubview:self.waitMoney];
    
    [self addConstrainsWithVisualFormat:@"H:|-12-[v0]-12-|" Views:@[self.spectorLine]];
    [self addConstrainsWithVisualFormat:@"H:|[v0]|" Views:@[self.botView]];
    [self addConstrainsWithVisualFormat:@"V:|[v0(==1)]-0-[v1(>=13)]|" Views:@[self.spectorLine,self.botView]];
    [self.botView addConstrainsWithVisualFormat:@"V:|[v0]|" Views:@[self.monthLabel]];
    [self.botView addConstrainsWithVisualFormat:@"V:|[v0]|" Views:@[self.baseMoney]];
    [self.botView addConstrainsWithVisualFormat:@"V:|[v0]|" Views:@[self.profitLabel]];
    [self.botView addConstrainsWithVisualFormat:@"V:|[v0]|" Views:@[self.waitMoney]];
    [self.botView addConstrainsWithVisualFormat:@"H:|[v0]-[v1(==v0)]-[v2(==v0)]-[v3(==v0)]|" Views:@[self.monthLabel,self.baseMoney,self.profitLabel,self.waitMoney]];
    
}

- (UIView *)spectorLine{
    if (!_spectorLine) {
        self.spectorLine = [[UIView alloc] init];
        _spectorLine.backgroundColor = UIColorFromRGB(0x192842);
    }
    return _spectorLine;
}

- (UIView *)botView{
    if (!_botView) {
        self.botView = [[UIView alloc] init];
    }
    return _botView;
}

- (UILabel *)monthLabel{
    if (!_monthLabel) {
        self.monthLabel = [[UILabel alloc] init];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _monthLabel.text = @"第14月";
        _monthLabel.textColor = UIColorFromRGB(0x4b6ca7);
    }
    return _monthLabel;
}

- (UILabel *)baseMoney{
    if (!_baseMoney) {
        self.baseMoney = [[UILabel alloc] init];
        _baseMoney.textAlignment = NSTextAlignmentCenter;
        _baseMoney.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _baseMoney.textColor = UIColorFromRGB(0x4b6ca7);
        _baseMoney.text = @"1632元";
    }
    return _baseMoney;
}

- (UILabel *)profitLabel{
    if (!_profitLabel) {
        self.profitLabel = [[UILabel alloc] init];
        _profitLabel.textAlignment = NSTextAlignmentCenter;
        _profitLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _profitLabel.textColor = UIColorFromRGB(0x4b6ca7);
        _profitLabel.text = @"84元";
    }
    return _profitLabel;
}

- (UILabel *)waitMoney{
    if (!_waitMoney) {
        self.waitMoney = [[UILabel alloc] init];
        _waitMoney.textAlignment = NSTextAlignmentCenter;
        _waitMoney.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _waitMoney.textColor = UIColorFromRGB(0x4b6ca7);
        _waitMoney.text = @"8567元";
    }
    return _waitMoney;
}


@end
