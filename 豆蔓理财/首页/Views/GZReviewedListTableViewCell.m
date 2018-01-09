//
//  GZReviewedListTableViewCell.m
//  豆蔓理财
//
//  Created by armada on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "GZReviewedListTableViewCell.h"

#import "GZPurchaseProgressView.h"

@interface GZReviewedListTableViewCell()

{
    UIImageView *leftSeparatorLineImgView;
    UIImageView *rightSeparatorLineImgView;
}

/** 产品周期 */
@property(nonatomic,strong) UILabel *termLabel;
/** 产品类型 */
@property(nonatomic,strong) UILabel *termTypeLabel;
/** 年化利率 */
@property(nonatomic,strong) UILabel *profitRateLabel;
/** 借款期限 */
@property(nonatomic,strong) UILabel *periodOfTermLabel;
/** 开放额度 */
@property(nonatomic,strong) UILabel *limitedLabel;
/** 标示新产品 */
@property(nonatomic,strong) UIImageView *markNewImgView;
/** 进度条 */
@property(nonatomic,strong) GZPurchaseProgressView *progressView;
/** 百分比 */
@property(nonatomic,strong) UILabel *percentLabel;

@end

@implementation GZReviewedListTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifier = @"reviewedCell";
    
    GZReviewedListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil) {
        cell = [[GZReviewedListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
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

//产品周期
- (UILabel *)termLabel {

    if(!_termLabel) {
        _termLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_termLabel];
        [self.termLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(10);
            make.height.mas_equalTo(@20);
        }];
        [_termLabel setFont:[UIFont systemFontOfSize:11]];
        [_termLabel setTextAlignment:NSTextAlignmentRight];
        [_termLabel setTextColor:UIColorFromRGB(0x4b6ca7)];

    }
    return _termLabel;
}

//产品类型
- (UILabel *)termTypeLabel {
    
    if(!_termTypeLabel) {
        _termTypeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_termTypeLabel];
        [_termTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.termLabel.mas_right).offset(1);
            make.height.mas_equalTo(@20);
        }];
        [_termTypeLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:12]];
        [_termTypeLabel setTextColor:UIColorFromRGB(0x50f1bf)];
        
//        //收益中
//        UIImageView *borderImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"圆角矩形-15"]];
//        [self.contentView addSubview:borderImgView];
//        [borderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.contentView).offset(-20);
//            make.centerY.equalTo(self.termTypeLabel);
//            make.width.mas_equalTo(@70);
//            make.height.mas_equalTo(@25);
//        }];
//        
//        UILabel *benefitingLabel = [[UILabel alloc]init];
//        [self.contentView addSubview:benefitingLabel];
//        [benefitingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(borderImgView).insets(UIEdgeInsetsZero);
//        }];
//        [benefitingLabel setTextAlignment:NSTextAlignmentCenter];
//        [benefitingLabel setTextColor:UIColorFromRGB(0x50f1bf)];
//        [benefitingLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:12]];
//        [benefitingLabel setText:@"收益中"];
        
        [self setMarkNewImgViewHidden:NO];
    }
    return _termTypeLabel;
}

//"新"
- (UIImageView *)markNewImgView {
    
    if(!_markNewImgView) {
        _markNewImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新"]];
        [self.contentView addSubview:_markNewImgView];
        [_markNewImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.termTypeLabel);
            make.left.equalTo(self.termTypeLabel.mas_right).offset(4);
            make.width.mas_equalTo(@22);
            make.height.mas_equalTo(@22);
        }];
    }
    return _markNewImgView;
}

//左分割竖线
- (UIImageView *)leftSeparatorLineImgView {
    
    if(!leftSeparatorLineImgView) {
        leftSeparatorLineImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割线-竖线"]];
        [self.contentView addSubview:leftSeparatorLineImgView];
        [leftSeparatorLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.termTypeLabel.mas_bottom).offset(20);
            make.left.equalTo(self.contentView).offset(DMDeviceWidth/3);
            make.width.mas_equalTo(@1);
            make.height.mas_equalTo(@40);
        }];
    }
    return leftSeparatorLineImgView;
}

