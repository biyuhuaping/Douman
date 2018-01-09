//
//  GZFAQTableCell.m
//  豆蔓理财
//
//  Created by armada on 2017/5/5.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "GZFAQTableCell.h"


@implementation GZFAQTableCell

#pragma mark - Initilizer

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Lazy Loading

- (UIImageView *)iconImageView {
    
    if (!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(38);
            make.left.equalTo(self.contentView).offset(12);
            make.width.mas_offset(@43);
            make.height.mas_offset(@43);
        }];
    }
    return _iconImageView;
}

- (UILabel *)questionLabel {
    
    if (!_questionLabel) {
        
        _questionLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_questionLabel];
        [_questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView);
            make.left.equalTo(self.iconImageView.mas_right).offset(11);
        }];
        [_questionLabel setFont:[UIFont systemFontOfSize:14]];
        [_questionLabel setTextColor:UIColorFromRGB(0x505050)];
    }
    return _questionLabel;
}

- (UILabel *)answerLabel {
    
    if (!_answerLabel) {
        
        _answerLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_answerLabel];
        [_answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.questionLabel.mas_bottom).offset(11);
            make.left.equalTo(self.questionLabel);
            make.right.equalTo(self.contentView).offset(-12);
        }];
        [_answerLabel setNumberOfLines:2];
        [_answerLabel setFont:[UIFont systemFontOfSize:11]];
        [_answerLabel setTextColor:UIColorFromRGB(0x8c8c8c)];
    }
    return _answerLabel;
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
