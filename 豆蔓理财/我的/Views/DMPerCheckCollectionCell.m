//
//  DMPerCheckCollectionCell.m
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/13.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMPerCheckCollectionCell.h"

@implementation DMPerCheckCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.typeImage];
        [self.contentView addSubview:self.isPass];

    }
    return self;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
        _typeLabel.textColor = UIColorFromRGB(0x4b5159);
        _typeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _typeLabel;
}

- (UIImageView *)typeImage{
    if (!_typeImage) {
        self.typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    }
    return _typeImage;
}

- (UIImageView *)isPass{
    if (!_isPass) {
        self.isPass = [[UIImageView alloc] initWithFrame:CGRectMake(DMDeviceWidth/2-26, 9, 12, 12)];
        _isPass.image = [UIImage imageNamed:@"certification_ok_icon"]; //////////////审核通过
    }
    return _isPass;
}



@end
