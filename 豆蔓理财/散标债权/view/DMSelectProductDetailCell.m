//
//  DMSelectProductDetailCell.m
//  豆蔓理财
//
//  Created by edz on 2017/7/28.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMSelectProductDetailCell.h"
#import "GZAssetInfoModel.h"
@interface DMSelectProductDetailCell ()

@property (nonatomic, strong)NSArray *textArr;
@property (nonatomic, strong)UILabel *messageOneLabel;
@property (nonatomic, strong)UILabel *messageTwoLabel;

@property (nonatomic, strong)UIView *line1;

@end

@implementation DMSelectProductDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:self.messageOneLabel];
        [self.contentView addSubview:self.line1];
        [self.contentView addSubview:self.messageTwoLabel];
    }
    return self;
}

- (NSDictionary *)setLabelAttribute{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.lineSpacing = 4;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:FONT_Regular(12)};
    return dic;
}

- (void)setAssetModel:(GZAssetInfoModel *)assetModel {
    if (_assetModel != assetModel) {
        _assetModel = assetModel;
    }
    if ([_assetModel.guarantyStyle isEqualToString:@"CarInsurance"]) {
        self.messageOneLabel.text = @"车保智投是由豆蔓智投推出的一款具备高收益、低风险的定期投资服务计划，产品采用等额本息的还款方式，让您省时安心。";
    }else if ([_assetModel.guarantyStyle isEqualToString:@"CarPledge"]) {
        self.messageOneLabel.text = @"质押快投(摇钱树)是由豆蔓智投推出的一款具备高收益、低风险的定期投资服务计划，产品采用按月付息到期还本的还款方式，让您省时安心。";
    }else if ([_assetModel.guarantyStyle isEqualToString:@"ConsumerInstallment"]) {
        self.messageOneLabel.text = @"分期慧投是由豆蔓智投推出的一款具备周期选择多样，资金使用灵活，低风险的定期投资服务计划，产品采用等额本息的还款方式，让您省时安心。";
    }else {
        self.messageOneLabel.text = @"抵押智投是由豆蔓智投推出的一款具备长期稳定，资金使用灵活，低风险的定期投资服务计划，产品采用等额本息的还款方式，让您省时安心。";
    }
    
    
    if ([_assetModel.repaymentMethod isEqualToString:@"EqualInstallment"]) {
        _messageTwoLabel.text = [NSString stringWithFormat:@"结算日期：以计息日为基准，每个自然月的当天为结算日（如遇当月无此日，则为当月最后一日）。\n等额本息：在还款期内，每月偿还同等数额的借款（包括本金和利息）计息日起每隔一个月，返回当月的本金和利息。\n计息时间：本期债权满标后，生成合同即计息。\n起投金额：%@元",_assetModel.minAmount];
    }else {
       _messageTwoLabel.text = [NSString stringWithFormat:@"结算日期：以计息日为基准，每个自然月的当天为结算日（如遇当月无此日，则为当月最后一日）。\n按月付息：购买产品计息后每自然月结息一次，利息收入计入账户余额，本金随最后一次结息日返还。\n计息时间：本期债权满标后，生成合同即计息。\n起投金额：%@元",_assetModel.minAmount];
    }
    
    
    _messageOneLabel.attributedText = [[NSAttributedString alloc] initWithString:_messageOneLabel.text attributes:[self setLabelAttribute]];
    _messageTwoLabel.attributedText = [[NSAttributedString alloc] initWithString:_messageTwoLabel.text attributes:[self setLabelAttribute]];
    
    CGRect oneRect = [self.messageOneLabel.text boundingRectWithSize:CGSizeMake(DMDeviceWidth-42, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self setLabelAttribute] context:nil];
    _messageOneLabel.frame = CGRectMake(21, 18, DMDeviceWidth-42, oneRect.size.height);
    _line1.frame = CGRectMake(0, oneRect.size.height+36, DMDeviceWidth, 1);
    CGRect twoRect = [self.messageTwoLabel.text boundingRectWithSize:CGSizeMake(DMDeviceWidth-42, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self setLabelAttribute] context:nil];
    _messageTwoLabel.frame = CGRectMake(21, oneRect.size.height+36 + 18, DMDeviceWidth-42, twoRect.size.height);

}

#pragma lazyLoading

- (UILabel *)messageOneLabel {
    if (!_messageOneLabel) {
        _messageOneLabel = [UILabel createLabelFrame:CGRectMake( 21, 18, DMDeviceWidth - 42, 20) labelColor:UIColorFromRGB(0x808080) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        _messageOneLabel.numberOfLines = 0;
//        _messageOneLabel.backgroundColor = MainRed;
    }
    return _messageOneLabel;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = UIColorFromRGB(0xf3f3f3);
    }
    return _line1;
}

- (UILabel *)messageTwoLabel {
    if (!_messageTwoLabel) {
        _messageTwoLabel = [UILabel createLabelFrame:CGRectMake(21, 20, DMDeviceWidth - 42, 20) labelColor:UIColorFromRGB(0x808080) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        _messageTwoLabel.numberOfLines = 0;
    }
    return _messageTwoLabel;
}

- (NSArray *)textArr {
    if (!_textArr) {
        _textArr = [@[@"车保智投以车险分期为债权，车主提出投保申请后，资金出借人先期帮其垫付全部车险保费，车主随后按约定逐期偿还。一旦发生逾期或违约豆蔓智投将代表资金出借人申请退保，未使用的保费也将随即退还。",@"结算日期：以计息日为基准，每个自然月的当天为结算日（如遇当月无此日，则为当月最后一日）。\n等额本息：在还款期内，每月偿还同等数额的借款（包括本金和利息）计息日起每隔一个月，返回当月的本金和利息。\n计息时间：本期债权满标后，生成合同即计息。\n起投金额：100元"] copy];
    }
    return _textArr;
}

@end
