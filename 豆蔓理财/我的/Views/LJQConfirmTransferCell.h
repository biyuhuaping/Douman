//
//  LJQConfirmTransferCell.h
//  豆蔓理财
//
//  Created by mac on 2017/5/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMCreditTransferListModel.h"
typedef void(^buyNowBlock)(NSString *string);
typedef void(^textFieldShowBlock)(NSString *string);
typedef void(^questionShowBlock)();
@interface LJQConfirmTransferCell : UITableViewCell

@property (nonatomic, copy)buyNowBlock buyNow;

@property (nonatomic, strong)DMCreditTransferListModel *model;

@property (nonatomic, copy)textFieldShowBlock textFieldShow;

@property (nonatomic, copy)questionShowBlock questionShow;
@end
