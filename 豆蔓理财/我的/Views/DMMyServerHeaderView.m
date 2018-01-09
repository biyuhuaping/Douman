//
//  DMMyServerHeaderView.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/14.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMMyServerHeaderView.h"
#import "MenuButton.h"
#import "DMMyServerModel.h"
@interface DMMyServerHeaderView ()<MenuButtonDelegate>


@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *rateTitle;

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *midLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) MenuButton *menuButton;
@property (nonatomic, strong) UIView *botmidLine;
@property (nonatomic, strong) UIView *botView;

@end

@implementation DMMyServerHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf6f5fa);
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.rateTitle];
        [self.contentView addSubview:self.leftLabel];
        [self.contentView addSubview:self.midLabel];
        [self.contentView addSubview:self.rightLabel];

        for (int i = 1; i < 3; i ++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i * DMDeviceWidth/3, 130, 1, 50)];
            lineView.backgroundColor = UIColorFromRGB(0xf6f5fa);
            [self.contentView addSubview:lineView];
        }
        
        
        
        [self addSubview:self.botView];
        [self addSubview:self.botmidLine];
        [self addSubview:self.menuButton];
    }
    return self;
}


- (void)setServerModel:(DMMyServerModel *)serverModel{
    _serverModel = serverModel;
    
    self.moneyLabel.text = [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",serverModel.totalAmount]];
    self.leftLabel.text = [NSString insertCommaWithString:[NSString stringWithFormat:@"%.2f",serverModel.totalInterest]];
    self.midLabel.text = [NSString stringWithFormat:@"%d",serverModel.robotCount];
    self.rightLabel.text = [NSString stringWithFormat:@"%.1f%%",serverModel.usageRate];
    
    NSMutableAttributedString *rateStr=[[NSMutableAttributedString alloc]initWithString:self.moneyLabel.text];
    [rateStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Light" size:17] range:NSMakeRange(self.moneyLabel.text.length-2, 2)];
    self.moneyLabel.attributedText = rateStr;

}






- (UIView *)contentView{
    if (!_contentView) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth, 195)];
        _contentView.backgroundColor = UIColorFromRGB(0xffffff);
        
        NSArray *titleArray = @[@"已结收益总额(元)",@"当前持有服务",@"总资金使用率"];
        for (int i = 0; i < 3; i ++) {
            UILabel *botLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth*i/3, 160, DMDeviceWidth/3, 20)];
            botLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
            botLabel.textColor = UIColorFromRGB(0x878787);
            botLabel.textAlignment = NSTextAlignmentCenter;
            botLabel.text = titleArray[i];
            [_contentView addSubview:botLabel];
        }
    }
    return _contentView;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, DMDeviceWidth, 32)];
//        _moneyLabel.text = @"20000.00";
        _moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:25];
        _moneyLabel.textColor = MainRed;
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

- (UILabel *)rateTitle{
    if (!_rateTitle) {
        self.rateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, DMDeviceWidth, 30)];
        _rateTitle.text = @"服务持有总额(元)";
        _rateTitle.textAlignment = NSTextAlignmentCenter;
        _rateTitle.textColor = UIColorFromRGB(0x878787);
        _rateTitle.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    }
    return _rateTitle;
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, DMDeviceWidth/3, 25)];
//        _leftLabel.text = @"217.92";
        _leftLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15];
        _leftLabel.textColor = UIColorFromRGB(0x505050);
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}

- (UILabel *)midLabel{
    if (!_midLabel) {
        self.midLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth/3, 130, DMDeviceWidth/3, 25)];
//        _midLabel.text = @"50";
        _midLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15];
        _midLabel.textColor = UIColorFromRGB(0x505050);
        _midLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _midLabel;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(DMDeviceWidth*2/3, 130, DMDeviceWidth/3, 25)];
//        _rightLabel.text = @"12.5%";
        _rightLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15];
        _rightLabel.textColor = UIColorFromRGB(0x505050);
        _rightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightLabel;
}

- (MenuButton *)menuButton{
    if (!_menuButton) {
        self.menuButton = [[MenuButton alloc] initWithFrame:CGRectMake(0, 203, DMDeviceWidth, 44) TitleArray:@[@"服务中",@"已结束"] SelectColor:UIColorFromRGB(0x00c79f) UnselectColor:UIColorFromRGB(0x4b5159)];
        _menuButton.delegate = self;
    }
    return _menuButton;
}
- (UIView *)botmidLine{
    if (!_botmidLine) {
        self.botmidLine = [[UIView alloc] initWithFrame:CGRectMake(DMDeviceWidth/2, 203, 1, 44)];
        _botmidLine.backgroundColor = UIColorFromRGB(0xf6f5fa);
    }
    return _botmidLine;
}

- (UIView *)botView{
    if (!_botView) {
        self.botView = [[UIView alloc] initWithFrame:CGRectMake(0, 203, DMDeviceWidth, 44)];
        _botView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _botView;
}
- (void)selectButtonWithIndex:(NSInteger)index{
    if (self.SelectButton) {
        self.SelectButton(index);
    }
}


@end
