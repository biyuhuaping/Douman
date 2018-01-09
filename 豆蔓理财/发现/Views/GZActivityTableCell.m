//
//  GZActivityTableCell.m
//  豆蔓理财
//
//  Created by armada on 2017/5/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "GZActivityTableCell.h"

@interface GZActivityTableCell ()

/** 内容视图 */
@property(nonatomic, strong) UIView *contentBackgroundView;

@end

@implementation GZActivityTableCell

#pragma mark - Initilizer

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Lazy Loading

- (UIView *)contentBackgroundView {
    
    if (!_contentBackgroundView) {
        
        _contentBackgroundView = [[UIView alloc] init];
        [self.contentView addSubview:_contentBackgroundView];
        [_contentBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(13);
            make.left.equalTo(self.contentView).offset(11);
            make.right.equalTo(self.contentView).offset(-11);
            make.bottom.equalTo(self.contentView).offset(-2);
        }];
        _contentBackgroundView.layer.cornerRadius = 6.0f;
        _contentBackgroundView.layer.borderWidth = 1.0f;
        _contentBackgroundView.layer.borderColor = UIColorFromRGB(0xD8D8D8).CGColor;
        _contentBackgroundView.clipsToBounds = YES;
    }
    return _contentBackgroundView;
}

- (UILabel *)activityTitleLabel {
    
    if (!_activityTitleLabel) {
        
        _activityTitleLabel = [[UILabel alloc] init];
        [self.contentBackgroundView addSubview:_activityTitleLabel];
        [_activityTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentBackgroundView).offset(10);
            make.left.equalTo(self.contentBackgroundView).offset(6);
        }];
        
        [_activityTitleLabel setFont:[UIFont systemFontOfSize:14]];
        [_activityTitleLabel setTextColor:UIColorFromRGB(0x595757)];
    }
    return _activityTitleLabel;
}

- (UILabel *)activityTimeStampLabel {
    
    if (!_activityTimeStampLabel) {
        
        _activityTimeStampLabel = [[UILabel alloc] init];
        [self.contentBackgroundView addSubview:_activityTimeStampLabel];
        [_activityTimeStampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.activityTitleLabel);
            make.right.equalTo(self.contentBackgroundView).offset(-6);
        }];
        
        [_activityTimeStampLabel setFont:[UIFont systemFontOfSize:12]];
        [_activityTimeStampLabel setTextColor:UIColorFromRGB(0x787878)];
    }
    return _activityTimeStampLabel;
}

- (UIImageView *)activityLogoImageView {
    
    if (!_activityLogoImageView) {
        
        _activityLogoImageView = [[UIImageView alloc] init];
        [self.contentBackgroundView addSubview:_activityLogoImageView];
        [_activityLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.activityTitleLabel.mas_bottom).offset(9);
            make.left.right.and.bottom.equalTo(self.contentView);
        }];
        _activityLogoImageView.layer.cornerRadius = 20.0f;
        _activityLogoImageView.clipsToBounds = YES;
    }
    return _activityLogoImageView;
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
