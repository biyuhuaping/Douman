//
//  DMPastServiceHeadView.m
//  豆蔓理财
//
//  Created by edz on 2017/7/20.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMPastServiceHeadView.h"
#import "MenuButton.h"
#import "DMRobtEndDetailModel.h"
@interface DMPastServiceHeadView ()<MenuButtonDelegate>

@property (nonatomic, strong)UILabel *productNameLabel;
@property (nonatomic, strong)UILabel *rateLabel;
@property (nonatomic, strong)UILabel *rateStaticLabel;

@property (nonatomic, strong)UILabel *monthLabel;
@property (nonatomic, strong)UILabel *monthStaticLabel;

@property (nonatomic, strong)UILabel *joinNumLabel;
@property (nonatomic, strong)UILabel *joinStaticLabel;

@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UIView *colorView;
@property (nonatomic, strong)UIView *colorOtherView;
@property (nonatomic, strong) MenuButton *menuButton;

@end

@implementation DMPastServiceHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.productNameLabel];
        [self addSubview:self.rateLabel];
        [self addSubview:self.rateStaticLabel];
        [self addSubview:self.monthLabel];
        [self addSubview:self.monthStaticLabel];
        [self addSubview:self.joinNumLabel];
        [self addSubview:self.joinStaticLabel];
      //  [self addSubview:self.lineView];
        [self addSubview:self.colorView];
       // [self addSubview:self.colorOtherView];
        [self addSubview:self.menuButton];
    }return self;
}

- (void)layoutSubviews {
//    self.productNameLabel.text = @"小豆机器人";
//    self.rateLabel.text = @"(7~10)% + 3%";
//    self.monthLabel.text = @"6个月";
//    self.joinNumLabel.text = @"40";
    
}

- (void)setModel:(DMRobtEndDetailModel *)model {
    if (_model != model) {
        _model = model;
    }
    self.productNameLabel.text = [NSString stringWithFormat:@"小豆机器人%@号",isOrEmpty(_model.robotNumber) ? @"--": _model.robotNumber];
    
    self.rateLabel.text = [NSString stringWithFormat:@"(%@~%@)%% + %@%%",isOrEmpty(_model.minRate) ? @"0": _model.minRate,isOrEmpty(_model.maxRate) ? @"0": _model.maxRate,isOrEmpty(_model.disCountRate) ? @"0": _model.disCountRate];
    self.monthLabel.text = [NSString stringWithFormat:@"%@个月",isOrEmpty(_model.robotCycle) ? @"--": _model.robotCycle];
    self.joinNumLabel.text = [NSString stringWithFormat:@"%@",isOrEmpty(_model.subNum) ? @"--": _model.subNum];
}

#pragma lazyLoading
- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [UILabel createLabelFrame:CGRectMake(12, 13, DMDeviceWidth - 24, 13) labelColor:UIColorFromRGB(0x505050) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    }
    return _productNameLabel;
}

- (UILabel *)rateLabel {
    if (!_rateLabel) {
        _rateLabel = [UILabel createLabelFrame:CGRectMake(0, 48, DMDeviceWidth, 26) labelColor:MainRed textAlignment:(NSTextAlignmentCenter) textFont:25.f];
        _rateLabel.font = FONT_Regular(25.f);
    }
    return _rateLabel;
}

- (UILabel *)rateStaticLabel {
    if (!_rateStaticLabel) {
        _rateStaticLabel = [UILabel createLabelFrame:CGRectMake(0, 48 + 26 + 13, DMDeviceWidth, 13) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        _rateStaticLabel.font = FONT_Regular(12.f);
        _rateStaticLabel.text = @"预计年化利率";
    }
    return _rateStaticLabel;
}

- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [UILabel createLabelFrame:CGRectMake(0, 139, DMDeviceWidth / 2, 18) labelColor:UIColorFromRGB(0x505050) textAlignment:(NSTextAlignmentCenter) textFont:17.f];
    }
    return _monthLabel;
}

- (UILabel *)monthStaticLabel {
    if (!_monthStaticLabel) {
        _monthStaticLabel = [UILabel createLabelFrame:CGRectMake(0, 139 + 32, DMDeviceWidth / 2, 13) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        _monthStaticLabel.text = @"服务期限";
    }
    return _monthStaticLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(DMDeviceWidth / 2, 139, 1, 45)];
        _lineView.backgroundColor = UIColorFromRGB(0xf6f5fa);
    }
    return _lineView;
}

- (UILabel *)joinNumLabel {
    if (!_joinNumLabel) {
        _joinNumLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 2 + 1, 139, DMDeviceWidth / 2 - 1, 18) labelColor:UIColorFromRGB(0x505050) textAlignment:(NSTextAlignmentCenter) textFont:17.f];
    }
    return _joinNumLabel;
}

- (UILabel *)joinStaticLabel {
    if (!_joinStaticLabel) {
        _joinStaticLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 2 + 1, 139 + 32, DMDeviceWidth / 2 - 1, 13) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        _joinStaticLabel.text = @"加入人数";
    }
    return _joinStaticLabel;
}

- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 198, DMDeviceWidth, 10)];
        _colorView.backgroundColor = UIColorFromRGB(0xf6f5fa);
    }
    return _colorView;
}

- (UIView *)colorOtherView {
    if (!_colorOtherView) {
        _colorOtherView = [[UIView alloc] initWithFrame:CGRectMake(0, 252, DMDeviceWidth, 10)];
        _colorOtherView.backgroundColor = UIColorFromRGB(0xf6f5fa);
    }
    return _colorOtherView;
}

- (MenuButton *)menuButton{
    if (!_menuButton) {
        self.menuButton = [[MenuButton alloc] initWithFrame:CGRectMake(0, 208, DMDeviceWidth, 44) TitleArray:@[@"服务介绍",@"加入列表"] SelectColor:UIColorFromRGB(0x00c79f) UnselectColor:UIColorFromRGB(0x878787)];
        _menuButton.delegate = self;
    }
    return _menuButton;
}

- (void)selectButtonWithIndex:(NSInteger)index{
    !self.touchBtnEvent ? : self.touchBtnEvent(index);
}


@end
