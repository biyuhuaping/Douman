//
//  DMTenderHeadView.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMTenderHeadView.h"
#import "MenuButton.h"
#import "DMScafferListModel.h"
@interface DMTenderHeadView ()<MenuButtonDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UILabel *rateTitle;

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *monthTitle;

@property (nonatomic, strong) UILabel *payBackLabel;
@property (nonatomic, strong) UILabel *payBackTitle;

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIView *midLine;
@property (nonatomic, strong) UIView *botmidLine;
@property (nonatomic, strong) MenuButton *menuButton;
@property (nonatomic, strong) UIView *botView;
@end

@implementation DMTenderHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf6f5fa);
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.rateLabel];
        [self.contentView addSubview:self.rateTitle];
        [self.contentView addSubview:self.monthLabel];
        [self.contentView addSubview:self.payBackLabel];
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.dateLabel];
//        [self.contentView addSubview:self.midLine];
        [self addSubview:self.botView];
        [self addSubview:self.menuButton];
    }
    return self;
}


- (void)setListModel:(DMScafferListModel *)listModel{
    _listModel = listModel;
    if ([listModel.interestRate isEqualToString:@"0"]) {
        self.rateLabel.text = [NSString stringWithFormat:@"%@%%",listModel.rate];
    }else{
        self.rateLabel.text = [NSString stringWithFormat:@"%@%%+%@%%",listModel.rate,listModel.interestRate];
    }
    NSMutableAttributedString *rateStr=[[NSMutableAttributedString alloc]initWithString:_rateLabel.text];
    NSRange maxRange = [_rateLabel.text rangeOfString:listModel.rate];
    [rateStr addAttribute:NSFontAttributeName value:FONT_Regular(44) range:maxRange];
    NSRange minRange = [_rateLabel.text rangeOfString:@"+"];
    [rateStr addAttribute:NSFontAttributeName value:FONT_Regular(15) range:minRange];
    _rateLabel.attributedText = rateStr;
   
    if (_listModel.termUnit == 1) {
        self.monthLabel.text = [NSString stringWithFormat:@"借款期限 %@天",listModel.months];
    }else {
        self.monthLabel.text = [NSString stringWithFormat:@"借款期限 %@个月",listModel.months];
    }
    self.payBackLabel.text = [listModel.method isEqualToString:@"MonthlyInterest"]?@"收益方式 按月付息":@"收益方式 等额本息";
    self.leftLabel.text = [NSString stringWithFormat:@"剩余可购（元）：%@",[NSString insertCommaWithString:listModel.surplusAmount]];
    self.dateLabel.text = [NSString stringWithFormat:@"募集期至：%@",listModel.timeEnd];
    
    
    NSMutableAttributedString *monthStr=[[NSMutableAttributedString alloc]initWithString:self.monthLabel.text];
    [monthStr addAttribute:NSFontAttributeName value:FONT_Light(11) range:NSMakeRange(0, 4)];
    [monthStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x7b7b7b) range:NSMakeRange(0, 4)];
    self.monthLabel.attributedText = monthStr;

    NSMutableAttributedString *payBack=[[NSMutableAttributedString alloc]initWithString:self.payBackLabel.text];
    [payBack addAttribute:NSFontAttributeName value:FONT_Light(11) range:NSMakeRange(0, 4)];
    [payBack addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x7b7b7b) range:NSMakeRange(0, 4)];
    self.payBackLabel.attributedText = payBack;

}


- (UIView *)contentView{
    if (!_contentView) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 190)];
        _contentView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _contentView;
}

