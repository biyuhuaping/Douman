//
//  DMCreditAssetInfoCell.m
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/12.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMCreditAssetInfoCell.h"

@interface DMCreditAssetInfoCell ()

@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation DMCreditAssetInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.text = @"资产信息";
    }
    return self;
}



- (void)setupValueWithTitleArray:(NSArray *)titleArray detailArray:(NSArray *)detailArray{
    [super setupValueWithTitleArray:titleArray detailArray:detailArray];
    
    for (int i = 0; i < titleArray.count; i ++) {
        UIImageView *checkImage = [[UIImageView alloc] initWithFrame:CGRectMake(i%2==0?DMDeviceWidth/2-22:DMDeviceWidth-32,i<2?64:(30 + 64), 12, 12)];
        
        if ([self.authenArray[i] isEqualToString:@"0"]) {
            checkImage.image = [UIImage imageNamed:@"certification_no_icon"]; //////////////审核未通过
        }else{
            checkImage.image = [UIImage imageNamed:@"certification_ok_icon"]; /////////////审核通过
        }
        [self.contentView addSubview:checkImage];
        
        [self.imageArray addObject:checkImage];
    }

    
}

- (NSArray *)authenArray{
    if (_authenArray == nil) {
        self.authenArray = [@[] copy];
    }
    return _authenArray;
}

- (NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        self.imageArray= [@[] mutableCopy];
    }
    return _imageArray;
}

- (int)getYWithi:(int)i{
    if (i<2) {
        return 55;
    }else if(i>=2&&i<4){
        return 85;
    }else if(i>=4&&i<6){
        return 115;
    }else{
        return 145;
    }
}


@end
