//
//  LJQwithDrawalCell.m
//  豆蔓分解页面
//
//  Created by mac on 2016/12/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQwithDrawalCell.h"
#import "LJQUserInfoModel.h"
#define space 60
@interface LJQwithDrawalCell ()

@property (nonatomic, strong)UIButton *withDrawalBtn;

@property (nonatomic, strong)UIImageView *imageViw;
@property (nonatomic, strong)UILabel *idNumberLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *cardLabel;

@property (nonatomic, strong)UIImageView *bottomBankView;
//开户支行
@property (nonatomic, strong)UIView *AccountBottomView;
@property (nonatomic, strong)NSArray<NSString *> *accountNameArr;
@end

@implementation LJQwithDrawalCell
@synthesize withDrawalBtn;
@synthesize bottomBankView;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf3f3f3);
            [self createAccountView];
            [self createCenterView];
        
            [self createBankView];
    }
    return self;
}


- (void)createAccountView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 114)];
    bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    UILabel *label = [UILabel createLabelFrame:CGRectMake(20, 10, 200, 13) labelColor:UIColorFromRGB(0x585757) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    label.text = @"账户余额(元)";
    
    self.amountLabel = [UILabel createLabelFrame:CGRectMake(20, LJQ_VIEW_MaxY(label) + 28, SCREENWIDTH, 30) labelColor:UIColorFromRGB(0x3e3e3e) textAlignment:(NSTextAlignmentLeft) textFont:28.f];
    self.amountLabel.text = @"---";
    [bottomView addSubview:label];
    [bottomView addSubview:self.amountLabel];
    [self.contentView addSubview:bottomView];
}

- (void)createCenterView {
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 115, SCREENWIDTH, 50)];
    centerView.backgroundColor = UIColorFromRGB(0xffffff);
    
    UIImage *image = [UIImage imageNamed:@"withdrawal"];
    UIImageView *withDrawal = [[UIImageView alloc] initWithImage:image];
    withDrawal.center = CGPointMake(20 + image.size.width / 2, centerView.frame.size.height / 2);
    UILabel *drawalLabel = [UILabel createLabelFrame:CGRectMake(LJQ_VIEW_MaxX(withDrawal) + 5, 18, 60, 14) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    drawalLabel.text = @"提现金额";
    
    self.allBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.allBtn setFrame:CGRectMake(SCREENWIDTH - 60, 19, 48, 12)];
    [self.allBtn setTitle:@"全部提现" forState:(UIControlStateNormal)];
    self.allBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [self.allBtn setTitleColor:UIColorFromRGB(0x25c587) forState:(UIControlStateNormal)];
    [self.allBtn addTarget:self action:@selector(allAcountWithDrawal:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UILabel *label = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH - 86, 19, 13, 13) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
    label.text = @"元";
    CGFloat number = iPhone5 ? 5 : 13;
    self.textField = [[CustomTextField alloc] initWithFrame:CGRectMake(LJQ_VIEW_MaxX(drawalLabel) + number, 0, 140, 52) PlaceHoldFont:11 PlaceHoldColor:UIColorFromRGB(0x878787)];
    self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.textField addTarget:self action:@selector(changeLengthLength:) forControlEvents:(UIControlEventEditingChanged)];
    self.textField.font = [UIFont systemFontOfSize:12.f];
    self.textField.placeholder = @"请输入您要提现的金额";
    
    [centerView addSubview:withDrawal];
    [centerView addSubview:drawalLabel];
    [centerView addSubview:self.textField];
    [centerView addSubview:label];
    [centerView addSubview:self.allBtn];
    [self.contentView addSubview:centerView];
}

//设置开户支行
- (void)openAccountView {
    self.AccountBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 166, DMDeviceWidth, 50)];
    self.AccountBottomView.backgroundColor = UIColorFromRGB(0xffffff);
    
    UIImage *image = [UIImage imageNamed:@"withdrawal"];
    UIImageView *withDrawal = [[UIImageView alloc] initWithImage:image];
    withDrawal.center = CGPointMake(20 + image.size.width / 2, self.AccountBottomView.frame.size.height / 2);
    
    UILabel *accountLabel = [UILabel createLabelFrame:CGRectMake(LJQ_VIEW_MaxX(withDrawal) + 5, 18, 60, 14) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    accountLabel.text = @"开户支行";
    [self.AccountBottomView addSubview:accountLabel];
    
    
    self.accountTextField = [UILabel createLabelFrame:CGRectMake(100 + 5, 25, 200, 28) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    self.accountTextField.numberOfLines = 0;
    [self.AccountBottomView addSubview:self.accountTextField];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setFrame:CGRectMake(DMDeviceWidth - 85, 0, 72, 50)];
    [button setTitle:@"选择支行名称" forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:11.f];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:UIColorFromRGB(0x25c587) forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(forgetAccountName:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.AccountBottomView addSubview:button];
    [self.contentView addSubview:self.AccountBottomView];
}

