//
//  DMMyAccountJumpCell.m
//  豆蔓理财
//
//  Created by bluesky on 2017/8/24.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMMyAccountJumpCell.h"
#import "CommonMethod.h"
@interface DMMyAccountJumpCell ()

@property (nonatomic, strong)UIImageView *pitcureView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIImageView *jiantouViwe;
@property (nonatomic, strong)UIView *lineView;

@property (nonatomic, strong)UILabel *showTextLabel;

@end

@implementation DMMyAccountJumpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self.contentView addSubview:self.pitcureView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.jiantouViwe];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.showTextLabel];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        _imageName = imageName;
    }
    UIImage *image = [UIImage imageNamed:_imageName];
    [self.pitcureView setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    self.pitcureView.image = image;
    [self.pitcureView setCenter:CGPointMake(13 + image.size.width / 2, self.contentView.center.y)];
    [self.nameLabel setFrame:CGRectMake(LJQ_VIEW_MaxX(self.pitcureView) + 10, 15, 200, 15)];
    [self.lineView setFrame:CGRectMake(LJQ_VIEW_MaxX(self.pitcureView) + 10, 44, DMDeviceWidth - (LJQ_VIEW_MaxX(self.pitcureView) + 10), 1)];
    
}

- (void)setLabelText:(NSString *)labelText {
    if (_labelText != labelText) {
        _labelText = labelText;
    }
    self.nameLabel.text = _labelText;
}

- (void)setIsOrShowTextLabel:(BOOL)isOrShowTextLabel {
    if (_isOrShowTextLabel != isOrShowTextLabel) {
        _isOrShowTextLabel = isOrShowTextLabel;
    }
    if (_isOrShowTextLabel == YES) {
        [self.showTextLabel setHidden:NO];
    }else {
        [self.showTextLabel setHidden:YES];
    }
}

- (void)setShowText:(NSString *)showText {
    _showText = showText;
    self.showTextLabel.text = _showText;
}


#pragma lazyLoading

- (UIImageView *)pitcureView {
    if (!_pitcureView) {
        _pitcureView = [[UIImageView alloc] init];
    }
    return _pitcureView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel createLabelFrame:CGRectMake(0, 0, 200, 15) labelColor:UIColorFromRGB(0x4b5159) textAlignment:(NSTextAlignmentLeft) textFont:14.f];
        _nameLabel.font = FONT_Light(14.f);
    }
    return _nameLabel;
}

- (UIImageView *)jiantouViwe {
    UIImage *image = [UIImage imageNamed:@"jiantou_icon"];
    if (!_jiantouViwe) {
        _jiantouViwe = [[UIImageView alloc] initWithFrame:CGRectMake(DMDeviceWidth - 13 - image.size.width, 45 / 2 - image.size.height / 2, image.size.width, image.size.height)];
        _jiantouViwe.image = image;
    }
    return _jiantouViwe;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _lineView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    }
    return _lineView;
}

- (UILabel *)showTextLabel {
    UIImage *image = [UIImage imageNamed:@"jiantou_icon"];
    if (!_showTextLabel) {
        _showTextLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth - 23 - image.size.width - 200, 45 / 2 - 7, 200, 13) labelColor:UIColorFromRGB(0x9a9a9a) textAlignment:(NSTextAlignmentRight) textFont:12.f];
        _showTextLabel.font = FONT_Regular(12.f);
    }
    return _showTextLabel;
}


@end