//右分割竖线
- (UIImageView *)rightSeparatorLineImgView {
    
    if(!rightSeparatorLineImgView) {
        rightSeparatorLineImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割线-竖线"]];
        [self.contentView addSubview:rightSeparatorLineImgView];
        [rightSeparatorLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.termTypeLabel.mas_bottom).offset(20);
            make.right.equalTo(self.contentView).offset(-DMDeviceWidth/3);
            make.width.mas_equalTo(@1);
            make.height.mas_equalTo(@40);
        }];
    }
    return rightSeparatorLineImgView;
}

//年化利率
- (UILabel *)profitRateLabel {
    
    if(!_profitRateLabel) {
        
        _profitRateLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_profitRateLabel];
        [_profitRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.termTypeLabel.mas_bottom).offset(15);
            make.centerX.equalTo(self.leftSeparatorLineImgView).offset(-self.contentView.bounds.size.width/6);
            make.height.mas_equalTo(@25);
        }];
        [_profitRateLabel setTextAlignment:NSTextAlignmentCenter];
        
        UILabel* profitRateTitleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:profitRateTitleLabel];
        [profitRateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_profitRateLabel.mas_bottom).offset(12);
            make.centerX.equalTo(_profitRateLabel);
            make.height.mas_equalTo(@15);
        }];
        [profitRateTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [profitRateTitleLabel setFont:[UIFont systemFontOfSize:12]];
        [profitRateTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
        [profitRateTitleLabel setText:@"年化利率"];
 
    }
    return _profitRateLabel;
}

//借款期限
- (UILabel *)periodOfTermLabel {
    
    if(!_periodOfTermLabel) {
        _periodOfTermLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_periodOfTermLabel];
        [_periodOfTermLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.termTypeLabel.mas_bottom).offset(15);
            make.centerX.equalTo(self.contentView);
            make.height.mas_equalTo(@25);
        }];
        [_periodOfTermLabel setTextAlignment:NSTextAlignmentCenter];
        
        UILabel *periodOfTermTitleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:periodOfTermTitleLabel];
        [periodOfTermTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_periodOfTermLabel.mas_bottom).offset(12);
            make.centerX.equalTo(_periodOfTermLabel);
            make.height.mas_equalTo(@15);
        }];
        [periodOfTermTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [periodOfTermTitleLabel setFont:[UIFont systemFontOfSize:12]];
        [periodOfTermTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
        [periodOfTermTitleLabel setText:@"借款期限"];
    }
    return _periodOfTermLabel;
}

//开放额度
- (UILabel *)limitedLabel {
    
    if(!_limitedLabel) {
        
        _limitedLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_limitedLabel];
        [_limitedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.periodOfTermLabel);
            make.centerX.equalTo(self.rightSeparatorLineImgView).offset(self.contentView.bounds.size.width/6);
            make.height.mas_equalTo(15);
        }];
        [_limitedLabel setTextAlignment:NSTextAlignmentCenter];
        [_limitedLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:15]];
        [_limitedLabel setTextColor:UIColorFromRGB(0x86a7e8)];
        
        UILabel *limitedTitleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:limitedTitleLabel];
        [limitedTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.periodOfTermLabel.mas_bottom).offset(12);
            make.centerX.equalTo(_limitedLabel);
            make.height.mas_equalTo(@15);
        }];
        [limitedTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [limitedTitleLabel setFont:[UIFont systemFontOfSize:12]];
        [limitedTitleLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
        [limitedTitleLabel setText:@"开放额度(元)"];
        
        //向右箭头
        UIImageView *rightArrowImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"向右箭头"]];
        [self.contentView addSubview:rightArrowImgView];
        [rightArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(limitedTitleLabel);
            make.left.equalTo(limitedTitleLabel.mas_right).offset(18);
            make.width.mas_equalTo(@7);
            make.height.mas_equalTo(@12);
        }];

    }
    return _limitedLabel;
}

