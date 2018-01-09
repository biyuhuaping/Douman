//
//  LJQSettingUpCell.m
//  豆蔓理财
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQSettingUpCell.h"

@implementation LJQSettingUpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.pitcureView];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        self.nameLabel = [UILabel createLabelFrame:CGRectMake(CGRectGetMaxX(self.pitcureView.frame),0, 100, 50*DMDeviceWidth/375) labelColor:DarkGray textAlignment:(NSTextAlignmentLeft) textFont:15*DMDeviceWidth/375];
    }
    return _nameLabel;
}

- (UIImageView *)pitcureView {
    if (!_pitcureView) {
        self.pitcureView = [[UIImageView alloc] initWithFrame:CGRectMake(50*DMDeviceWidth/375 + spaceline,0, 50*DMDeviceWidth/375, 50*DMDeviceWidth/375)];
        _pitcureView.contentMode =UIViewContentModeCenter;
    }
    return _pitcureView;
}

@end
