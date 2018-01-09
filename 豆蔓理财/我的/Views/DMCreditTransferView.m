//
//  DMCreditTransferView.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/5/8.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMCreditTransferView.h"

@interface DMCreditTransferView ()

@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *serverLabel;
@property (nonatomic, strong) UILabel *investLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *interestLabel;
@property (nonatomic, strong) UILabel *nextDayLabel;
@property (nonatomic, strong) UILabel *profitLabel;
@property (nonatomic, strong) UIButton *protocolBtn;
@property (nonatomic, strong) UILabel *protocolLabel;
@property (nonatomic, strong) UIButton *transferBtn;

@end

@implementation DMCreditTransferView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconLabel];
        [self addSubview:self.titleLabel];
        [self creatLines];
        [self creatTitlesWithArray:@[@"投资金额",@"剩余期限",@"当前产生利息",@"下个回款日"]];
        
        [self addSubview:self.serverLabel];
        [self addSubview:self.investLabel];
        [self addSubview:self.dayLabel];
        [self addSubview:self.interestLabel];
        [self addSubview:self.nextDayLabel];
        [self addSubview:self.profitLabel];
        [self addSubview:self.protocolBtn];
        [self addSubview:self.protocolLabel];
        [self addSubview:self.transferBtn];
    }
    return self;
}

- (void)setTransferModel:(DMCreditTransferModel *)transferModel{
    _transferModel = transferModel;
    
    self.titleLabel.text = transferModel.TITLE;
    NSString *serverMoney = [NSString stringWithFormat:@"%@元",transferModel.FEEAMOUNT];
    self.serverLabel.text = [NSString stringWithFormat:@"服务费：%@",serverMoney];
    [self setLabel:self.serverLabel ColorStr:serverMoney Color:UIColorFromRGB(0xfb9e1c)];
    self.investLabel.text = [[NSString insertCommaWithString:transferModel.INVESTAMOUNT] stringByAppendingString:@"元"];
    self.dayLabel.text = [transferModel.SURPLUSDAYS stringByAppendingString:@"天"];
    self.interestLabel.text = [transferModel.CURRENTINTEREST stringByAppendingString:@"元"];
    self.nextDayLabel.text = transferModel.LATELYDUEDATE;
    self.profitLabel.text = [NSString stringWithFormat:@"预计收益：%@",[[NSString insertCommaWithString:transferModel.SUCCESSAMOUNT] stringByAppendingString:@"元"]];
}


- (UILabel *)iconLabel{
    if (!_iconLabel) {
        self.iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        _iconLabel.text = @"转";
        _iconLabel.font = [UIFont systemFontOfSize:13];
        _iconLabel.textColor = UIColorFromRGB(0xffffff);
        _iconLabel.textAlignment = NSTextAlignmentCenter;
        _iconLabel.backgroundColor = UIColorFromRGB(0x02b281);
        _iconLabel.layer.cornerRadius = 2;
        _iconLabel.layer.masksToBounds = YES;
    }
    return _iconLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, DMDeviceWidth, 20)];
        _titleLabel.text = @"保时捷车牌车辆质押资金周转";
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = UIColorFromRGB(0x787878);
    }
    return _titleLabel;
}

- (void)creatLines{
    for (int i = 0; i < 6; i ++) {
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(i==0?0:35, 40+40*i, DMDeviceWidth, 1);
        line.backgroundColor = UIColorFromRGB(0xf5f5f9);
        [self addSubview:line];
    }
}

- (void)creatTitlesWithArray:(NSArray *)titles{
    for (int i = 0; i < 4; i ++) {
        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(35, 50 + 40*i, DMDeviceWidth/2, 20);
        title.text = titles[i];
        title.font = [UIFont systemFontOfSize:13];
        title.textColor = UIColorFromRGB(0x878787);
        [self addSubview:title];
    }
}

- (UILabel *)serverLabel{
    if (!_serverLabel) {
        self.serverLabel = [[UILabel alloc] init];
        _serverLabel.text = @"服务费：4.85元";
        _serverLabel.font = [UIFont systemFontOfSize:13];
        _serverLabel.textColor = UIColorFromRGB(0x878787);
        _serverLabel.frame = CGRectMake(35, 210, DMDeviceWidth/2, 20);
    }
    return _serverLabel;
}

- (UILabel *)investLabel{
    if (!_investLabel) {
        self.investLabel = [[UILabel alloc] init];
        _investLabel.text = @"500.00元";
        _investLabel.font = [UIFont systemFontOfSize:13];
        _investLabel.textColor = UIColorFromRGB(0xfb9e1c);
        _investLabel.textAlignment = NSTextAlignmentRight;
        _investLabel.frame = CGRectMake(0, 50, DMDeviceWidth-15, 20);
    }
    return _investLabel;
}

