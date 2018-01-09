//
//  DMHoldTableCell.m
//  zaiquan
//
//  Created by wujianqiang on 2016/12/6.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMHoldTableCell.h"
#import "DMCreditAssetListModel.h"

@implementation DMHoldTableCell

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
        [self.contentView addSubview:self.periodLabel];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.assetLabel];
        [self.contentView addSubview:self.creditLabel];
        [self.contentView addSubview:self.detailImage];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.slider];
        [self.contentView addSubview:self.progressLabel];

        int padding = 5;
        if (iPhone5) {
            [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@10);
                make.left.equalTo(@5);
                make.height.equalTo(@20);
            }];
            [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@10);
                make.left.equalTo(self.periodLabel.mas_right).offset(padding);
                make.width.equalTo(@80);
                make.height.equalTo(@20);
            }];
            [self.assetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@10);
                make.left.equalTo(self.typeLabel.mas_right).offset(padding);
                make.height.equalTo(@20);
            }];
            [self.creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@10);
                make.left.equalTo(self.assetLabel.mas_right).offset(padding);
                make.height.equalTo(@20);
            }];
        }
        
        

    }
    return self;
}

- (UILabel *)periodLabel{
    if (_periodLabel == nil) {
        self.periodLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, DMDeviceWidth/4, 20)];
        _periodLabel.text = @"第0期";
        _periodLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _periodLabel.textColor = LightGray;
        _periodLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _periodLabel;
}

- (UILabel *)typeLabel{
    if (_typeLabel == nil) {
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.periodLabel.frame)+10, 10, 80, 20)];
        _typeLabel.text = @"";
        _typeLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel.textColor = MainRed;
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.layer.cornerRadius = 10;
        _typeLabel.layer.masksToBounds = YES;
        _typeLabel.layer.borderColor = MainRed.CGColor;
        _typeLabel.layer.borderWidth = 1;
        _typeLabel.backgroundColor = mainBack;
    }
    return _typeLabel;
}

- (UILabel *)assetLabel{
    if (_assetLabel == nil) {
        self.assetLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.typeLabel.frame)+10, 10, DMDeviceWidth/4, 20)];
        _assetLabel.text = @"";
        _assetLabel.font = [UIFont systemFontOfSize:12];
        _assetLabel.textColor = LightGray;
        _assetLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _assetLabel;
}

- (UILabel *)creditLabel{
    if (_creditLabel == nil) {
        self.creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth-20-DMDeviceWidth/4, 10, DMDeviceWidth/4, 20)];
        _creditLabel.text = @"债权34个";
        _creditLabel.font = [UIFont systemFontOfSize:12];
        _creditLabel.textColor = LightGray;
        _creditLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _creditLabel;
}

- (UIImageView *)detailImage{
    if (_detailImage == nil) {
        self.detailImage = [[UIImageView alloc] initWithFrame:CGRectMake(DMDeviceWidth-25, 12, 15, 15)];
        _detailImage.image = [UIImage imageNamed:@"right_arrow_icon"];
    }
    return _detailImage;
}

- (UILabel *)detailLabel{
    if (_detailLabel == nil) {
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 125, 20)];
        _detailLabel.text = @"满标生成合同后开始计息";
        _detailLabel.font = [UIFont systemFontOfSize:11];
        _detailLabel.textColor = LightGray;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}

- (UISlider *)slider{
    if (_slider == nil) {
        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(135, 50, DMDeviceWidth - 200, 20)];
        UIImage *thumbImage = [UIImage imageNamed:@"进度条圆"];
        [_slider setThumbImage:thumbImage forState:UIControlStateNormal];
        UIImage *leftImage = [UIImage imageNamed:@"进度条"];
        UIImage *rightImage = [UIImage imageNamed:@"进度条灰色"];
        [_slider setMinimumTrackImage:leftImage forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:rightImage forState:UIControlStateNormal];
        _slider.value = 0.5;
        _slider.userInteractionEnabled = NO;
    }
    return _slider;
}

- (UILabel *)progressLabel{
    if (_progressLabel == nil) {
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth-65, 50, 50, 20)];
        _progressLabel.text = @"50%";
        _progressLabel.font = [UIFont systemFontOfSize:12];
        _progressLabel.textColor = LightGray;
        _progressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _progressLabel;
}

- (void)setListModel:(DMCreditAssetListModel *)listModel{
    _listModel = listModel;
    
    _periodLabel.text = [NSString stringWithFormat:@"第%@期",listModel.periods];
    _typeLabel.text = listModel.guarantyStyle;
    _assetLabel.text = listModel.sourceOfAssets;
    _creditLabel.text = [NSString stringWithFormat:@"债权%@个",listModel.loanNum];
    
    if (listModel.isAssetFinished) {
        self.detailLabel.hidden = YES;
        self.slider.hidden = YES;
        self.progressLabel.hidden = YES;
        self.detailImage.hidden = NO;
        self.backgroundColor = mainBack;
    }else{
        self.backgroundColor = mainBack;
        self.detailImage.hidden = YES;
        self.detailLabel.hidden = NO;
        self.slider.hidden = NO;
        self.progressLabel.hidden = NO;
        self.slider.value = [listModel.purchaseRatio floatValue]/100.f;
        self.progressLabel.text = [NSString stringWithFormat:@"%@%%",listModel.purchaseRatio];
        
    }
}


@end
