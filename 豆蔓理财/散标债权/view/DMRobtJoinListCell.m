//
//  DMRobtJoinListCell.m
//  豆蔓理财
//
//  Created by edz on 2017/7/18.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMRobtJoinListCell.h"
#import "DMRobtDetailModel.h"
@interface DMRobtJoinListCell ()

@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UILabel *acountLabel;
@property (nonatomic, strong)UILabel *userLabel;
@property (nonatomic, strong)UILabel *timeLabel;

@end

@implementation DMRobtJoinListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self.contentView addSubview:self.bottomView];
        [self.bottomView addSubview:self.acountLabel];
        [self.bottomView addSubview:self.userLabel];
        [self.bottomView addSubview:self.timeLabel];
    }
    return self;
}

- (void)setListModel:(DMRobtDetailModel *)listModel {
    if (_listModel != listModel) {
        _listModel = listModel;
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@",isOrEmpty(_listModel.timeCreated) ? @"--" : _listModel.timeCreated];
    self.userLabel.text = [NSString stringWithFormat:@"%@",isOrEmpty(_listModel.mobile) ? @"--" : _listModel.mobile];
    NSString *amountStr = [self stringFormatterDecimalStyle:isOrEmpty(_listModel.orderAmount) ? @(0) : @([_listModel.orderAmount floatValue])];
    self.acountLabel.text = amountStr;

}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DMDeviceWidth - 40, 54)];
        _bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _bottomView;
}

- (UILabel *)acountLabel {
    if (!_acountLabel) {
        self.acountLabel = [UILabel createLabelFrame:CGRectMake((DMDeviceWidth - 40) - (DMDeviceWidth - 40) / 3, 0, (DMDeviceWidth - 40) / 3, self.frame.size.height) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        _acountLabel.text = [self stringFormatterDecimalStyle:@(5000)];
    }
    return _acountLabel;
}

- (UILabel *)userLabel {
    if (!_userLabel) {
        self.userLabel = [UILabel createLabelFrame:CGRectMake((DMDeviceWidth - 40) / 3, 0, (DMDeviceWidth - 40) / 3, self.frame.size.height) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        _userLabel.text = [self userString:@"18726349871"];
    }
    return _userLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        self.timeLabel = [UILabel createLabelFrame:CGRectMake(0, 0, (DMDeviceWidth - 40) / 3, self.frame.size.height) labelColor:UIColorFromRGB(0x878787) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        _timeLabel.text = @"2017-04-28";
    }
    return _timeLabel;
}

- (NSString *)userString:(NSString *)string {
    NSString *str = string;
    for (int i = 0; i < string.length; i++) {
        if (i > 2 && i < 6) {
            str = [str stringByReplacingCharactersInRange:NSMakeRange(i ,1) withString:@"*"];
        }
    }
    return str;
}

- (NSString *)stringFormatterDecimalStyle:(NSNumber *)money
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.minimumFractionDigits = 2;
    formatter.maximumFractionDigits = 2;
    
    return [formatter stringFromNumber:money];
}

@end
