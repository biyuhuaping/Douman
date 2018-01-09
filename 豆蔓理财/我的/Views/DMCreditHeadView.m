//
//  DMCreditHeadView.m
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/9.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMCreditHeadView.h"
#import "elseiCarouselView.h"
#import "DMCarPledgeModel.h"
#import "DMCarPledgeListModel.h"

@interface DMCreditHeadView ()

@property (nonatomic) CreditType type;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIButton *contractBtn;    //合同
@property (nonatomic, strong) UILabel *generalLabel;    //总额
@property (nonatomic, strong) UILabel *dayLabel;        //期限
@property (nonatomic, strong) UILabel *sourceLabel;     //来源
@property (nonatomic, strong) UILabel *PBType;     //还款方式
@property (nonatomic, strong) UILabel *setPeriodLabel; //还款进度
@property (nonatomic, strong) UILabel *payBackLabel;    // 提前还款
@property (nonatomic, strong) UIImageView *topImage; // 8
@property (nonatomic, strong) UIImageView *bottomImage; // 1

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, strong) elseiCarouselView *elesicar;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *lineView1;
@end


@implementation DMCreditHeadView


- (instancetype)initWithFrame:(CGRect)frame Type:(CreditType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;

        [self addSubview:self.titleLabel];
        [self addSubview:self.typeLabel];
        [self addSubview:self.contractBtn];
        [self addSubview:self.generalLabel];
        [self addSubview:self.dayLabel];
        [self addSubview:self.sourceLabel];
        [self addSubview:self.PBType];
        [self addSubview:self.topImage];
        [self addSubview:self.segmentControl];
        [self addSubview:self.bottomImage];
        [self addSubview:self.setPeriodLabel];
//        [self addSubview:self.lineView];
//        [self addSubview:self.lineView1];
        if (self.type == CarInsurancePerson) {
            [self addSubview:self.payBackLabel];
        }else{
            
        }
    }
    return self;
}

- (void)setInfoModel:(DMCarPledgeModel *)infoModel{
    _infoModel = infoModel;
    self.typeLabel.text = infoModel.guarantyName;
    self.titleLabel.text = infoModel.title;
    NSString * amount = [NSString stringWithFormat:@"%.2f",[infoModel.loanAmount doubleValue]];
    self.generalLabel.text = [NSString stringWithFormat:@"债权总额：%@",[NSString insertCommaWithString:amount]];
    if (infoModel.termUnit == 1) {
        self.dayLabel.text = [NSString stringWithFormat:@"还款期限：%@天",infoModel.period];
    }else{
        self.dayLabel.text = [NSString stringWithFormat:@"还款期限：%@个月",infoModel.period];
    }
    self.sourceLabel.text = [NSString stringWithFormat:@"债权来源：%@",infoModel.sourceOfAssets];
    self.PBType.text = [NSString stringWithFormat:@"还款方式：%@",[infoModel.method isEqualToString:@"MonthlyInterest"]?@"按月付息":@"等额本息"];
    if (infoModel.settlePeriod) {
        self.setPeriodLabel.text = [NSString stringWithFormat:@"还款进度：%@ 期",infoModel.settlePeriod];
    }
    [self setAttributeWithLabel:self.setPeriodLabel Str:infoModel.settlePeriod];
    if (infoModel.isAheadSettle) {
        self.payBackLabel.text = [infoModel.isAheadSettle isEqualToString:@"1"]?@"提前还款":@"";
    }else{
        self.payBackLabel.text = @"";
    }
    
    [self setAtteributeWithLabel:_generalLabel];
    [self setAtteributeWithLabel:_dayLabel];
    [self setAtteributeWithLabel:_sourceLabel];
    [self setAtteributeWithLabel:_PBType];
    
    CGRect titleRect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(DMDeviceWidth - 180, 50)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:13]} context:nil];
    
    if (titleRect.size.height > 20) {
        self.titleLabel.frame = CGRectMake(10, 10, DMDeviceWidth - 180, titleRect.size.height);
    }else {
        self.titleLabel.frame = CGRectMake(10, 17, titleRect.size.width, titleRect.size.height);
    }

    self.typeLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+10, 12, 75, 23);
    
    self.elesicar = [[elseiCarouselView alloc] initWithFrame:CGRectMake(0,self.type == CarInsurancePerson?210:150, DMDeviceWidth, 100) Type:self.type];
    self.elesicar.dataArray = [NSMutableArray arrayWithArray:self.icars];
    [self addSubview:self.elesicar];
    
    if (self.elesicar.type == CarInsurancePerson) {
        if (self.elesicar.dataArray.count != 0) {
            DMCarPledgeListModel *model = [[DMCarPledgeListModel alloc] init];
            model.repayAmount = [self.infoModel.loanAmount doubleValue];
            model.dueDate = self.infoModel.timeSettled;
            model.isSettled = @"3";
            [self.elesicar.dataArray insertObject:model atIndex:0];
        }
    }else{
        if (self.elesicar.dataArray.count != 0) {
            DMCarPledgeListModel *model = [[DMCarPledgeListModel alloc] init];
            model.repayAmount = [self.infoModel.loanAmount doubleValue];
            model.dueDate = self.infoModel.timeSettled;
            model.settleStatus = @"3";
            [self.elesicar.dataArray insertObject:model atIndex:0];
        }
    }
    [self.elesicar.carousel reloadData];
    
    if ([self.infoModel.isLoanSettle isEqualToString:@"0"]||[self.infoModel.isUserHasLoan isEqualToString:@"0"]) {
        [self.setPeriodLabel removeFromSuperview];
        [self.elesicar removeFromSuperview];
        [self.payBackLabel removeFromSuperview];
        self.segmentControl.frame = CGRectMake(10, 120, DMDeviceWidth - 20, 40);
        self.bottomImage.frame = CGRectMake(0, self.segmentControl.mj_y+self.segmentControl.mj_h-1, SCREENWIDTH, 1);
    }
    
    if ([self.infoModel.isUserHasLoan isEqualToString:@"1"]) {
        self.contractBtn.hidden = NO;
    }else{
        self.contractBtn.hidden = YES;
    }
}