- (UILabel *)dayLabel{
    if (!_dayLabel) {
        self.dayLabel = [[UILabel alloc] init];
        _dayLabel.text = @"30天";
        _dayLabel.font = [UIFont systemFontOfSize:13];
        _dayLabel.textColor = UIColorFromRGB(0xfb9e1c);
        _dayLabel.textAlignment = NSTextAlignmentRight;
        _dayLabel.frame = CGRectMake(0, 90, DMDeviceWidth-15, 20);
    }
    return _dayLabel;
}

- (UILabel *)interestLabel{
    if (!_interestLabel) {
        self.interestLabel = [[UILabel alloc] init];
        _interestLabel.text = @"2.55元";
        _interestLabel.font = [UIFont systemFontOfSize:13];
        _interestLabel.textColor = UIColorFromRGB(0xfb9e1c);
        _interestLabel.textAlignment = NSTextAlignmentRight;
        _interestLabel.frame = CGRectMake(0, 130, DMDeviceWidth-15, 20);
    }
    return _interestLabel;
}

- (UILabel *)nextDayLabel{
    if (!_nextDayLabel) {
        self.nextDayLabel = [[UILabel alloc] init];
        _nextDayLabel.text = @"2017-05-08";
        _nextDayLabel.font = [UIFont systemFontOfSize:13];
        _nextDayLabel.textColor = UIColorFromRGB(0xfb9e1c);
        _nextDayLabel.textAlignment = NSTextAlignmentRight;
        _nextDayLabel.frame = CGRectMake(0, 170, DMDeviceWidth-15, 20);
    }
    return _nextDayLabel;
}

- (UILabel *)profitLabel{
    if (!_profitLabel) {
        self.profitLabel = [[UILabel alloc] init];
        _profitLabel.text = @"预计收益：100.45元";
        _profitLabel.font = [UIFont systemFontOfSize:13];
        _profitLabel.textColor = UIColorFromRGB(0xfb9e1c);
        _profitLabel.textAlignment = NSTextAlignmentRight;
        _profitLabel.frame = CGRectMake(0, 210, DMDeviceWidth-15, 20);
    }
    return _profitLabel;
}

- (UIButton *)protocolBtn{
    if (!_protocolBtn) {
        self.protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_protocolBtn setImage:[UIImage imageNamed:@"creditProtocolButton"] forState:UIControlStateSelected];
        [_protocolBtn setImage:[UIImage imageNamed:@"creditProtocolButton_unselect"] forState:UIControlStateNormal];
        [_protocolBtn addTarget:self action:@selector(buttonaction) forControlEvents:UIControlEventTouchUpInside];
        _protocolBtn.selected = YES;
        _protocolBtn.frame = CGRectMake(22, 240, 40, 40);
    }
    return _protocolBtn;
}

- (void)buttonaction{
    self.protocolBtn.selected = !self.protocolBtn.selected;
//    if (self.protocolBtn.selected == YES) {
//        self.protocolBtn.selected = NO;
//    }else{
//        self.protocolBtn.selected = YES;
//    }
}

- (UILabel *)protocolLabel{
    if (!_protocolLabel) {
        self.protocolLabel = [[UILabel alloc] init];
        _protocolLabel.text = @"已阅读，并同意<风险提示函>";
        _protocolLabel.textColor = UIColorFromRGB(0x585656);
        _protocolLabel.font = [UIFont systemFontOfSize:12];
        _protocolLabel.frame = CGRectMake(62, 250, DMDeviceWidth, 20);
        [self setLabel:_protocolLabel ColorStr:@"<风险提示函>" Color:UIColorFromRGB(0x00b282)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        _protocolLabel.userInteractionEnabled = YES;
        [_protocolLabel addGestureRecognizer:tap];
    }
    return _protocolLabel;
}

- (UIButton *)transferBtn{
    if (!_transferBtn) {
        self.transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _transferBtn.frame = CGRectMake((DMDeviceWidth-150)/2, 300, 150, 35);
        _transferBtn.layer.borderColor = UIColorFromRGB(0x425a86).CGColor;
        _transferBtn.layer.borderWidth = 1;
        _transferBtn.layer.cornerRadius = 17.5;
        _transferBtn.layer.masksToBounds = true;
        [_transferBtn setTitle:@"确认转让" forState:UIControlStateNormal];
        _transferBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_transferBtn setTitleColor:UIColorFromRGB(0x425a86) forState:UIControlStateNormal];
        [_transferBtn addTarget:self action:@selector(transferAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferBtn;
}

- (void)transferAction{
    if (self.protocolBtn.selected == YES) {
        if (self.TransferAction) {
            self.TransferAction();
        }
    }else{
        ShowMessage(@"请先同意<风险提示函>");
    }
}

- (void)tapAction{
    if (self.ProtocolAction) {
        self.ProtocolAction();
    }
}

- (void)setLabel:(UILabel *)label ColorStr:(NSString *)colorStr Color:(UIColor *)color{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:label.text];
    NSRange dayRange = [label.text rangeOfString:colorStr];
    [hintString addAttribute:NSForegroundColorAttributeName value:color range:dayRange];
    label.attributedText = hintString;
}



@end
