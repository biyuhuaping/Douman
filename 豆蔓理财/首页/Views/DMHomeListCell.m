//
//  DMHomeListCell.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/26.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMHomeListCell.h"
#import "DMRobtOpeningModel.h"
#import "DMHomeListModel.h"

#define CHAR_RED UIColorFromRGB(0xff6e51)
#define Light_RED UIColorFromRGB(0xff6151)


@interface DMHomeListCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *flagImage;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UILabel *seasonLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *rateLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *midLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIButton *buyBtn;

//@property (nonatomic, strong) UILabel *autumnGift;  //金秋送福

@end

@implementation DMHomeListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = WITHEBACK_LINE;
        [self.contentView addSubview:self.backView];
        [self.contentView addSubview:self.flagImage];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.moreBtn];
        [self.contentView addSubview:self.seasonLabel];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.rateLabel];
        [self.contentView addSubview:self.monthLabel];
        [self.contentView addSubview:self.amountLabel];
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.midLabel];
        [self.contentView addSubview:self.rightLabel];
        [self.contentView addSubview:self.buyBtn];
//        [self.contentView addSubview:self.autumnGift];
        
    }
    return self;
}

- (UIView *)backView{
    if (!_backView) {
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, DMDeviceWidth, 185)];
        _backView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _backView;
}

- (UIImageView *)flagImage{
    if (!_flagImage) {
        CGFloat wide = 26*DMDeviceWidth/375;
        _flagImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, wide, wide * 29/26)];
    }
    return _flagImage;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, DMDeviceWidth, 45)];
        _titleLabel.text = @"新手专享";
        _titleLabel.font = FONT_Regular(15);
        _titleLabel.textColor = DarkGray;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"更多+" forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = FONT_Light(11);
        [_moreBtn setTitleColor:CHAR_RED forState:UIControlStateNormal];
        _moreBtn.frame = CGRectMake(DMDeviceWidth-60, 10, 60, 40);
        [_moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UILabel *)seasonLabel{
    if (!_seasonLabel) {
        self.seasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, DMDeviceWidth, 25)];
//        _seasonLabel.text = @"17041404期";
        _seasonLabel.font = FONT_Light(11);
        _seasonLabel.textColor = LightGray;
        _seasonLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _seasonLabel;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, 65, 15)];
//        _typeLabel.text = @"质押快投";
        _typeLabel.font = FONT_Light(11);
        _typeLabel.textColor = UIColorFromRGB(0xff6e51);
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.layer.cornerRadius = 4;
        _typeLabel.layer.masksToBounds = true;
        _typeLabel.layer.borderColor = MainRed.CGColor;
        _typeLabel.layer.borderWidth = 0.7;
    }
    return _typeLabel;
}

//- (UILabel *)autumnGift {
//    if (!_autumnGift) {
//        _autumnGift = [UILabel createLabelFrame:CGRectMake(15 , 60  , 65, 14) labelColor:UIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
//        _autumnGift.layer.cornerRadius = 3;
//        _autumnGift.layer.masksToBounds = YES;
//        _autumnGift.text = @"金秋送福";
//        _autumnGift.backgroundColor = UIColorFromRGB(0xff6e51);
//        _autumnGift.font = FONT_Light(11.f);
//    }
//    return _autumnGift;
//}

- (UILabel *)rateLabel{
    if (!_rateLabel) {
        self.rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, DMDeviceWidth/3, 25)];
//        _rateLabel.text = @"10.00%";
        _rateLabel.font = FONT_Light(15);
        _rateLabel.textColor = CHAR_RED;
        _rateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rateLabel;
}

- (UILabel *)monthLabel{
    if (!_monthLabel) {
        self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth/3, 90, DMDeviceWidth/3, 25)];
//        _monthLabel.text = @"1个月";
        _monthLabel.font = FONT_Light(15);
        _monthLabel.textColor = DarkGray;
        _monthLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _monthLabel;
}

- (UILabel *)amountLabel{
    if (!_amountLabel) {
        self.amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth*2/3, 90, DMDeviceWidth/3, 25)];
//        _amountLabel.text = @"1860000.00";
        _amountLabel.font = FONT_Light(15);
        _amountLabel.textColor = DarkGray;
        _amountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _amountLabel;
}


