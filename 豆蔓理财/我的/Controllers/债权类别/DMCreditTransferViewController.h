//
//  DMCreditTransferViewController.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/5/8.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMBaseViewController.h"
#import "DMCreditTransferModel.h"

@interface DMCreditTransferViewController :DMBaseViewController

@property (nonatomic, strong) DMCreditTransferModel *transferModel;

@property (nonatomic, copy) void(^TransferCompletion)();


@end
