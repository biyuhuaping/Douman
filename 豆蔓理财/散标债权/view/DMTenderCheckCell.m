//
//  DMTenderCheckCell.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMTenderCheckCell.h"

@implementation DMTenderCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *point = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 12, 40)];
        point.text = @"•";
        point.font = [UIFont systemFontOfSize:14];
        point.textColor = UIColorFromRGB(0x01b37f);
        point.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:point];

    }
    return self;
}

- (void)createWithArryay:(NSMutableArray *)array{
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]||[obj isKindOfClass:[UILabel class]] ) {
            [obj removeFromSuperview];
        }
    }];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 10, DMDeviceWidth/2, 40)];
    titleLabel.text = @"审核情况";
    titleLabel.font = FONT_Regular(13);
    titleLabel.textColor = DarkGray;
    [self.contentView addSubview:titleLabel];

    
    for (int i = 0; i < array.count; i ++) {        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i%3) * DMDeviceWidth/3 , 40 + 40 * floor(i/3), DMDeviceWidth/3, 40)];
        label.text = array[i];
        label.textColor = UIColorFromRGB(0x808080);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT_Regular(11);
        [self.contentView addSubview:label];
        
        UIImageView *checkImage = [[UIImageView alloc] initWithFrame:CGRectMake((i%3) * DMDeviceWidth/3+DMDeviceWidth/6 + 30 , 40 + 40 * floor(i/3), 13, 40)];
        checkImage.image = [UIImage imageNamed:@"tender_check"];
        checkImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:checkImage];

        
    }
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, array.count>3?129:89, DMDeviceWidth, 1)];
    view.backgroundColor = UIColorFromRGB(0xf6f5fa);
    [self.contentView addSubview:view];
}

@end
