//
//  GZBenefitDetailTableViewCell.m
//  豆蔓理财
//
//  Created by armada on 2017/2/16.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "GZBenefitDetailTableViewCell.h"

@implementation GZBenefitDetailTableViewCell

#pragma mark - initilizer

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"benefitDetailCell";
    
    GZBenefitDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil) {
        cell = [[GZBenefitDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *separatorLineImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割线-1"]];
        [self.contentView addSubview:separatorLineImgView];
        [separatorLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(@1);
        }];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - lazy loading

- (UILabel *)monthLabel {
    
    if (!_monthLabel) {
        
        _monthLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_monthLabel];
        [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            //make.centerX.equalTo(self.contentView).offset(-DMDeviceWidth/5*1.5);
            make.centerX.equalTo(self.contentView).offset(-(DMDeviceWidth/2-kCenterXtoMarginPadding));
            make.height.mas_equalTo(@15);
        }];
        [_monthLabel setTextAlignment:NSTextAlignmentCenter];
        [_monthLabel setFont:[UIFont systemFontOfSize:15]];
        [_monthLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
    }
    return _monthLabel;
}

- (UILabel *)residualPrincipalLabel {
    
    if (!_residualPrincipalLabel) {
        
        _residualPrincipalLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_residualPrincipalLabel];
        [_residualPrincipalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            //make.centerX.equalTo(self.contentView).offset(-DMDeviceWidth/5*0.5);
            make.centerX.equalTo(self.contentView).offset(-(DMDeviceWidth-2*kCenterXtoMarginPadding)/3*0.5);
            make.height.mas_equalTo(@15);
        }];
        [_residualPrincipalLabel setTextAlignment:NSTextAlignmentCenter];
        [_residualPrincipalLabel setFont:[UIFont systemFontOfSize:15]];
        [_residualPrincipalLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
    }
    return _residualPrincipalLabel;
}

- (UILabel *)residualBenefitLabel {
    
    if (!_residualBenefitLabel) {
        
        _residualBenefitLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_residualBenefitLabel];
        [_residualBenefitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            //make.centerX.equalTo(self.contentView).offset(DMDeviceWidth/5*0.5);
            make.centerX.equalTo(self.contentView).offset((DMDeviceWidth-2*kCenterXtoMarginPadding)/3*0.5);
            make.height.mas_equalTo(@15);
        }];
        [_residualBenefitLabel setTextAlignment:NSTextAlignmentCenter];
        [_residualBenefitLabel setFont:[UIFont systemFontOfSize:15]];
        [_residualBenefitLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
    }
    return _residualBenefitLabel;
}

- (UILabel *)residualWithdrawLabel {
    
    if(!_residualWithdrawLabel) {
        
        _residualWithdrawLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_residualWithdrawLabel];
        [_residualWithdrawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            //make.centerX.equalTo(self.contentView).offset(DMDeviceWidth/5*1.5);
            make.centerX.equalTo(self.contentView).offset(DMDeviceWidth/2-kCenterXtoMarginPadding);
            make.height.mas_equalTo(@15);
        }];
        [_residualWithdrawLabel setTextAlignment:NSTextAlignmentCenter];
        [_residualWithdrawLabel setFont:[UIFont systemFontOfSize:15]];
        [_residualWithdrawLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
        
    }
    return _residualWithdrawLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