- (void)getContractAction:(UIButton *)button{
    [self.delegate getContract];
}

- (void)selectSegmentControl:(UISegmentedControl *)segmentControl{
    [self.delegate selectSegmentWithIndex:segmentControl.selectedSegmentIndex];
}


- (NSArray *)icars{
    if (!_icars) {
        self.icars = [@[] copy];
    }
    return _icars;
}


- (UIImageView *)topImage {
    if (!_topImage) {
        _topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.PBType.mj_y+self.PBType.mj_h+15, SCREENWIDTH, 8)];
        _topImage.backgroundColor = MainF5;
    }
    return _topImage;
}


- (UIImageView *)bottomImage {
    if (!_bottomImage) {
        _bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.segmentControl.mj_y+self.segmentControl.mj_h-1, SCREENWIDTH, 1)];
        _bottomImage.backgroundColor = MainF5;
    }
    return _bottomImage;
}


- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 27, DMDeviceWidth/2, 13)];
        _titleLabel.text = @"";
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        _titleLabel.textColor = DarkGray; /////////////86a7e8
    }
    return _titleLabel;
}


- (UILabel *)typeLabel{
    if (_typeLabel == nil) {
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth/2, 22, 75, 23)];
        _typeLabel.font = [UIFont systemFontOfSize:11];
        _typeLabel.textColor = MainRed; ///////////////ffd542
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.layer.cornerRadius = 10;
        _typeLabel.layer.masksToBounds = YES;
//        _typeLabel.layer.borderColor = [UIColor colorWithRed:29/255.0 green:91/255.0 blue:80/255.0 alpha:1].CGColor;
        _typeLabel.layer.borderColor = UIColorFromRGB(0xfc6f57).CGColor;
        _typeLabel.layer.borderWidth = 1;
//        _typeLabel.backgroundColor = UIColorFromRGB(0x1b273d);
        _typeLabel.backgroundColor = [UIColor clearColor];
    }
    return _typeLabel;
}


