//
//  DMKeepRecordCell.m
//  豆蔓理财
//
//  Created by bluesky on 2017/8/25.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMKeepRecordCell.h"
#import "DMKeepRecordModel.h"
@interface DMKeepRecordCell ()

@property (nonatomic, strong)UILabel *firstLabel;
@property (nonatomic, strong)UILabel *secordLabel;
@property (nonatomic, strong)UILabel *threeLabel;
@property (nonatomic, strong)UILabel *fourLabel;
@property (nonatomic, strong)UIView *lineView;

@end

@implementation DMKeepRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.firstLabel];
        [self.contentView addSubview:self.secordLabel];
        [self.contentView addSubview:self.threeLabel];
        [self.contentView addSubview:self.fourLabel];
        [self.contentView addSubview:self.lineView];
    }return self;
}

- (void)setKeepModel:(DMKeepRecordModel *)keepModel {
    if (_keepModel != keepModel) {
        _keepModel = keepModel;
    }
    
    NSArray *array;
    if (!isOrEmpty(_keepModel.TIMECREATED)) {
        array = [_keepModel.TIMECREATED componentsSeparatedByString:@" "];
    }else {
        array = @[@"--"];
    }
    self.firstLabel.text = [NSString stringWithFormat:@"%@",[array firstObject]];

}

- (UILabel *)firstLabel {
    if (!_firstLabel) {
        _firstLabel = [UILabel createLabelFrame:CGRectMake(0, 0, DMDeviceWidth / 4, 44) labelColor:UIColorFromRGB(0x7b7b7b) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        _firstLabel.font = FONT_Light(12.f);
        _firstLabel.text =@"--";
    }
    return _firstLabel;
}

- (UILabel *)secordLabel {
    if (!_secordLabel) {
        _secordLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 4, (LJQ_VIEW_Height(self.contentView) - 13) / 2, DMDeviceWidth / 4, 13) labelColor:UIColorFromRGB(0x7b7b7b) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        _secordLabel.font = FONT_Light(12.f);
        _secordLabel.text = @"数据保全";
    }
    return _secordLabel;
}

- (UILabel *)threeLabel {
    if (!_threeLabel) {
        _threeLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 2, (LJQ_VIEW_Height(self.contentView) - 13) / 2, DMDeviceWidth / 4, 13) labelColor:UIColorFromRGB(0x7b7b7b) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        _threeLabel.font = FONT_Light(12.f);
        _threeLabel.text = @"成功";
    }
    return _threeLabel;
}

- (UILabel *)fourLabel {
    if (!_fourLabel) {
        _fourLabel = [UILabel createLabelFrame:CGRectMake(DMDeviceWidth / 4 * 3, (LJQ_VIEW_Height(self.contentView) - 13) / 2, DMDeviceWidth / 4, 13) labelColor:UIColorFromRGB(0x00c79f) textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        _fourLabel.font = FONT_Light(12.f);
        _fourLabel.text = @"查看详情";
        _fourLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookDetail)];
        [_fourLabel addGestureRecognizer:gusture];
    }
    return _fourLabel;
}
- (void)lookDetail {
    !self.checkTheDetail ? : self.checkTheDetail();
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, DMDeviceWidth, 1)];
        _lineView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    }
    return _lineView;
}

@end
