//
//  DMRobtPastServiceCell.m
//  豆蔓理财
//
//  Created by edz on 2017/7/20.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMRobtPastServiceCell.h"
#import "DMRobtEndListModel.h"

#define textFontfont 14.f
#define colorSpace 6
@interface DMRobtPastServiceCell ()

@property (nonatomic, strong)UILabel *productNameLabel;
@property (nonatomic, strong)UILabel *rateLabel;
@property (nonatomic, strong)UILabel *monthLabel;
@property (nonatomic, strong)UILabel *joinNumLabel;
@property (nonatomic, strong)UILabel *endTimeLabel;
@property (nonatomic, strong)UIView *bottomView;

@property (nonatomic, strong)UIView *colorView;
@end

@implementation DMRobtPastServiceCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.productNameLabel];
        [self.contentView addSubview:self.rateLabel];
        [self.contentView addSubview:self.monthLabel];
        //[self.contentView addSubview:self.joinNumLabel];
        [self.contentView addSubview:self.endTimeLabel];
        [self createUI:@[@"预计年化利率",@"服务期限",@"结束时间"]];
        [self.contentView addSubview:self.colorView];
        
//        for (int i = 1; i < 4; i++) {
//            UILabel *label = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH ) / 4 * i, 64, 1, 49) labelColor:UIColorFromRGB(0xf3f3f3) textAlignment:(NSTextAlignmentCenter) textFont:1.f];
//            label.backgroundColor = UIColorFromRGB(0xf3f3f3);
//            [self.contentView addSubview:label];
//        }
    }
    return self;
}

- (void)createUI:(NSArray *)textArr {
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 47 + 23 + 10 + colorSpace, SCREENWIDTH, 13)];
    self.bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    if (self.bottomView.subviews.count != 0) {
        for (UILabel *label in self.bottomView.subviews) {
            [label removeFromSuperview];
        }
    }
    for (int i = 0; i < textArr.count; i++) {
        UILabel *label = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH ) / textArr.count * i, 0, (SCREENWIDTH) / textArr.count, 12) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
        label.text = textArr[i];
        [self.bottomView addSubview:label];
    }
    [self.contentView addSubview:self.bottomView];
}

- (void)setListModel:(DMRobtEndListModel *)listModel {
    if (_listModel != listModel) {
        _listModel = listModel;
    }
    
    self.productNameLabel.text = [NSString stringWithFormat:@"小豆机器人%@号",isOrEmpty(_listModel.robotNumber) ? @"--": _listModel.robotNumber];
    
    NSString *string = [NSString stringWithFormat:@"(%@~%@)%% + %@%%",isOrEmpty(_listModel.minRate) ? @"0": _listModel.minRate,isOrEmpty(_listModel.maxRate) ? @"0": _listModel.maxRate,isOrEmpty(_listModel.disCountRate) ? @"0": _listModel.disCountRate];
    
    NSRange range1 = [string rangeOfString:@"+"];
    NSMutableAttributedString *attributeString = [self LJQLabelAttributeDic:@{NSFontAttributeName:FONT_Light(10.f)} textRange:range1 text:string length:YES];
    
    NSRange range2 = [string rangeOfString:@"%"];
    [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(10.f)} range:NSMakeRange(range2.location, 1)];
    
    [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(13.f)} range:NSMakeRange(range1.location + 1, 1)];
    
    [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(10.f)} range:NSMakeRange(string.length - 1, 1)];
    self.rateLabel.attributedText = attributeString;
    
    self.monthLabel.text = [NSString stringWithFormat:@"%@个月",isOrEmpty(_listModel.robotCycle) ? @"--": _listModel.robotCycle];
    self.joinNumLabel.text = [NSString stringWithFormat:@"%@",isOrEmpty(_listModel.sunNum) ? @"--": _listModel.sunNum];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@",isOrEmpty(_listModel.endTime) ? @"--" : _listModel.endTime];
}

#pragma lazyLoading 

- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [UILabel createLabelFrame:CGRectMake(12, 10 + colorSpace, DMDeviceWidth, 14) labelColor:UIColorFromRGB(0x505050) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        _productNameLabel.text = @"--";
        _productNameLabel.font = FONT_Light(11.f);
    }
    return _productNameLabel;
}

- (UILabel *)rateLabel {
    if (!_rateLabel) {
        _rateLabel = [UILabel createLabelFrame:CGRectMake(0, 54 + colorSpace, DMDeviceWidth / 3 - 1, 13) labelColor:MainRed textAlignment:(NSTextAlignmentCenter) textFont:textFontfont];
        _rateLabel.font = FONT_Regular(textFontfont);
        _rateLabel.text = @"--";
    }
    return _rateLabel;
}

- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 3, 54 + colorSpace, DMDeviceWidth / 3, 13) labelColor:MainRed textAlignment:(NSTextAlignmentCenter) textFont:textFontfont];
        _rateLabel.font = FONT_Regular(textFontfont);
        _monthLabel.text = @"--";
    }
    return _monthLabel;
}

- (UILabel *)joinNumLabel {
    if (!_joinNumLabel) {
        _joinNumLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 3 * 2, 54 + colorSpace, DMDeviceWidth / 3, 13) labelColor:MainRed textAlignment:(NSTextAlignmentCenter) textFont:textFontfont];
        _joinNumLabel.font = FONT_Regular(textFontfont);
        _joinNumLabel.text = @"--";
    }
    return _joinNumLabel;
}

- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        _endTimeLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 3 * 2, 54 + colorSpace, DMDeviceWidth / 3, 13) labelColor:MainRed textAlignment:(NSTextAlignmentCenter) textFont:textFontfont];
        _endTimeLabel.font = FONT_Regular(textFontfont);
        _endTimeLabel.text = @"--";
    }
    return _endTimeLabel;
}

- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 6)];
        _colorView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    }
    return _colorView;
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
@end
