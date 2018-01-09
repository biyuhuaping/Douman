//
//  DMHoldingAssetsTableViewCell.m
//  豆蔓理财
//
//  Created by edz on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMHoldingAssetsTableViewCell.h"


@interface DMHoldingAssetsTableViewCell()

//期数类型 结清时间
@property (nonatomic, strong) UILabel *stageL;
@property (nonatomic, strong) UILabel *settleL;
//月结本息
@property (nonatomic, strong) UILabel *MonthlyinterestL;
@property (nonatomic, strong) UILabel *MonthlyinterestMoneyL;
//已结期数
@property (nonatomic, strong) UILabel *NumberofknotsL;
@property (nonatomic, strong) UILabel *NumberL;
//等结金额
@property (nonatomic, strong) UILabel *Otherknotamount;
@property (nonatomic, strong) UILabel *MoneyL;
//最近一次计算日
@property (nonatomic, strong) UILabel *LasttimeL;
@property (nonatomic, strong) UILabel *TimeL;
//线
@property (nonatomic, strong) UILabel *fline;
@property (nonatomic, strong) UILabel *sline;
@property (nonatomic, strong) UILabel *tline;
//箭头
//@property (nonatomic, strong) UIImageView *ArrowImg;
//虚线
@property (nonatomic, strong) UIImageView *dottedline;


@end



@implementation DMHoldingAssetsTableViewCell

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
        [self.contentView addSubview:self.stageL];
        [self.contentView addSubview:self.settleL];
        [self.contentView addSubview:self.MonthlyinterestL];
        [self.contentView addSubview:self.MonthlyinterestMoneyL];
//        [self.contentView addSubview:self.fline];
        
        [self.contentView addSubview:self.NumberofknotsL];
        [self.contentView addSubview:self.NumberL];
//        [self.contentView addSubview:self.sline];
        
        [self.contentView addSubview:self.Otherknotamount];
        [self.contentView addSubview:self.MoneyL];
//        [self.contentView addSubview:self.tline];
        
        [self.contentView addSubview:self.LasttimeL];
        [self.contentView addSubview:self.TimeL];
//        [self.contentView addSubview:self.ArrowImg];
        
        [self.contentView addSubview:self.dottedline];
        
    }
    return self;
}

- (void)setModel:(DMHoldingAssetsModel *)model {
    if (_model != model) {
        _model = model;
    }
    
    if ([_model.investType isEqual:[NSNull null]] ) {
        
        _model.investType = @"无";
    }
    if ([_model.periods isEqual:[NSNull null]]) {
        
        _model.periods = @"0";
    }
    if (_model.investAmout ==nil) {
        
        _model.investAmout = @"0";
    }
    if (_model.period == nil) {
        
        _model.period = @"0";
    }
    if ([_model.rate isEqual:[NSNull null]]) {
        
        _model.rate = @"0";
    }
    if ([_model.lastSettleTime isEqual:[NSNull null]]) {
        
        _model.lastSettleTime = @"0/0";
    }
    if ([_model.nextSettleTime isEqual:[NSNull null]]) {
        
        _model.nextSettleTime = @"无";
    }
    if ([_model.monthSettleAmount isEqual:[NSNull null]]) {
        
        _model.monthSettleAmount = @"0";
    }
    if ([_model.settlePeriod isEqual:[NSNull null]]) {
        
        _model.settlePeriod = @"0";
    }
    if ([_model.noSettleAmount isEqual:[NSNull null]]) {
        
        _model.noSettleAmount = @"0";
    }
    
    
    
    if ([_model.investType isEqualToString:@"按月付息"]) {
        
        if (!_model.periods) {
            
        } else {
        
        NSString *str = [NSString stringWithFormat:@"第%@期 · %@",_model.periods,_model.investType];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:MainRed //////////////ffd542
                              range:NSMakeRange(10, 7)];
        
        _stageL.attributedText = AttributedStr;
        }
        
    } else if ([_model.investType isEqualToString:@"等额本息"]){
        
        if (!_model.periods) {
            
        } else {

        NSString *str = [NSString stringWithFormat:@"第%@期 · %@",_model.periods,_model.investType];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:MainGreen //////////////50f1bf
                          range:NSMakeRange(10, 7)];
    
        _stageL.attributedText = AttributedStr;
        }

    } 
    
    
    
    if ([_model.isLoanEnd isEqualToString:@"0"]) {
        self.LasttimeL.text = @" ";
        self.settleL.text = @" ";
        _TimeL.text = @"待计息 >>";
//        _ArrowImg.image = [UIImage imageNamed:@""];
        
        _MonthlyinterestMoneyL.text = @"认购本金(元)";
        _MonthlyinterestL.text = _model.investAmout;
        
        _NumberL.text = @"投资期限";
        if (_model.termUnit == 1) {
            _NumberofknotsL.text = [NSString stringWithFormat:@"%@天",_model.period];
        }else{
            _NumberofknotsL.text = [NSString stringWithFormat:@"%@个月",_model.period];
        }

        _MoneyL.text = @"预计年化利率";
        _Otherknotamount.text = [NSString stringWithFormat:@"%@%%",_model.rate];

        
        
       
    } else {
        
        self.settleL.text = [NSString stringWithFormat:@"预计%@~%@结清",_model.lastSettleTime,[self dateAddTwoDays:_model.lastSettleTime]];
        
        self.LasttimeL.text = _model.nextSettleTime;
        _TimeL.text = @"最近一次结算日";
//        _ArrowImg.image = [UIImage imageNamed:@"向右箭头"];
        
        _NumberL.text = @"已结期数";
        if (_model.termUnit == 1) {
           _MonthlyinterestMoneyL.text = @"待结本息(元)";
            _NumberofknotsL.text = @"0/1";
        }else {
            _MonthlyinterestMoneyL.text = @"月结本息(元)";
            _NumberofknotsL.text = _model.settlePeriod;
        }
        _MonthlyinterestL.text = _model.monthSettleAmount;
        
        _MoneyL.text = @"待结总额";
        _Otherknotamount.text = _model.noSettleAmount;
    }
}


