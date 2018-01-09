//
//  DMScafferListCell.m
//  豆蔓理财
//
//  Created by edz on 2017/7/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMScafferListCell.h"
#import "DMScafferListModel.h"
#define SPACELINE 6
@interface DMScafferListCell ()

@property (nonatomic, strong)UILabel *titleLabel; //标题
@property (nonatomic, strong)UILabel *investmentLabel; //年化利率
@property (nonatomic, strong)UILabel *timeLimitLabel; //期限
@property (nonatomic, strong)UILabel *remainBuyLabel; //剩余可购
@property (nonatomic, strong)UILabel *actualAmountLabel;

@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIView *bottomView;

@end

@implementation DMScafferListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.topView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.investmentLabel];
        [self.contentView addSubview:self.timeLimitLabel];
        [self.contentView addSubview:self.remainBuyLabel];
        [self.contentView addSubview:self.actualAmountLabel];
        [self createUI:@[@"年化利率",@"借款期限",@"剩余可购"]];
    }
    return self;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 6)];
        _topView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    }
    return _topView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelFrame:CGRectMake(15, 10 + SPACELINE, SCREENWIDTH, 14) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        _titleLabel.font = FONT_Light(11.f);
        NSRange range = [@"17041404期 " rangeOfString:@" "];
        _titleLabel.attributedText = [self returenAttribute:@"17041404期  凯迪拉克XTS车辆质押"  imageName:@"散标圆点" imageBounds:CGRectMake(0, 3, 4, 4) index:range.location + 1];
    }
    return _titleLabel;
}

- (UILabel *)typeLabel {
    UIImage *image = [UIImage imageNamed:@"已满标"];
    if (!_typeLabel) {
        _typeLabel = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH - image.size.width - 35, 15, image.size.width, image.size.height) labelColor:UIColorFromRGB(0x47b994) textAlignment:(NSTextAlignmentRight) textFont:image.size.height];
        _typeLabel.text = @"";
       _typeLabel.attributedText = [self returenAttribute:@""  imageName:@"已满标" imageBounds:CGRectMake(0, 0, image.size.width, image.size.height) index:0];
        _typeLabel.hidden = YES;
    }
    return _typeLabel;
}

- (UILabel *)investmentLabel {
    if (!_investmentLabel) {
        _investmentLabel = [UILabel createLabelFrame:CGRectMake(0, 23 + 25 + SPACELINE, (SCREENWIDTH) / 3, 23) labelColor:UIColorFromRGB(0xff6e51) textAlignment:(NSTextAlignmentCenter) textFont:22.f];
        _investmentLabel.font = FONT_Regular(22.f);
        NSRange range = [@"8%" rangeOfString:@"%"];
        self.investmentLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:range text:@"8%" length:YES];
    }
    return _investmentLabel;
}

- (UILabel *)timeLimitLabel {
    if (!_timeLimitLabel) {
        _timeLimitLabel = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH ) / 3, 54 + SPACELINE, (SCREENWIDTH) / 3, 16) labelColor:UIColorFromRGB(0x4b5159) textAlignment:(NSTextAlignmentCenter) textFont:15];
        _timeLimitLabel.font = FONT_Regular(15);
        
    }
    return _timeLimitLabel;
}

- (UILabel *)remainBuyLabel {
    if (!_remainBuyLabel) {
        _remainBuyLabel = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH ) / 3 * 2, 54 + SPACELINE, (SCREENWIDTH) / 3, 16) labelColor:UIColorFromRGB(0x4b5159) textAlignment:(NSTextAlignmentCenter) textFont:15];
        _remainBuyLabel.font = FONT_Regular(15);
        NSString *timeLimit = [NSString stringWithFormat:@"%@元",@"100"];
        NSRange rang1 = [timeLimit rangeOfString:@"元"];
        _remainBuyLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:rang1 text:timeLimit length:YES];
    }
    return _remainBuyLabel;
}

- (void)createUI:(NSArray *)textArr {
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 47 + 23 + 10 + SPACELINE, SCREENWIDTH / 3 * textArr.count, 13)];
    self.bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    if (self.bottomView.subviews.count != 0) {
        for (UILabel *label in self.bottomView.subviews) {
            [label removeFromSuperview];
        }
    }
    for (int i = 0; i < textArr.count; i++) {
        UILabel *label = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH ) / 3 * i, 0, (SCREENWIDTH) / 3, 12) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
        label.font = FONT_Light(11.f);
        label.text = textArr[i];
        [self.bottomView addSubview:label];
    }
    [self.contentView addSubview:self.bottomView];
}

