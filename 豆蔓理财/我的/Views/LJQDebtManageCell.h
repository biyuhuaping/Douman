//
//  LJQDebtManageCell.h
//  豆蔓理财
//
//  Created by mac on 2017/5/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^contractJumpBlock)(UIButton *sender);
typedef NS_ENUM (NSInteger, LJQDebttransferType) {
    LJQDebttransferUse = 1, //可转让
    LJQDebttransferUseing = 2, //转让中
    LJQDebttransferUsed = 3 //已转让
};
@interface LJQDebtManageCell : UITableViewCell

@property (nonatomic, assign)LJQDebttransferType debtTransferType;

@property (nonatomic, copy)contractJumpBlock contractJump;

@end