- (UIButton *)contractBtn{
    if (_contractBtn == nil) {
        self.contractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _contractBtn.frame = CGRectMake(DMDeviceWidth-70, 10, 80, 30);
        [_contractBtn setTitleColor:LightGray forState:UIControlStateNormal]; ///////////4b6ca7
        [_contractBtn setTitle:@"合同+" forState:UIControlStateNormal];
        _contractBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _contractBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        [_contractBtn addTarget:self action:@selector(getContractAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contractBtn;
}

- (UILabel *)generalLabel{
    if (_generalLabel == nil) {
        self.generalLabel = [self CreatLabelWithFrame:CGRectMake(10, 55, DMDeviceWidth/2, 12)
                                                 Font:11
                                                 Text:@"债权总额：0元"
                                            Alignment:NSTextAlignmentLeft
                                            TextColor:DarkGray]; //////////////86a7e8
    }
    return _generalLabel;
}

- (UILabel *)dayLabel{
    if (_dayLabel == nil) {
        self.dayLabel = [self CreatLabelWithFrame:CGRectMake(DMDeviceWidth/2+10, 55, DMDeviceWidth/2, 12)
                                             Font:11
                                             Text:@"还款期限：0天"
                                        Alignment:NSTextAlignmentLeft
                                        TextColor:DarkGray]; ///////////////86a7e8
    }
    return _dayLabel;
}

- (UILabel *)sourceLabel{
    if (_sourceLabel == nil) {
        self.sourceLabel = [self CreatLabelWithFrame:CGRectMake(10, 80, DMDeviceWidth/2, 12)
                                                Font:11
                                                Text:@"债权来源："
                                           Alignment:NSTextAlignmentLeft
                                           TextColor:DarkGray]; ////////////////86a7e8
    }
    return _sourceLabel;
}

//- (UIView *)lineView {
//    if (_lineView == nil) {
//        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, DMDeviceWidth, 8)];
//        _lineView.backgroundColor = MainF5;
//    }
//    return _lineView;
//}
//
//- (UIView *)lineView1 {
//    if (_lineView1 == nil) {
//        _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 160, DMDeviceWidth, 1)];
//        _lineView1.backgroundColor = MainF5;
//    }
//    return _lineView1;
//
//}

- (UILabel *)PBType{
    if (_PBType == nil) {
        self.PBType = [self CreatLabelWithFrame:CGRectMake(DMDeviceWidth/2+10, 80, DMDeviceWidth/2, 12)
                                           Font:11
                                           Text:@"还款方式："
                                      Alignment:NSTextAlignmentLeft
                                      TextColor:DarkGray]; ////////////////86a7e8
    }
    return _PBType;
}

- (UILabel *)setPeriodLabel{
    if (_setPeriodLabel == nil) {
        self.setPeriodLabel = [self CreatLabelWithFrame:CGRectMake(10, 140, DMDeviceWidth/2, 13)
                                                   Font:12
                                                   Text:@"还款进度：0/0期"
                                              Alignment:NSTextAlignmentLeft
                                              TextColor:MainRed]; ///////////////ffd542
    }
    return _setPeriodLabel;
}

- (UILabel *)payBackLabel{
    if (_payBackLabel == nil) {
        self.payBackLabel = [self CreatLabelWithFrame:CGRectMake(120, 140, DMDeviceWidth/2, 13)
                                                 Font:12
                                                 Text:@"提前还款"
                                            Alignment:NSTextAlignmentLeft
                                            TextColor:LightGray]; //////////////4b6ca7
    }
    return _payBackLabel;
}


- (UISegmentedControl *)segmentControl{
    if (!_segmentControl) {
        NSArray *imageArray = @[@"借款信息",@"审核情况"];
        self.segmentControl = [[UISegmentedControl alloc] initWithItems:imageArray];
        _segmentControl.tintColor = [UIColor clearColor]; ///////////////253653
        _segmentControl.backgroundColor = [UIColor clearColor]; /////////////1B2942
        _segmentControl.frame = CGRectMake(10, self.bounds.size.height - 41, DMDeviceWidth - 20, 40);
        _segmentControl.layer.cornerRadius = 20;
        _segmentControl.layer.masksToBounds = YES;
        _segmentControl.layer.borderWidth = 1;
        _segmentControl.layer.borderColor = [UIColor clearColor].CGColor; ////////////1B2942
        _segmentControl.selectedSegmentIndex = 0;
        NSDictionary *selected = [NSDictionary dictionaryWithObjectsAndKeys:MainGreen,NSForegroundColorAttributeName,[UIFont systemFontOfSize:13],NSFontAttributeName, nil]; //////////////86a7e8
        NSDictionary *normal = [NSDictionary dictionaryWithObjectsAndKeys:LightGray,NSForegroundColorAttributeName,[UIFont systemFontOfSize:13],NSFontAttributeName, nil]; ///////////////4b6ca7
        [_segmentControl setTitleTextAttributes:normal forState:UIControlStateNormal];
        [_segmentControl setTitleTextAttributes:selected forState:UIControlStateSelected];
        [_segmentControl addTarget:self action:@selector(selectSegmentControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (void)setAtteributeWithLabel:(UILabel *)label {
    NSMutableAttributedString *labelStr=[[NSMutableAttributedString alloc]initWithString:label.text];
    NSRange range = NSMakeRange(0, 5);
    [labelStr addAttribute:NSForegroundColorAttributeName value:LightGray range:range]; ////////////4b6ca7
    label.attributedText = labelStr;
}



- (UILabel *)CreatLabelWithFrame:(CGRect)frame Font:(CGFloat)font Text:(NSString *)text Alignment:(NSTextAlignment)aligent TextColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = aligent;
    label.font = [UIFont fontWithName:@"PingFangSC-Light" size:font];
    label.textColor = color;
    label.text = text;
    return label;
}

- (void)setAttributeWithLabel:(UILabel *)label Str:(NSString *)str{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:label.text];
    NSString *string = str;
    NSRange dayRange = [label.text rangeOfString:string];
    [hintString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:dayRange];
    label.attributedText = hintString;

}

@end
