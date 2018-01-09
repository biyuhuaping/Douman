//
//  LJQProductIntroductionvc.h
//  豆蔓理财
//
//  Created by mac on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "LJQBaseTableViewVC.h"

@interface LJQProductIntroductionvc : LJQBaseTableViewVC

/** 年化利率 */
@property(nonatomic,assign) double assetRate;
/** 投资期限 */
@property(nonatomic,assign) double assetDuration;
/** 投资方式,0代表等额本息,1代表按月付息到期还本,-1代表两者都不是 */
@property(nonatomic,assign) int assetRepaymentMethod;

@property (nonatomic, copy) NSString *guarantyName;

@end
