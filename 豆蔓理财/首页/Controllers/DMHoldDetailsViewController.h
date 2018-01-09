//
//  DMHoldDetailsViewController.h
//  豆蔓理财
//
//  Created by edz on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMBaseViewController.h"
#import "DMHoldingAssetsModel.h"

@interface DMHoldDetailsViewController : DMBaseViewController

//@property (nonatomic ,strong)DMHoldingAssetsModel *model;

@property (nonatomic ,strong)NSString *assetId;

@property (nonatomic, strong)NSString *storeId;

@end
