//
//  LJQMineCell.m
//  豆蔓理财
//
//  Created by mac on 2016/12/7.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQMineCell.h"
#import "LJQMineModel.h"
#import "DMAmountInfoView.h"
static NSInteger isroating = 0;
static NSString *changeString = @"资产总额(元)";
@interface LJQMineCell ()<CAAnimationDelegate>

@property (nonatomic, strong)UILabel *TopAssectLabel; //待回款金额
@property (nonatomic, strong)UILabel *totalAmountLabel; //总资产
@property (nonatomic, strong)UILabel *investmentLabel; //累计投资
@property (nonatomic, strong)UILabel *earningsLabel; //累计收益


@property (nonatomic, strong)UILabel *totalLabel;

@property (nonatomic, strong)NSArray *classes;

@property (nonatomic, copy)NSMutableAttributedString *accountString;
@property (nonatomic, copy)NSMutableAttributedString *availableAmountString;

@end

@implementation LJQMineCell
@synthesize pieChartView;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    UIButton *leftBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage *image = [UIImage imageNamed:@"creditor's_button"];
    [leftBtn setBackgroundImage:image forState:(UIControlStateNormal)];
    [leftBtn setBackgroundImage:image forState:(UIControlStateHighlighted)];
    [leftBtn setFrame:CGRectMake(10, 30, image.size.width, image.size.height)];
    [leftBtn addTarget:self action:@selector(HoldtheClaim:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"assets_button"] forState:(UIControlStateNormal)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"assets_button"] forState:(UIControlStateHighlighted)];
    [rightBtn setFrame:CGRectMake(SCREENWIDTH - image.size.width - 10, 30, image.size.width, image.size.height)];
    [rightBtn addTarget:self action:@selector(HoldAsset:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:rightBtn];
    
    UIImage *centerImage = [UIImage imageNamed:@"fuwurobot"];
    UIButton *centerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [centerBtn setBackgroundImage:centerImage forState:(UIControlStateNormal)];
    [centerBtn setBackgroundImage:centerImage forState:(UIControlStateNormal)];
    [centerBtn setBackgroundImage:centerImage forState:(UIControlStateHighlighted)];
    [centerBtn setFrame:CGRectMake((SCREENWIDTH - centerImage.size.width) / 2, 30, centerImage.size.width, centerImage.size.height)];
    [centerBtn addTarget:self action:@selector(myServiceAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:centerBtn];
    
    self.TopAssectLabel = [UILabel createLabelFrame:CGRectMake(0, 25, SCREENWIDTH, 20) labelColor:MainRed textAlignment:(NSTextAlignmentCenter) textFont:18.f];
    self.TopAssectLabel.text = @"--";
    //[self.contentView addSubview:self.TopAssectLabel];
    
    UILabel *sevenLabel = [UILabel createLabelFrame:CGRectMake(0, CGRectGetMaxY(self.TopAssectLabel.frame) + 8, SCREENWIDTH, 13) labelColor:LightGray textAlignment:(NSTextAlignmentCenter) textFont:12.f];
    sevenLabel.text = @"账户余额(元)";
    //sevenLabel.attributedText = [self returnBackString:@"账户余额(元)"]; //二期为近七日待回款
    [sevenLabel DM_addAttributeTapActionWithStrings:@[sevenLabel.text] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
       // self.sevenDay();
    }];
   // [self.contentView addSubview:sevenLabel];
    
    CGFloat width = [self returenWitch:sevenLabel.text];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((SCREENWIDTH - width) / 2, LJQ_VIEW_MaxY(self.TopAssectLabel) + 21, width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0x436090);
  //  [self.contentView addSubview:lineView];
    
    NSArray *portions = @[@"10",@"10",@"80"];
    NSArray *colors = @[UIColorFromRGB(0x31c19f),UIColorFromRGB(0x63d9f4),UIColorFromRGB(0xfc745d)];
    NSArray *values = @[@"0.00",@"0.00",@"0.00"];
    self.classes = @[@"持有资产",@"未结收益",@"账户余额"];
    self.pieChartView = [[GZPieChartTwoView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.TopAssectLabel.frame) + 22 + 21, SCREENWIDTH , 360 * SCREENWIDTH / 400) portions:portions portionColors:colors radius:(350 * SCREENWIDTH / 400) / 2 - 65 lineWidth:15 values:values classes:self.classes];
    [self.contentView addSubview:pieChartView];
    
    self.totalAmountLabel = [UILabel createLabelFrame:CGRectMake(0, 0, CGRectGetWidth(pieChartView.frame), 30) labelColor:MainRed textAlignment:(NSTextAlignmentCenter) textFont:iPhone5 ? 20 : 28];
    self.totalAmountLabel.attributedText = [self attributeString:@"0.00"];
    self.totalAmountLabel.center = CGPointMake(CGRectGetWidth(pieChartView.frame) / 2, CGRectGetHeight(pieChartView.frame) / 2 - 10);
    [pieChartView addSubview:self.totalAmountLabel];
    
    UILabel *totalLabel = [UILabel createLabelFrame:CGRectMake(0, 0, CGRectGetWidth(pieChartView.frame), 20) labelColor:DarkGray textAlignment:(NSTextAlignmentCenter) textFont:iPhone5 ? 12 : 15];
    totalLabel.center = CGPointMake(CGRectGetWidth(pieChartView.frame) / 2 , self.totalAmountLabel.center.y + 8 + CGRectGetHeight(self.totalAmountLabel.frame) / 2);
    totalLabel.text = @"资产总额(元)";
    totalLabel.userInteractionEnabled = YES;
    [pieChartView addSubview:totalLabel];
    
    
    
    self.investmentLabel = [UILabel createLabelFrame:CGRectMake(0, CGRectGetMaxY(pieChartView.frame) + 8, SCREENWIDTH / 2, 21) labelColor:DarkGray textAlignment:(NSTextAlignmentCenter) textFont:20.f];
    self.investmentLabel.text = [self stringFormatterDecimalStyle:@(453452.80)];
    [self.contentView addSubview:self.investmentLabel];
    
    
    UIImage *pitcure = [UIImage imageNamed:@"cumulative-subscribe"];
    UIImageView *leftPitcure = [[UIImageView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.investmentLabel.frame) + 8, pitcure.size.width, pitcure.size.height)];
    leftPitcure.center = CGPointMake(SCREENWIDTH / 4, CGRectGetMaxY(self.investmentLabel.frame) + 5 + pitcure.size.height / 2);
    leftPitcure.image = pitcure;
    [self.contentView addSubview:leftPitcure];
    
    
    self.earningsLabel = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH / 2, CGRectGetMaxY(pieChartView.frame) + 8, SCREENWIDTH / 2, 21) labelColor:DarkGray textAlignment:(NSTextAlignmentCenter) textFont:20.f];
    self.earningsLabel.text = [self stringFormatterDecimalStyle:@(34353453.30)];
    [self.contentView addSubview:self.earningsLabel];
    
    
    UIImageView *rightPitcure = [[UIImageView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.earningsLabel.frame) + 8, pitcure.size.width, pitcure.size.height)];
    rightPitcure.center = CGPointMake(SCREENWIDTH / 4 * 3, CGRectGetMaxY(self.earningsLabel.frame) + 5 + pitcure.size.height / 2);
    rightPitcure.image = [UIImage imageNamed:@"cumulative-returns"];
    [self.contentView addSubview:rightPitcure];
    
    
    
    //提现
    UIButton *withDrawal = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage *drawal = [UIImage imageNamed:@"extract_button"];
    withDrawal.tag = 20000;
    [withDrawal setBackgroundImage:drawal forState:(UIControlStateNormal)];
    [withDrawal setBackgroundImage:drawal forState:(UIControlStateHighlighted)];
    [withDrawal setFrame:CGRectMake(0, 0, drawal.size.width, drawal.size.height)];
    withDrawal.center = CGPointMake(SCREENWIDTH / 4, CGRectGetMaxY(self.investmentLabel.frame) + 43 + pitcure.size.height / 2);
    [withDrawal addTarget:self action:@selector(WithDrawal:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:withDrawal];
    
    //充值
    UIButton *topUpBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [topUpBtn setBackgroundImage:[UIImage imageNamed:@"recharge_button"] forState:(UIControlStateNormal)];

    topUpBtn.tag = 20001;

    [topUpBtn setBackgroundImage:[UIImage imageNamed:@"recharge_button"] forState:(UIControlStateHighlighted)];

    [topUpBtn setFrame:CGRectMake(0, 0, drawal.size.width, drawal.size.height)];
    topUpBtn.center = CGPointMake(SCREENWIDTH / 4 * 3, CGRectGetMaxY(self.investmentLabel.frame) + 43 + pitcure.size.height / 2);
    [topUpBtn addTarget:self action:@selector(topUp:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:topUpBtn];
}

- (NSString *)stringFormatterDecimalStyle:(NSNumber *)money
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    return [formatter stringFromNumber:money];
}


