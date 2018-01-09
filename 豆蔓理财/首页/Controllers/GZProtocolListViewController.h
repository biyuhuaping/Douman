//
//  GZProtocolListViewController.h
//  豆蔓理财
//
//  Created by armada on 2017/3/30.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMBaseViewController.h"
#import "GZContractModel.h"

@interface GZProtocolListViewController : DMBaseViewController

@property(nonatomic, strong) NSArray<GZContractModel *> *dataSource;

@end