//进度条
- (GZPurchaseProgressView *)progressView {
    
    if(!_progressView) {
        
        _progressView = [[GZPurchaseProgressView alloc]initWithFrame:CGRectMake(0, 0, DMDeviceWidth-60, 3)];
        [self.contentView addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-20);
            make.left.equalTo(self.contentView).offset(15);
            make.width.mas_equalTo(DMDeviceWidth-60);
        }];
        
        _percentLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_percentLabel];
        [_percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(_progressView);
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@30);
        }];
        [_percentLabel setTextAlignment:NSTextAlignmentCenter];
        [_percentLabel setFont:[UIFont systemFontOfSize:9]];
        [_percentLabel setTextColor:UIColorFromRGB(0x4b6ca7)];
        [_percentLabel setText:@"100%"];
        
        UIImageView *dashLineImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分割虚线"]];
        [self.contentView addSubview:dashLineImgView];
        [dashLineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-1);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.mas_equalTo(1);
        }];
    }
    return _progressView;
}

#pragma mark - setting

- (void)setProgress:(double)progress {
    
    self.progressView.progress = progress;
}

- (void)setMarkNewImgViewHidden:(BOOL)hidden{
    
    if(!hidden) {
        self.markNewImgView.hidden = false;
    }else {
        [self.markNewImgView removeFromSuperview];
        self.markNewImgView = nil;
    }
}

- (void)setCellWithReviewedListModel:(GZProductListModel *)model {
    
    self.termLabel.text = [NSString stringWithFormat:@"第%@期",model.assetPeriodNum];
    if([model.assetRepaymentMethod isEqualToString:@"EqualInstallment"]) {
         self.termTypeLabel.text = @"·等额本息";
    }else if([model.assetRepaymentMethod isEqualToString:@"MonthlyInterest"]) {
         self.termTypeLabel.text = @"·按月付息";
    }else {
         self.termTypeLabel.text = @"";
    }
    self.profitRateLabel.attributedText = [self getAttributedStringWith:model.assetRate.stringValue andString:@"%"];
    self.periodOfTermLabel.attributedText = [self getAttributedStringWith:model.assetDuration.stringValue andString:@"个月"];
    self.limitedLabel.text = [self getFormattedAmountOfNumberWithString:model.assetTotalAmount];
    self.progressView.progress = model.assetSoldPercent.doubleValue/100;
    self.percentLabel.text = [NSString stringWithFormat:@"%@%%",model.assetSoldPercent];
}

#pragma mark - Helper Functions

- (NSMutableAttributedString *)getAttributedStringWith:(NSString *)str1 andString:(NSString *)str2{
    
    NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc]initWithString:str1 attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:25],NSForegroundColorAttributeName:UIColorFromRGB(0x86a7e8)}];
    
    NSAttributedString *percentSymbol = [[NSAttributedString alloc]initWithString:str2 attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:15],NSForegroundColorAttributeName:UIColorFromRGB(0x86a7e8)}];
    
    [mutableAttributedStr appendAttributedString:percentSymbol];
    
    return mutableAttributedStr;
}

//格式化金额数目
- (NSString *)getFormattedAmountOfNumberWithString:(NSString *)str {
    
    NSString *strWithTwoDecimals = [NSString stringWithFormat:@"%.2f",str.doubleValue];
    
    NSArray *separatedStrs = [strWithTwoDecimals componentsSeparatedByString:@"."];
    
    NSMutableString *mutableStr = [NSMutableString stringWithCapacity:20];
    
    for(int i=1;i<=[separatedStrs[0] length];i++) {
        
        [mutableStr insertString:[separatedStrs[0] substringWithRange:NSMakeRange([separatedStrs[0] length]-i, 1)] atIndex:0];
        
        if(i%3==0 && i != [separatedStrs[0] length]) {
            [mutableStr insertString:@"," atIndex:0];
        }
    }
    
    [mutableStr appendString:@"."];
    [mutableStr appendString:separatedStrs[1]];
    
    return mutableStr;
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
