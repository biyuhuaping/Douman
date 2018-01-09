//
//  DMRobtCollectionCell.m
//  豆蔓理财
//
//  Created by edz on 2017/7/17.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMRobtCollectionCell.h"
#import "DMRobtOpenInfoModel.h"
#define robtScale (DMDeviceWidth - 24) / 368
@interface DMRobtCollectionCell ()

@property (nonatomic, strong)UILabel *rateLabel;
@property (nonatomic, strong)UILabel *monthLabel;
@property (nonatomic, strong)UIImageView *pitcureView;
@property (nonatomic, strong)UILabel *infoLabel;

@end

@implementation DMRobtCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.pitcureView];
        [self.pitcureView addSubview:self.rateLabel];
        [self.pitcureView addSubview:self.monthLabel];
        [self.pitcureView addSubview:self.infoLabel];
    }
    return self;
}

- (void)setInfoModel:(DMRobtOpenInfoModel *)infoModel {
    if (_infoModel != infoModel) {
        _infoModel = infoModel;
    }
    self.rateLabel.text = [NSString stringWithFormat:@"(%@~%@)%% + %@%%",isOrEmpty(_infoModel.minRate) ? @"-": _infoModel.minRate,isOrEmpty(_infoModel.maxRate) ? @"-" : _infoModel.maxRate,isOrEmpty(_infoModel.disCountRate) ? @"-" : _infoModel.disCountRate];
    self.monthLabel.text = [NSString stringWithFormat:@"%@个月",isOrEmpty(_infoModel.robotCycle) ? @"-" :_infoModel.robotCycle];
    
}

#pragma lazyLoading

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [UILabel createLabelFrame:CGRectMake(0, 6, self.frame.size.width, 11) labelColor:UIColorFromRGB(0x9a9a9a) textAlignment:(NSTextAlignmentCenter) textFont:10.f];
        _infoLabel.hidden = YES;
        _infoLabel.text = @"基础利率 服务加息";
    }
    return _infoLabel;
}

- (UILabel *)rateLabel {
    if (!_rateLabel) {
        _rateLabel = [UILabel createLabelFrame:CGRectMake(0, 20 * robtScale, self.frame.size.width, 15) labelColor:UIColorFromRGB(0x787878) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        _rateLabel.text = @"(7~10)% + 3%";
    }
    return _rateLabel;
}

- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [UILabel createLabelFrame:CGRectMake(0, 60 * robtScale, self.frame.size.width, 15) labelColor:UIColorFromRGB(0x787878) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
        _monthLabel.text = @"6个月";
    }
    return _monthLabel;
}

- (UIImageView *)pitcureView {
    UIImage *image = [UIImage imageNamed:@"产品选中底色"];
    if (!_pitcureView) {
        _pitcureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, (self.frame.size.width - 20) * image.size.height / image.size.width * robtScale)];
    }
    return _pitcureView;
}

- (void)setIsSelected:(BOOL)isSelected {
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
    }
    
    if (_isSelected) {
        [self.infoLabel setHidden:NO];
        [self.pitcureView setImage:[UIImage imageNamed:@"产品选中底色"]];
        [self.rateLabel setTextColor:MainRed];
        [self.monthLabel setTextColor:MainRed];
    }else {
        [self.infoLabel setHidden:YES];
        [self.pitcureView setImage:[UIImage new]];
        [self.rateLabel setTextColor:UIColorFromRGB(0x787878)];
        [self.monthLabel setTextColor:UIColorFromRGB(0x787878)];
    }
}

@end
