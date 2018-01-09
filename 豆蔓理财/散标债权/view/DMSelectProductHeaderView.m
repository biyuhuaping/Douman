//
//  DMSelectProductHeaderView.m
//  豆蔓理财
//
//  Created by edz on 2017/7/28.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMSelectProductHeaderView.h"
#import "MenuButton.h"
#import "DMHomeListModel.h"
@interface DMSelectProductHeaderView ()<MenuButtonDelegate>

@property (nonatomic, strong)UILabel *rateLabel;
@property (nonatomic, strong)UILabel *rateInfoLabel;

@property (nonatomic, strong)UIView *lineView;

@property (nonatomic, strong)UILabel *timeLimitLabel; //期限
@property (nonatomic, strong)UILabel *toBuyLabel; //剩余可购

@property (nonatomic, strong)UILabel *earnWayLabel; //收益方式
@property (nonatomic, strong)UILabel *collectLabel; //募集

@property (nonatomic, strong)UIView *colorView;
@property (nonatomic, strong) MenuButton *menuButton;
@end

@implementation DMSelectProductHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:self.rateLabel];
        [self addSubview:self.rateInfoLabel];
        //[self addSubview:self.lineView];
        [self addSubview:self.timeLimitLabel];
        [self addSubview:self.toBuyLabel];
        [self addSubview:self.earnWayLabel];
        [self addSubview:self.collectLabel];
        [self addSubview:self.colorView];
        [self addSubview:self.menuButton];
    }
    return self;
}

- (void)setAssetModel:(DMHomeListModel *)assetModel {
    if (_assetModel != assetModel) {
        _assetModel = assetModel;
    }
    
    //利率
    
    if (isOrEmpty(_assetModel.assetInterestRate) || [_assetModel.assetInterestRate doubleValue] == 0) {
        NSString *rateString = [NSString stringWithFormat:@"%@%%",isOrEmpty(_assetModel.assetRate) ? @"--" : _assetModel.assetRate];
         NSRange range1 = [rateString rangeOfString:@"%"];
        self.rateLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:FONT_Light(22.f)} textRange:range1 text:rateString length:YES];
    }else {
        NSString *string = [NSString stringWithFormat:@"%@%%+%@%%",isOrEmpty(_assetModel.assetRate) ? @"-" : _assetModel.assetRate,isOrEmpty(_assetModel.assetInterestRate) ? @"-" : _assetModel.assetInterestRate];
        NSRange range1 = [string rangeOfString:@"+"];
        NSMutableAttributedString *attributeString = [self LJQLabelAttributeDic:@{NSFontAttributeName:FONT_Light(15.f)} textRange:range1 text:string length:YES];
        
        NSRange range2 = [string rangeOfString:@"%"];
        [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(15.f)} range:NSMakeRange(range2.location, 1)];
        
        [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(22.f)} range:NSMakeRange(range1.location + 1, 1)];
        
        [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(15.f)} range:NSMakeRange(string.length - 1, 1)];
        self.rateLabel.attributedText = attributeString;
    }
    //借款期限
    NSString *timeLimit;
    if (_assetModel.termUnit == 1) {
        timeLimit = [NSString stringWithFormat:@"借款期限 %@天",_assetModel.productCycle];
    }else {
        timeLimit = [NSString stringWithFormat:@"借款期限 %@个月",_assetModel.productCycle];
    }
    NSRange timeRange = [timeLimit rangeOfString:@" "];
    self.timeLimitLabel.attributedText = [self returnAttributeWithString:timeLimit range:timeRange length:(timeLimit.length - timeRange.location - 1) color:UIColorFromRGB(0x4b5159) font:13.f fontName:@"PingFangSC-Regular"];
    
    //募集期
    NSString *collctStr = [NSString stringWithFormat:@"募集期至：%@",isOrEmpty(_assetModel.timeOut) ? @"--": _assetModel.timeOut];
    CGFloat width = [self returenLabelHeight:collctStr size:CGSizeMake(DMDeviceWidth, 12) fontsize:11.f isWidth:YES];
    
    CGFloat X = DMDeviceWidth - 21 - width;
    [self.collectLabel setFrame:CGRectMake(X, 112 + 23 + 14 + 10, width, 12)];
    self.collectLabel.text = collctStr;
    
    //收益方式
    NSString *earnStr;
     [self.earnWayLabel setFrame:CGRectMake(X, 112 + 23, 200, 14)];
    if ([_assetModel.assetRepaymentMethod isEqualToString:@"EqualInstallment"]) {
       earnStr  = @"收益方式 等额本息";
    }else {
        earnStr = @"收益方式 按月付息";
    }
    NSRange earnRange = [earnStr rangeOfString:@" "];
    self.earnWayLabel.attributedText = [self returnAttributeWithString:earnStr range:earnRange length:(earnStr.length - earnRange.location - 1) color:UIColorFromRGB(0x4b5159) font:13.f fontName:@"PingFangSC-Regular"];
    
    //剩余可购
    self.toBuyLabel.text = [NSString stringWithFormat:@"剩余可购（元）：%@",_assetModel.assetBalance];
}

