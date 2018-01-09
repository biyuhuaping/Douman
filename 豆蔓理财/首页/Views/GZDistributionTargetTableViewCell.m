//
//  GZDistributionTargetCell.m
//  豆蔓理财
//
//  Created by armada on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "GZDistributionTargetTableViewCell.h"

@interface GZDistributionTargetTableViewCell()

{
    UIImageView *maskImgView;
}

@end

@implementation GZDistributionTargetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *reuseIdentifier = @"DistributionTargetCell";
    
    GZDistributionTargetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    [cell maskFadeAnimation];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - lazy loading
- (UILabel *)orderLabel {
    
    if(!_orderLabel) {
        
        UIImageView *separatorLineImgView = [[UIImageView alloc]init];
        separatorLineImgView.backgroundColor = MainLine;
        [self.contentView addSubview:separatorLineImgView];
        [separatorLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(@1);
        }];
        
        _orderLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_orderLabel];
        [_orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@20);
        }];
        [_orderLabel setTextAlignment:NSTextAlignmentCenter];
        [_orderLabel setTextColor:DarkGray];
        [_orderLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:12]];
    }
    return _orderLabel;
}

- (UILabel *)debtsRightNameLabel {
    
    if(!_debtsRightNameLabel) {
        
        _debtsRightNameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_debtsRightNameLabel];
        [_debtsRightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderLabel.mas_right).offset(30);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(@25);
            if(iPhone5) {
                make.width.mas_equalTo(@160);
            }else if(iPhone6) {
                make.width.mas_equalTo(@200);
            }else {
                make.width.mas_equalTo(@240);
            }
            //make.right.equalTo(self.sumOfDebtsRightLabel.mas_left).offset(-15);
        }];
        
        [_debtsRightNameLabel setTextAlignment:NSTextAlignmentCenter];
        [_debtsRightNameLabel setTextColor:DarkGray];
        [_debtsRightNameLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:13]];
        _debtsRightNameLabel.layer.borderWidth = 1.0f;
        _debtsRightNameLabel.layer.borderColor = MainLine.CGColor;
        
        maskImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Mask_"]];
        maskImgView.alpha = 0.6;
        //[self.contentView addSubview:maskImgView];
        [self.contentView addSubview:maskImgView];
        [maskImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_debtsRightNameLabel);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(@25);
            if(iPhone5) {
                make.width.mas_equalTo(@160);
            }else if(iPhone6) {
                make.width.mas_equalTo(@200);
            }else {
                make.width.mas_equalTo(@240);
            }
            
        }];
    }
    return _debtsRightNameLabel;
}

- (UILabel *)sumOfDebtsRightLabel {
    
    if(!_sumOfDebtsRightLabel) {
        _sumOfDebtsRightLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_sumOfDebtsRightLabel];
        [_sumOfDebtsRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-30);
            make.width.mas_equalTo(@50);
            make.height.mas_equalTo(@20);
        }];
        
        [_sumOfDebtsRightLabel setTextAlignment:NSTextAlignmentLeft];
        [_sumOfDebtsRightLabel setTextColor:DarkGray];
        [_sumOfDebtsRightLabel setFont:[UIFont systemFontOfSize:12]];
        
        UIImageView *rightArrowImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_arrow_icon"]];
        [self.contentView addSubview:rightArrowImgView];
        [rightArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
            make.width.mas_equalTo(@15);
            make.height.mas_equalTo(@15);
        }];
    }
    return _sumOfDebtsRightLabel;
}

- (void)setCellWithModel:(GZDistributionLoanListModel *)model {
    
    self.debtsRightNameLabel.text = model.title;
    self.sumOfDebtsRightLabel.text = [NSString stringWithFormat:@"¥ %@",model.amount.stringValue];
}

- (void)setOrderLabelWithNum:(NSString *)orderNum {
    
    self.orderLabel.text = orderNum;
}

#pragma mark - Mask Animation

- (void)maskFadeAnimation {
    
    [maskImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        if(iPhone5) {
            make.width.mas_equalTo(@160);
        }else if(iPhone6) {
            make.width.mas_equalTo(@200);
        }else {
            make.width.mas_equalTo(@240);
        }
    }];
    
    [maskImgView.superview layoutIfNeeded];
    
    [maskImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@0);
    }];
    
    [UIView animateWithDuration:3.0f animations:^{
        [maskImgView.superview layoutIfNeeded];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
