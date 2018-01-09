//
//  GZDashboardTableCell.m
//  豆蔓理财
//
//  Created by armada on 2017/5/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "GZDashboardTableCell.h"

@interface GZDashboardTableCell()

/** 分割线 */
@property(nonatomic, strong) UIView *separatorLine;

@end

@implementation GZDashboardTableCell

#pragma mark - Initilizer

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_separatorLine) {
            
            _separatorLine = [[UIView alloc] init];
            [self.contentView addSubview:_separatorLine];
            [_separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(10);
                make.right.equalTo(self.contentView).offset(-10);
                make.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(@1);
            }];
            _separatorLine.backgroundColor = UIColorFromRGB(0xD8D8D8);
        }
    }
    return self;
}

#pragma mark - Lazy Loading

- (UILabel *)notificationTitleLabel {
    
    if (!_notificationTitleLabel) {
        
        _notificationTitleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_notificationTitleLabel];
        [_notificationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(17);
            make.left.equalTo(self.contentView).offset(11);
        }];
        
        [_notificationTitleLabel setFont:[UIFont systemFontOfSize:14]];
        [_notificationTitleLabel setTextColor:UIColorFromRGB(0x595757)];
    }
    return _notificationTitleLabel;
}

- (UILabel *)notificationTimeStampLabel {
    
    if (!_notificationTimeStampLabel) {
        
        _notificationTimeStampLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_notificationTimeStampLabel];
        [_notificationTimeStampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.notificationTitleLabel);
            make.right.equalTo(self.contentView).offset(-6);
        }];
        
        [_notificationTimeStampLabel setFont:[UIFont systemFontOfSize:12]];
        [_notificationTimeStampLabel setTextColor:UIColorFromRGB(0x787878)];
    }
    return _notificationTimeStampLabel;
}

- (UILabel *)notificationSummaryLabel {
    
    if (!_notificationSummaryLabel) {
        
        _notificationSummaryLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_notificationSummaryLabel];
        [_notificationSummaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.notificationTitleLabel.mas_bottom).offset(16);
            make.left.equalTo(self.contentView).offset(11);
            make.right.equalTo(self.contentView).offset(-11);
        }];
        
        [_notificationSummaryLabel setFont:[UIFont systemFontOfSize:12]];
        [_notificationSummaryLabel setTextColor:UIColorFromRGB(0x787878)];
        [_notificationSummaryLabel setNumberOfLines:3];
    }
    return _notificationSummaryLabel;
}

#pragma mark - awakeFromNib

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