- (void)layoutSubviews {
    
    
//    NSString *string = @"7%+1%";
//    NSRange range1 = [string rangeOfString:@"+"];
//    NSMutableAttributedString *attributeString = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} textRange:range1 text:string length:YES];
//    
//    NSRange range2 = [string rangeOfString:@"%"];
//    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} range:NSMakeRange(range2.location, 1)];
//
//    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22.f]} range:NSMakeRange(range1.location + 1, 1)];
//    
//    [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} range:NSMakeRange(string.length - 1, 1)];
//    self.rateLabel.attributedText = attributeString;
//    
//    NSString *timeLimit = @"借款期限 1个月";
//    NSRange timeRange = [timeLimit rangeOfString:@" "];
//    self.timeLimitLabel.attributedText = [self returnAttributeWithString:timeLimit range:timeRange length:(timeLimit.length - timeRange.location - 1) color:UIColorFromRGB(0x4b5159) font:13.f fontName:@"PingFangSC-Regular"];
//    self.toBuyLabel.text = @"剩余可购（元）：1800800.00";
//    
//    NSString *collctStr = @"募集期至：2017/05/01";
//    CGFloat width = [self returenLabelHeight:collctStr size:CGSizeMake(DMDeviceWidth, 12) fontsize:11.f isWidth:YES];
//    
//    CGFloat X = DMDeviceWidth - 21 - width;
//    [self.collectLabel setFrame:CGRectMake(X, 112 + 23 + 14 + 10, width, 12)];
//    self.collectLabel.text = collctStr;
//    
//    [self.earnWayLabel setFrame:CGRectMake(X, 112 + 23, 200, 14)];
//    NSString *earnStr = @"收益方式 等额本息";
//    NSRange earnRange = [earnStr rangeOfString:@" "];
//    self.earnWayLabel.attributedText = [self returnAttributeWithString:earnStr range:earnRange length:(earnStr.length - earnRange.location - 1) color:UIColorFromRGB(0x4b5159) font:13.f fontName:@"PingFangSC-Regular"];
}

#pragma 可变字符串
- (NSMutableAttributedString *)LJQLabelAttributeDic:(NSDictionary *)dic textRange:(NSRange)range text:(NSString *)text length:(BOOL)length{
    NSMutableAttributedString *mutableAttribute = [[NSMutableAttributedString alloc] initWithString:text];
    [mutableAttribute addAttributes:dic range:NSMakeRange(range.location, length ? 1 : 2)];
    return mutableAttribute;
}

- (NSMutableAttributedString *)returnAttributeWithString:(NSString *)string range:(NSRange)range length:(NSInteger)length  color:(UIColor *)color font:(CGFloat)font fontName:(NSString *)fontName{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:font],NSForegroundColorAttributeName:color} range:NSMakeRange(range.location + 1, length)];
    return attribute;
}

- (CGFloat)returenLabelHeight:(NSString *)string size:(CGSize)size fontsize:(NSInteger)font isWidth:(BOOL)isWidth{
    
    CGRect rect = [string boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    if (isWidth == YES) {
        return rect.size.width;
    }else {
        return rect.size.height;
    }
}

#pragma lazyLoading

- (UILabel *)rateLabel {
    if (!_rateLabel) {
        _rateLabel = [UILabel createLabelFrame:CGRectMake(0, 23, DMDeviceWidth, 45) labelColor:UIColorFromRGB(0xff6e51) textAlignment:NSTextAlignmentCenter textFont:44.f];
        _rateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:44.f];
    }
    return _rateLabel;
}

- (UILabel *)rateInfoLabel {
    if (!_rateInfoLabel) {
        _rateInfoLabel = [UILabel createLabelFrame:CGRectMake(0, 23 + 45 + 8, DMDeviceWidth, 12) labelColor:UIColorFromRGB(0x7b7b7b) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
        _rateInfoLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:11.f];
        _rateInfoLabel.text = @"年化利率";
    }
    return _rateInfoLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 111, DMDeviceWidth, 1)];
        _lineView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    }
    return _lineView;
}

- (UILabel *)timeLimitLabel {
    if (!_timeLimitLabel) {
        _timeLimitLabel = [UILabel createLabelFrame:CGRectMake(21, 112 + 23, DMDeviceWidth / 2, 14) labelColor:UIColorFromRGB(0x7b7b7b) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        _timeLimitLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11.f];
    }
    return _timeLimitLabel;
}

- (UILabel *)toBuyLabel {
    if (!_toBuyLabel) {
        _toBuyLabel = [UILabel createLabelFrame:CGRectMake(21, 112 + 23 + 14 + 10, DMDeviceWidth / 3 * 2, 12) labelColor:UIColorFromRGB(0x7b7b7b) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        _toBuyLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:11.f];
    }
    return _toBuyLabel;
}

- (UILabel *)earnWayLabel {
    if (!_earnWayLabel) {
        _earnWayLabel = [UILabel createLabelFrame:CGRectMake(21, 112 + 23, DMDeviceWidth / 2, 14) labelColor:UIColorFromRGB(0x7b7b7b) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        _earnWayLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11.f];
    }
    return _earnWayLabel;
}

- (UILabel *)collectLabel {
    if (!_collectLabel) {
        _collectLabel = [UILabel createLabelFrame:CGRectMake(21, 112 + 23 + 14 + 10, DMDeviceWidth / 3 * 2, 12) labelColor:UIColorFromRGB(0x7b7b7b) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        _collectLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:11.f];
    }
    return _collectLabel;
}

- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 194, DMDeviceWidth, 10)];
        _colorView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    }
    return _colorView;
}

- (MenuButton *)menuButton{
    if (!_menuButton) {
        self.menuButton = [[MenuButton alloc] initWithFrame:CGRectMake(0, 204, DMDeviceWidth, 43) TitleArray:@[@"出借详情",@"出借列表",@"本期债权"] SelectColor:UIColorFromRGB(0x00c79f) UnselectColor:UIColorFromRGB(0x878787)];
        _menuButton.delegate = self;
    }
    return _menuButton;
}

- (void)selectButtonWithIndex:(NSInteger)index{
    
    !self.touchAction ? : self.touchAction(index);
}



@end
