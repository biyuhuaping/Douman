//
//  LJQCreditTheZoneCell.m
//  豆蔓理财
//
//  Created by mac on 2017/5/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQCreditTheZoneCell.h"
#import "DMCreditTransferListModel.h"
@interface LJQCreditTheZoneCell ()

@property (nonatomic, strong)UILabel *titleLabel; //标题
@property (nonatomic, strong)UILabel *investmentLabel; //投资金额
@property (nonatomic, strong)UILabel *timeLimitLabel; //期限
@property (nonatomic, strong)UIButton *transferButton; //转让

@property (nonatomic, strong)UIView *bottomView;

@property (nonatomic, strong)UIView *centerView;
@end

@implementation LJQCreditTheZoneCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self.contentView addSubview:self.centerView];
        
        [self.centerView addSubview:self.titleLabel];
        [self.centerView addSubview:self.investmentLabel];
        [self.centerView addSubview:self.timeLimitLabel];
        [self.centerView addSubview:self.transferButton];
        
        [self createUI:@[@"年化利率",@"剩余期限"]];
    }
    return self;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, DMDeviceWidth, 120)];
        _centerView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _centerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelFrame:CGRectMake(11, 13, SCREENWIDTH, 15) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentLeft) textFont:14.f];
        _titleLabel.attributedText = [self returenAttribute:@" 保时捷牌车辆质押资金周转" imageName:@"turnicon" imageBounds:CGRectMake(0, -2, 15, 15) index:0];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 1)];
        view.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self.contentView addSubview:view];
    }
    return _titleLabel;
}

- (UILabel *)investmentLabel {
    if (!_investmentLabel) {
        _investmentLabel = [UILabel createLabelFrame:CGRectMake(0, 55, (SCREENWIDTH) / 3, 32) labelColor:UIColorFromRGB(0xfb9e1c) textAlignment:(NSTextAlignmentCenter) textFont:31.f];
    }
    return _investmentLabel;
}

- (UILabel *)timeLimitLabel {
    if (!_timeLimitLabel) {
        _timeLimitLabel = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH) / 3, 60, (SCREENWIDTH) / 3, 21) labelColor:UIColorFromRGB(0xfb9e1c) textAlignment:(NSTextAlignmentCenter) textFont:20.f];
    }
    return _timeLimitLabel;
}

- (UIButton *)transferButton {
    if (!_transferButton) {
        UIImage *image = [UIImage imageNamed:@"立即购买按钮"];
        _transferButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_transferButton setBackgroundImage:image forState:(UIControlStateNormal)];
        [_transferButton setFrame:CGRectMake(((SCREENWIDTH) / 3 - image.size.width) / 2 + (SCREENWIDTH ) / 3 * 2, 60, image.size.width, image.size.height)];
        [_transferButton addTarget:self action:@selector(transferAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _transferButton;
}

- (void)transferAction:(UIButton *)sender {
    !self.buyCredit ? : self.buyCredit(sender);
}

- (void)createUI:(NSArray *)textArr {
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREENWIDTH / 3 * textArr.count, 13)];
    self.bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    if (self.bottomView.subviews.count != 0) {
        for (UILabel *label in self.bottomView.subviews) {
            [label removeFromSuperview];
        }
    }
    for (int i = 0; i < textArr.count; i++) {
        UILabel *label = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH) / 3 * i, 0, (SCREENWIDTH) / 3, 12) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
        label.text = textArr[i];
        [self.bottomView addSubview:label];
    }
    [self.contentView addSubview:self.bottomView];
}


- (void)setListModel:(DMCreditTransferListModel *)listModel {
    if (_listModel != listModel) {
        _listModel = listModel;
    }
    NSString *tittle = [@" " stringByAppendingString:_listModel.TITLE];
    self.titleLabel.attributedText = [self returenAttribute:tittle imageName:@"turnicon" imageBounds:CGRectMake(0, -2, 15, 15) index:0];
    
    if ([_listModel.INTEREST_RATE isEqualToString:@"0"]) {
        NSString *string = [NSString stringWithFormat:@"%@%%",_listModel.RATE];
        NSRange range = [string rangeOfString:@"%"];
        self.investmentLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:range text:string length:YES];
    }else {
        NSString *string = [NSString stringWithFormat:@"%@+%@%%",_listModel.RATE,_listModel.INTEREST_RATE];
        NSRange range1 = [string rangeOfString:@"+"];
        NSMutableAttributedString *attributeString = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:range1 text:string length:YES];
        
        NSRange range2 = [string rangeOfString:@"%"];
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} range:NSMakeRange(range2.location, 1)];
        
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.f],NSForegroundColorAttributeName:UIColorFromRGB(0xfb9e1c)} range:NSMakeRange(range1.location + 1, _listModel.INTEREST_RATE.length)];
        self.investmentLabel.attributedText = attributeString;
    }
    
    NSString *timeLimit = [NSString stringWithFormat:@"%@天",_listModel.SURPLUSDAYS];
    NSRange rang1 = [timeLimit rangeOfString:@"天"];
    self.timeLimitLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:rang1 text:timeLimit length:YES];
}

#pragma 插入图片
//创建图片附件
- (NSAttributedString *)pitcureStringName:(NSString *)imageName imageBounds:(CGRect)imageBounds{
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:imageName];
    attach.bounds = imageBounds;
    NSAttributedString *attachStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    return attachStr;
}

- (NSMutableAttributedString *)returenAttribute:(NSString *)string imageName:(NSString *)imageName imageBounds:(CGRect)imageBounds index:(NSInteger)index{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute insertAttributedString:[self pitcureStringName:imageName imageBounds:imageBounds] atIndex:index];
    
    return attribute;
}

#pragma 可变字符串
- (NSMutableAttributedString *)LJQLabelAttributeDic:(NSDictionary *)dic textRange:(NSRange)range text:(NSString *)text length:(BOOL)length{
    NSMutableAttributedString *mutableAttribute = [[NSMutableAttributedString alloc] initWithString:text];
    [mutableAttribute addAttributes:dic range:NSMakeRange(range.location, length ? 1 : 2)];
    return mutableAttribute;
}

- (NSMutableAttributedString *)returnAttributeWithString:(NSString *)string range:(NSRange)range length:(NSInteger)length  color:(UIColor *)color{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f],NSForegroundColorAttributeName:color} range:NSMakeRange(range.location + 1, length)];
    return attribute;
}


@end
