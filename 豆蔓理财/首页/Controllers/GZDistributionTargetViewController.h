//
//  GZDistributionTargetViewController.h
//  豆蔓理财
//
//  Created by armada on 2016/12/10.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "DMBaseViewController.h"

@interface GZDistributionTargetViewController : DMBaseViewController

/** 购买记录ID */
@property(nonatomic, copy) NSString *assetBuyRecordId;
/** 产品ID */
@property(nonatomic, copy) NSString *assetId;

@property(nonatomic,copy) NSString *repayAmount;

@end
