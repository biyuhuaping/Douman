//
//  DMTenderRuleCell.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/6.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMTenderRuleCell.h"

@interface DMTenderRuleCell ()

@property (nonatomic, strong)UILabel *dateLabel;
@property (nonatomic, strong)UIView *lineView;
@end

@implementation DMTenderRuleCell

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
        NSString *str = @"结算日期：以计息日为基准，每个自然月的当天为结算日（如遇当月无此日，则为当月最后一日）。\n等额本息：在还款期内，每月偿还同等数额的借款（包括本金和利息）计息日起每隔一个月，返回当月的本金和利息。\n计息时间：本期债权满标后，生成合同即计息。\n起投金额：100元";
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.text = str;
        self.dateLabel.numberOfLines = 0;
        self.dateLabel.textColor = UIColorFromRGB(0x808080);
        self.dateLabel.attributedText = [[NSAttributedString alloc] initWithString:self.dateLabel.text attributes:[self setLabelAttribute]];
        [self.contentView addSubview:self.dateLabel];
        
        CGRect rect = [str boundingRectWithSize:CGSizeMake(DMDeviceWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self setLabelAttribute] context:nil];
        self.dateLabel.frame = CGRectMake(20, 18, DMDeviceWidth-40, rect.size.height);
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height + 35, DMDeviceWidth, 1)];
        self.lineView.backgroundColor = UIColorFromRGB(0xf6f5fa);
        [self.contentView addSubview:self.lineView];
        
    }
    return self;
}

- (void)setRuleStr:(NSString *)ruleStr {
    _ruleStr = ruleStr;
    if ([_ruleStr isEqualToString:@"MonthlyInterest"]) {
        self.dateLabel.text = @"结算日期：以计息日为基准，每个自然月的当天为结算日（如遇当月无此日，则为当月最后一日）。\n按月付息：购买产品计息后每自然月结息一次，利息收入计入账户余额，本金随最后一次结息日返还。\n计息时间：本期债权满标后，生成合同即计息。\n起投金额：100元";
        self.dateLabel.attributedText = [[NSAttributedString alloc] initWithString:self.dateLabel.text attributes:[self setLabelAttribute]];
        CGRect rect = [self.dateLabel.text boundingRectWithSize:CGSizeMake(DMDeviceWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self setLabelAttribute] context:nil];
        self.dateLabel.frame = CGRectMake(20, 18, DMDeviceWidth-40, rect.size.height);
        [self.lineView setFrame:CGRectMake(0, rect.size.height + 35, DMDeviceWidth, 1)];
    }
}

- (NSDictionary *)setLabelAttribute{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.lineSpacing = 4;
//    paraStyle.headIndent = 60;
//    paraStyle.tailIndent = -14;
//    paraStyle.firstLineHeadIndent = 0;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:FONT_Regular(12)};
    return dic;
}

@end
