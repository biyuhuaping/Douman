//
//  DMRobotHoldCreditCell.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/31.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMRobotHoldCreditCell.h"
#import "DMRobotHoldCreditModel.h"

#define label_wide (DMDeviceWidth - DMDeviceWidth/3 - 30)/3

@interface DMRobotHoldCreditCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *holdAmount;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *profitLabel;

@end



@implementation DMRobotHoldCreditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.holdAmount];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.profitLabel];
        
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, 73.5, DMDeviceWidth, 0.5)];
        lineView.backgroundColor = MainF5;
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)setCreditModel:(DMRobotHoldCreditModel *)creditModel{
    _creditModel = creditModel;
    _titleLabel.text = [NSString stringWithFormat:@"债权名称\n%@",creditModel.title];
    _holdAmount.text = [NSString stringWithFormat:@"持有金额\n%.2f",creditModel.amount];
    
    if (_creditModel.termUnit == 1) {
        _dateLabel.text = [NSString stringWithFormat:@"期限\n%d天",creditModel.period];
    }else {
       _dateLabel.text = [NSString stringWithFormat:@"期限\n%d个月",creditModel.period];
    }
    
    _profitLabel.text = [NSString stringWithFormat:@"预计收益\n%.2f",creditModel.interestAmount];

    
    _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:_titleLabel.text attributes:[self setLabelAttribute]];
    NSMutableAttributedString *titleStr=(NSMutableAttributedString*)_titleLabel.attributedText;
    [titleStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x878787) range:NSMakeRange(0, 4)];
    [titleStr addAttribute:NSFontAttributeName value:FONT_Light(12) range:NSMakeRange(0, 4)];
    _titleLabel.attributedText = titleStr;

    _holdAmount.attributedText = [[NSAttributedString alloc] initWithString:_holdAmount.text attributes:[self setLabelAttribute]];
    NSMutableAttributedString *holdStr=(NSMutableAttributedString*)_holdAmount.attributedText;
    [holdStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x878787) range:NSMakeRange(0, 4)];
    [holdStr addAttribute:NSFontAttributeName value:FONT_Light(12) range:NSMakeRange(0, 4)];
    [holdStr addAttribute:NSFontAttributeName value:FONT_Light(10) range:NSMakeRange(_holdAmount.text.length-2, 2)];
    _holdAmount.attributedText = holdStr;

    _dateLabel.attributedText = [[NSAttributedString alloc] initWithString:_dateLabel.text attributes:[self setLabelAttribute]];
    NSMutableAttributedString *dateStr = (NSMutableAttributedString*)_dateLabel.attributedText;
    [dateStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x878787) range:NSMakeRange(0, 2)];
    [dateStr addAttribute:NSFontAttributeName value:FONT_Light(12) range:NSMakeRange(0, 2)];
    _dateLabel.attributedText = dateStr;

    _profitLabel.attributedText = [[NSAttributedString alloc] initWithString:_profitLabel.text attributes:[self setLabelAttribute]];
    NSMutableAttributedString *profitStr=(NSMutableAttributedString*)_profitLabel.attributedText;
    [profitStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x878787) range:NSMakeRange(0, 4)];
    [profitStr addAttribute:NSFontAttributeName value:FONT_Light(12) range:NSMakeRange(0, 4)];
    [profitStr addAttribute:NSFontAttributeName value:FONT_Light(10) range:NSMakeRange(_profitLabel.text.length-2, 2)];
    _profitLabel.attributedText = profitStr;

}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth/3, 74)];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}


- (UILabel *)holdAmount{
    if (!_holdAmount) {
        self.holdAmount = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth/3, 0, label_wide, 74)];
        _holdAmount.text = @"债权名称\n丰田皇冠车辆质押";
        _holdAmount.numberOfLines = 2;
        
    }
    return _holdAmount;
}
- (UILabel *)dateLabel{
    if (!_dateLabel) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_holdAmount.frame), 0, label_wide, 74)];
        _dateLabel.numberOfLines = 2;
    }
    return _dateLabel;
}
- (UILabel *)profitLabel{
    if (!_profitLabel) {
        self.profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_dateLabel.frame), 0, label_wide, 74)];
        _profitLabel.numberOfLines = 2;
    }
    return _profitLabel;
}


- (NSDictionary *)setLabelAttribute{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.lineSpacing = 20;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:FONT_Light(15),NSForegroundColorAttributeName:MainRed};
    return dic;
}

/*
 
 NSMutableAttributedString *rateStr=(NSMutableAttributedString*)_titleLabel.attributedText;
 [rateStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfb931c) range:NSMakeRange(4, 8)];
 [rateStr addAttribute:NSFontAttributeName value:FONT_Light(15) range:NSMakeRange(4, 8)];
 
 _titleLabel.attributedText = rateStr;

 */
@end