- (NSMutableAttributedString *)attributeString:(NSString *)string {
    NSMutableAttributedString *attribur = [[NSMutableAttributedString alloc] initWithString:string];
    if ([string containsString:@"."]) {
        NSRange range = [string rangeOfString:@"."];
        [attribur addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.f] range:NSMakeRange(range.location, string.length - range.location)];
        
    }
    return attribur;
}

- (NSMutableAttributedString *)returnBackString:(NSString *)string {
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:UIColorFromRGB(0x436090),NSBaselineOffsetAttributeName:@(0)} range:NSMakeRange(0, string.length)];
    return attribute;
}

- (CGFloat)returenWitch:(NSString *)string {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(200, 14) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil];
    return rect.size.width;
}

//持有债权
- (void)HoldtheClaim:(UIButton *)sender {
    self.holdThebk(sender);
}

//持有资产
- (void)HoldAsset:(UIButton *)sender {
    self.holdAssetBK(sender);
}

//提现
- (void)WithDrawal:(UIButton *)sender {
    
    self.withDrawalBK(sender);
}

//充值
- (void)topUp:(UIButton *)sender {
    
    self.topUpBK(sender);
}

- (void)myServiceAction:(UIButton *)sender {
    !self.serviceBK ? : self.serviceBK();
}

