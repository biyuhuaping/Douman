//
//  DMCreditCpInfoCell.h
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/13.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMCreditCpInfoCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setupValueWithTitleArray:(NSArray *)titleArray detailArray:(NSArray *)detailArray;


@property (nonatomic, strong) NSMutableArray *labelArray;

@end
