//
//  DMSelectProductCell.m
//  豆蔓理财
//
//  Created by edz on 2017/7/27.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMSelectProductCell.h"
#import "DMHomeListModel.h"
#define SPACELINE 6
@interface DMSelectProductCell ()

@property (nonatomic, strong)UILabel *titleLabel; //标题
@property (nonatomic, strong)UILabel *investmentLabel; //年化利率
@property (nonatomic, strong)UILabel *timeLimitLabel; //期限
@property (nonatomic, strong)UILabel *remainBuyLabel; //剩余可购

@property (nonatomic, strong)UILabel *twoTitleLabel;

@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIView *bottomView;

//@property (nonatomic, strong) UILabel *autumnGift;  //金秋送福

@end

@implementation DMSelectProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.topView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.investmentLabel];
        [self.contentView addSubview:self.timeLimitLabel];
        [self.contentView addSubview:self.remainBuyLabel];
        [self.contentView addSubview:self.twoTitleLabel];
        [self.contentView addSubview:self.typeLabel];
//        [self.contentView addSubview:self.autumnGift];
        [self createUI:@[@"年化利率",@"借款期限",@"剩余可购（元）"]];
    }
    return self;
}

- (void)setScafferListModel:(DMHomeListModel *)scafferListModel {
    if (_scafferListModel != scafferListModel) {
        _scafferListModel = scafferListModel;
    }
    //标题
    NSString *titleStr = [NSString stringWithFormat:@"第%@期",isOrEmpty(_scafferListModel.assetPeriodNum) ? @"--" : _scafferListModel.assetPeriodNum];
//    NSRange titleRange = [titleStr rangeOfString:@" "];
//    _titleLabel.attributedText = [self returenAttribute:titleStr  imageName:@"zhiyakuaitou" imageBounds:CGRectMake(0, -2, 65, 14) index:titleRange.location + 1];
    _titleLabel.text = titleStr;
    
    CGFloat width = [self returenLabelHeight:titleStr size:CGSizeMake(DMDeviceWidth, 12) fontsize:11.f isWidth:YES];
    [self.titleLabel setFrame:CGRectMake(15, 10 + SPACELINE, width, 14)];
    
    [self.twoTitleLabel setFrame:CGRectMake(LJQ_VIEW_MaxX(self.titleLabel), 10 + SPACELINE, 65, 14)];
    self.twoTitleLabel.text = _scafferListModel.assetTypeName;
    
    //利率
    
    if (isOrEmpty(_scafferListModel.assetInterestRate) || [_scafferListModel.assetInterestRate doubleValue] == 0) {
        NSString *string = [NSString stringWithFormat:@"%@%%",isOrEmpty(_scafferListModel.assetRate) ? @"--" : _scafferListModel.assetRate];
        NSRange range = [string rangeOfString:@"%"];
        self.investmentLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:FONT_Regular(15.f)} textRange:range text:string length:YES];
    }else {
        NSString *string = [NSString stringWithFormat:@"%@%%+%@%%",isOrEmpty(_scafferListModel.assetRate) ? @"-" : _scafferListModel.assetRate,isOrEmpty(_scafferListModel.assetInterestRate) ? @"-" : _scafferListModel.assetInterestRate];
        NSRange range1 = [string rangeOfString:@"+"];
        NSMutableAttributedString *attributeString = [self LJQLabelAttributeDic:@{NSFontAttributeName:FONT_Light(15.f)} textRange:range1 text:string length:YES];
        
        NSRange range2 = [string rangeOfString:@"%"];
        [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(15.f)} range:NSMakeRange(range2.location, 1)];
        
        [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(15.f)} range:NSMakeRange(range1.location + 1, 1)];
        
        [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(15.f)} range:NSMakeRange(string.length - 1, 1)];
        self.investmentLabel.attributedText = attributeString;
    }
    
    //期限
    if (_scafferListModel.termUnit == 1) {
       self.timeLimitLabel.text = [NSString stringWithFormat:@"%@天",isOrEmpty(_scafferListModel.productCycle) ? @"--" : _scafferListModel.productCycle];
    }else {
      self.timeLimitLabel.text = [NSString stringWithFormat:@"%@个月",isOrEmpty(_scafferListModel.productCycle) ? @"--" : _scafferListModel.productCycle];
    }

    //可购金额
    self.remainBuyLabel.text = [NSString stringWithFormat:@"%@",isOrEmpty(_scafferListModel.assetBalance) ? @"--" : _scafferListModel.assetBalance];
    
    if (isOrEmpty(_scafferListModel.assetStatus)) {
        [self.typeLabel setHidden:YES];
    }else {
        if ([_scafferListModel.assetStatus isEqualToString:@"HASENDED"]) {
            [self.typeLabel setHidden:NO];
        }else {
            [self.typeLabel setHidden:YES];
        }
    }
    
//    if ([_scafferListModel.productCycle isEqualToString:@"1"]&&[_scafferListModel.assetTypeName isEqualToString:@"质押快投"]) {
//        self.autumnGift.hidden = NO;
//    }else{
//        self.autumnGift.hidden = YES;
//    }
//    [self.autumnGift setFrame:CGRectMake(CGRectGetMaxX(self.twoTitleLabel.frame)+5, 10 + SPACELINE, 65, 14)];
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 6)];
        _topView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    }
    return _topView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelFrame:CGRectMake(15, 10 + SPACELINE, SCREENWIDTH, 14) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        _titleLabel.font = FONT_Light(11.f);
        NSRange range = [@"17041404期 " rangeOfString:@" "];
        _titleLabel.attributedText = [self returenAttribute:@"17041404期  "  imageName:@"zhiyakuaitou" imageBounds:CGRectMake(0, -2, 65, 14) index:range.location + 1];
    }
    return _titleLabel;
}

