//
//  DMCalaulateView.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/2/16.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMCalaulateView.h"

@interface DMCalaulateView ()

@property (nonatomic, strong) UIImageView *titleImage;

@property (nonatomic, strong) UIImageView *detailImage;
@property (nonatomic, strong) UIView *sectionView;

@end


@implementation DMCalaulateView

- (instancetype)initWithInvestAmount:(NSString *)amount Type:(NSString *)type Rate:(NSString *)rate Month:(int)month{
    self = [super init];
    if (self) {
        
        [self addSubview:self.titleImage];
        [self addSubview:self.detailImage];
        [self addSubview:self.sectionView];
        [self setConstraints];
        
        NSArray *titles = @[@"预计认购金额",@"应收利息",@"月收本息"];
        NSString *yuqishouyi=@"";
        NSString *yuejiebenxi=@"";
        CGFloat investAmount = [amount doubleValue];
        CGFloat duration = month;
        CGFloat rates = [rate doubleValue];
        if ([type isEqualToString:@"等额本息"]) {
            CGFloat monthRate = rates / 100 / 12;
            CGFloat yuejiebenxiF = (investAmount * (monthRate * pow(1 + monthRate, duration))/(pow((1 + monthRate), duration) - 1));
            yuejiebenxi = [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",yuejiebenxiF]];
            yuqishouyi = [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",(duration * yuejiebenxiF - investAmount)]];
        }else if ([type isEqualToString:@"按月付息"]){
            yuqishouyi = [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",(investAmount * rates/100/12*duration)]];
            if (month == 1) {
                yuejiebenxi = [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",(investAmount * rates / 100 / 12) + [amount floatValue]]];
            }else{
                yuejiebenxi = [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",(investAmount * rates / 100 / 12)]];
            }
        }
        
        
        NSArray *details = @[amount,yuqishouyi,yuejiebenxi];
        for (int i = 0; i < 3; i ++) {
            UILabel *exceptLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * DMDeviceWidth/3.0, 20, DMDeviceWidth/3.0, 38)];
            exceptLabel.text = titles[i];
            exceptLabel.textColor = UIColorFromRGB(0x4b6ca7);
            exceptLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
            exceptLabel.textAlignment = NSTextAlignmentCenter;
            [self.titleImage addSubview:exceptLabel];
            
            UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * DMDeviceWidth/3.0, 58, DMDeviceWidth/3.0, 38)];
            detailLabel.text = [details[i] stringByAppendingString:@"元"];
            detailLabel.textColor = UIColorFromRGB(0xffd542);
            detailLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
            detailLabel.textAlignment = NSTextAlignmentCenter;
            [self.titleImage addSubview:detailLabel];

            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:detailLabel.text];
            NSString *str = @"元";
            NSRange dayRange = [detailLabel.text rangeOfString:str];
            [hintString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:dayRange];
            detailLabel.attributedText = hintString;

            for (int i = 0; i < 2; i ++ ) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i * DMDeviceWidth/3.0+DMDeviceWidth/3.0, 40, 1, 35)];
                lineView.backgroundColor = UIColorFromRGB(0x23395f);
                [self.titleImage addSubview:lineView];
            }
            
            NSArray *sections = @[@"月份",@"应收本金",@"应收利息",@"剩余本息"];
            for ( int i = 0; i < 4; i ++) {
                UILabel *sectionlabel = [[UILabel alloc] initWithFrame:CGRectMake(i * DMDeviceWidth/4.0, 0, DMDeviceWidth/4.0, 15)];
                sectionlabel.text = sections[i];
                sectionlabel.textColor = UIColorFromRGB(0x86a7e8);
                sectionlabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
                sectionlabel.textAlignment = NSTextAlignmentCenter;
                [self.sectionView addSubview:sectionlabel];
            }
            
        }
        
    }
    return self;
}

- (void)setConstraints{
    
    [self addConstrainsWithVisualFormat:@"H:|[v0]|" Views:@[self.titleImage]];
    [self addConstrainsWithVisualFormat:@"H:|[v0]|" Views:@[self.sectionView]];
    [self addConstrainsWithVisualFormat:@"V:|[v0(==116)]-25-[v1(==18)]-25-[v2(==15)]" Views:@[self.titleImage,self.detailImage,self.sectionView]];
    [self addConstrainsWithVisualFormat:@"H:[v0(==320)]" Views:@[self.detailImage]];
    [self addConstraintWithSetView:self.detailImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.titleImage attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
}

- (UIImageView *)titleImage{
    if (!_titleImage) {
        self.titleImage = [[UIImageView alloc] init];
        _titleImage.image = [UIImage imageNamed:@"calaulate_titleview"];
    }
    return _titleImage;
}

- (UIImageView *)detailImage{
    if (!_detailImage) {
        self.detailImage = [[UIImageView alloc] init];
        _detailImage.image = [UIImage imageNamed:@"本息回收详情表"];
    }
    return _detailImage;
}

- (UIView *)sectionView{
    if (_sectionView == nil) {
        self.sectionView = [[UIView alloc] init];
    }
    return _sectionView;
}


@end
