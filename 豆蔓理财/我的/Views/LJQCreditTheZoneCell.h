//
//  LJQCreditTheZoneCell.h
//  豆蔓理财
//
//  Created by mac on 2017/5/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DMCreditTransferListModel;

typedef void(^buyCreditTransferBlock)(UIButton *sender);

@interface LJQCreditTheZoneCell : UITableViewCell

@property (nonatomic, copy)buyCreditTransferBlock buyCredit;
@property (nonatomic, strong)DMCreditTransferListModel *listModel;

@end