- (void)setModel:(LJQMineModel *)model {
    if (_model != model) {
        _model = model;
    }
    [self.pieChartView removeFromSuperview];
    for (UILabel *label in self.pieChartView.subviews) {
        [label removeFromSuperview];
    }
    //七日回款
    NSString *sevenString = [self stringFormatterDecimalStyle:@(_model.availableAmount)]; //model.nextSevenDayAmount
    self.TopAssectLabel.text = [self returnDecimalString:sevenString];
    //总资产
    NSString *strring = [NSString stringWithFormat:@"%.2f",_model.totalAmount];
    NSString *totalStr = [self returnDecimalString:strring];
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:totalStr];
    NSRange range = [totalStr rangeOfString:@"."];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:iPhone5 ? 12.f : 18.f]} range:NSMakeRange(range.location, strring.length - range.location )];
    self.totalAmountLabel.attributedText = attribute;
    self.accountString = attribute;
    
    //账户余额
    NSString *available = [NSString stringWithFormat:@"%.2f",_model.availableAmount];
    NSString *availableStr = [self returnDecimalString:available];
    NSMutableAttributedString *availableAtribute = [[NSMutableAttributedString alloc] initWithString:availableStr];
    NSRange availRange = [availableStr rangeOfString:@"."];
    [availableAtribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:iPhone5 ? 12.f : 18.f]} range:NSMakeRange(availRange.location, available.length - availRange.location )];
    self.availableAmountString = availableAtribute;
    
    //累计投资
    NSString *investment = [self stringFormatterDecimalStyle:@(_model.totalInvestAmount)];
    self.investmentLabel.text = [self returnDecimalString:investment];
    //累计收益
    NSString *earnString = [self stringFormatterDecimalStyle:@(_model.totalInterest)];
    self.earningsLabel.text = [self returnDecimalString:earnString];
    
    //持有资产
    NSString *hasAmount = [NSString stringWithFormat:@"%.2f",_model.hasAmount];
    //未结收益
