//
//  DMSetupBankTableViewCell.m
//  豆蔓理财
//
//  Created by edz on 2016/12/27.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMSetupBankTableViewCell.h"

@interface DMSetupBankTableViewCell()

@property (nonatomic, strong)UILabel *line;

@end

@implementation DMSetupBankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        [self.contentView addSubview:self.image];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.simple];
        [self.contentView addSubview:self.onetime];
        [self.contentView addSubview:self.day];
        [self.contentView addSubview:self.line];
        
    }
    return self;
}

- (UILabel *)line {
    
    if (!_line) {
        _line = [[UILabel alloc] init];
        _line.frame = CGRectMake(10 + 32 + 11, 55.5, DMDeviceWidth - 10-32-21, 0.5);
        _line.backgroundColor = WITHEBACK_LINE;

    }
    
    return _line;
}


- (UIImageView *)image {
    
    if (!_image) {
        _image = [[UIImageView alloc] init];
        _image.frame = CGRectMake(18, 14, 32, 32);
    
    }
    
    return _image;

}

- (UILabel *)name {
    
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.frame = CGRectMake(65, 24, (DMDeviceWidth - 65)/4, 12);
        _name.font = SYSTEMFONT(12);
        _name.textAlignment = NSTextAlignmentCenter;
        _name.textColor = UIColorFromRGB(0x6d727a);
        
    }
    return _name;
    
}

- (UILabel *)simple {
    
    if (!_simple) {
        _simple = [[UILabel alloc] init];
        _simple.frame = CGRectMake(65+(DMDeviceWidth - 65)/4, 24, (DMDeviceWidth - 65)/4, 12);
        _simple.font = SYSTEMFONT(12);
        _simple.textAlignment = NSTextAlignmentCenter;
        _simple.textColor = UIColorFromRGB(0x6d727a);
    }
    
    return _simple;
    
}


- (UILabel *)onetime {
    
    if (!_onetime) {
        _onetime = [[UILabel alloc] init];
        _onetime.frame = CGRectMake(65+(DMDeviceWidth - 65)/4*2, 24, (DMDeviceWidth - 65)/4, 12);
        _onetime.font = SYSTEMFONT(12);
        _onetime.textColor = UIColorFromRGB(0x6d727a);
        _onetime.textAlignment = NSTextAlignmentCenter;
    }
    
    return _onetime;
    
}


- (UILabel *)day {
    
    if (!_day) {
        _day = [[UILabel alloc] init];
        _day.frame = CGRectMake(65+(DMDeviceWidth - 65)/4*3, 24, (DMDeviceWidth - 65)/4, 12);
        _day.font = SYSTEMFONT(12);
        _day.textColor = UIColorFromRGB(0x6d727a);
        _day.textAlignment = NSTextAlignmentCenter;
    }
    
    return _day;
    
}


@end
