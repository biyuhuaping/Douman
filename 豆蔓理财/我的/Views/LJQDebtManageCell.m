//
//  LJQDebtManageCell.m
//  豆蔓理财
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQDebtManageCell.h"

@interface LJQDebtManageCell ()

@property (nonatomic, strong)UILabel *titleLabel; //标题
@property (nonatomic, strong)UILabel *investmentLabel; //投资金额
@property (nonatomic, strong)UILabel *timeLimitLabel; //期限
@property (nonatomic, strong)UIButton *transferButton; //转让

@property (nonatomic, strong)UILabel *createDateLabel;

@property (nonatomic, strong)UIButton *contractButton; //合同按钮

@property (nonatomic, strong)NSArray<NSString *> *tittleArr;

@property (nonatomic, strong)UIView *bottomView;

@property (nonatomic, strong)UIView *centerView;
@end

@implementation LJQDebtManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self.contentView addSubview:self.centerView];
        
        [self.centerView addSubview:self.titleLabel];
        [self.centerView addSubview:self.investmentLabel];
        [self.centerView addSubview:self.timeLimitLabel];
        [self.centerView addSubview:self.createDateLabel];
        [self.centerView addSubview:self.contractButton];
        [self.centerView addSubview:self.transferButton];
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
        _investmentLabel = [UILabel createLabelFrame:CGRectMake(25, 55, (SCREENWIDTH - 36) / 3, 32) labelColor:UIColorFromRGB(0xfb9e1c) textAlignment:(NSTextAlignmentCenter) textFont:31.f];
    }
    return _investmentLabel;
}

- (UILabel *)timeLimitLabel {
    if (!_timeLimitLabel) {
        _timeLimitLabel = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH - 36) / 3 + 25, 66, (SCREENWIDTH - 36) / 3, 21) labelColor:UIColorFromRGB(0xfb9e1c) textAlignment:(NSTextAlignmentCenter) textFont:20.f];
    }
    return _timeLimitLabel;
}

- (UILabel *)createDateLabel {
    if (!_createDateLabel) {
        _createDateLabel = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH - 36) / 3 * 2 + 25, 66, (SCREENWIDTH - 36) / 3, 21) labelColor:UIColorFromRGB(0xfb9e1c) textAlignment:(NSTextAlignmentCenter) textFont:20.f];
    }
    return _createDateLabel;
}

- (UIButton *)transferButton {
    if (!_transferButton) {
        UIImage *image = [UIImage imageNamed:@"transferAction"];
        _transferButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_transferButton setFrame:CGRectMake(((SCREENWIDTH - 36) / 3 - image.size.width) / 2 + (SCREENWIDTH - 36) / 3 * 2 + 25, 60, image.size.width, image.size.height)];
        [_transferButton addTarget:self action:@selector(transferAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _transferButton;
}

- (void)transferAction:(UIButton *)sender {
    if (self.debtTransferType == LJQDebttransferUse) {
        // 可转让
        NSLog(@"可转让");
    }else {
        // 转让中
        NSLog(@"转让中");
    }
}

//合同
- (UIButton *)contractButton {
    if (!_contractButton) {
    
        _contractButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_contractButton setTitle:@"合同+" forState:(UIControlStateNormal)];
        
        [_contractButton setTitleColor:UIColorFromRGB(0x595757) forState:(UIControlStateNormal)];
        _contractButton.backgroundColor = UIColorFromRGB(0xffffff);
        _contractButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        _contractButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _contractButton.frame = CGRectMake( SCREENWIDTH - 39 - 11, 0, 40, 40);
        [_contractButton addTarget:self action:@selector(contractAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _contractButton;
}

//合同事件
- (void)contractAction:(UIButton *)sender {
    if (self.contractJump) {
        self.contractJump(sender);
    }
}

- (void)setDebtTransferType:(LJQDebttransferType)debtTransferType {
    _debtTransferType = debtTransferType;
    switch (debtTransferType) {
        case LJQDebttransferUse:
         //可转让
        {
            self.tittleArr = @[@"投资金额",@"剩余期限"];
            [self.bottomView removeFromSuperview];
            [self createUI:self.tittleArr];
            
            NSRange range = [@"10000元" rangeOfString:@"元"];
            self.investmentLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:range text:@"10000元" length:YES];
            
            NSRange rang1 = [@"30天" rangeOfString:@"天"];
            self.timeLimitLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:rang1 text:@"30天" length:YES];
            
            self.transferButton.hidden = NO;
            self.createDateLabel.hidden = YES;
            self.contractButton.hidden = YES;
            
            [self.transferButton setBackgroundImage:[UIImage imageNamed:@"transferAction"] forState:(UIControlStateNormal)];
        }
            break;
            case LJQDebttransferUseing:
        //转让中
        {
            self.tittleArr = @[@"转让本金",@"已转金额"];
             [self.bottomView removeFromSuperview];
             [self createUI:self.tittleArr];
            
            NSRange range = [@"10000元" rangeOfString:@"元"];
            self.investmentLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:range text:@"10000元" length:YES];
            
            NSRange rang1 = [@"30元" rangeOfString:@"元"];
            self.timeLimitLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:rang1 text:@"30元" length:YES];
            
             self.transferButton.hidden = NO;
            self.createDateLabel.hidden = YES;
            self.contractButton.hidden = YES;
            
             [self.transferButton setBackgroundImage:[UIImage imageNamed:@"cancelAction"] forState:(UIControlStateNormal)];
        }
            break;
            case LJQDebttransferUsed:
        //已转让
        {
            self.tittleArr = @[@"转让本金",@"到手金额",@"转让成交时间"];
             [self.bottomView removeFromSuperview];
             [self createUI:self.tittleArr];
            
            NSRange range = [@"10000元" rangeOfString:@"元"];
            self.investmentLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:range text:@"10000元" length:YES];
            
            NSRange rang1 = [@"30元" rangeOfString:@"元"];
            self.timeLimitLabel.attributedText = [self LJQLabelAttributeDic:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} textRange:rang1 text:@"30元" length:YES];
            
            self.createDateLabel.text = @"2017-12-10";
            
             self.transferButton.hidden = YES;
            self.createDateLabel.hidden = NO;
            self.contractButton.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)createUI:(NSArray *)textArr {
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, SCREENWIDTH / 3 * textArr.count, 13)];
    self.bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    for (UILabel *label in self.bottomView.subviews) {
        [label removeFromSuperview];
    }
    for (int i = 0; i < textArr.count; i++) {
        UILabel *label = [UILabel createLabelFrame:CGRectMake((SCREENWIDTH - 36) / 3 * i + 25, 0, (SCREENWIDTH - 36) / 3, 12) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
        label.text = textArr[i];
        [self.bottomView addSubview:label];
    }
    [self.contentView addSubview:self.bottomView];
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

#pragma lazyLoading
- (NSArray<NSString *> *)tittleArr {
    if (!_tittleArr) {
        _tittleArr = [@[] copy];
    }
    return _tittleArr;
}


@end