//    NSString *noSettleInterest = [NSString stringWithFormat:@"%.2f",_model.noSettleInterest];
    //账户余额
    NSString *availableAmount = [NSString stringWithFormat:@"%.2f",_model.availableAmount];
    //提现审核资金
    NSString *withDrawal = [NSString stringWithFormat:@"%.2f",_model.frozenAmount];
    //颜色值
    
    
    NSArray *portions = @[@"1",@"1",@"1",@"1"];
    NSArray *colors = @[UIColorFromRGB(0x31c19f),UIColorFromRGB(0x63d9f4),UIColorFromRGB(0xfc745d),UIColorFromRGB(0x212d46)];
    NSArray *values = @[hasAmount,withDrawal,availableAmount];
    self.classes = @[@"持有资产",@"提现审核中",@"账户余额"];
    
    if (_model.hasAmount == 0 && _model.availableAmount == 0 && _model.frozenAmount == 0) {
        portions = @[];
        colors = @[];
        values = @[];
        self.classes = @[];
    }else if (_model.hasAmount != 0 && _model.availableAmount != 0 && _model.frozenAmount != 0) {
        portions = @[hasAmount,withDrawal,availableAmount];
        colors = @[UIColorFromRGB(0x31c19f),UIColorFromRGB(0x63d9f4),UIColorFromRGB(0xfc745d)];
        values = @[hasAmount,withDrawal,availableAmount];
        self.classes = @[@"持有资产",@"审核中",@"账户余额"];
    }
    else if (_model.availableAmount != 0 && _model.frozenAmount != 0){
        //账户余额不为0，提现审核不为0
        if (_model.hasAmount == 0) {
            
            portions = @[availableAmount,withDrawal];
            colors = @[UIColorFromRGB(0x31c19f),UIColorFromRGB(0x63d9f4)];
            values = @[availableAmount,withDrawal];
            self.classes = @[@"账户余额",@"审核中"];
        }else {
            //持有资产不为0
            portions = @[hasAmount,availableAmount,withDrawal];
            colors = @[UIColorFromRGB(0x31c19f),UIColorFromRGB(0x63d9f4),UIColorFromRGB(0xfc745d)];
            values = @[hasAmount,availableAmount,withDrawal];
            self.classes = @[@"持有资产",@"账户余额",@"审核中"];
        }
    }else if (_model.availableAmount == 0 && _model.frozenAmount != 0) {
        //账户余额为0，提现审核不为0
        if (_model.hasAmount == 0) {
            //持有资产为0，未结收益也为0
            portions = @[withDrawal];
            colors = @[UIColorFromRGB(0x31c19f)];
            values = @[withDrawal];
            self.classes = @[@"审核中"];
        }else {
            portions = @[hasAmount,withDrawal];
            colors = @[UIColorFromRGB(0x31c19f),UIColorFromRGB(0x63d9f4)];
            values = @[hasAmount,withDrawal];
            self.classes = @[@"持有资产",@"审核中"];
        }

    }else if (_model.frozenAmount == 0 && _model.availableAmount == 0) {
        //提现审核金额为0，账户余额为0
        if (_model.hasAmount == 0) {
            //持有资产为0，未结收益也为0
            portions = @[];
            colors = @[];
            values = @[];
            self.classes = @[];
        }else {
            portions = @[hasAmount];
            colors = @[UIColorFromRGB(0x31c19f)];
            values = @[hasAmount];
            self.classes = @[@"持有资产"];

        }

    }else if (_model.frozenAmount == 0 && _model.availableAmount != 0) {
        //提现审核金额为0，账户余额不为0
        if (_model.hasAmount == 0) {
            //持有资产为0，未结收益也为0
            portions = @[availableAmount];
            colors = @[UIColorFromRGB(0x31c19f)];
            values = @[availableAmount];
            self.classes = @[@"账户余额"];
        }else {
            portions = @[hasAmount,availableAmount];
            colors = @[UIColorFromRGB(0x31c19f),UIColorFromRGB(0x63d9f4)];
            values = @[hasAmount,availableAmount];
            self.classes = @[@"持有资产",@"账户余额"];
        }

    }
    
    self.pieChartView = [[GZPieChartTwoView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.TopAssectLabel.frame) + 22 + 21, SCREENWIDTH , 360 * SCREENWIDTH / 400) portions:portions portionColors:colors radius:(350 * SCREENWIDTH / 400) / 2 - 73 lineWidth:15 values:values classes:self.classes];
    [self.contentView addSubview:self.pieChartView];
    [pieChartView addSubview:self.totalAmountLabel];
    
    
    self.totalLabel = [UILabel createLabelFrame:CGRectMake(0, 0, CGRectGetWidth(pieChartView.frame), 20) labelColor:DarkGray textAlignment:(NSTextAlignmentCenter) textFont:iPhone5 ? 12 : 15];
    self.totalLabel.center = CGPointMake(CGRectGetWidth(pieChartView.frame) / 2 , self.totalAmountLabel.center.y + 8 + CGRectGetHeight(self.totalAmountLabel.frame) / 2);
    self.totalLabel.text = changeString;

    
    [self.totalLabel DM_addAttributeTapActionWithStrings:@[changeString] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        
        //旋转效果
//        [self rotatingEffect:self.totalLabel];
//        [self rotatingEffect:self.totalAmountLabel];
//        if (isroating == 0) {
//            isroating = 1;
//        }else if (isroating == 1){
//            isroating = 0;
//        }
    
    }];
    [pieChartView addSubview:self.totalLabel];
    
    
    [self amountInfo:self.totalLabel];
}

