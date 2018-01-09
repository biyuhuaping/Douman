//
//  GZProtocolListTableViewCell.m
//  豆蔓理财
//
//  Created by armada on 2017/3/30.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "GZProtocolListTableViewCell.h"

@interface GZProtocolListTableViewCell ()

@property(nonatomic, strong) UIImageView *nextPageImageView;

@property(nonatomic, strong) UIView *separatedlLine;

@end

@implementation GZProtocolListTableViewCell

#pragma mark - Initilizer

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self loadNextPageImageView];
        [self loadSeparatedlLine];
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Lazy Loading

- (void)loadNextPageImageView {
    
    if (!_nextPageImageView) {
        
        _nextPageImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_nextPageImageView];
        [_nextPageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-25);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(@15);
            make.height.mas_equalTo(@15);
        }];
        _nextPageImageView.image = [UIImage imageNamed:@"绿色箭头"];
    }
}

- (void)loadSeparatedlLine {
    
    if (!_separatedlLine) {
        
        _separatedlLine = [[UIView alloc] init];
        [self.contentView addSubview:_separatedlLine];
        [_separatedlLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(@1);
        }];
        _separatedlLine.backgroundColor = UIColorFromRGB(0xD8D8D8);
    }
}

- (UILabel *)protocolNameLabel {
    
    if (!_protocolNameLabel) {
        
        _protocolNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_protocolNameLabel];
        [_protocolNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
        }];
        _protocolNameLabel.font = [UIFont systemFontOfSize:13];
        _protocolNameLabel.textColor = UIColorFromRGB(0x00ab5f);
    }
    return _protocolNameLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
