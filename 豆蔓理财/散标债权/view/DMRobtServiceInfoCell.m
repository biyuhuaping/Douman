//
//  DMRobtServiceInfoCell.m
//  豆蔓理财
//
//  Created by edz on 2017/7/17.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMRobtServiceInfoCell.h"
#import "DMRobtOpeningModel.h"
@interface DMRobtServiceInfoCell ()

@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UILabel *messageLabel;
@property (nonatomic, strong)UILabel *twoMessageLabel;
@property (nonatomic, strong)UILabel *threeMessageLabel;
@property (nonatomic, strong)NSArray<NSString *> *textArr;

@property (nonatomic, strong)UIView *line1;
@property (nonatomic, strong)UIView *line2;
@property (nonatomic, strong)UIView *colorView;
@property (nonatomic, strong)UIButton *serviceButton;
@end

@implementation DMRobtServiceInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self.contentView addSubview:self.bottomView];
        [self.bottomView addSubview:self.messageLabel];
        [self.bottomView addSubview:self.twoMessageLabel];
        [self.bottomView addSubview:self.threeMessageLabel];
        [self.bottomView addSubview:self.line1];
        [self.bottomView addSubview:self.line2];
        [self.bottomView addSubview:self.colorView];
        [self.bottomView addSubview:self.serviceButton];
    }
    return self;
}

- (void)setOpenModel:(DMRobtOpeningModel *)openModel {
    if (_openModel != openModel) {
        _openModel = openModel;
    }
    
    if (_openModel.isServiceFeeFree == YES) {
        NSString *string = [NSString stringWithFormat:@"服务周期：%@个月\n投资类型：%@\n计息时间：加入服务，成功匹配债权满标后开始计息\n加入条件：%@元起投，且为%@整数倍的金额\n服务费用：活动期间，暂免服务费\n*活动结束后，平台服务费恢复至总收益的10%%",_openModel.robotCycle,_openModel.guarantyStyleName,_openModel.minPurchaseAmount,_openModel.minPurchaseAmount];
        self.threeMessageLabel.attributedText = [self returnAttributeWithString:string color:MainRed arrString:@[@"*"] length:@[@"22"] paragraphSpacing:5 space:0];
    }else {
        NSString *string = [NSString stringWithFormat:@"服务周期：%@个月\n投资类型：%@\n计息时间：加入服务，成功匹配债权满标后开始计息\n加入条件：%@元起投，且为%@整数倍的金额\n服务费用：小豆机器人服务获取收益的%@%%\n*活动结束后，平台服务费恢复至总收益的10%%",_openModel.robotCycle,_openModel.guarantyStyleName,_openModel.minPurchaseAmount,_openModel.minPurchaseAmount,_openModel.serviceFee];
        NSRange range = [string rangeOfString:@"益"];
        NSInteger length = [string length] - range.location - 2;
        self.threeMessageLabel.attributedText = [self returnAttributeWithString:string color:MainRed arrString:@[@"益",@"*"] length:@[@(length),@"0"] paragraphSpacing:5 space:2];
    }
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DMDeviceWidth - 40, self.frame.size.width)];
        _bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _bottomView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        CGFloat height1 = [self returenLabelHeight:self.textArr[0] size:CGSizeMake(DMDeviceWidth - 80, 300) fontsize:12.f isWidth:NO];
        _messageLabel = [UILabel createLabelFrame:CGRectMake(20, 20, DMDeviceWidth - 80, height1) labelColor:UIColorFromRGB(0x505050) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = UIColorFromRGB(0xf3f3f3);
    }
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [UIView new];
        _line2.backgroundColor = UIColorFromRGB(0xf3f3f3);
    }
    return _line2;
}

- (UILabel *)twoMessageLabel {
    if (!_twoMessageLabel) {
        _twoMessageLabel = [UILabel createLabelFrame:CGRectMake(20, 20, DMDeviceWidth - 80, 20) labelColor:UIColorFromRGB(0x505050) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
        _twoMessageLabel.numberOfLines = 0;
    }
    return _twoMessageLabel;
}

- (UILabel *)threeMessageLabel {
    if (!_threeMessageLabel) {
        _threeMessageLabel = [UILabel createLabelFrame:CGRectMake(20, 20, DMDeviceWidth - 80, 20) labelColor:UIColorFromRGB(0x505050) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
        _threeMessageLabel.numberOfLines = 0;
        _threeMessageLabel.attributedText = [self returnAttributeWithString:@"投资类型：质押快投" color:UIColorFromRGB(0x505050) arrString:@[] length:@[] paragraphSpacing:0 space:0];
    }
    return _threeMessageLabel;
}

- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, [self returnRowHeight] - 40, DMDeviceWidth - 40, 1)];
        _colorView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    }
    return _colorView;
}

- (UIButton *)serviceButton {
    if (!_serviceButton) {
        
        _serviceButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_serviceButton setFrame:CGRectMake(0, [self returnRowHeight] - 39, DMDeviceWidth - 40, 30)];
        _serviceButton.userInteractionEnabled = YES;
        [_serviceButton addTarget:self action:@selector(LookService) forControlEvents:(UIControlEventTouchUpInside)];
        UILabel *label = [UILabel createLabelFrame:CGRectMake(20, (39-14)/2, 200, 14) labelColor:UIColorFromRGB(0x505050) textAlignment:(NSTextAlignmentLeft) textFont:14.f];
        label.text = @"查看服务协议";
        UIImageView *pitcure = [[UIImageView alloc] initWithFrame:CGRectMake((DMDeviceWidth - 40) - 20 - 18, (39-18)/2, 9, 18)];
        pitcure.image = [UIImage imageNamed:@"箭头右"];
        [_serviceButton addSubview:pitcure];
        [_serviceButton addSubview:label];
        
    }
    return _serviceButton;
}
//查看服务协议
- (void)LookService {
    if (self.ContactAction) {
        self.ContactAction();
    }
}

