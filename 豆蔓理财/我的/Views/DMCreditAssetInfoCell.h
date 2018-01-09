//
//  DMCreditAssetInfoCell.h
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/12.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMCreditInfoCell.h"

@interface DMCreditAssetInfoCell : DMCreditInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) NSArray *authenArray;

@end