- (UILabel *)leftLabel{
    if (!_leftLabel) {
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 115, DMDeviceWidth/3, 25)];
        _leftLabel.text = @"年化利率";
        _leftLabel.font = FONT_Light(11);
        _leftLabel.textColor = LightGray;
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}

- (UILabel *)midLabel{
    if (!_midLabel) {
        self.midLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth/3, 115, DMDeviceWidth/3, 25)];
        _midLabel.text = @"借款期限";
        _midLabel.font = FONT_Light(11);
        _midLabel.textColor = LightGray;
        _midLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _midLabel;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth*2/3, 115, DMDeviceWidth/3, 25)];
        _rightLabel.font = FONT_Light(11);
        _rightLabel.textColor = LightGray;
        _rightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightLabel;
}

- (UIButton *)buyBtn{
    if (!_buyBtn) {
        self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.titleLabel.font = FONT_Regular(15);
        _buyBtn.frame = CGRectMake((DMDeviceWidth-135)/2, 145, 135, 35);
        _buyBtn.layer.cornerRadius = 17.5;
        _buyBtn.layer.masksToBounds = YES;
        _buyBtn.layer.borderWidth = 1;
        [_buyBtn setTitle:@"立即出借" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:UIColorFromRGB(0xff7255) forState:UIControlStateNormal];
        _buyBtn.layer.borderColor = UIColorFromRGB(0xff7255).CGColor;
        _buyBtn.backgroundColor = UIColorFromRGB(0xffd3ca);
        [_buyBtn addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}

- (void)moreAction:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate didSelectMoreWithIndex:self.tag];
    }
}

- (void)buyAction:(UIButton *)btn{
    if (self.delegate) {
        [self.delegate didSelectBuyNowWithIndex:self.tag];
    }
}

