//
//  DMAccountInfoCell.m
//  豆蔓理财
//
//  Created by bluesky on 2017/8/25.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMAccountInfoCell.h"

@interface DMAccountInfoCell ()

@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIImageView *jiantouViwe;
@property (nonatomic, strong)UILabel *showTextLabel;

@property (nonatomic, strong)UIView *lineView;
@end

@implementation DMAccountInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.jiantouViwe];
        [self.contentView addSubview:self.showTextLabel];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)setTextStyle:(showTextStyle)textStyle {
    _textStyle = textStyle;
    switch (_textStyle) {
        case showTextStyleNone:
        {
            [self.showTextLabel setTextColor:UIColorFromRGB(0x9a9a9a)];
        }
            break;
        case showTextStyleWithColor:
        {
             [self.showTextLabel setTextColor:UIColorFromRGB(0xfc6f57)];
        }
            break;
            
        default:
            break;
    }
}

- (void)setShowText:(NSString *)showText {
    _showText = showText;
    self.showTextLabel.text = _showText;
    if (!isOrEmpty(_showText)) {
        [self.showTextLabel setHidden:NO];
    }
}

- (void)setCellName:(NSString *)cellName {
    _cellName = cellName;
    self.nameLabel.text = _cellName;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel createLabelFrame:CGRectMake(13, LJQ_VIEW_Height(self.contentView) / 2 - 15 / 2, 200, 15) labelColor:UIColorFromRGB(0x4b5159) textAlignment:(NSTextAlignmentLeft) textFont:14.f];
        _nameLabel.font = FONT_Light(14.f);
    }
    return _nameLabel;
}

- (UIImageView *)jiantouViwe {
    UIImage *image = [UIImage imageNamed:@"jiantou_icon"];
    if (!_jiantouViwe) {
        _jiantouViwe = [[UIImageView alloc] initWithFrame:CGRectMake(DMDeviceWidth - 13 - image.size.width, LJQ_VIEW_Height(self.contentView) / 2 - image.size.height / 2, image.size.width, image.size.height)];
        _jiantouViwe.image = image;
    }
    return _jiantouViwe;
}

- (UILabel *)showTextLabel {
    UIImage *image = [UIImage imageNamed:@"jiantou_icon"];
    if (!_showTextLabel) {
        _showTextLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth - 23 - image.size.width - 200, LJQ_VIEW_Height(self.contentView) / 2 - 7, 200, 13) labelColor:UIColorFromRGB(0x9a9a9a) textAlignment:(NSTextAlignmentRight) textFont:12.f];
        _showTextLabel.font = FONT_Regular(12.f);
        _showTextLabel.hidden = YES;
    }
    return _showTextLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, DMDeviceWidth, 1)];
        _lineView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    }
    return _lineView;
}

@end