- (UILabel *)investmentLabel {
    if (!_investmentLabel) {
        _investmentLabel = [UILabel createLabelFrame:CGRectMake(0, 22 + 25 + SPACELINE, (SCREENWIDTH) / 3, 23) labelColor:UIColorFromRGB(0xff6e51) textAlignment:(NSTextAlignmentCenter) textFont:22.f];
        _investmentLabel.font = FONT_Regular(22.f);
    }
    return _investmentLabel;
}

- (UILabel *)timeLimitLabel {
    if (!_timeLimitLabel) {
        _timeLimitLabel = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH ) / 3, 54 + SPACELINE, (SCREENWIDTH) / 3, 16) labelColor:UIColorFromRGB(0x4b5159) textAlignment:(NSTextAlignmentCenter) textFont:15.f];
        _timeLimitLabel.font = FONT_Regular(15.f);
        
    }
    return _timeLimitLabel;
}

- (UILabel *)remainBuyLabel {
    if (!_remainBuyLabel) {
        _remainBuyLabel = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH ) / 3 * 2, 54 + SPACELINE, (SCREENWIDTH) / 3, 16) labelColor:UIColorFromRGB(0x4b5159) textAlignment:(NSTextAlignmentCenter) textFont:15.f];
        _remainBuyLabel.font = FONT_Regular(15.f);
    }
    return _remainBuyLabel;
}

- (UILabel *)typeLabel {
    UIImage *image = [UIImage imageNamed:@"已满标"];
    if (!_typeLabel) {
        _typeLabel = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH - image.size.width - 35, 15, image.size.width, image.size.height) labelColor:UIColorFromRGB(0x47b994) textAlignment:(NSTextAlignmentRight) textFont:image.size.height];
        _typeLabel.text = @"";
        _typeLabel.attributedText = [self returenAttribute:@""  imageName:@"已满标" imageBounds:CGRectMake(0, 0, image.size.width, image.size.height) index:0];
        _typeLabel.hidden = YES;
    }
    return _typeLabel;
}



- (UILabel *)twoTitleLabel {
    if (!_twoTitleLabel) {
        _twoTitleLabel = [UILabel createLabelFrame:CGRectMake(15, 10 + SPACELINE, SCREENWIDTH, 14) labelColor:UIColorFromRGB(0xff6e51) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
        _twoTitleLabel.layer.borderColor = UIColorFromRGB(0xff6e51).CGColor;
        _twoTitleLabel.layer.borderWidth = 0.7;
        _twoTitleLabel.layer.cornerRadius = 3;
        _twoTitleLabel.layer.masksToBounds = YES;
        _twoTitleLabel.font = FONT_Light(11.f);
    }
    return _twoTitleLabel;
}


//- (UILabel *)autumnGift {
//    if (!_autumnGift) {
//        _autumnGift = [UILabel createLabelFrame:CGRectMake(15 , 10 + SPACELINE , 65, 14) labelColor:UIColorFromRGB(0xffffff) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
//        _autumnGift.layer.cornerRadius = 3;
//        _autumnGift.layer.masksToBounds = YES;
//        _autumnGift.text = @"金秋送福";
//        _autumnGift.backgroundColor = UIColorFromRGB(0xff6e51);
//        _autumnGift.font = FONT_Light(11.f);
//    }
//    return _autumnGift;
//}


- (void)createUI:(NSArray *)textArr {
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 47 + 23 + 10 + SPACELINE, SCREENWIDTH / 3 * textArr.count, 13)];
    self.bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    if (self.bottomView.subviews.count != 0) {
        for (UILabel *label in self.bottomView.subviews) {
            [label removeFromSuperview];
        }
    }
    for (int i = 0; i < textArr.count; i++) {
        UILabel *label = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH ) / 3 * i, 0, (SCREENWIDTH) / 3, 12) labelColor:UIColorFromRGB(0x7b7b7b) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
        label.font = FONT_Light(11.f);
        label.text = textArr[i];
        [self.bottomView addSubview:label];
    }
    [self.contentView addSubview:self.bottomView];
}

- (void)layoutSubviews {
//    NSString *string = @"7%+1%";
//    NSRange range1 = [string rangeOfString:@"+"];
//    NSMutableAttributedString *attributeString = [self LJQLabelAttributeDic:@{NSFontAttributeName:FONT_Light(15.f)} textRange:range1 text:string length:YES];
//    
//    NSRange range2 = [string rangeOfString:@"%"];
//    [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(15.f)} range:NSMakeRange(range2.location, 1)];
//    
//    [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(15.f)} range:NSMakeRange(range1.location + 1, 1)];
//    
//    [attributeString addAttributes:@{NSFontAttributeName:FONT_Light(15.f)} range:NSMakeRange(string.length - 1, 1)];
//    self.investmentLabel.attributedText = attributeString;
//    
//    self.timeLimitLabel.text = @"3个月";
//    self.remainBuyLabel.text = @"18600000";
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

- (CGFloat)returenLabelHeight:(NSString *)string size:(CGSize)size fontsize:(NSInteger)font isWidth:(BOOL)isWidth{
    
    CGRect rect = [string boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    if (isWidth == YES) {
        return rect.size.width;
    }else {
        return rect.size.height;
    }
}

@end
