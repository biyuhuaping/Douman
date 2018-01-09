//
//  LJQWithDrawalNoCell.m
//  豆蔓分解页面
//
//  Created by mac on 2016/12/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQWithDrawalNoCell.h"
#define space 60
@interface LJQWithDrawalNoCell ()

@property (nonatomic, strong)UILabel *amountLabel;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIButton *allBtn;

@property (nonatomic, strong)UIButton *withDrawalBtn;

@end

@implementation LJQWithDrawalNoCell
@synthesize withDrawalBtn;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self createAccountView];
        [self createCenterView];
        [self crateBtn];
    }
    return self;
}

- (void)createAccountView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 60 - space, SCREENWIDTH, 80)];
    bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    UILabel *label = [UILabel createLabelFrame:CGRectMake(20, 15, 200, 12) labelColor:UIColorFromRGB(0x585757) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
    label.text = @"账户余额(元)";
    
    self.amountLabel = [UILabel createLabelFrame:CGRectMake(20, LJQ_VIEW_MaxY(label) + 14, SCREENWIDTH, 20) labelColor:[UIColor blackColor] textAlignment:(NSTextAlignmentLeft) textFont:16.f];
    self.amountLabel.text = @"100000000.00";
    [bottomView addSubview:label];
    [bottomView addSubview:self.amountLabel];
    [self.contentView addSubview:bottomView];
}

- (void)createCenterView {
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 141 - space, SCREENWIDTH, 50)];
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
    
    UILabel *label = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH - 86, 19, 13, 13) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
    label.text = @"元";
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(LJQ_VIEW_MaxX(drawalLabel) + 15, 18, 140, 14)];
    [self.textField addTarget:self action:@selector(changeLength:) forControlEvents:(UIControlEventEditingChanged)];
    self.textField.font = [UIFont systemFontOfSize:12.f];
    self.textField.placeholder = @"请输入您要提现的金额";
    
    [centerView addSubview:withDrawal];
    [centerView addSubview:drawalLabel];
    [centerView addSubview:self.textField];
    [centerView addSubview:label];
    [centerView addSubview:self.allBtn];
    [self.contentView addSubview:centerView];
}

- (void)crateBtn {
    UIImage *img = [UIImage imageNamed:@"添加银行卡"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 141, SCREENWIDTH, SCREENWIDTH * img.size.height / img.size.width)];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0,  0, SCREENWIDTH, SCREENWIDTH * img.size.height / img.size.width);
    [button setBackgroundImage:img forState:(UIControlStateNormal)];
    [button setBackgroundImage:img forState:(UIControlStateHighlighted)];
    [button addTarget: self action:@selector(addBankEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:button];
    [self.contentView addSubview:view];
    
    
    withDrawalBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    withDrawalBtn.frame = CGRectMake(20, LJQ_VIEW_MaxY(view) + 67, SCREENWIDTH - 40, 44);
    [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现"] forState:(UIControlStateNormal)];
    [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现"] forState:(UIControlStateHighlighted)];
    [withDrawalBtn addTarget: self action:@selector(drawalAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:withDrawalBtn];
    
}

- (void)changeLength:(UITextField *)textfield {
    if (textfield.text.length != 0) {
        [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现-选中"] forState:(UIControlStateNormal)];
        [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现-选中"] forState:(UIControlStateHighlighted)];
        return;
    }else {
        [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现"] forState:(UIControlStateNormal)];
        [withDrawalBtn setBackgroundImage:[UIImage imageNamed:@"立即提现"] forState:(UIControlStateHighlighted)];
    }
}

//添加银行卡
- (void)addBankEvent:(UIButton *)sender {
   
    
}

//提现
- (void)drawalAction:(UIButton *)sender {
    
    
}

@end
