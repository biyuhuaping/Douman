//
//  DMCreditManageCell.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/5/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMCreditManageCell.h"
#import "DMCreditTransferModel.h"

#define k_RMB @"元"
#define k_DAY @"天"

@interface DMCreditManageCell()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *botLabel1;
@property (nonatomic, strong) UILabel *botLabel2;
@property (nonatomic, strong) UILabel *botLabel3;

@property (nonatomic, strong) UIButton *transferBtn;    //转让
@property (nonatomic, strong) UIButton *revokeBtn;      // 撤销

@property (nonatomic, strong) UIButton *contractBtn;    // 合同

@end

@implementation DMCreditManageCell

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
        self.backgroundColor = UIColorFromRGB(0xf5f5f9);
        [self.contentView addSubview:self.backView];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.iconLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.botLabel1];
        [self.contentView addSubview:self.botLabel2];
        [self.contentView addSubview:self.botLabel3];
        [self.contentView addSubview:self.transferBtn];
        [self.contentView addSubview:self.revokeBtn];
        [self.contentView addSubview:self.contractBtn];
    }
    return self;
}

- (void)setTransferModel:(DMCreditTransferModel *)transferModel{
    _transferModel = transferModel;
    self.titleLabel.text = transferModel.TITLE;
    
    switch (self.manageType) {
        case kCanTransfer:{
            self.moneyLabel.text = [[NSString insertCommaWithString:transferModel.INVESTAMOUNT] stringByAppendingString:k_RMB];
            [self setLabel:self.moneyLabel FontStr:k_RMB Font:10];
            self.dateLabel.text = [[NSString insertCommaWithString:transferModel.SURPLUSDAYS] stringByAppendingString:k_DAY];
            [self setLabel:self.dateLabel FontStr:k_DAY Font:10];
        }
            break;
        case kTransferIng:{
            self.moneyLabel.text = [[NSString insertCommaWithString:transferModel.CREDITPRINCIPAL] stringByAppendingString:k_RMB];
            [self setLabel:self.moneyLabel FontStr:k_RMB Font:10];
            self.dateLabel.text = [[NSString insertCommaWithString:transferModel.BIDAMOUNT] stringByAppendingString:k_RMB];
            [self setLabel:self.dateLabel FontStr:k_RMB Font:10];
        }
            break;
        case kHadtransfer:{
            self.moneyLabel.text = [[NSString insertCommaWithString:transferModel.CREDITPRINCIPAL] stringByAppendingString:k_RMB];
            [self setLabel:self.moneyLabel FontStr:k_RMB Font:10];
            self.dateLabel.text = [[NSString insertCommaWithString:transferModel.HANDAMOUNT] stringByAppendingString:k_RMB];
            [self setLabel:self.dateLabel FontStr:k_RMB Font:10];
            self.timeLabel.text = transferModel.TIMEFINISHED;
        }
            break;
        default:
            break;
    }

    
}

- (void)setLabel:(UILabel *)label ColorStr:(NSString *)colorStr Color:(UIColor *)color{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:label.text];
    NSRange dayRange = [label.text rangeOfString:colorStr];
    [hintString addAttribute:NSForegroundColorAttributeName value:color range:dayRange];
    label.attributedText = hintString;
}

- (void)setLabel:(UILabel *)label FontStr:(NSString *)fontStr Font:(CGFloat)font{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:label.text];
    NSRange dayRange = [label.text rangeOfString:fontStr];
    [hintString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:dayRange];
    label.attributedText = hintString;
}

- (void)setManageType:(CreditManageType)manageType{
    _manageType = manageType;
    switch (manageType) {
        case kCanTransfer:{
            self.revokeBtn.hidden = YES;
            self.transferBtn.hidden = NO;
            
            self.contractBtn.hidden = YES;
            self.timeLabel.hidden = YES;
            self.botLabel3.hidden = YES;
            
            self.botLabel1.text = @"投资金额";
            self.botLabel2.text = @"剩余期限";
        }
            break;
        case kTransferIng:{
            self.revokeBtn.hidden = NO;
            self.transferBtn.hidden = YES;
            
            self.contractBtn.hidden = YES;
            self.timeLabel.hidden = YES;
            self.botLabel3.hidden = YES;
            
            self.botLabel1.text = @"转让本金";
            self.botLabel2.text = @"已转金额";
        }
            break;
        case kHadtransfer:{
            self.revokeBtn.hidden = YES;
            self.transferBtn.hidden = YES;
            
            self.timeLabel.hidden = NO;
            self.botLabel3.hidden = NO;
            self.contractBtn.hidden = NO;
            
            self.botLabel1.text = @"转让本金";
            self.botLabel2.text = @"到手金额";
        }
            break;
        default:
            break;
    }
}

