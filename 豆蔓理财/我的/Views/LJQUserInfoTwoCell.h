//
//  LJQUserInfoTwoCell.h
//  豆蔓理财
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJQUserInfoModel.h"
typedef void(^addBankCardBlock)(UIButton *sender);

@interface LJQUserInfoTwoCell : UITableViewCell

@property (nonatomic, copy)addBankCardBlock addBankBlock;

@property (nonatomic, assign)BOOL isCard;

@property (nonatomic, strong)LJQUserInfoModel *model;

@end
