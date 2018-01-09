//
//  DMCreditAssetDesCell.m
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/12.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMCreditAssetDesCell.h"

@interface  DMCreditAssetDesCell ()

@property (nonatomic, strong) UILabel *descripteLabel;

@end

@implementation DMCreditAssetDesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.text = @"资产描述";
        [self.contentView addSubview:self.descripteLabel];
    }
    return self;
}

- (UILabel *)descripteLabel{
    if (_descripteLabel == nil) {
        self.descripteLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, DMDeviceWidth -30, 200)];
        _descripteLabel.text = @"";
        _descripteLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        _descripteLabel.textColor = DarkGray; ////////////////4b6ca7
        _descripteLabel.numberOfLines = 0;
    }
    return _descripteLabel;
}

- (void)setLoanDescript:(NSString *)descript{
    _descripteLabel.text = descript;
    CGRect rect = [_descripteLabel.text boundingRectWithSize:CGSizeMake(DMDeviceWidth -30, MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:12]}
                                                     context:nil];
    _descripteLabel.frame = CGRectMake(15, 55, DMDeviceWidth-30, rect.size.height);

}

@end
