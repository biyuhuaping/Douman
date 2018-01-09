//
//  DMScatterBuyCell.m
//  豆蔓理财
//
//  Created by edz on 2017/6/28.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMScatterBuyCell.h"
#import "DMScafferListModel.h"
#import "DMHomeListModel.h"
@interface DMScatterBuyCell ()<UITextFieldDelegate>

@property (nonatomic, strong)CustomTextField *textField;
@property (nonatomic, strong)UIButton *button;

@end

@implementation DMScatterBuyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.button];
        [self createBottomView];
    }
    return self;
}

- (void)createBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, DMDeviceWidth,2)];
    bottomView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self.contentView addSubview:bottomView];
}

- (void)setIsOrHidden:(BOOL)isOrHidden {
    if (_isOrHidden != isOrHidden) {
        _isOrHidden = isOrHidden;
    }
    
    if (_isOrHidden) {
        [self.button setHidden:YES];
    }else {
        [self.button setHidden:NO];
    }
}

- (CustomTextField *)textField {
    if (!_textField) {
        _textField = [[CustomTextField alloc] initWithFrame:CGRectMake(16, 20, 474 / 2, 30) PlaceHoldFont:13 PlaceHoldColor:UIColorFromRGB(0xa7a7a7)];
        _textField.placeholder = @"100元起投，请输入购买金额";
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        [_textField addTarget:self action:@selector(inputStringChange:) forControlEvents:UIControlEventEditingChanged];
        _textField.delegate = self;
    }
    return _textField;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setFrame:CGRectMake(DMDeviceWidth - 83, 19, 67, 31)];
        [_button setTitle:@"全投" forState:(UIControlStateNormal)];
        [_button setTitleColor:UIColorFromRGB(0xff7255) forState:(UIControlStateNormal)];
        _button.titleLabel.font = FONT_Regular(13.f);
        _button.layer.cornerRadius = 15;
        _button.layer.borderWidth = 1;
        _button.layer.borderColor = UIColorFromRGB(0xff7255).CGColor;
        [_button addTarget:self action:@selector(allMade:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _button;
}

- (void)setAvailableBalance:(NSString *)AvailableBalance {
    if (_AvailableBalance != AvailableBalance) {
        _AvailableBalance = AvailableBalance;
    }
    
    if (isOrEmpty(_AvailableBalance)) {
        _AvailableBalance = @"0";
    }
}

- (void)setListModel:(DMScafferListModel *)listModel {
    if (_listModel != listModel) {
        _listModel = listModel;
    }
    
    if ([_listModel.surplusAmount doubleValue] < 100) {
        self.textField.placeholder = [NSString stringWithFormat:@"当前债权余额%@元，请点击全投",_listModel.surplusAmount];
    }else {
        self.textField.placeholder = @"100元起投，请输入购买金额";
    }
}

- (void)setProductModel:(DMHomeListModel *)productModel {
    if (_productModel != productModel) {
        _productModel = productModel;
    }
    
    self.textField.placeholder = @"100元起投，请输入购买金额";
}

//全投
- (void)allMade:(UIButton *)sender {
    
    if ([self.listModel.surplusAmount doubleValue] >= [self.AvailableBalance doubleValue]) {
        //债权余额大于账户余额,默认输入账户余额
        NSInteger number = [self.AvailableBalance integerValue] / 100;
        
        //self.textField.text = self.AvailableBalance;
        self.textField.text = [NSString stringWithFormat:@"%ld",number * 100];
        !self.scatterAllBuy ? : self.scatterAllBuy(self.textField.text);
    }
    
    if ([self.listModel.surplusAmount doubleValue] <= [self.AvailableBalance doubleValue]) {
        //债权余额小于账户余额,默认输入债权余额
        self.textField.text = isOrEmpty(self.listModel.surplusAmount) ? @"0" : self.listModel.surplusAmount;
        !self.scatterAllBuy ? : self.scatterAllBuy(self.textField.text);
    }
    
    if (([self.listModel.surplusAmount doubleValue] > 100 && [self.AvailableBalance doubleValue] < 100) | ([self.listModel.surplusAmount doubleValue] < 100 && [self.AvailableBalance doubleValue] < [self.listModel.surplusAmount doubleValue])) {
        !self.scatterAllBuy ? : self.scatterAllBuy(@"账户余额不足，请先充值");
    }
}

//textfield
- (void)inputStringChange:(CustomTextField *)textField {
     !self.changeStringBlock ? : self.changeStringBlock(textField.text);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text doubleValue] != [self.listModel.surplusAmount doubleValue]) {
        if ([textField.text integerValue] % 100 != 0) {
            //提示
             !self.scatterAllBuy ? : self.scatterAllBuy(@"提示");
            self.textField.text = @"";
        }
    }
}

@end