//银行卡
- (void)createBankView {
    bottomBankView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 195, SCREENWIDTH - 40, 280 * (SCREENWIDTH - 40) / 668)];
    bottomBankView.image = [[UIImage imageNamed:@"银行卡背景"] imageWithRenderingMode:(UIImageRenderingModeAutomatic)];
    [self.contentView addSubview: bottomBankView];
    
    UIImage *image = [UIImage imageNamed:@"招商银行"];
    CGFloat scale = image.size.width / image.size.height;
    self.imageViw = [[UIImageView alloc] initWithFrame:CGRectMake(-(104 * LJQ_VIEW_Height(bottomBankView) / 280 * scale / 4 - 20), 0, 104 * LJQ_VIEW_Height(bottomBankView) / 280 * scale, 104 * LJQ_VIEW_Height(bottomBankView) / 280)];
    self.imageViw.image = image;
    self.imageViw.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [bottomBankView addSubview:self.imageViw];
    
    self.idNumberLabel = [UILabel createLabelFrame:CGRectMake(0, 0, LJQ_VIEW_Width(bottomBankView), 16) labelColor:UIColorFromRGB(0x767676) textAlignment:(NSTextAlignmentCenter) textFont:15.f];
    self.idNumberLabel.center = CGPointMake(LJQ_VIEW_Width(bottomBankView) / 2, LJQ_VIEW_Height(bottomBankView) / 2 + 10);
    [bottomBankView addSubview:self.idNumberLabel];
    
    self.nameLabel = [UILabel createLabelFrame:CGRectMake(23, LJQ_VIEW_Height(bottomBankView) - 23, LJQ_VIEW_Width(bottomBankView) / 2, 13) labelColor:UIColorFromRGB(0x767676) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    self.nameLabel.text = @"持卡人：";
    [bottomBankView addSubview:self.nameLabel];
    
    self.cardLabel = [UILabel createLabelFrame:CGRectMake(LJQ_VIEW_Width(bottomBankView) - LJQ_VIEW_Width(bottomBankView) - 16, LJQ_VIEW_Height(bottomBankView) - 23, LJQ_VIEW_Width(bottomBankView), 13) labelColor:UIColorFromRGB(0x767676) textAlignment:(NSTextAlignmentRight) textFont:12.f];

    [bottomBankView addSubview:self.cardLabel];
    
    withDrawalBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    withDrawalBtn.frame = CGRectMake(20, LJQ_VIEW_MaxY(bottomBankView) + 67, SCREENWIDTH - 40, 44);
    [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现"] forState:(UIControlStateNormal)];
    [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现"] forState:(UIControlStateHighlighted)];
    [withDrawalBtn addTarget: self action:@selector(drawalEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:withDrawalBtn];
    
}


- (NSString *)returnIdString:(NSString *)string {
    NSString *str = string;
    for (int length = 0; length < string.length; length++) {
        if (length > 2 && length < string.length - 4) {
            str = [str stringByReplacingCharactersInRange:NSMakeRange(length, 1) withString:@"*"];
        }
    }
    return str;
}


- (NSString *)returnBackIdString:(NSString *)string {
    NSString *str = string;
    for (int length = 0; length < string.length; length++) {
        if (length < string.length - 4) {
            str = [str stringByReplacingCharactersInRange:NSMakeRange(length, 1) withString:@"*"];
        }
    }
    return str;
}

- (NSString *)returnBankString:(NSString *)string {
    NSString *str = [self returnBackIdString:string];
    NSMutableString *mutable = [str mutableCopy];
    for (int length = 0; length < string.length; length++) {
        if ((length + 1)% 5 == 0) {
            [mutable insertString:@" " atIndex:length];
        }
    }
    
    NSString *endstr = [NSString stringWithFormat:@"%@",mutable];
    return endstr;
}


- (void)changeLengthLength:(UITextField *)textfield {
   
    NSNumber *number = [self stringFormatterDecimalStyle:self.amountLabel.text];
    NSString *money = [NSString stringWithFormat:@"%.2f",[number doubleValue]];
    
    //大额提现
//    if ([self.accountNameArr containsObject:self.model.bank]) {
//        if ([textfield.text doubleValue] <= [number doubleValue]) {
//            if ([textfield.text doubleValue] > 50005) {
//                [self openAccountView];
//                if (self.AccountBottomView) {
//                    NSString *branchString;
//                    if (isOrEmpty(self.model.associateNumber)) {
//                        branchString = isOrEmpty(self.accountTextField.text) ? @"请选择支行名称": self.accountTextField.text;
//                    }else {
//                        branchString = self.model.branch;
//                    }
//                    self.accountTextField.text = [NSString stringWithFormat:@"%@",branchString];
//                    CGFloat height = [self returenLabelHeight:self.accountTextField.text size:CGSizeMake(DMDeviceWidth - 105 - 90, 50) fontsize:12.f isWidth:NO];
//                    [self.accountTextField setFrame:CGRectMake(105, (50 - height) / 2, DMDeviceWidth - 105 - 90, height)];
//                    [bottomBankView setFrame:CGRectMake(20, 195 + 50, SCREENWIDTH - 40, 280 * (SCREENWIDTH - 40) / 668)];
//                }
//            }else {
//                [self.AccountBottomView removeFromSuperview];
//                [bottomBankView setFrame:CGRectMake(20, 195, SCREENWIDTH - 40, 280 * (SCREENWIDTH - 40) / 668)];
//            }
//        }
//    }
    
    if (textfield.text.length != 0) {
        if ([textfield.text doubleValue] > [number doubleValue]) {
            textfield.text = [money substringToIndex:money.length];
            [textfield resignFirstResponder];
        }

        [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现-选中"] forState:(UIControlStateNormal)];
        [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现-选中"] forState:(UIControlStateHighlighted)];
    }else {
        [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现"] forState:(UIControlStateNormal)];
        [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现"] forState:(UIControlStateHighlighted)];
    }
}


- (NSNumber *)stringFormatterDecimalStyle:(NSString *)money
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    return [formatter numberFromString:money];
}

- (void)layoutSubviews {
   
    
    if (self.AccountBottomView) {
        CGFloat height = [self returenLabelHeight:self.accountTextField.text size:CGSizeMake(DMDeviceWidth - 105 - 90, 50) fontsize:12.f isWidth:NO];
        [self.accountTextField setFrame:CGRectMake(105, (50 - height) / 2, DMDeviceWidth - 105 - 90, height)];
    }
}

- (void)setModel:(LJQUserInfoModel *)model {
    if (_model != model) {
        _model = model;
    }

    self.imageViw.image = [UIImage imageNamed:_model.bank];
    self.idNumberLabel.text = [self returnBankString:_model.account];
    self.cardLabel.text = _model.idNumber;
    self.cardLabel.text = [NSString stringWithFormat:@"身份证号:%@",[self returnIdString:_model.idNumber]];
    self.nameLabel.text = [NSString stringWithFormat:@"持卡人:%@",_model.name];
}

#pragma 提现
- (void)drawalEvent:(UIButton *)sender {
    
    
    NSString *branchString;
    if (isOrEmpty(self.model.associateNumber)) {
         branchString = @"请选择支行名称";
    }else {
        branchString = self.model.branch;
          }
     !self.withDrawalBK ? : self.withDrawalBK(sender,self.textField.text,branchString);
    
//    if (self.accountTextField.text.length <= 0) {
//         !self.withDrawalBK ? : self.withDrawalBK(sender,self.textField.text,@"");
//    }else {
//         !self.withDrawalBK ? : self.withDrawalBK(sender,self.textField.text,self.accountTextField.text);
//    }
}


- (void)allAcountWithDrawal:(UIButton *)sender {
    
    NSNumber *number = [self stringFormatterDecimalStyle:self.amountLabel.text];
    
    if ([number doubleValue] >= 1) {
        self.textField.text = [NSString stringWithFormat:@"%.2f",[number doubleValue]];
    }else {
       
    }

    [self.textField resignFirstResponder];
    if (self.textField.text.length != 0) {
        [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现-选中"] forState:(UIControlStateNormal)];
        [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现-选中"] forState:(UIControlStateHighlighted)];
    }else {
        [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现"] forState:(UIControlStateNormal)];
        [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现"] forState:(UIControlStateHighlighted)];
    }

    self.allWithDrawalBK(self.amountLabel.text);
}

//忘记支行名称
- (void)forgetAccountName:(UIButton *)sender {
    
    [self.textField resignFirstResponder];
    !self.forgetOpenAccountName ? : self.forgetOpenAccountName();
}

- (NSArray<NSString *> *)accountNameArr {
    if (!_accountNameArr) {
        _accountNameArr = [@[@"中国工商银行",@"中国农业银行",@"中国银行",@"中国建设银行",@"南京银行"] copy];
    }
    return _accountNameArr;
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