- (NSString *)returnDecimalString:(NSString *)string {
    
    NSString *Decimal;
    
    if ([string containsString:@"."]) {
        Decimal = string;
    }else {
        Decimal = [string stringByAppendingString:@".00"];
    }
    
    return Decimal;
}

//旋转效果
- (void)rotatingEffect:(UIView *)view {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.delegate = self;
    animation.toValue = @(M_PI * 2);
    animation.duration = 1;
    animation.autoreverses = NO;
    [view.layer addAnimation:animation forKey:@"rotating"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        if (isroating == 0) {
            self.totalAmountLabel.attributedText = self.accountString;
            changeString = @"资产总额(元)";
            self.totalLabel.text = @"资产总额(元)";
        }
        if (isroating == 1) {
            self.totalAmountLabel.attributedText = self.availableAmountString;
            changeString = @"账户余额(元)";
            self.totalLabel.text = @"账户余额(元)";
        }
    }
}

- (void)amountInfo:(UILabel *)label {
    //资产说明
    UILabel *amountInfoLabel = [UILabel createLabelFrame:CGRectMake(0, 0, CGRectGetWidth(pieChartView.frame), 20) labelColor:LightGray textAlignment:(NSTextAlignmentCenter) textFont:12.f];
    amountInfoLabel.center = CGPointMake(CGRectGetWidth(pieChartView.frame) / 2 , label.center.y + 17 + CGRectGetHeight(label.frame) / 2);
    amountInfoLabel.text = @"资产说明";
    [amountInfoLabel DM_addAttributeTapActionWithStrings:@[@"资产说明"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        
        NSString *infoText = @" 回款日由于银行和本地数据同步量较大，可能会导致持有资产数据更新过慢，数据以回款次日的为准，请您耐心等待。";
        DMAmountInfoView *infoView = [[DMAmountInfoView alloc] initWithIsOpenAccount:infoText flag:0];
        [infoView showView];
    }];
    [pieChartView addSubview:amountInfoLabel];
    
    CGFloat width1 = [self returenWitch:amountInfoLabel.text];
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake((SCREENWIDTH - width1) / 2, LJQ_VIEW_MaxY(amountInfoLabel) - 3, width1, 1)];
    lineView1.backgroundColor = MainLine;
    [pieChartView addSubview:lineView1];
}

@end
