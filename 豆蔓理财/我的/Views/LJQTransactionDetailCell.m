//
//  LJQTransactionDetailCell.m
//  豆蔓分解页面
//
//  Created by mac on 2016/12/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQTransactionDetailCell.h"
#import "UILabel+DMLabel.h"

@interface LJQTransactionDetailCell ()

@property (nonatomic, strong)UILabel *productLabel;//项目
@property (nonatomic, strong)UILabel *acountLabel; //金额
@property (nonatomic, strong)UILabel *timeLabel; //时间
@property (nonatomic, strong)UILabel *stateLabel; //状态

@end

@implementation LJQTransactionDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.productLabel];
        [self.contentView addSubview:self.acountLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.stateLabel];
    }
    return self;
}

- (UILabel *)productLabel {
    if (!_productLabel) {
        self.productLabel = [UILabel createLabelFrame:CGRectMake(0, 0, SCREENWIDTH / 4, 50) labelColor:UIColorFromRGB(0x787878) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
        self.productLabel.text = @"认购金额";
    }
    return _productLabel;
}

- (UILabel *)acountLabel {
    if (!_acountLabel) {
        self.acountLabel = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH / 4, 0, SCREENWIDTH / 4, 50) labelColor:UIColorFromRGB(0x787878) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
        self.acountLabel.text = @"--";
    }
    return _acountLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        self.timeLabel = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH / 2, 0, SCREENWIDTH / 4, 50) labelColor:UIColorFromRGB(0x787878) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
        self.timeLabel.numberOfLines = 0;
        self.timeLabel.text = @"--";
    }
    return _timeLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        self.stateLabel = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH / 4 * 3, 0, SCREENWIDTH / 4, 50) labelColor:UIColorFromRGB(0x787878) textAlignment:(NSTextAlignmentCenter) textFont:11.f];
        self.stateLabel.text = @"--";
    }
    return _stateLabel;
}

- (void)setModel:(LJQTradeDetailModel *)model {
    if (_model != model) {
        _model = model;
    }
    self.productLabel.text = _model.recordName;
    NSString *string = [self stringFormatterDecimalStyle:@(_model.amount)];
    self.acountLabel.text = [self returnDecimalString:string];
   
    NSArray *array = [_model.timeRecord componentsSeparatedByString:@" "];
    if (array.count > 1) {
      self.timeLabel.text = [NSString stringWithFormat:@"%@\n%@",[array objectAtIndex:0],[array objectAtIndex:1]];
    }else {
        self.timeLabel.text = isOrEmpty(_model.timeRecord) ? @"" : _model.timeRecord;
    }
    
    self.stateLabel.text = _model.statusName;
}

- (NSString *)stringFormatterDecimalStyle:(NSNumber *)money
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    return [formatter stringFromNumber:money];
}

- (NSString *)returnDecimalString:(NSString *)string {
    
    NSString *Decimal;
    
    if ([string containsString:@"."]) {
        Decimal = string;
    }else {
        Decimal = [string stringByAppendingString:@".00"];
    }
    
    return Decimal;
}



@end
