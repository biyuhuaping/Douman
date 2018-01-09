//
//  GZBenefitDetailTableViewCell.h
//  豆蔓理财
//
//  Created by armada on 2017/2/16.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCenterXtoMarginPadding 50.0f

@interface GZBenefitDetailTableViewCell : UITableViewCell

/** 月份 */
@property(nonatomic, strong) UILabel *monthLabel;
/** 待回本金 */
@property(nonatomic, strong) UILabel *residualPrincipalLabel;
/** 待结收益 */
@property(nonatomic, strong) UILabel *residualBenefitLabel;
/** 待结本息 */
@property(nonatomic, strong) UILabel *residualWithdrawLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