- (UIView *)backView{
    if (!_backView) {
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 115)];
        _backView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _backView;
}

- (UIView *)lineView{
    if (!_lineView) {
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, DMDeviceWidth, 1)];
        _lineView.backgroundColor = UIColorFromRGB(0xf5f5f9);
    }
    return _lineView;
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
        _titleLabel.text = @"";
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = UIColorFromRGB(0x787878);
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, DMDeviceWidth/3, 18)];
        _moneyLabel.text = @"元";
        _moneyLabel.font = [UIFont systemFontOfSize:17];
        _moneyLabel.textColor = UIColorFromRGB(0xff9900);
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth/3, 60, DMDeviceWidth/3, 18)];
        _dateLabel.text = @"天";
        _dateLabel.font = [UIFont systemFontOfSize:17];
        _dateLabel.textColor = UIColorFromRGB(0xff9900);
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth *2/3, 60, DMDeviceWidth/3, 18)];
        _timeLabel.text = @"1970-00-00";
        _timeLabel.font = [UIFont systemFontOfSize:17];
        _timeLabel.textColor = UIColorFromRGB(0xff9900);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}


- (UILabel *)botLabel1{
    if (!_botLabel1) {
        self.botLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, DMDeviceWidth/3, 13)];
        _botLabel1.text = @"投资金额";
        _botLabel1.font = [UIFont systemFontOfSize:12];
        _botLabel1.textColor = UIColorFromRGB(0x999999);
        _botLabel1.textAlignment = NSTextAlignmentCenter;
    }
    return _botLabel1;
}

- (UILabel *)botLabel2{
    if (!_botLabel2) {
        self.botLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth/3, 90, DMDeviceWidth/3, 13)];
        _botLabel2.text = @"剩余期限";
        _botLabel2.font = [UIFont systemFontOfSize:12];
        _botLabel2.textColor = UIColorFromRGB(0x999999);
        _botLabel2.textAlignment = NSTextAlignmentCenter;
    }
    return _botLabel2;
}

- (UILabel *)botLabel3{
    if (!_botLabel3) {
        self.botLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth * 2/3, 90, DMDeviceWidth/3, 13)];
        _botLabel3.text = @"转让成交时间";
        _botLabel3.font = [UIFont systemFontOfSize:12];
        _botLabel3.textColor = UIColorFromRGB(0x999999);
        _botLabel3.textAlignment = NSTextAlignmentCenter;
    }
    return _botLabel3;
}

- (UIButton *)transferBtn{
    if (!_transferBtn) {
        self.transferBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _transferBtn.frame = CGRectMake(DMDeviceWidth-130, 70, 115, 35);
        _transferBtn.layer.borderColor = UIColorFromRGB(0x425a86).CGColor;
        _transferBtn.layer.borderWidth = 1;
        _transferBtn.layer.cornerRadius = 17.5;
        _transferBtn.layer.masksToBounds = true;
        [_transferBtn setTitle:@"转 让" forState:UIControlStateNormal];
        _transferBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_transferBtn setTitleColor:UIColorFromRGB(0x425a86) forState:UIControlStateNormal];
        [_transferBtn addTarget:self action:@selector(transferAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferBtn;
}

- (UIButton *)revokeBtn{
    if (!_revokeBtn) {
        self.revokeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _revokeBtn.frame = CGRectMake(DMDeviceWidth-130, 70, 115, 35);
        _revokeBtn.layer.borderColor = UIColorFromRGB(0x425a86).CGColor;
        _revokeBtn.layer.borderWidth = 1;
        _revokeBtn.layer.cornerRadius = 17.5;
        _revokeBtn.layer.masksToBounds = true;
        [_revokeBtn setTitle:@"撤 销" forState:UIControlStateNormal];
        _revokeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_revokeBtn setTitleColor:UIColorFromRGB(0x425a86) forState:UIControlStateNormal];
        [_revokeBtn addTarget:self action:@selector(revokeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _revokeBtn;
}

- (UIButton *)contractBtn{
    if (!_contractBtn) {
        self.contractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _contractBtn.frame = CGRectMake(DMDeviceWidth-60, 0, 60, 39);
        [_contractBtn setTitle:@"合同+" forState:UIControlStateNormal];
        _contractBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_contractBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_contractBtn addTarget:self action:@selector(pushContractBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contractBtn;
}

- (void)revokeAction{
    if (self.delegate) {
        [self.delegate revokeCreditWithIndex:self.tag];
    }
}

- (void)transferAction{
    if (self.delegate) {
        [self.delegate transferCreditWithIndex:self.tag];
    }
}

- (void)pushContractBtn:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate contractWithIndex:self.tag];
    }

}

@end
