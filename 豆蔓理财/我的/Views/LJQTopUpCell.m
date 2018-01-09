//
//  LJQTopUpCell.m
//  豆蔓分解页面
//
//  Created by mac on 2016/12/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQTopUpCell.h"

@interface LJQTopUpCell ()

@property (nonatomic, strong)UIButton *topUpBtn;

@end

@implementation LJQTopUpCell
@synthesize topUpBtn;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self createAccountView];
        [self createCenterView];
        [self createbottomView];
    }
    return self;
}


- (void)createAccountView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 114)];
    bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    UILabel *label = [UILabel createLabelFrame:CGRectMake(20, 10, 200, 13) labelColor:UIColorFromRGB(0x585757) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    label.text = @"账户余额(元)";
    
    self.amountLabel = [UILabel createLabelFrame:CGRectMake(20, LJQ_VIEW_MaxY(label) + 28, SCREENWIDTH, 30) labelColor:UIColorFromRGB(0x3e3e3e) textAlignment:(NSTextAlignmentLeft) textFont:28.f];
    self.amountLabel.text = @"100000000.00";
    [bottomView addSubview:label];
    [bottomView addSubview:self.amountLabel];
    [self.contentView addSubview:bottomView];
}

- (void)createCenterView {
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 115, SCREENWIDTH, 50)];
    centerView.backgroundColor = UIColorFromRGB(0xffffff);
    
    UIImage *image = [UIImage imageNamed:@"充值金额icon"];
    UIImageView *withDrawal = [[UIImageView alloc] initWithImage:image];
    withDrawal.center = CGPointMake(27 + image.size.width / 2, centerView.frame.size.height / 2);
    UILabel *drawalLabel = [UILabel createLabelFrame:CGRectMake(LJQ_VIEW_MaxX(withDrawal) + 5, 18, 60, 14) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    drawalLabel.text = @"充值金额";
    
   
    UILabel *label = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH - 40, 19, 13, 13) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
    label.text = @"元";
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(LJQ_VIEW_MaxX(drawalLabel) + 58, 18, 140, 14)];
    self.textField.font = [UIFont systemFontOfSize:12.f];
    [self.textField addTarget:self action:@selector(changeLength:) forControlEvents:(UIControlEventEditingChanged)];
    self.textField.placeholder = @"请输入您要充值的金额";
    
    [centerView addSubview:withDrawal];
    [centerView addSubview:drawalLabel];
    [centerView addSubview:self.textField];
    [centerView addSubview:label];
    [centerView addSubview:self.allBtn];
    [self.contentView addSubview:centerView];
}

- (void)createbottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 180, SCREENWIDTH, 71)];
    bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    
    UIImage *image = [UIImage imageNamed:@"农业"];
    UIImageView *imageViw = [[UIImageView alloc] initWithFrame:CGRectMake(27, (LJQ_VIEW_Height(bottomView) - image.size.height) / 2, image.size.width, image.size.height)];
    imageViw.image = image;
    [bottomView addSubview:imageViw];
    
    UILabel *label = [UILabel createLabelFrame:CGRectMake(LJQ_VIEW_MaxX(imageViw) + 22, 17, LJQ_VIEW_Width(bottomView), 16) labelColor:UIColorFromRGB(0x3e3e3e) textAlignment:(NSTextAlignmentLeft) textFont:15.f];
    label.text = [self returnBankString:@"1234567891234567"];
    [bottomView addSubview:label];
    
    UILabel *nameLabel = [UILabel createLabelFrame:CGRectMake(LJQ_VIEW_MaxX(imageViw) + 22, CGRectGetMaxY(label.frame) + 6, LJQ_VIEW_Width(bottomView) / 2, 13) labelColor:UIColorFromRGB(0x767676) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    nameLabel.text = @"中国农业银行";
    [bottomView addSubview:nameLabel];
    
    UILabel *cardLabel = [UILabel createLabelFrame:CGRectMake(LJQ_VIEW_Width(bottomView) - 218, LJQ_VIEW_Height(bottomView) - 20, 200, 13) labelColor:UIColorFromRGB(0xffc898) textAlignment:(NSTextAlignmentRight) textFont:12.f];
    cardLabel.text = @"单笔限1万，单日限1万";
    [bottomView addSubview:cardLabel];
    [self.contentView addSubview:bottomView];
    
    topUpBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    topUpBtn.frame = CGRectMake(20, LJQ_VIEW_MaxY(bottomView) + 114, SCREENWIDTH - 40, 44);
    [topUpBtn setBackgroundImage:[UIImage imageNamed:@"立即充值-置灰"] forState:(UIControlStateNormal)];
    [topUpBtn setBackgroundImage:[UIImage imageNamed:@"立即充值-置灰"] forState:(UIControlStateHighlighted)];
    [topUpBtn addTarget: self action:@selector(topUpEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.contentView addSubview:topUpBtn];
}


- (NSString *)returnIdString:(NSString *)string {
    NSString *str = string;
    for (int length = 0; length < string.length; length++) {
        if (length < string.length - 4) {
            str = [str stringByReplacingCharactersInRange:NSMakeRange(length, 1) withString:@"*"];
        }
    }
    return str;
}

- (NSString *)returnBankString:(NSString *)string {
    NSString *str = [self returnIdString:string];
    NSMutableString *mutable = [NSMutableString stringWithString:str];
    for (int length = 0; length < string.length; length++) {
        if ((length + 1)% 5 == 0) {
            [mutable insertString:@" " atIndex:length];
        }
    }
    
    NSString *endstr = [NSString stringWithFormat:@"%@",mutable];
    return endstr;
}

- (void)changeLength:(UITextField *)textfield {
    if (textfield.text.length != 0) {
        [topUpBtn setBackgroundImage:[UIImage imageNamed:@"立即充值"] forState:(UIControlStateNormal)];
        [topUpBtn setBackgroundImage:[UIImage imageNamed:@"立即充值"] forState:(UIControlStateHighlighted)];
        NSLog(@"111111111");
        return;
    }else {
        [topUpBtn setBackgroundImage:[UIImage imageNamed:@"立即充值-置灰"] forState:(UIControlStateNormal)];
        [topUpBtn setBackgroundImage:[UIImage imageNamed:@"立即充值-置灰"] forState:(UIControlStateHighlighted)];
    }
}

//充值
- (void)topUpEvent:(UIButton *)sender {
    
}

@end
