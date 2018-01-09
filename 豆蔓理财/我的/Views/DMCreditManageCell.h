//
//  DMCreditManageCell.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/5/3.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMCreditManageConfig.h"

@class DMCreditTransferModel;

@protocol DMCreditManageCellDelegate <NSObject>

- (void)revokeCreditWithIndex:(NSInteger)index;

- (void)transferCreditWithIndex:(NSInteger)index;

- (void)contractWithIndex:(NSInteger)index;

@end

@interface DMCreditManageCell : UITableViewCell


@property (nonatomic) CreditManageType manageType;

@property (nonatomic, assign) id<DMCreditManageCellDelegate>delegate;

@property (nonatomic, strong) DMCreditTransferModel *transferModel;


@end