- (NSString *)dateAddTwoDays:(NSString *)formatTime{
    if (formatTime.length > 1) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY/MM/dd"]; //(@"YYYY-MM-dd hh:mm:ss")
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSDate* date = [formatter dateFromString:formatTime];
        NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
        NSInteger newtimeSp = timeSp + 172800;
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:newtimeSp];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        return confromTimespStr;
    }else{
        return formatTime;
    }
}



- (UILabel *)stageL {


    _stageL = [[UILabel alloc] init];
    _stageL.frame = CGRectMake(11, 15, 150, 12);
    _stageL.textColor = LightGray; //////////4b6ca7
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"第20160909期 · 等额本息"];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:MainGreen //////////////50f1bf
                              range:NSMakeRange(10, 7)];
    _stageL.attributedText = AttributedStr;
    _stageL.font = SYSTEMFONT(12);

    
    return _stageL;
}

- (UILabel *)settleL {
    
    if (!_settleL) {
        
        
        _settleL = [[UILabel alloc] init];
        _settleL.frame = CGRectMake(DMDeviceWidth - 210, 16, 200, 12);
        _settleL.font = SYSTEMFONT(11);
        _settleL.textAlignment = NSTextAlignmentRight;
        _settleL.textColor = LightGray; ///////////////86a7e8
        
    }
    

        

    return _settleL;
}

-(UILabel *)MonthlyinterestL {
    
    
    if (!_MonthlyinterestL) {
        
        _MonthlyinterestL = [[UILabel alloc] init];
        _MonthlyinterestL.frame = CGRectMake(0, 42, DMDeviceWidth/4, 12);
        _MonthlyinterestL.font = SYSTEMFONT(14);
        _MonthlyinterestL.textColor = MainRed; ///////////////ffd542
        _MonthlyinterestL.textAlignment = NSTextAlignmentCenter;
        
    }


    return _MonthlyinterestL;
}

-(UILabel *)MonthlyinterestMoneyL {
    

    _MonthlyinterestMoneyL = [[UILabel alloc] init];
    _MonthlyinterestMoneyL.frame = CGRectMake(0, 65, DMDeviceWidth/4, 12);
    _MonthlyinterestMoneyL.font = SYSTEMFONT(11);
    _MonthlyinterestMoneyL.textColor = LightGray; ////////////////4b6ca7
    _MonthlyinterestMoneyL.textAlignment = NSTextAlignmentCenter;
    

    return _MonthlyinterestMoneyL;
}

- (UILabel *)fline {
    
    if (!_fline) {
        _fline = [[UILabel alloc] init];
        _fline.frame = CGRectMake(DMDeviceWidth/4, 40, 1, 35);
        _fline.backgroundColor = LightGray; ////////////4b6ca7
    }
    
    return _fline;
}

