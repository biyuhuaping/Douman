//
//  LJQWithDrawalVC.h
//  豆蔓分解页面
//
//  Created by mac on 2016/12/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LJQBaseViewVC.h"
#import "LJQUserInfoModel.h"
@interface LJQWithDrawalVC : LJQBaseViewVC

@property (nonatomic, assign)BOOL isOrBankCard;

@property (nonatomic, copy)NSString *availableAmount; //

@property (nonatomic, strong)LJQUserInfoModel *userModel;

@end
