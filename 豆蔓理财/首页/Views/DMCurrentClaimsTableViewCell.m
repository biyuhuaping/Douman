//
//  DMCurrentClaimsTableViewCell.m
//  豆蔓理财
//
//  Created by edz on 2016/12/7.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMCurrentClaimsTableViewCell.h"



@interface DMCurrentClaimsTableViewCell()

{
    UIImageView *image;
}

@end

@implementation DMCurrentClaimsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(GZLoanListModel *)model {
    if (_model != model) {
        _model = model;
    }
    
   
    
    _Name.text = model.loanTitle;
    _Money.text = [NSString stringWithFormat:@"¥%@",model.loanAmount.stringValue];
    
    if ([model.loanTitle isEqual:[NSNull null]]) {
        _Name.text = @"无";
    }
    
    if ([model.loanAmount isEqual:[NSNull null]]) {
    _Money.text = [NSString stringWithFormat:@"¥0"];
    }
    
    
    
    
    double q = model.loanBidPercent.doubleValue;
    
    if (q == 100) {
        [_img setHidden:NO];
    } else {
        [_img setHidden:YES];
    }
    
    
    
    [UIView animateWithDuration:2 animations:^{
        
        image.backgroundColor = [UIColor clearColor];
        image.image = [UIImage imageNamed:@"Mask_"];
        image.alpha = 0.6;
   
        if (iPhone5) {
            image.frame = CGRectMake(26 + q*2,12,200 - q*2, 41);
        } else{
            image.frame = CGRectMake(26 + q *2.5,12,250-q * 2.5, 41);
        }
        

    }];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.Num];
        [self CreateName];
        [self.contentView addSubview:self.Money];
        [self.contentView addSubview:self.img];
        
    }
    return self;
}

- (UILabel *)Num {
    
    if (!_Num) {
        
        _Num = [[UILabel alloc] init];
        _Num.frame = CGRectMake(30, 12, 30, 53 - 12);
        _Num.font = [UIFont systemFontOfSize:12];
//        _Num.textColor = [UIColor colorWithRed:((float)((0x86a7e8 & 0xFF0000) >> 16))/255.0 green:((float)((0x86a7e8 & 0xFF00) >> 8))/255.0 blue:((float)(0x86a7e8 & 0xFF))/255.0 alpha:1.0];
        _Num.textColor = DarkGray;
    }
    
    return _Num;
}

- (void)CreateName {
    

    if (!_Name) {
        
        _Name = [[UILabel alloc] init];
        _Name.frame = CGRectMake(76, 12, 200, 53 - 12);
        if (iPhone5) {
            _Name.frame = CGRectMake(76, 12, 150, 53 - 12);
        }
        _Name.font = [UIFont systemFontOfSize:12];
        _Name.layer.borderWidth = 1;
        _Name.layer.cornerRadius = 10;
        _Name.textAlignment = NSTextAlignmentCenter;
        _Name.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
//        _Name.textColor = [UIColor colorWithRed:((float)((0x86a7e8 & 0xFF0000) >> 16))/255.0 green:((float)((0x86a7e8 & 0xFF00) >> 8))/255.0 blue:((float)(0x86a7e8 & 0xFF))/255.0 alpha:1.0];
        _Name.textColor = DarkGray;
        [self.contentView addSubview:self.Name];
        
    }
    
    if (!image) {
        image = [[UIImageView alloc] init];
        image.layer.cornerRadius = 5;
        image.frame = CGRectMake(26, 12, 250 , 41);
        if (iPhone5) {
            image.frame = CGRectMake(26, 12, 200 , 41);
        }
    }
    
    
    [self.contentView addSubview:image];
      
}


- (UILabel *)Money {
    if (!_Money) {
        _Money = [[UILabel alloc] init];
        _Money.frame = CGRectMake(DMDeviceWidth - 90, 12, 60, 53 - 12);
        _Money.font = [UIFont systemFontOfSize:12];
        _Money.textAlignment = NSTextAlignmentCenter;
//        _Money.textColor = [UIColor colorWithRed:((float)((0x86a7e8 & 0xFF0000) >> 16))/255.0 green:((float)((0x86a7e8 & 0xFF00) >> 8))/255.0 blue:((float)(0x86a7e8 & 0xFF))/255.0 alpha:1.0];
        _Money.textColor = DarkGray;
    }
    return _Money;
}

- (UIImageView *)img {
    
    if (_img == nil) {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(DMDeviceWidth-25, 24, 15, 15)];
        _img.image = [UIImage imageNamed:@"right_arrow_icon"];
        _img.hidden = YES;
    }
    return _img;
}

@end
