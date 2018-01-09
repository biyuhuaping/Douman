//
//  DMMyServerCell.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/14.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMMyServerCell.h"
#import "DMMyServerHoldListModel.h"

#define  fontSize iPhone5 ? 12 : 15
@interface DMMyServerCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *agreementButton;

@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UILabel *profitLabel;
@property (nonatomic, strong) UILabel *overTimeLabel;

@property (nonatomic, strong) NSMutableArray *textArray;


@end

@implementation DMMyServerCell

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
        self.backgroundColor = UIColorFromRGB(0xf6f5fa);

        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 125)];
        backView.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:backView];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.agreementButton];
        
        UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake(0, 45, DMDeviceWidth-10, 1)];
        hLine.backgroundColor = UIColorFromRGB(0xf5f5f9);
        [self.contentView addSubview:hLine];
        
        [self.contentView addSubview:self.amountLabel];
        [self.contentView addSubview:self.rateLabel];
        [self.contentView addSubview:self.profitLabel];
        [self.contentView addSubview:self.overTimeLabel];
        
        NSArray *textArray = @[@"加入金额(元)",@"预计年化利率",@"已结收益(元)",@"服务结束时间"];
        for (int i = 0 ; i < 4 ; i ++) {
            UILabel *botLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * DMDeviceWidth/4, 85, DMDeviceWidth/4, 25)];
            botLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:iPhone5 ? 10 : 12];
            botLabel.textColor = UIColorFromRGB(0x878787);
            botLabel.textAlignment = NSTextAlignmentCenter;
            botLabel.text = textArray[i];
            [self.contentView addSubview:botLabel];
            [self.textArray addObject:botLabel];
        }
        for (int i = 1; i < 4; i++) {
            UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(i * DMDeviceWidth/4, 58, 1, 50)];
            vLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
            [self.contentView addSubview:vLine];
        }
    }
    return self;
}


- (void)setHoldModel:(DMMyServerHoldListModel *)holdModel{
    _holdModel = holdModel;
    
    self.titleLabel.text = [NSString stringWithFormat:@"小豆机器人%@",holdModel.robotNumber];
    self.amountLabel.text = [NSString stringWithFormat:@"%.2f",holdModel.orderAmount];
    self.rateLabel.text = [NSString stringWithFormat:@"(%.0f~%.0f)%%+%@%%",holdModel.minRate,holdModel.maxRate,holdModel.addRate];
    self.profitLabel.text = [NSString stringWithFormat:@"%.2f",holdModel.interestAmountSum];
    self.overTimeLabel.text = holdModel.orderEndDate;
    
    if ([self.type isEqualToString:@"0"]) {
        self.amountLabel.textColor = MainRed;
        _rateLabel.textColor = MainRed;
        _profitLabel.textColor = MainRed;
        _overTimeLabel.textColor = MainRed;
        self.agreementButton.hidden = NO;
        [self setTitleWithTitleArray:@[@"加入金额(元)",@"预计年化利率",@"已结收益(元)",@"服务结束时间"]];
    }else{
        self.amountLabel.textColor = UIColorFromRGB(0x878787);
        _rateLabel.textColor = UIColorFromRGB(0x878787);
        _profitLabel.textColor = UIColorFromRGB(0x878787);
        _overTimeLabel.textColor = UIColorFromRGB(0x878787);
        self.agreementButton.hidden = YES;
        [self setTitleWithTitleArray:@[@"加入金额(元)",@"预计利率",@"共获收益(元)",@"到期时间"]];
    }
    
    [self setLowerWithLabel:self.amountLabel];
    [self setLowerWithLabel:self.profitLabel];
}

- (void)setLowerWithLabel:(UILabel *)label{
    NSMutableAttributedString *rateStr=[[NSMutableAttributedString alloc]initWithString:label.text];
    [rateStr addAttribute:NSFontAttributeName value:FONT_Light(fontSize-3) range:NSMakeRange(label.text.length-2, 2)];
    label.attributedText = rateStr;
}

- (void)setTitleWithTitleArray:(NSArray *)array{
    [self.textArray enumerateObjectsUsingBlock:^(UILabel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.text = array[idx];
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, DMDeviceWidth-20, 45)];
        _titleLabel.text = @"小豆机器人17052701号";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        _titleLabel.textColor = UIColorFromRGB(0x505050);
    }
    return _titleLabel;
}

- (UIButton *)agreementButton{
    if (!_agreementButton) {
        self.agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreementButton.frame =CGRectMake(DMDeviceWidth-95, 12, 80, 20);
        _agreementButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_agreementButton setTitle:@"查看相关协议" forState:UIControlStateNormal];
        [_agreementButton setTitleColor:UIColorFromRGB(0x878787) forState:UIControlStateNormal];
        _agreementButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _agreementButton.layer.cornerRadius = 10;
        _agreementButton.layer.masksToBounds = YES;
        _agreementButton.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
        _agreementButton.layer.borderWidth = .5f;
        [_agreementButton addTarget:self action:@selector(agreementAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreementButton;
}

- (UILabel *)amountLabel{
    if (!_amountLabel) {
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, DMDeviceWidth/4, 45)];
        _amountLabel.text = @"10000.00";
        _amountLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:fontSize];
        _amountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _amountLabel;
}

- (UILabel *)rateLabel{
    if (!_rateLabel) {
        self.rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth/4, 45, DMDeviceWidth/4, 45)];
        _rateLabel.text = @"(7~10)% + 3%";
        _rateLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:fontSize];
        _rateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rateLabel;
}

- (UILabel *)profitLabel{
    if (!_profitLabel) {
        self.profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth/2, 45, DMDeviceWidth/4, 45)];
        _profitLabel.text = @"18600.96";
        _profitLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:fontSize];
        _profitLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _profitLabel;
}

- (UILabel *)overTimeLabel{
    if (!_overTimeLabel) {
        self.overTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth*3/4, 45, DMDeviceWidth/4, 45)];
        _overTimeLabel.text = @"2017/12/23";
        _overTimeLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:fontSize];
        _overTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _overTimeLabel;
}

- (NSMutableArray *)textArray{
    if (!_textArray) {
        self.textArray = [@[] mutableCopy];
    }
    return _textArray;
}

- (void)agreementAction{
    if (self.GetAgreement) {
        self.GetAgreement(self.tag);
    }
}

@end
