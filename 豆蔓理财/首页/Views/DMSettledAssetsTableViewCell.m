//
//  DMSettledAssetsTableViewCell.m
//  豆蔓理财
//
//  Created by edz on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMSettledAssetsTableViewCell.h"

@interface DMSettledAssetsTableViewCell()
    
//期数类型 结清时间
@property (nonatomic, strong) UILabel *stageL;
@property (nonatomic, strong) UILabel *Annualyield;
//已结本金
@property (nonatomic, strong) UILabel *Principal;
@property (nonatomic, strong) UILabel *Money;
//已结收益
@property (nonatomic, strong) UILabel *Profit;
@property (nonatomic, strong) UILabel *ProfitMoney;
//期数
@property (nonatomic, strong) UILabel *Numberofperiods;
@property (nonatomic, strong) UILabel *Number;
//结清日期
@property (nonatomic, strong) UILabel *LasttimeL;
@property (nonatomic, strong) UILabel *TimeL;
//线
@property (nonatomic, strong) UILabel *fline;
@property (nonatomic, strong) UILabel *sline;
@property (nonatomic, strong) UILabel *tline;
//箭头
@property (nonatomic, strong) UIImageView *ArrowImg;
//虚线
@property (nonatomic, strong) UIImageView *dottedline;


    
    


@end

@implementation DMSettledAssetsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(DMSettledAssetsModel *)model {
    if (_model != model) {
        _model = model;
    }
    
    if ([_model.investType isEqual:[NSNull null]]) {
        
        _model.investType = @"无";
    }
    if ([_model.periods isEqual:[NSNull null]]) {
        
        _model.periods = @"0";
    }
    if ([_model.rate isEqual:[NSNull null]]) {
        
        _model.rate = @"0";
    }
    if ([_model.settlePrincipal isEqual:[NSNull null]]) {
        
        _model.settlePrincipal = @"0";
    }
    if ([_model.settleInterest isEqual:[NSNull null]]) {
        
        _model.settleInterest = @"0";
    }
    if ([_model.settlePeriod isEqual:[NSNull null]]) {
        
        _model.settlePeriod = @"0";
    }
    if ([_model.lastSettleTime isEqual:[NSNull null]]) {
        
        _model.lastSettleTime = @"0";
    }

    
    if ([_model.investType isEqualToString:@"按月付息"]) {
        
        if (!_model.periods) {
            
        } else {
            
            NSString *str = [NSString stringWithFormat:@"第%@期 · %@",_model.periods,_model.investType];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:MainRed //////////////// ffd542
                                  range:NSMakeRange(10, 7)];
            
            _stageL.attributedText = AttributedStr;
        }
        
    } else if ([_model.investType isEqualToString:@"等额本息"]){
        
        if (!_model.periods) {
            
        } else {
            
            NSString *str = [NSString stringWithFormat:@"第%@期 · %@",_model.periods,_model.investType];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
                                  value:MainGreen ///////////////50f1bf
                                  range:NSMakeRange(10, 7)];
            
            _stageL.attributedText = AttributedStr;
        }
        
    } 


    _Annualyield.text = [NSString stringWithFormat:@"预计年化利率%@%%",_model.rate];
    _Principal.text = _model.settlePrincipal;
    _Profit.text = _model.settleInterest;
    if (_model.termUnit == 1) {
       _Numberofperiods.text = @"1/1";
    }else {
        _Numberofperiods.text = _model.settlePeriod;
    }
    _LasttimeL.text = _model.lastSettleTime;

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.stageL];
        [self.contentView addSubview:self.Annualyield];
        [self.contentView addSubview:self.Principal];
        [self.contentView addSubview:self.Money];
//        [self.contentView addSubview:self.fline];
        
        [self.contentView addSubview:self.Profit];
        [self.contentView addSubview:self.ProfitMoney];
//        [self.contentView addSubview:self.sline];
        
        [self.contentView addSubview:self.Numberofperiods];
        [self.contentView addSubview:self.Number];
//        [self.contentView addSubview:self.tline];
        
        [self.contentView addSubview:self.LasttimeL];
        [self.contentView addSubview:self.TimeL];
//        [self.contentView addSubview:self.ArrowImg];
        
        [self.contentView addSubview:self.dottedline];
        
    }
    return self;
}

- (UILabel *)stageL {
    
    if (!_stageL) {
        _stageL = [[UILabel alloc] init];
        _stageL.frame = CGRectMake(15, 16, 150, 12);
        _stageL.textColor = LightGray; ////////////4b6ca7
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"第20160909期 · 等额本息"];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:MainGreen ///////////////50f1bf
                              range:NSMakeRange(10, 7)];
        _stageL.attributedText = AttributedStr;
        _stageL.font = SYSTEMFONT(12);
    }
    
    return _stageL;
}

- (UILabel *)Annualyield {
    
    if (!_Annualyield) {
        _Annualyield = [[UILabel alloc] init];
        _Annualyield.frame = CGRectMake(DMDeviceWidth - 111, 16, 100, 12);
        _Annualyield.font = SYSTEMFONT(11);
        _Annualyield.textAlignment = NSTextAlignmentRight;
        _Annualyield.textColor = DarkGray; /////////////////86a7e8
        
    }
    return _Annualyield;
}



