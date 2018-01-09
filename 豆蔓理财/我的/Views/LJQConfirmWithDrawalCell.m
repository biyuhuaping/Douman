//
//  LJQConfirmWithDrawalCell.m
//  豆蔓理财
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQConfirmWithDrawalCell.h"

@interface LJQConfirmWithDrawalCell ()

@property (nonatomic, strong)UILabel *withDrawalAcountLabel;
@property (nonatomic, strong)UILabel *poundageLabel;

@end

@implementation LJQConfirmWithDrawalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createAccountView];
        [self createWithDrawalView];
    }
    return self;
}

- (void)createAccountView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 114)];
    bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    UILabel *label = [UILabel createLabelFrame:CGRectMake(20, 10, 200, 13) labelColor:UIColorFromRGB(0x585757) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    label.text = @"提现金额(元)";
    
    self.amountLabel = [UILabel createLabelFrame:CGRectMake(20, LJQ_VIEW_MaxY(label) + 28, SCREENWIDTH, 30) labelColor:UIColorFromRGB(0x3e3e3e) textAlignment:(NSTextAlignmentLeft) textFont:28.f];
    self.amountLabel.text = @"--";
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 113.5 , SCREENWIDTH, 0.5)];
    line1.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [bottomView addSubview:line1];
    [bottomView addSubview:label];
    [bottomView addSubview:self.amountLabel];
    [self.contentView addSubview:bottomView];
}

- (void)createWithDrawalView {
    UIImage *image = [UIImage imageNamed:@"withdrawal"];
    
    UIImageView *pitcureView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    pitcureView1.center = CGPointMake(20 + image.size.width / 2, 24 + 114);
    pitcureView1.image = [UIImage imageNamed:@"提现手续费"];
    [self.contentView addSubview:pitcureView1];
    
    UILabel *nameLabel = [UILabel createLabelFrame:CGRectMake(LJQ_VIEW_MaxX(pitcureView1) + 10, 16 + 114 , 150, 16) labelColor:UIColorFromRGB(0x6d727a) textAlignment:(NSTextAlignmentLeft) textFont:14.f];
    nameLabel.text = @"提现手续费";
    [self.contentView addSubview:nameLabel];
    
    self.poundageLabel = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH - 220, 16 + 114, 200, 16) labelColor:UIColorFromRGB(0x2ac580) textAlignment:(NSTextAlignmentRight) textFont:14.f];
    self.poundageLabel.text = @"无手续费";
    [self.contentView addSubview:self.poundageLabel];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 47.5 + 114, SCREENWIDTH, 0.5)];
    line1.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self.contentView addSubview:line1];
    
    
    
    UIImageView *pitcureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    pitcureView.center = CGPointMake(20 + image.size.width / 2, 72 + 114);
    pitcureView.image = image;
    [self.contentView addSubview:pitcureView];

    
    UILabel *nameLabel1 = [UILabel createLabelFrame:CGRectMake(LJQ_VIEW_MaxX(pitcureView) + 10, 64 + 114, 150, 16) labelColor:UIColorFromRGB(0x6d727a) textAlignment:(NSTextAlignmentLeft) textFont:14.f];
    nameLabel1.text = @"实际到账金额";
    [self.contentView addSubview:nameLabel1];
    
    self.withDrawalAcountLabel = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH - 220, 64 + 114, 200, 16) labelColor:UIColorFromRGB(0x2ac580) textAlignment:(NSTextAlignmentRight) textFont:14.f];
    self.withDrawalAcountLabel.text = @"--元";
    [self.contentView addSubview:self.withDrawalAcountLabel];

    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 95.5 + 114, SCREENWIDTH, 0.5)];
    line2.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [self.contentView addSubview:line2];

    UIImageView *pitcureView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    pitcureView3.center = CGPointMake(20 + image.size.width / 2, 120 + 114);
    pitcureView3.image = [UIImage imageNamed:@"交易密码"];
//    [self.contentView addSubview:pitcureView3];
    
    self.textField = [[CustomTextField alloc] initWithFrame:CGRectMake(LJQ_VIEW_MaxX(pitcureView3), 101 + 114, 200, 40) PlaceHoldFont:12 PlaceHoldColor:UIColorFromRGB(0xa8abb1)];
    self.textField.font = [UIFont systemFontOfSize:14.f];
    self.textField.secureTextEntry = YES;
    self.textField.textColor = UIColorFromRGB(0x6d727a);
    self.textField.placeholder = @"请输入交易密码";
    self.textField.keyboardType = UIKeyboardTypePhonePad;
    [self.textField addTarget:self action:@selector(limitLength:) forControlEvents:(UIControlEventEditingChanged)];
//    [self.contentView addSubview:self.textField];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 143.5 + 114, SCREENWIDTH, 0.5)];
    line3.backgroundColor = UIColorFromRGB(0xf3f3f3);
//    [self.contentView addSubview:line3];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"忘记交易密码" forState:(UIControlStateNormal)];
    [button setTitleColor:UIColorFromRGB(0xa8abb1) forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [button setFrame:CGRectMake(SCREENWIDTH - 100, 144 + 114 + 22, 90, 20)];
    [button addTarget:self action:@selector(forgetPassWord:) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.contentView addSubview:button];
}

- (void)limitLength:(UITextField *)textField {
    if (textField.text.length > 6) {
       textField.text = [textField.text substringToIndex:6];
    }
}

- (void)layoutSubviews {
    NSNumber *money = [self stringByNumber:self.amountLabel.text];
    
    if ([SOURCE isEqualToString:@"BACK"]) {
        //借款人不需要手续费
        self.poundageLabel.text = @"无手续费";
        self.withDrawalAcountLabel.text = [NSString stringWithFormat:@"%.2f元",[money doubleValue]];
    }else {
        if ( [money doubleValue] >= 0 && [money doubleValue] < 3) {
            self.poundageLabel.text = @"无手续费";
            self.withDrawalAcountLabel.text = [NSString stringWithFormat:@"%.2f元",[money doubleValue]];
        }else {
            if ([money doubleValue] > 50000) {
                self.poundageLabel.text = @"5.00元";
                
                double number = [money doubleValue] - 5.00;
                self.withDrawalAcountLabel.text = [NSString stringWithFormat:@"%.2f元",number];
            }else {
                self.poundageLabel.text = @"2.00元";
                
                double number = [money doubleValue] - 2.00;
                self.withDrawalAcountLabel.text = [NSString stringWithFormat:@"%.2f元",number];
            }
            
        }
    }
}


- (NSNumber *)stringByNumber:(NSString *)money {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    return [formatter numberFromString:money];

}

- (void)forgetPassWord:(UIButton *)sender {
    self.forgetPW(sender);
}


@end
