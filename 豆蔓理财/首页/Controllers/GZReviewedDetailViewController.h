//
//  GZReviewedDetailViewController.h
//  豆蔓理财
//
//  Created by armada on 2016/12/9.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMBaseViewController.h"

@interface GZReviewedDetailViewController : DMBaseViewController

/** 产品ID */
@property(nonatomic,assign) NSString *assetId;

/** 产品期限 */
@property(nonatomic,strong) NSNumber *productCycle;

@end
