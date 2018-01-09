//
//  GZSinglePeriodTableViewCell.h
//  豆蔓理财
//
//  Created by armada on 2016/12/14.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "GZDistributionTargetTableViewCell.h"

@class DMSingleLoanModel;
@interface GZSinglePeriodTableViewCell : GZDistributionTargetTableViewCell

@property(nonatomic,weak) UIViewController *delegate;

@property (nonatomic, strong) DMSingleLoanModel *loanModel;

@end
