//
//  DMCreditCPCheckCell.h
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/13.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMCreditCPCheckCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setTitleWithString:(NSString *)str checkdate:(NSString *)date;

@end
