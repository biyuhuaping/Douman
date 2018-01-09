//
//  DMCreditInfoCell.h
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/12.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMCreditBaseCell.h"

@interface DMCreditInfoCell : DMCreditBaseCell

@property (nonatomic, strong) NSMutableArray *labelArray;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;



- (void)setupValueWithTitleArray:(NSArray *)titleArray
                     detailArray:(NSArray *)detailArray;

- (void)setCreditInfoWithTitleArray:(NSArray *)titleArray
                        detailArray:(NSArray *)detailArray;

- (void)setPolicyWithTitleArray:(NSArray *)titleArray
                    detailArray:(NSArray *)detailArray;

- (void)setCompanyBaseInfoTitleArray:(NSArray *)titleArray
                         detailArray:(NSArray *)detailArray;
@end
