//
//  DMTenderDescCell.m
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMTenderDescCell.h"

@interface DMTenderDescCell ()

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *botView;

@end

@implementation DMTenderDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        UILabel *point = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 12, 40)];
//        point.text = @"•";
//        point.font = [UIFont systemFontOfSize:14];
//        point.textColor = UIColorFromRGB(0x01b37f);
//        point.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:point];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 10, DMDeviceWidth/2, 40)];
        titleLabel.text = @"资产描述";
        titleLabel.font = FONT_Regular(13);
        titleLabel.textColor = DarkGray;
        [self.contentView addSubview:titleLabel];
//        [self.contentView addSubview:self.botView];
        [self.contentView addSubview:self.descLabel];
    }
    return self;
}


- (void)setLoanDesc:(NSString *)loanDesc{
    _loanDesc = loanDesc;
    
    self.descLabel.text = loanDesc;
    if (loanDesc.length > 0) {
        CGRect rect = [loanDesc boundingRectWithSize:CGSizeMake(DMDeviceWidth-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_Regular(10)} context:nil];
        self.descLabel.frame = CGRectMake(22, 40, DMDeviceWidth-40, rect.size.height + 20);
        self.botView.frame = CGRectMake(0, 60 + rect.size.height, DMDeviceWidth, 10);
    }
}

- (UILabel *)descLabel{
    if (!_descLabel) {
        self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 40, DMDeviceWidth-40, 20)];
        _descLabel.font = FONT_Regular(12);
        _descLabel.textColor = UIColorFromRGB(0x808080);
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

//-(UIView *)botView{
//    if (!_botView) {
//        self.botView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, DMDeviceWidth, 10)];
//        _botView.backgroundColor = UIColorFromRGB(0xf6f5fa);
//    }
//    return _botView;
//}
@end