- (void)setRobotModel:(DMRobtOpeningModel *)robotModel{
    _robotModel = robotModel;
    _flagImage.image = [UIImage imageNamed:@"home_server"];
    self.titleLabel.text = @"小豆机器人";
    self.seasonLabel.text = [NSString stringWithFormat:@"%@号",robotModel.robotNumber];
    self.typeLabel.text = robotModel.guarantyStyleName;
    self.monthLabel.text = [robotModel.robotCycle stringByAppendingString:@"个月"];
    self.amountLabel.text = robotModel.minPurchaseAmount;
    self.midLabel.text = @"服务期限";
    self.rightLabel.text = @"起投金额(元)";
    
    NSString *maxStr = [NSString stringWithFormat:@"(%@~%@)",robotModel.minRate,robotModel.maxRate];
    if ([robotModel.disCountRate isEqualToString:@"0"]) {
        self.rateLabel.text = [NSString stringWithFormat:@"%@%%",maxStr];
    }else{
        self.rateLabel.text =[maxStr stringByAppendingString:[NSString stringWithFormat:@"%%+%@%%",robotModel.disCountRate]];
    }
    NSMutableAttributedString *rateStr=[[NSMutableAttributedString alloc]initWithString:_rateLabel.text];
    NSRange maxRange = [_rateLabel.text rangeOfString:maxStr];
    [rateStr addAttribute:NSFontAttributeName value:FONT_Light(22) range:maxRange];
    [rateStr addAttribute:NSForegroundColorAttributeName value:Light_RED range:maxRange];
    NSRange minRange = [_rateLabel.text rangeOfString:@"+"];
    [rateStr addAttribute:NSFontAttributeName value:FONT_Regular(10) range:minRange];
    _rateLabel.attributedText = rateStr;

    
    CGRect rect = [self.seasonLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_Light(11)} context:nil];
    self.typeLabel.frame = CGRectMake(rect.size.width + 25, 60, 65, 15);
    
    if ([robotModel.saleStatus isEqualToString:@"2"]) {
        [self.buyBtn setTitle:@"已结束" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _buyBtn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        _buyBtn.backgroundColor = UIColorFromRGBA(0x4b5159,0.3f);
        _buyBtn.userInteractionEnabled = false;
    }else if ([robotModel.saleStatus isEqualToString:@"1"]){
        [_buyBtn setTitle:@"立即加入" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:UIColorFromRGB(0xff7255) forState:UIControlStateNormal];
        _buyBtn.layer.borderColor = UIColorFromRGB(0xff7255).CGColor;
        _buyBtn.backgroundColor = UIColorFromRGB(0xffd3ca);
        _buyBtn.userInteractionEnabled = true;
    }else{
        [self.buyBtn setTitle:@"未开始" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _buyBtn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        _buyBtn.backgroundColor = UIColorFromRGBA(0x4b5159,0.3f);
        _buyBtn.userInteractionEnabled = false;
    }
    
//    self.autumnGift.hidden=YES;
}

- (void)setListModel:(DMHomeListModel *)listModel{
    _listModel = listModel;
    
    if (listModel.noviceTask) {
        _flagImage.image = [UIImage imageNamed:@"home_recommendflag"];
        self.titleLabel.text = @"为您推荐";
        
        NSString *maxStr = [NSString stringWithFormat:@"%@",listModel.assetRate];
        if ([listModel.assetInterestRate isEqualToString:@"0"]) {
            self.rateLabel.text = [NSString stringWithFormat:@"%@%%",maxStr];
        }else{
            self.rateLabel.text =[maxStr stringByAppendingString:[NSString stringWithFormat:@"%%+%@%%",listModel.assetInterestRate]];
        }
        NSMutableAttributedString *rateStr=[[NSMutableAttributedString alloc]initWithString:_rateLabel.text];
        NSRange maxRange = [_rateLabel.text rangeOfString:maxStr];
        [rateStr addAttribute:NSFontAttributeName value:FONT_Light(22) range:maxRange];
        [rateStr addAttribute:NSForegroundColorAttributeName value:Light_RED range:maxRange];
        NSRange minRange = [_rateLabel.text rangeOfString:@"+"];
        [rateStr addAttribute:NSFontAttributeName value:FONT_Regular(10) range:minRange];
        _rateLabel.attributedText = rateStr;

    }else{
//        self.autumnGift.hidden=YES;
        _flagImage.image = [UIImage imageNamed:@"home_newflag"];
        self.titleLabel.text = @"新手专享";
        
        CGFloat rate = [listModel.assetRate floatValue] + [listModel.assetInterestRate floatValue];
        self.rateLabel.text = [NSString stringWithFormat:@"%.f%%",rate];
        NSMutableAttributedString *rateStr=[[NSMutableAttributedString alloc]initWithString:_rateLabel.text];
        NSRange maxRange = [_rateLabel.text rangeOfString:[NSString stringWithFormat:@"%.f",rate]];
        [rateStr addAttribute:NSFontAttributeName value:FONT_Light(22) range:maxRange];
        _rateLabel.attributedText = rateStr;
    }
    
//    if ([listModel.assetTypeName isEqualToString:@"质押快投"]&&[listModel.productCycle isEqualToString:@"1"]) {
//        self.autumnGift.hidden=NO;
//    }else{
//        self.autumnGift.hidden=YES;
//    }

    self.midLabel.text = @"借款期限";
    self.rightLabel.text = @"剩余可购(元)";
    self.seasonLabel.text = [NSString stringWithFormat:@"第%@期",listModel.assetPeriodNum];
    self.typeLabel.text = listModel.assetTypeName;
    if (listModel.termUnit == 1) {
        self.monthLabel.text = [listModel.productCycle stringByAppendingString:@"天"];
    }else{
        self.monthLabel.text = [listModel.productCycle stringByAppendingString:@"个月"];
    }
    self.amountLabel.text = listModel.assetBalance;
    
    CGRect rect = [self.seasonLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_Light(11)} context:nil];
    self.typeLabel.frame = CGRectMake(rect.size.width + 25, 60, 65, 15);

    if ([listModel.assetStatus isEqualToString:@"HASENDED"]) {
        [self.buyBtn setTitle:@"已结束" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _buyBtn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        _buyBtn.backgroundColor = UIColorFromRGBA(0x4b5159,0.3f);
        _buyBtn.userInteractionEnabled = false;
    }else{
        [_buyBtn setTitle:@"立即出借" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:UIColorFromRGB(0xff7255) forState:UIControlStateNormal];
        _buyBtn.layer.borderColor = UIColorFromRGB(0xff7255).CGColor;
        _buyBtn.backgroundColor = UIColorFromRGB(0xffd3ca);
        _buyBtn.userInteractionEnabled = true;
    }
    
//    [self.autumnGift setFrame:CGRectMake(CGRectGetMaxX(self.typeLabel.frame)+5, 60, 65, 14)];

}


@end