- (void)layoutSubviews {
    CGFloat height1 = [self returenLabelHeight:self.textArr[0] size:CGSizeMake(DMDeviceWidth - 80, 300) fontsize:12.f isWidth:NO];
    [self.messageLabel setFrame:CGRectMake(20, 20, DMDeviceWidth - 80, height1)];
    self.messageLabel.attributedText = [self returnAttributeWithString:self.textArr[0] color:UIColorFromRGB(0x505050) arrString:@[] length:@[] paragraphSpacing:0 space:0];
    [self.line1 setFrame:CGRectMake(0, height1 + 40, DMDeviceWidth - 40, 1)];
    
    CGFloat height2 = [self returenLabelHeight:self.textArr[1] size:CGSizeMake(DMDeviceWidth - 80, 300) fontsize:12.f isWidth:NO];
    [self.twoMessageLabel setFrame:CGRectMake(20, height1 + 60, DMDeviceWidth - 80, height2)];
    self.twoMessageLabel.attributedText = [self returnAttributeWithString:self.textArr[1] color:UIColorFromRGB(0x505050) arrString:@[] length:@[] paragraphSpacing:20 space:0];
    [self.line2 setFrame:CGRectMake(0, height1 + 40 + height2 + 40, DMDeviceWidth - 40, 1)];
    
     CGFloat height3 = [self returenLabelHeight:self.textArr[2] size:CGSizeMake(DMDeviceWidth - 80, 300) fontsize:12.f isWidth:NO];
    
    [self.threeMessageLabel setFrame:CGRectMake(20, height1 + 40 + height2 + 40, DMDeviceWidth - 80, height3)];
    if (isOrEmpty(self.openModel.guarantyStyle)) {
        self.threeMessageLabel.attributedText = [self returnAttributeWithString:self.textArr[2] color:MainRed arrString:@[@"*"] length:@[@"22"] paragraphSpacing:5 space:0];
    }
    [self.bottomView setFrame:CGRectMake(20, 0, DMDeviceWidth - 40, height1 + height2 + height3 + 120 + 15)];
}


- (NSMutableAttributedString *)returnAttributeWithString:(NSString *)string color:(UIColor *)color arrString:(NSArray<NSString *>*)arrStr length:(NSArray *)lengthArr paragraphSpacing:(CGFloat)paragraphSpacing space:(NSInteger)space{
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 5;
    paragraph.paragraphSpacingBefore = paragraphSpacing;
    [attribute addAttributes:@{NSParagraphStyleAttributeName:paragraph} range:NSMakeRange(0, string.length - 1)];
    for (int i = 0; i < arrStr.count; i++) {
        NSRange range = [string rangeOfString:arrStr[i]];
        [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f],NSForegroundColorAttributeName:color} range:NSMakeRange(range.location + space, [lengthArr[i] integerValue])];
    }
    
    return attribute;
}

- (CGFloat)returenLabelHeight:(NSString *)string size:(CGSize)size fontsize:(NSInteger)font isWidth:(BOOL)isWidth{

    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 5;
    paragraph.paragraphSpacingBefore = 10.f;
    paragraph.paragraphSpacing = 10.f;
    paragraph.hyphenationFactor = 1;
    CGRect rect = [string boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paragraph} context:nil];
    if (isWidth == YES) {
        return rect.size.width;
    }else {
        return rect.size.height;
    }
}

- (NSArray<NSString *> *)textArr {
    if (!_textArr) {
        _textArr = [@[@"「小豆机器人」是豆蔓智投研发的第一代智能财富配置工具，它能够根据您要求的期限自动安排资金投向，从而博取规定期限内的收益最大化",@"服务说明：每人每期服务只能加入一次；加入后等待超过3个工作日仍未成功出借，则自动退还本金。\n 回款方式：本金复投，收益提取至账户；根据持有债权结清时间而定，借款人还款后收回全部本息至账户余额",@"投资类型：质押快投\n计息时间：加入服务，成功匹配债权满标后开始计息\n加入条件：100元起投，且为100整数倍的金额\n服务费用：活动期间，暂免服务费\n*活动结束后，平台服务费恢复至总收益的10%"] copy];
    }
    return _textArr;
}

- (CGFloat)returnRowHeight {
    CGFloat height1 = [self returenLabelHeight:self.textArr[0] size:CGSizeMake(DMDeviceWidth - 80, 300) fontsize:12.f isWidth:NO] + 40;
    CGFloat height2 = [self returenLabelHeight:self.textArr[1] size:CGSizeMake(DMDeviceWidth - 80, 300) fontsize:12.f isWidth:NO] + 40;
     CGFloat height3 = [self returenLabelHeight:self.textArr[2] size:CGSizeMake(DMDeviceWidth - 80, 300) fontsize:12.f isWidth:NO] + 40;
    return height1 + height2 + height3 + 15;
}

@end
