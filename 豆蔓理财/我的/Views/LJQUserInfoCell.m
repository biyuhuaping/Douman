//
//  LJQUserInfoCell.m
//  豆蔓理财
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQUserInfoCell.h"

@interface LJQUserInfoCell ()

@property (nonatomic, strong)UIButton *button;


@end

@implementation LJQUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.infoLabel];
        [self.contentView addSubview:self.button];
    }
    return self;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        self.nameLabel = [UILabel createLabelFrame:CGRectMake(10, 12, 80, 20) labelColor:UIColorFromRGB(0x878585) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        self.infoLabel = [UILabel createLabelFrame:CGRectMake(110, 12, 200, 20) labelColor:UIColorFromRGB(0x878585) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    }
    return _infoLabel;
}

- (UIButton *)button {
    if (!_button) {
        self.button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.button setFrame:CGRectMake(DMDeviceWidth - 80, 12, 70, 20)];
        [self.button setTitle:@"实名绑卡 >" forState:(UIControlStateNormal)];
        self.button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [self.button setTitleColor:UIColorFromRGB(0x878585) forState:(UIControlStateNormal)];
        [self.button addTarget:self action:@selector(ImmediatelyRealName:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _button;
}

- (void)ImmediatelyRealName:(UIButton *)sender {
    self.realNameBlock(sender);
}

- (void)setIsRealName:(BOOL)isRealName {
    _isRealName = isRealName;
    if (_isRealName) {
        // 实名通过
        self.button.hidden = YES;
    }else {
        self.button.hidden = NO;
    }
}

@end
