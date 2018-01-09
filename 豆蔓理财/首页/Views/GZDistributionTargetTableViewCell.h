//
//  GZDistributionTargetCell.h
//  豆蔓理财
//
//  Created by armada on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GZLoanListModel.h"

@interface GZDistributionTargetTableViewCell : UITableViewCell

{
    UILabel *_orderLabel;
    UILabel *_debtsRightNameLabel;
    UILabel *_sumOfDebtsRightLabel;
}

/** 序号 */
@property(nonatomic,strong) UILabel *orderLabel;
/** 债权名称 */
@property(nonatomic,strong) UILabel *debtsRightNameLabel;
/** 债权金额 */
@property(nonatomic,strong) UILabel *sumOfDebtsRightLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setCellWithModel:(GZDistributionLoanListModel *)model;

- (void)setOrderLabelWithNum:(NSString *)orderNum;

- (void)maskFadeAnimation;

@end