-(UILabel *)NumberofknotsL {
    
    
    if (!_NumberofknotsL) {
        _NumberofknotsL = [[UILabel alloc] init];
        _NumberofknotsL.frame = CGRectMake(DMDeviceWidth/4, 42, DMDeviceWidth/4-10, 12);
        _NumberofknotsL.font = SYSTEMFONT(14);
        _NumberofknotsL.textColor = MainRed; /////////////ffd542
        _NumberofknotsL.textAlignment = NSTextAlignmentCenter;
    }

    
        

    return _NumberofknotsL;
}

-(UILabel *)NumberL {
    
    if (!_NumberL) {
        _NumberL = [[UILabel alloc] init];
        _NumberL.frame = CGRectMake(DMDeviceWidth/4, 65, DMDeviceWidth/4-10, 12);
        _NumberL.font = SYSTEMFONT(11);
        _NumberL.textColor = LightGray; ////////////4b6ca7
        _NumberL.textAlignment = NSTextAlignmentCenter;
        
        
    }
    return _NumberL;
}

- (UILabel *)sline {
    
    if (!_sline) {
        _sline = [[UILabel alloc] init];
        _sline.frame = CGRectMake(DMDeviceWidth/2-10, 40, 1, 35);
        _sline.backgroundColor = LightGray; ////////////4b6ca7
    }
    
    return _sline;
}

-(UILabel *)Otherknotamount {
    

    if (!_Otherknotamount) {
        _Otherknotamount = [[UILabel alloc] init];
        _Otherknotamount.frame = CGRectMake(DMDeviceWidth/2-10, 42, DMDeviceWidth/4, 12);
        _Otherknotamount.font = SYSTEMFONT(14);
        _Otherknotamount.textColor = MainRed; ///////////////ffd542
        _Otherknotamount.textAlignment = NSTextAlignmentCenter;
    }

    return _Otherknotamount;
}

-(UILabel *)MoneyL {
    
    if (!_MoneyL) {
        _MoneyL = [[UILabel alloc] init];
        _MoneyL.frame = CGRectMake(DMDeviceWidth/2-10, 65, DMDeviceWidth/4, 12);
        _MoneyL.font = SYSTEMFONT(11);
        _MoneyL.textColor = LightGray; ///////////4b6ca7
        _MoneyL.textAlignment = NSTextAlignmentCenter;
        
        
    }
    return _MoneyL;
}

- (UILabel *)tline {
    
    if (!_tline) {
        _tline = [[UILabel alloc] init];
        _tline.frame = CGRectMake(DMDeviceWidth/4*3-10, 40, 1, 35);
        _tline.backgroundColor = LightGray; /////////////4b6ca7
    }
    
    return _tline;
}

-(UILabel *)LasttimeL {
    
    
    if (!_LasttimeL) {
        _LasttimeL = [[UILabel alloc] init];
        _LasttimeL.frame = CGRectMake(DMDeviceWidth/4*3-10, 42, DMDeviceWidth/4+10, 12);
        _LasttimeL.font = SYSTEMFONT(14);
        _LasttimeL.textColor = MainRed; /////////////ffd542
        _LasttimeL.textAlignment = NSTextAlignmentCenter;
    }

    

    return _LasttimeL;
}

-(UILabel *)TimeL {
    
    
    if (!_TimeL) {
        _TimeL = [[UILabel alloc] init];
        _TimeL.frame = CGRectMake(DMDeviceWidth/4*3-10, 65, DMDeviceWidth/4+10, 12);
        _TimeL.font = SYSTEMFONT(11);
        _TimeL.textColor = LightGray; ////////////4b6ca7
        _TimeL.textAlignment = NSTextAlignmentCenter;
    }

    return _TimeL;
}

//-(UIImageView *)ArrowImg {
//    
//
//    _ArrowImg = [[UIImageView alloc] init];
//    _ArrowImg.frame = CGRectMake(DMDeviceWidth - 12, 52, 7, 25/2);
//
//    return _ArrowImg;
//}


- (UIImageView *)dottedline {
    
    if (!_dottedline) {
        
        _dottedline = [[UIImageView alloc] init];
        _dottedline.backgroundColor = UIColorFromRGB(0xdedede);
        _dottedline.frame = CGRectMake(10, 94, DMDeviceWidth - 20, .5);
//        _dottedline.image = [UIImage imageNamed:@"分割虚线"];
        
    }
    
    return _dottedline;
}

@end
