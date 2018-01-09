//
//  DMCreditAssetListModel.h
//  豆蔓理财
//
//  Created by wujianqiang on 2016/12/23.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMCreditAssetListModel : NSObject

@property (nonatomic, copy) NSString *purchaseRatio;    //满标比例
@property (nonatomic, copy) NSString *loanNum;          //债权数量
@property (nonatomic, copy) NSString *sourceOfAssets;   //资产来源
@property (nonatomic, copy) NSString *periods;          //产品期数
@property (nonatomic, copy) NSString *guarantyStyle;    //债权类型
@property (nonatomic, copy) NSString *assetId;          //产品ID
@property (nonatomic, copy) NSString *loanType;

@property (nonatomic) BOOL isAssetFinished;  //是否满标1满标，0未满标
@end