- (UIView *)botView{
    if (!_botView) {
        self.botView = [[UIView alloc] initWithFrame:CGRectMake(0, 198, DMDeviceWidth, 44)];
        _botView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _botView;
}

- (UIView *)midLine{
    if (!_midLine) {
        self.midLine = [[UIView alloc] initWithFrame:CGRectMake(0, 100, DMDeviceWidth, 1)];
        _midLine.backgroundColor = UIColorFromRGB(0xf6f5fa);
    }
    return _midLine;
}

- (UIView *)botmidLine{
    if (!_botmidLine) {
        self.botmidLine = [[UIView alloc] initWithFrame:CGRectMake(DMDeviceWidth/2, 218, 1, 44)];
        _botmidLine.backgroundColor = UIColorFromRGB(0xf6f5fa);
    }
    return _botmidLine;
}


- (UILabel *)rateLabel{
    if (!_rateLabel) {
        self.rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, DMDeviceWidth, 32)];
//        _rateLabel.text = @"8%+1%";
        _rateLabel.font = FONT_Regular(22);
        _rateLabel.textColor = UIColorFromRGB(0xff6e51);
        _rateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rateLabel;
}

- (UILabel *)rateTitle{
    if (!_rateTitle) {
        self.rateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, DMDeviceWidth, 30)];
        _rateTitle.text = @"年化利率";
        _rateTitle.textAlignment = NSTextAlignmentCenter;
        _rateTitle.textColor = UIColorFromRGB(0x7b7b7b);
        _rateTitle.font = FONT_Light(11);
    }
    return _rateTitle;
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, 140, DMDeviceWidth, 41)];
        _leftLabel.font = [UIFont fontWithName:@"PingFangTC-Light" size:11];
        _leftLabel.textColor = UIColorFromRGB(0x7b7b7b);
    }
    return _leftLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth/2 + 40, 140, DMDeviceWidth-10, 41)];
        _dateLabel.font = [UIFont fontWithName:@"PingFangTC-Light" size:11];
        _dateLabel.textColor = UIColorFromRGB(0x7b7b7b);
    }
    return _dateLabel;
}

- (UILabel *)monthLabel{
    if (!_monthLabel) {
        self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, 120, DMDeviceWidth/2, 30)];
        _monthLabel.text = @"1个月";
        _monthLabel.textColor = UIColorFromRGB(0x505050);
        _monthLabel.font = FONT_Regular(13);
    }
    return _monthLabel;
}

- (UILabel *)monthTitle{
    if (!_monthTitle) {
        self.monthTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 130, DMDeviceWidth/2, 30)];
        _monthTitle.text = @"借款期限";
        _monthTitle.textAlignment = NSTextAlignmentCenter;
        _monthTitle.textColor = UIColorFromRGB(0x878787);
        _monthTitle.font = [UIFont systemFontOfSize:12];
    }
    return _monthTitle;
}

- (UILabel *)payBackLabel{
    if (!_payBackLabel) {
        self.payBackLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth/2 + 40, 120, DMDeviceWidth/2, 30)];
        _payBackLabel.text = @"按月付息";
        _payBackLabel.textColor = UIColorFromRGB(0x4b5159);
        _payBackLabel.font = FONT_Regular(13);
    }
    return _payBackLabel;
}

- (UILabel *)payBackTitle{
    if (!_payBackTitle) {
        self.payBackTitle = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth/2, 130, DMDeviceWidth/2, 30)];
        _payBackTitle.text = @"还款方式";
        _payBackTitle.textAlignment = NSTextAlignmentCenter;
        _payBackTitle.textColor = UIColorFromRGB(0x878787);
        _payBackTitle.font = [UIFont systemFontOfSize:12];
    }
    return _payBackTitle;
}

- (MenuButton *)menuButton{
    if (!_menuButton) {
        self.menuButton = [[MenuButton alloc] initWithFrame:CGRectMake(0, 198, DMDeviceWidth, 44) TitleArray:@[@"资产说明",@"出借列表"] SelectColor:UIColorFromRGB(0x00c79f) UnselectColor:UIColorFromRGB(0x4b5159)];
        _menuButton.delegate = self;
    }
    return _menuButton;
}

- (void)selectButtonWithIndex:(NSInteger)index{
    if (self.SelectButton) {
        self.SelectButton(index);
    }
}

@end
