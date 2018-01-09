//
//  LJQOpenAccountCell.m
//  豆蔓理财
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQOpenAccountCell.h"

@implementation LJQOpenAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf5f5f9);
        [self createBankView];
    }
    return self;
}

//银行卡
- (void)createBankView {
    UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 16, SCREENWIDTH - 40, 280 * (SCREENWIDTH - 40) / 668)];
    bottomView.image = [[UIImage imageNamed:@"银行卡背景"] imageWithRenderingMode:(UIImageRenderingModeAutomatic)];
    [self.contentView addSubview: bottomView];
    
    UIImage *image = [UIImage imageNamed:@"银行"];
    CGFloat scale = image.size.width / image.size.height;
    UIImageView *imageViw = [[UIImageView alloc] initWithFrame:CGRectMake(-(104 * LJQ_VIEW_Height(bottomView) / 280 * scale / 4 - 20), 0, 104 * LJQ_VIEW_Height(bottomView) / 280 * scale, 104 * LJQ_VIEW_Height(bottomView) / 280)];
    imageViw.image = image;
    imageViw.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [bottomView addSubview:imageViw];
    
    UILabel *label = [UILabel createLabelFrame:CGRectMake(0, 0, LJQ_VIEW_Width(bottomView), 16) labelColor:UIColorFromRGB(0x767676) textAlignment:(NSTextAlignmentCenter) textFont:15.f];
    label.center = CGPointMake(LJQ_VIEW_Width(bottomView) / 2, LJQ_VIEW_Height(bottomView) / 2 + 10);
    label.text = [self returnBankString:@"1234567891234567"];
    [bottomView addSubview:label];
    
    UILabel *nameLabel = [UILabel createLabelFrame:CGRectMake(23, LJQ_VIEW_Height(bottomView) - 23, LJQ_VIEW_Width(bottomView) / 2, 13) labelColor:UIColorFromRGB(0x767676) textAlignment:(NSTextAlignmentLeft) textFont:12.f];
    nameLabel.text = @"持卡人：张三";
    [bottomView addSubview:nameLabel];
    
    UILabel *cardLabel = [UILabel createLabelFrame:CGRectMake(LJQ_VIEW_Width(bottomView) - LJQ_VIEW_Width(bottomView) * 3 / 2 - 16, LJQ_VIEW_Height(bottomView) - 23, LJQ_VIEW_Width(bottomView) * 3 / 2, 13) labelColor:UIColorFromRGB(0x767676) textAlignment:(NSTextAlignmentRight) textFont:12.f];
    cardLabel.text = [self returnIdString:@"12345678912345678"];
    [bottomView addSubview:cardLabel];
    
   
    
}

- (NSString *)returnIdString:(NSString *)string {
    NSString *str = string;
    for (int length = 0; length < string.length; length++) {
        if (length > 2 && length < string.length - 4) {
            str = [str stringByReplacingCharactersInRange:NSMakeRange(length, 1) withString:@"*"];
        }
    }
    return str;
}


- (NSString *)returnBackIdString:(NSString *)string {
    NSString *str = string;
    for (int length = 0; length < string.length; length++) {
        if (length < string.length - 4) {
            str = [str stringByReplacingCharactersInRange:NSMakeRange(length, 1) withString:@"*"];
        }
    }
    return str;
}

- (NSString *)returnBankString:(NSString *)string {
    NSString *str = [self returnBackIdString:string];
    NSMutableString *mutable = [NSMutableString stringWithString:str];
    for (int length = 0; length < string.length; length++) {
        if ((length + 1)% 5 == 0) {
            [mutable insertString:@" " atIndex:length];
        }
    }
    
    NSString *endstr = [NSString stringWithFormat:@"%@",mutable];
    return endstr;
}


@end
