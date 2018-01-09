//
//  LJQTransferFinishCell.m
//  豆蔓理财
//
//  Created by mac on 2017/5/5.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQTransferFinishCell.h"

@interface LJQTransferFinishCell ()

@property (nonatomic, strong)UILabel *titleLabel; //标题

@property (nonatomic, strong)UILabel *investAmountLabel; //投资金额
@property (nonatomic, strong)UILabel *remainLimitLabel; //剩余期限
@property (nonatomic, strong)UILabel *currentInterestLabel; //当前产生利息
@property (nonatomic, strong)UILabel *receivableLabel; //回款日

@property (nonatomic, strong)UILabel *serviceLabel; //服务费
@property (nonatomic, strong)UILabel *earnLabel; //预计收益

@property (nonatomic, strong)UIButton *selectedButton;

@property (nonatomic, strong)UIButton *confirmButton;
@end

@implementation LJQTransferFinishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.investAmountLabel];
        [self.contentView addSubview:self.remainLimitLabel];
        [self.contentView addSubview:self.currentInterestLabel];
        [self.contentView addSubview:self.receivableLabel];
        [self.contentView addSubview:self.serviceLabel];
        [self.contentView addSubview:self.earnLabel];
        [self.contentView addSubview:self.confirmButton];
        
        [self.contentView addSubview:[self createView]];
        [self createLabel];
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

- (UILabel *)investAmountLabel {
    if (!_investAmountLabel) {
        _investAmountLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 3 - 11, 41 + 13, DMDeviceWidth / 3 * 2, 14) labelColor:UIColorFromRGB(0xfb9e1c) textAlignment:(NSTextAlignmentRight) textFont:13.f];
        _investAmountLabel.text = @"500.00元";
    }
    return _investAmountLabel;
}

- (UILabel *)remainLimitLabel {
    if (!_remainLimitLabel) {
        _remainLimitLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 3 - 11, 54 + 41, DMDeviceWidth / 3 * 2, 14) labelColor:UIColorFromRGB(0xfb9e1c) textAlignment:(NSTextAlignmentRight) textFont:13.f];
        _remainLimitLabel.text = @"30天";
    }
    return _remainLimitLabel;
}

- (UILabel *)currentInterestLabel {
    if (!_currentInterestLabel) {
        _currentInterestLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 3 - 11, 54 + 41 * 2, DMDeviceWidth / 3 * 2, 14) labelColor:UIColorFromRGB(0xfb9e1c) textAlignment:(NSTextAlignmentRight) textFont:13.f];
        _currentInterestLabel.text = @"2.55元";
    }
    return _currentInterestLabel;
}

- (UILabel *)receivableLabel {
    if (!_receivableLabel) {
        _receivableLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 3 - 11, 54 + 41 * 3, DMDeviceWidth / 3 * 2, 14) labelColor:UIColorFromRGB(0xfb9e1c) textAlignment:(NSTextAlignmentRight) textFont:13.f];
        _receivableLabel.text = @"2017-05-08";
    }
    return _receivableLabel;
}

- (UILabel *)serviceLabel {
    if (!_serviceLabel) {
        _serviceLabel = [UILabel createLabelFrame:CGRectMake(25, 54 + 41 * 4, DMDeviceWidth / 2, 14) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentLeft) textFont:13.f];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 54 + 41 * 4 + 27, SCREENWIDTH, 1)];
        view.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self.contentView addSubview:view];
        
        NSString *string = [NSString stringWithFormat:@"服务费：4.85元"];
        NSRange range = [string rangeOfString:@"："];
        _serviceLabel.attributedText = [self returnAttributeWithString:string range:range length:string.length - range.location - 1 color:UIColorFromRGB(0xfb9e1c)];
    }
    return _serviceLabel;
}

