//
//  LJQEarlyReimbursementCell.m
//  豆蔓理财
//
//  Created by mac on 2016/12/9.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQEarlyReimbursementCell.h"
#import "LJQEarlyBackMoneyModel.h"

@interface LJQEarlyReimbursementCell ()

@property (nonatomic, strong)UILabel *productLabel;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *amountLabel;
@property (nonatomic, strong)UIImageView *pitcureView;
@property (nonatomic, assign)NSInteger index;
@end

@implementation LJQEarlyReimbursementCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(NSInteger)index {
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    self.index = index;
  //  if (self) {
    //    [self.contentView addSubview:self.productLabel];
      //  [self.contentView addSubview:self.nameLabel];
        //[self.contentView addSubview:self.amountLabel];
       // [self.contentView addSubview:self.pitcureView];
    //}
    //return self;
//}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.numberLabel];
        [self.contentView addSubview:self.productLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.amountLabel];
//        [self.contentView addSubview:self.pitcureView];
    }
    return self;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        self.numberLabel = [UILabel createLabelFrame:CGRectMake(10, 21, 20, 14) labelColor:LightGray textAlignment:(NSTextAlignmentLeft) textFont:12.f];
        self.numberLabel.text = @"1";
    }
    return _numberLabel;
}

- (UILabel *)productLabel {
    if (!_productLabel) {
        self.productLabel = [UILabel createLabelFrame:CGRectMake(25, 21, 150, 14) labelColor:LightGray textAlignment:(NSTextAlignmentLeft) textFont:12.f];
        self.productLabel.text = @"第--期";
    }
    return _productLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        self.nameLabel = [UILabel createLabelFrame:CGRectMake(0, 13, 150, 30) labelColor:LightGray textAlignment:(NSTextAlignmentCenter) textFont:12.f];
        self.nameLabel.center = CGPointMake(SCREENWIDTH / 2, 27);
        self.nameLabel.layer.borderWidth = 1.f;
        self.nameLabel.layer.cornerRadius = 5;
        self.nameLabel.layer.borderColor = MainLine.CGColor;
        self.nameLabel.text = @"某建筑公司扩大规模生产";
    }
    return _nameLabel;
}

- (UILabel *)amountLabel {
    UIImage *iamge = [UIImage imageNamed:@"right_arrow_icon"];
    if (!_amountLabel) {
        self.amountLabel = [UILabel createLabelFrame:CGRectMake(SCREENWIDTH - 16 - iamge.size.width - 150, 21, 150+iamge.size.width, 14) labelColor:LightGray textAlignment:(NSTextAlignmentRight) textFont:12.f];
        self.amountLabel.text = @"¥-------";
    }
    return _amountLabel;
}

- (UIImageView *)pitcureView {
    if (!_pitcureView) {
        UIImage *iamge = [UIImage imageNamed:@"right_arrow_icon"];
        self.pitcureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iamge.size.width, iamge.size.height)];
        self.pitcureView.center = CGPointMake(SCREENWIDTH - 10 - iamge.size.width / 2, 21 + iamge.size.height / 2);
        self.pitcureView.image = iamge;
    }
    return _pitcureView;
}

- (void)setModel:(LJQEarlyBackMoneyModel *)model {
    if (_model != model) {
        _model = model;
    }
    self.productLabel.text = [NSString stringWithFormat:@"第%@期",_model.periods];
    self.nameLabel.text = _model.title;
    CGFloat number = [_model.hasAmount floatValue];
    self.amountLabel.text = [@"¥" stringByAppendingString:[self stringFormatterDecimalStyle:@(number)]];
    
    [self.nameLabel setFrame:CGRectMake(110, 13, DMDeviceWidth-170, 30)];
//    self.nameLabel.center = CGPointMake(SCREENWIDTH / 2, 27);
    
}

- (CGFloat)labelBouce:(NSString *)string {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(SCREENWIDTH, 13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} context:nil];
    return rect.size.width + 10;
}

- (NSString *)stringFormatterDecimalStyle:(NSNumber *)money
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    return [formatter stringFromNumber:money];
}


@end
