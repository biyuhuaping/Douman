//
//  LJQConfirmTransferCell.m
//  豆蔓理财
//
//  Created by mac on 2017/5/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQConfirmTransferCell.h"

@interface LJQConfirmTransferCell ()

@property (nonatomic, strong)UILabel *titleLabel; //标题
@property (nonatomic, strong)UILabel *investmentLabel; //年化利率
@property (nonatomic, strong)UILabel *timeLimitLabel; //期限
@property (nonatomic, strong)UILabel *remainBuyLabel; //剩余可购
@property (nonatomic, strong)CustomTextField *textField;
@property (nonatomic, strong)UILabel *actualAmountLabel;

@property (nonatomic, strong)UIButton *transferButton; //转让

@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UIView *bottomView;

@end

@implementation LJQConfirmTransferCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.investmentLabel];
        [self.contentView addSubview:self.timeLimitLabel];
        [self.contentView addSubview:self.remainBuyLabel];
        [self.contentView addSubview:self.actualAmountLabel];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.transferButton];
        [self createUI:@[@"年化利率",@"剩余期限",@"剩余可购"]];
    }
    return self;
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

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH - 210, 15, 200, 14) labelColor:UIColorFromRGB(0x47b994) textAlignment:(NSTextAlignmentRight) textFont:13.f];
        _typeLabel.text = @"等额本息";
    }
    return _typeLabel;
}

- (UILabel *)investmentLabel {
    if (!_investmentLabel) {
        _investmentLabel = [UILabel createLabelFrame:CGRectMake(0, 55, (SCREENWIDTH) / 3, 32) labelColor:UIColorFromRGB(0xfb9e1c) textAlignment:(NSTextAlignmentCenter) textFont:31.f];
        NSRange range = [@"8%" rangeOfString:@"%"];
        self.investmentLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:range text:@"8%" length:YES];
    }
    return _investmentLabel;
}

- (UILabel *)timeLimitLabel {
    if (!_timeLimitLabel) {
        _timeLimitLabel = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH ) / 3, 66, (SCREENWIDTH - 36) / 3, 21) labelColor:UIColorFromRGB(0xfb9e1c) textAlignment:(NSTextAlignmentCenter) textFont:20.f];
    }
    return _timeLimitLabel;
}

- (UILabel *)remainBuyLabel {
    if (!_remainBuyLabel) {
        _remainBuyLabel = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH ) / 3 * 2, 66, (SCREENWIDTH - 36) / 3, 21) labelColor:UIColorFromRGB(0xfb9e1c) textAlignment:(NSTextAlignmentCenter) textFont:20.f];
    }
    return _remainBuyLabel;
}

- (CustomTextField *)textField {
    if (!_textField) {
        _textField = [[CustomTextField alloc] initWithFrame:CGRectMake(25, 130, SCREENWIDTH - 36, 40) PlaceHoldFont:12.f PlaceHoldColor:UIColorFromRGB(0x878787)];
        _textField.layer.borderWidth = 1;
        _textField.layer.borderColor = UIColorFromRGB(0xf3f3f3).CGColor;
        _textField.placeholder = @"请输入购买金额";
        [_textField addTarget:self action:@selector(alertShow:) forControlEvents:(UIControlEventEditingChanged)];
    }
    return _textField;
}

- (UILabel *)actualAmountLabel {
    if (!_actualAmountLabel) {
        _actualAmountLabel = [UILabel createLabelFrame:CGRectMake(25, 190, 300, 15) labelColor:UIColorFromRGB(0x595757) textAlignment:(NSTextAlignmentLeft) textFont:14.f];
        NSString *string = @"实际承接金额：0元 ";
        _actualAmountLabel.attributedText = [self returenAttribute:string imageName:@"问号" imageBounds:CGRectMake(0, -2, 15, 15) index:string.length];
        _actualAmountLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(questionShowTap)];
        [_actualAmountLabel addGestureRecognizer:tap];
    }
    return _actualAmountLabel;
}