- (void)setScafferListModel:(DMScafferListModel *)scafferListModel {
    if (_scafferListModel != scafferListModel) {
        _scafferListModel = scafferListModel;
    }
    
//    NSString *periods = [NSString stringWithFormat:@"%@期  %@",_scafferListModel.periods,_scafferListModel.title];
//    NSRange range = [periods rangeOfString:@" "];
//
//    self.titleLabel.attributedText = [self returenAttribute:periods imageName:@"散标圆点" imageBounds:CGRectMake(0, 3, 4, 4) index:range.location + 1];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",_scafferListModel.title];
    if ([_scafferListModel.interestRate isEqualToString:@"0"]) {
        NSString *string = [NSString stringWithFormat:@"%@%%",_scafferListModel.rate];
        NSRange range = [string rangeOfString:@"%"];
        self.investmentLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} textRange:range text:string length:YES];
    }else {
        NSString *string = [NSString stringWithFormat:@"%@%%+%@%%",_scafferListModel.rate,_scafferListModel.interestRate];
        NSRange range1 = [string rangeOfString:@"+"];
        NSMutableAttributedString *attributeString = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:range1 text:string length:YES];
        
        
        NSRange range2 = [string rangeOfString:@"%"];
        [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(15.f)} range:NSMakeRange(range2.location, 1)];
        
        [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(15.f)} range:NSMakeRange(range1.location + 1, 1)];
        
        [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(15.f)} range:NSMakeRange(string.length - 1, 1)];
        self.investmentLabel.attributedText = attributeString;
        
    
        
//        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.f],NSForegroundColorAttributeName:MainRed} range:NSMakeRange(range1.location + 1, _scafferListModel.interestRate.length)];
//        self.investmentLabel.attributedText = attributeString;
    }
    
    if (_scafferListModel.termUnit == 1) {
       self.timeLimitLabel.text = [NSString stringWithFormat:@"%@天",_scafferListModel.months];
    }else {
       self.timeLimitLabel.text = [NSString stringWithFormat:@"%@个月",_scafferListModel.months];
    }
    
    
    
    NSString *remainBuy = [NSString stringWithFormat:@"%@元",_scafferListModel.surplusAmount];
    NSRange rang2 = [remainBuy rangeOfString:@"元"];
    self.remainBuyLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:rang2 text:remainBuy length:YES];
    
    UIImage *image = [UIImage imageNamed:@"已满标"];
    if ([_scafferListModel.status isEqualToString:@"CLEARED"]) {
        //已还款
        self.typeLabel.attributedText = [self returenAttribute:@""  imageName:@"已还款" imageBounds:CGRectMake(0, 0, image.size.width, image.size.height) index:0];
        self.typeLabel.hidden = NO;
    }else if ([_scafferListModel.status isEqualToString:@"FINISHED"]){
        //已满标
        self.typeLabel.attributedText = [self returenAttribute:@""  imageName:@"已满标" imageBounds:CGRectMake(0, 0, image.size.width, image.size.height) index:0];
        self.typeLabel.hidden = NO;
    }else if ([_scafferListModel.status isEqualToString:@"SETTLED"]) {
        //还款中
        self.typeLabel.attributedText = [self returenAttribute:@""  imageName:@"还款中" imageBounds:CGRectMake(0, 0, image.size.width, image.size.height) index:0];
        self.typeLabel.hidden = NO;
    }else {
        //
         self.typeLabel.hidden = YES;
    }
}


#pragma 插入图片
//创建图片附件
- (NSAttributedString *)pitcureStringName:(NSString *)imageName imageBounds:(CGRect)imageBounds{
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:imageName];
    attach.bounds = imageBounds;
    NSAttributedString *attachStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    return attachStr;
}

- (NSMutableAttributedString *)returenAttribute:(NSString *)string imageName:(NSString *)imageName imageBounds:(CGRect)imageBounds index:(NSInteger)index{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute insertAttributedString:[self pitcureStringName:imageName imageBounds:imageBounds] atIndex:index];
    
    return attribute;
}

#pragma 可变字符串
- (NSMutableAttributedString *)LJQLabelAttributeDic:(NSDictionary *)dic textRange:(NSRange)range text:(NSString *)text length:(BOOL)length{
    NSMutableAttributedString *mutableAttribute = [[NSMutableAttributedString alloc] initWithString:text];
    [mutableAttribute addAttributes:dic range:NSMakeRange(range.location, length ? 1 : 2)];
    return mutableAttribute;
}

- (NSMutableAttributedString *)returnAttributeWithString:(NSString *)string range:(NSRange)range length:(NSInteger)length  color:(UIColor *)color{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f],NSForegroundColorAttributeName:color} range:NSMakeRange(range.location + 1, length)];
    return attribute;
}

@end
