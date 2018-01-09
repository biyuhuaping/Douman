//
//  DMCreditAssetDesCell.h
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/12.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMCreditBaseCell.h"

@interface DMCreditAssetDesCell : DMCreditBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setLoanDescript:(NSString *)descript;
@end
