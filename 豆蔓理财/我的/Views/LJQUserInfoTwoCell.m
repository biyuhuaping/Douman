//
//  LJQUserInfoTwoCell.m
//  豆蔓理财
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQUserInfoTwoCell.h"

@interface LJQUserInfoTwoCell ()

@property (nonatomic, strong)UIImageView *pitcureView;
@property (nonatomic, strong)UILabel *numberLabel;
@property (nonatomic, strong)UILabel *bankNameLabel;
@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UIView *bottomView1;
@property (nonatomic, strong)UIView *bottomView2;

@end

@implementation LJQUserInfoTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf3f3f3);
    }
    return self;
}

- (void)setUp {
    
    self.bottomView1 = [[UIView alloc] initWithFrame:self.bounds];
    self.bottomView1.backgroundColor = UIColorFromRGB(0xf3f3f3);
    UIImage *image = [UIImage imageNamed:@"北京"];
    self.pitcureView = [[UIImageView alloc] initWithFrame:CGRectMake(27, (LJQ_VIEW_Height(self.bottomView1) - image.size.height) / 2, image.size.width, image.size.height)];
    self.pitcureView.image = image;
    self.pitcureView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [self.bottomView1 addSubview:self.pitcureView];
    
    self.numberLabel = [UILabel createLabelFrame:CGRectMake(CGRectGetMaxX(self.pitcureView.frame) + 22, 17, 300, 16) labelColor:UIColorFromRGB(0x878585) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    self.numberLabel.text = @"12314321423421";
    [self.bottomView1 addSubview:self.numberLabel];
    
    self.bankNameLabel = [UILabel createLabelFrame:CGRectMake(CGRectGetMaxX(self.pitcureView.frame) + 22, CGRectGetMaxY(self.numberLabel.frame) + 6, 75, 13) labelColor:UIColorFromRGB(0x878585) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
    self.bankNameLabel.text = @"中国农业银行";
    [self.bottomView1 addSubview:self.bankNameLabel];
    
    self.typeLabel = [UILabel createLabelFrame:CGRectMake(CGRectGetMaxX(self.bankNameLabel.frame), CGRectGetMaxY(self.numberLabel.frame) + 6, 100, 13) labelColor:UIColorFromRGB(0x878585) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
    self.typeLabel.text = @"储蓄卡";
    [self.bottomView1 addSubview:self.typeLabel];
    [self.contentView addSubview:self.bottomView1];
}

- (void)createBtn {
    self.bottomView2 = [[UIView alloc] init];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIImage *image = [UIImage imageNamed:@"添加银行卡"];
    [button setBackgroundImage:image forState:(UIControlStateNormal)];
    [button setBackgroundImage:image forState:(UIControlStateHighlighted)];
    [button setFrame:CGRectMake(0, 0, DMDeviceWidth, image.size.height * DMDeviceWidth / image.size.width)];
    [button addTarget:self action:@selector(addbankCard:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bottomView2 setFrame:CGRectMake(0, 0, DMDeviceWidth, image.size.height * DMDeviceWidth / image.size.width)];
    [self.bottomView2 addSubview:button];
    [self.contentView addSubview:self.bottomView2];
}


- (void)setIsCard:(BOOL)isCard {
    _isCard = isCard;
    [self.bottomView1 removeFromSuperview];
    [self.bottomView2 removeFromSuperview];
    if (_isCard) {
        [self setUp];
    }else {
        [self createBtn];
    }
}

- (void)addbankCard:(UIButton *)sender {
    if (self.addBankBlock) {
        self.addBankBlock(sender);
    }
}

- (void)setModel:(LJQUserInfoModel *)model {
    if (_model != model) {
        _model = model;
    }
    self.numberLabel.text = [self returnIdString:_model.account];
    self.bankNameLabel.text = _model.bank;
    NSString *string = [NSString stringWithFormat:@"%@银行",_model.bank];
    self.pitcureView.image = [UIImage imageNamed:string];
    [self.bankNameLabel setFrame:CGRectMake(CGRectGetMaxX(self.pitcureView.frame) + 22, CGRectGetMaxY(self.numberLabel.frame) + 6, [self returenWith:_model.bank], 13)];
    [self.typeLabel setFrame:CGRectMake(CGRectGetMaxX(self.bankNameLabel.frame), CGRectGetMaxY(self.numberLabel.frame) + 6, 100, 13)];
}

- (CGFloat)returenWith:(NSString *)string {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(200, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil];
    return rect.size.width;
}

- (NSString *)returnIdString:(NSString *)string {
    NSString *str = string;
    for (int length = 0; length < string.length; length++) {
        if (length > 3 && length < string.length - 4) {
            str = [str stringByReplacingCharactersInRange:NSMakeRange(length, 1) withString:@"*"];
        }
    }
    return str;
}

@end