-(UILabel *)Principal {
    
    if (!_Principal) {
        _Principal = [[UILabel alloc] init];
        _Principal.frame = CGRectMake(0, 42, 80, 12);
        _Principal.font = SYSTEMFONT(14);
        _Principal.textColor = MainRed; //////////////ffd542
        _Principal.textAlignment = NSTextAlignmentCenter;
        
    }
    return _Principal;
}

-(UILabel *)Money {
    
    if (!_Money) {
        _Money = [[UILabel alloc] init];
        _Money.frame = CGRectMake(0, 65, 80, 12);
        _Money.font = SYSTEMFONT(11);
        _Money.textColor = LightGray; //////////////4b6ca7
        _Money.textAlignment = NSTextAlignmentCenter;
        _Money.text = @"已结本金(元)";
        
    }
    return _Money;
}

- (UILabel *)fline {
    
    if (!_fline) {
        _fline = [[UILabel alloc] init];
        _fline.frame = CGRectMake(80, 40, 1, 35);
        _fline.backgroundColor = LightGray; ////////////4b6ca7
    }
    
    return _fline;
}


-(UILabel *)Profit {
    
    if (!_Profit) {
        _Profit = [[UILabel alloc] init];
        _Profit.frame = CGRectMake(80, 42, 80, 12);
        _Profit.font = SYSTEMFONT(14);
        _Profit.textColor = MainRed; ///////////////////ffd542
        _Profit.textAlignment = NSTextAlignmentCenter;

        
    }
    return _Profit;
}

-(UILabel *)ProfitMoney {
    
    if (!_ProfitMoney) {
        _ProfitMoney = [[UILabel alloc] init];
        _ProfitMoney.frame = CGRectMake(80, 65, 80, 12);
        _ProfitMoney.font = SYSTEMFONT(11);
        _ProfitMoney.textColor = LightGray; /////////////4b6ca7
        _ProfitMoney.textAlignment = NSTextAlignmentCenter;
        _ProfitMoney.text = @"已结利息";
        
    }
    return _ProfitMoney;
}

- (UILabel *)sline {
    
    if (!_sline) {
        _sline = [[UILabel alloc] init];
        _sline.frame = CGRectMake(160, 40, 1, 35);
        _sline.backgroundColor = LightGray; //////////////4b6ca7
    }
    
    return _sline;
}


-(UILabel *)Numberofperiods {
    
    if (!_Numberofperiods) {
        _Numberofperiods = [[UILabel alloc] init];
        _Numberofperiods.frame = CGRectMake(160, 42, 80, 12);
        _Numberofperiods.font = SYSTEMFONT(14);
        _Numberofperiods.textColor = MainRed; ///////////////ffd542
        _Numberofperiods.textAlignment = NSTextAlignmentCenter;

        
    }
    return _Numberofperiods;
}

-(UILabel *)Number {
    
    if (!_Number) {
        _Number = [[UILabel alloc] init];
        _Number.frame = CGRectMake(160, 65, 80, 12);
        _Number.font = SYSTEMFONT(11);
        _Number.textColor = LightGray; ////////////////4b6ca7
        _Number.textAlignment = NSTextAlignmentCenter;
        _Number.text = @"已结期数";
        
    }
    return _Number;
}

- (UILabel *)tline {
    
    if (!_tline) {
        _tline = [[UILabel alloc] init];
        _tline.frame = CGRectMake(240, 40, 1, 35);
        _tline.backgroundColor = LightGray; ///////////////4b6ca7
    }
    
    return _tline;
}


-(UILabel *)LasttimeL {
    
    if (!_LasttimeL) {
        _LasttimeL = [[UILabel alloc] init];
        _LasttimeL.frame = CGRectMake(240, 42, DMDeviceWidth - 260, 12);
        _LasttimeL.font = SYSTEMFONT(14);
        _LasttimeL.textColor = MainRed; /////////////////ffd542
        _LasttimeL.textAlignment = NSTextAlignmentCenter;

        
    }
    return _LasttimeL;
}

-(UILabel *)TimeL {
    
    if (!_TimeL) {
        _TimeL = [[UILabel alloc] init];
        _TimeL.frame = CGRectMake(240, 65, DMDeviceWidth - 260, 12);
        _TimeL.font = SYSTEMFONT(11);
        _TimeL.textColor = LightGray; ///////////////4b6ca7
        _TimeL.textAlignment = NSTextAlignmentCenter;
        _TimeL.text = @"结清日期";
        
    }
    return _TimeL;
}

-(UIImageView *)ArrowImg {
    
    if (!_ArrowImg) {
        _ArrowImg = [[UIImageView alloc] init];
        _ArrowImg.frame = CGRectMake(DMDeviceWidth - 12, 52, 7, 25/2);
        _ArrowImg.image = [UIImage imageNamed:@"向右箭头"];
    }
    
    return _ArrowImg;
}


- (UIImageView *)dottedline {
    
    if (!_dottedline) {
        
        _dottedline = [[UIImageView alloc] init];
        _dottedline.frame = CGRectMake(10, 94, DMDeviceWidth - 20, .5);
        _dottedline.backgroundColor = UIColorFromRGB(0xdedede);
//        _dottedline.image = [UIImage imageNamed:@"分割虚线"];
        
    }
    
    return _dottedline;
}








@end