- (void)questionShowTap {
    
    [self.textField resignFirstResponder];
    !self.questionShow ? : self.questionShow();
}

- (UIButton *)transferButton {
    if (!_transferButton) {
        UIImage *image = [UIImage imageNamed:@"BuyNowAction"];
        _transferButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_transferButton setBackgroundImage:image forState:(UIControlStateNormal)];
        [_transferButton setFrame:CGRectMake((SCREENWIDTH - image.size.width) / 2, 230, image.size.width, image.size.height)];
        [_transferButton addTarget:self action:@selector(BuyNowAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _transferButton;
}

- (void)BuyNowAction:(UIButton *)sender {

        if ([self.model.SURPLUSAMOUNT floatValue] != 0) {
          if (self.textField.text.length != 0) {
            if (self.buyNow) {
                self.buyNow(self.textField.text);
            }
          }else {
              ShowMessage(@"请输入购买金额");
          }
        }else {
            ShowMessage(@"剩余可转让金额为0");
        }
}

- (void)alertShow:(CustomTextField *)textField {
    
    double number = ([textField.text floatValue] / [self.model.SURPLUSAMOUNT doubleValue] * [self.model.CREDITINTEREST doubleValue]) + [textField.text floatValue];
    NSString *string = [NSString stringWithFormat:@"实际承接金额：%.2f元",number];
    self.actualAmountLabel.attributedText = [self returenAttribute:string imageName:@"问号" imageBounds:CGRectMake(0, -2, 15, 15) index:string.length];
    if ([textField.text doubleValue] > [self.model.SURPLUSAMOUNT doubleValue]) {
        if (self.textFieldShow) {
            self.textFieldShow(textField.text);
        }
    }
    
    
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
        UILabel *label = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH ) / 3 * i, 0, (SCREENWIDTH) / 3, 12) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
        label.text = textArr[i];
        [self.bottomView addSubview:label];
    }
    [self.contentView addSubview:self.bottomView];
}


- (void)setModel:(DMCreditTransferListModel *)model {
    if (_model != model) {
        _model = model;
    }
    
    NSString *tittle = [@" " stringByAppendingString:_model.TITLE];
    self.titleLabel.attributedText = [self returenAttribute:tittle imageName:@"turnicon" imageBounds:CGRectMake(0, -2, 15, 15) index:0];
    
    if ([_model.INTEREST_RATE isEqualToString:@"0"]) {
        NSString *string = [NSString stringWithFormat:@"%@%%",_model.RATE];
        NSRange range = [string rangeOfString:@"%"];
        self.investmentLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:range text:string length:YES];
    }else {
        NSString *string = [NSString stringWithFormat:@"%@+%@%%",_model.RATE,_model.INTEREST_RATE];
        NSRange range1 = [string rangeOfString:@"+"];
        NSMutableAttributedString *attributeString = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:range1 text:string length:YES];
        
        NSRange range2 = [string rangeOfString:@"%"];
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} range:NSMakeRange(range2.location, 1)];
        
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.f],NSForegroundColorAttributeName:UIColorFromRGB(0xfb9e1c)} range:NSMakeRange(range1.location + 1, _model.INTEREST_RATE.length)];
        self.investmentLabel.attributedText = attributeString;
    }
    
    NSString *timeLimit = [NSString stringWithFormat:@"%@天",_model.SURPLUSDAYS];
    NSRange rang1 = [timeLimit rangeOfString:@"天"];
    self.timeLimitLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:rang1 text:timeLimit length:YES];
    
    NSString *remainBuy = [NSString stringWithFormat:@"%@元",_model.SURPLUSAMOUNT];
    NSRange rang2 = [remainBuy rangeOfString:@"元"];
    self.remainBuyLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:rang2 text:remainBuy length:YES];
    
    self.typeLabel.text = [NSString stringWithFormat:@"%@",_model.METHOD];
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