- (UILabel *)earnLabel {
    if (!_earnLabel) {
        _earnLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 2  - 11, 54 + 41 * 4, DMDeviceWidth / 2, 14) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentRight) textFont:13.f];
        NSString *string = [NSString stringWithFormat:@"预计收益：100.45元"];
        NSRange range = [string rangeOfString:@"："];
        _earnLabel.attributedText = [self returnAttributeWithString:string range:range length:string.length - range.location - 1 color:UIColorFromRGB(0xfb9e1c)];
    }
    return _earnLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        UIImage *image = [UIImage imageNamed:@"确认转让-可点击"];
        _confirmButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_confirmButton setBackgroundImage:image forState:(UIControlStateNormal)];
        [_confirmButton setFrame:CGRectMake((DMDeviceWidth - image.size.width) / 2, 54 + 41 * 6 + 13, image.size.width, image.size.height)];
        [_confirmButton addTarget:self action:@selector(confirmTransferAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _confirmButton;
}

- (UIView *)createView {
    UIImage *image = [UIImage imageNamed:@"勾选框"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 54 + 41 * 5, DMDeviceWidth, 20)];
    
    self.selectedButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.selectedButton setFrame:CGRectMake(0, 0, 0, 0)];
    [self.selectedButton setBackgroundImage:image forState:(UIControlStateNormal)];
    [self.selectedButton addTarget:self action:@selector(changestatus:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel *label = [UILabel createLabelFrame:CGRectMake(0, 0, 0, 14) labelColor:UIColorFromRGB(0x999999) textAlignment:(NSTextAlignmentLeft) textFont:13];
    label.numberOfLines = 0;
    NSString *string = [NSString stringWithFormat:@"已阅读，并同意<债权转让及受让协议>"];
    NSRange range = [string rangeOfString:@"意"];
    label.attributedText = [self returnAttributeWithString:string range:range length:string.length - range.location - 1 color:UIColorFromRGB(0x47b994)];
    
    CGFloat height = [self returenLabelHeight:string size:CGSizeMake(300, 60) fontsize:14 isWidth:NO];
    CGFloat width = [self returenLabelHeight:string size:CGSizeMake(300, 60) fontsize:14 isWidth:YES];
    
    [view setFrame:CGRectMake(0, 54 + 41 * 5, DMDeviceWidth, height)];
    [self.selectedButton setFrame:CGRectMake(25, (height - image.size.height) / 2, image.size.width, image.size.height)];
    
    [label DM_addAttributeTapActionWithStrings:@[@"<债权转让及受让协议>"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        NSLog(@"跳转协议");
    }];
    
    [label setFrame:CGRectMake(LJQ_VIEW_MaxX(self.selectedButton) + 3, 0, width, height)];
    [view addSubview:self.selectedButton];
    [view addSubview:label];
    return view;
}

- (void)changestatus:(UIButton *)sender {
    if (sender.selected) {
        [sender setBackgroundImage:[UIImage imageNamed:@"勾选框"] forState:(UIControlStateNormal)];
         [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"确认转让-可点击"] forState:(UIControlStateNormal)];
        sender.selected = !sender.selected;
    }else {
        [sender setBackgroundImage:[UIImage imageNamed:@"未勾选框"] forState:(UIControlStateNormal)];
        [self.confirmButton setBackgroundImage:[UIImage imageNamed:@"确认转让-不可点击"] forState:(UIControlStateNormal)];
        sender.selected = !sender.selected;
    }
}

//确认转让
- (void)confirmTransferAction:(UIButton *)sender {
    if (self.selectedButton.selected) {
       
    }else {
        
        if (self.confirmTransfer) {
            self.confirmTransfer(sender);
        }
    }
}

- (void)createLabel {
    NSArray<NSString *> *array = @[@"投资金额",@"剩余期限",@"当前产生利息",@"下个回款日"];
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [UILabel createLabelFrame:CGRectMake(25, 41 + 13 + 41 * i, 200, 14) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentLeft) textFont:13.f];
        label.text = array[i];
        
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 41 + 40 * (i + 1), DMDeviceWidth, 1)];
            view.backgroundColor = UIColorFromRGB(0xf3f3f3);
            [self.contentView addSubview:view];
        [self.contentView addSubview:label];
    }
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
