//
//  GZSinglePeriodTableViewCell.m
//  豆蔓理财
//
//  Created by armada on 2016/12/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "GZSinglePeriodTableViewCell.h"
#import "DMSingleLoanModel.h"
#import "LJQEarlyReimbursementVC.h"

@interface GZSinglePeriodTableViewCell()

@property(nonatomic,strong) UIButton *payForDebtsInAdvanceBtn;

@property(nonatomic,strong) UIImageView *maskImgView;

@property (nonatomic, strong) UILabel *loanStatusTag;

@end

@implementation GZSinglePeriodTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *reuseIdentifier = @"SinglePeriodCell";
    
    GZSinglePeriodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    [cell.contentView addSubview:cell.loanStatusTag];
    [cell.loanStatusTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.maskImgView).offset(50);
        make.centerY.equalTo(cell.contentView);
        make.height.mas_equalTo(@13);
        make.width.mas_equalTo(@40);
    }];
    
    
    
    return cell;
}

- (UILabel *)orderLabel {
    
    if(!_orderLabel) {
        
//        UIImageView *separatorLineImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割线-筹标"]];
        UIImageView *separatorLineImgView = [[UIImageView alloc] init];
        separatorLineImgView.backgroundColor = MainLine;
        [self.contentView addSubview:separatorLineImgView];
        [separatorLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(@1);
        }];
        
        _orderLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_orderLabel];
        [_orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
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
            make.left.equalTo(self.orderLabel.mas_right).offset(20);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(@30);
            if (iPhone5) {
                make.width.mas_equalTo(@110);
                
            }else if(iPhone6){
                make.width.mas_equalTo(@160);
                
            }else if(iPhone6plus) {
                make.width.mas_equalTo(@200);
                
            }
        }];
        
        [_debtsRightNameLabel setTextAlignment:NSTextAlignmentCenter];
        [_debtsRightNameLabel setTextColor:DarkGray];
        [_debtsRightNameLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:13]];

        
        
        self.payForDebtsInAdvanceBtn.hidden = NO;
    }
    return _debtsRightNameLabel;
}

- (UIButton *)payForDebtsInAdvanceBtn {
    
    if(!_payForDebtsInAdvanceBtn) {
        
        _payForDebtsInAdvanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_payForDebtsInAdvanceBtn];
        [_payForDebtsInAdvanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.debtsRightNameLabel);
            make.left.equalTo(self.debtsRightNameLabel.mas_right).offset(10);
           // make.right.equalTo(self.sumOfDebtsRightLabel.mas_left).offset(-10);
            make.width.mas_equalTo(@60);
            make.height.mas_offset(@20);
        }];
        
        [_payForDebtsInAdvanceBtn setTitle:@"提前还款" forState:UIControlStateNormal];
//        [_payForDebtsInAdvanceBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形-15"] forState:UIControlStateNormal];
//        [_payForDebtsInAdvanceBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形-15"] forState:UIControlStateHighlighted];
        [_payForDebtsInAdvanceBtn setBackgroundColor:mainBack];
        _payForDebtsInAdvanceBtn.layer.borderWidth = 1.0f;
        _payForDebtsInAdvanceBtn.layer.borderColor = MainRed.CGColor;
        _payForDebtsInAdvanceBtn.layer.cornerRadius = 8;
        _payForDebtsInAdvanceBtn.layer.masksToBounds = YES;
        [_payForDebtsInAdvanceBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:10]];
        [_payForDebtsInAdvanceBtn setTitleColor:MainRed forState:UIControlStateNormal];
        [_payForDebtsInAdvanceBtn setTitleColor:MainRed forState:UIControlStateHighlighted];
        [_payForDebtsInAdvanceBtn addTarget:self action:@selector(payForDebtsInAdvanceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payForDebtsInAdvanceBtn;
}

- (UILabel *)sumOfDebtsRightLabel {
    
    if(!_sumOfDebtsRightLabel) {
        _sumOfDebtsRightLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_sumOfDebtsRightLabel];
        [_sumOfDebtsRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.payForDebtsInAdvanceBtn.mas_right).offset(10);
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

- (UIImageView *)maskImgView {
    
    if(!_maskImgView) {
        _maskImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Mask_"]];
//        _maskImgView.alpha = 0.6;
        [self.sumOfDebtsRightLabel addSubview:_maskImgView];
        [_maskImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self.debtsRightNameLabel);
            make.width.equalTo(self.debtsRightNameLabel);
        }];
                _maskImgView.layer.borderWidth = 1.0f;
                _maskImgView.layer.borderColor = MainLine.CGColor;
        _maskImgView.layer.masksToBounds = YES;
        if (iPhone5) {
            _maskImgView.layer.cornerRadius = 8;
            
        }else if(iPhone6){
            _maskImgView.layer.cornerRadius = 10;
            
        }else if(iPhone6plus) {
            _maskImgView.layer.cornerRadius = 12;
            
        }
        
    }
    return _maskImgView;
}

- (UILabel *)loanStatusTag{
    if (!_loanStatusTag) {
        self.loanStatusTag = [[UILabel alloc] init];
        _loanStatusTag.font = [UIFont systemFontOfSize:10];
        _loanStatusTag.textColor = MainRed;
        _loanStatusTag.backgroundColor = mainBack;
        _loanStatusTag.textAlignment = NSTextAlignmentCenter;
        _loanStatusTag.layer.cornerRadius = 6;
        _loanStatusTag.layer.masksToBounds = YES;
        _loanStatusTag.layer.borderColor = MainRed.CGColor;
        _loanStatusTag.layer.borderWidth = 1.0f;
    }
    return _loanStatusTag;
}



#pragma mark - Button Click Action
- (void)payForDebtsInAdvanceBtnClick {
    LJQEarlyReimbursementVC *ervc = [[LJQEarlyReimbursementVC alloc]init];
    [self.delegate.navigationController pushViewController:ervc animated:YES];
}

- (void)setLoanModel:(DMSingleLoanModel *)loanModel{
    _loanModel = loanModel;
    
    self.debtsRightNameLabel.text = loanModel.title;
    self.sumOfDebtsRightLabel.text = loanModel.investAmount;
    
    [self.contentView layoutIfNeeded];
    
//    [self.maskImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.equalTo(self.debtsRightNameLabel);
//        make.width.mas_offset(self.debtsRightNameLabel.frame.size.width*(1-loanModel.ratio.doubleValue));
//    }];
    
    [self.contentView layoutIfNeeded];
    
    if ([loanModel.isAheadSettle isEqualToString:@"1"]) {
        _payForDebtsInAdvanceBtn.hidden = NO;
        [_payForDebtsInAdvanceBtn setTitle:@"提前还款" forState:UIControlStateNormal];
    }else{
        _payForDebtsInAdvanceBtn.hidden = YES;
    }
    
    self.loanStatusTag.text = loanModel.loanStatusName;
}



@end
