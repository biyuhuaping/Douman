//
//  LJQBuyListCell.m
//  豆蔓理财
//
//  Created by mac on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQBuyListCell.h"

@implementation LJQBuyListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.acountLabel];
        [self.contentView addSubview:self.userLabel];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (UILabel *)acountLabel {
    if (!_acountLabel) {
        self.acountLabel = [UILabel createLabelFrame:CGRectMake(0, 0, SCREENWIDTH / 3, self.frame.size.height) labelColor:UIColorFromRGB(0x696969) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
    }
    return _acountLabel;
}

- (UILabel *)userLabel {
    if (!_userLabel) {
        self.userLabel = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH / 3, 0, SCREENWIDTH / 3, self.frame.size.height) labelColor:UIColorFromRGB(0x696969) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
    }
    return _userLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        self.timeLabel = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH - SCREENWIDTH / 3, 0, SCREENWIDTH / 3, self.frame.size.height) labelColor:UIColorFromRGB(0x696969) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
    }
    return _timeLabel;
}

- (NSString *)userString:(NSString *)string {
    NSString *str = string;
    for (int i = 0; i < string.length; i++) {
        if (i > 6) {
            str = [str stringByReplacingCharactersInRange:NSMakeRange(i ,1) withString:@"*"];
        }
    }
    return str;
}

@end
