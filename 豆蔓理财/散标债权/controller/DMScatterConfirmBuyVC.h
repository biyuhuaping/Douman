//
//  DMScatterConfirmBuyVC.h
//  豆蔓理财
//
//  Created by edz on 2017/6/28.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "LJQBaseViewVC.h"

typedef NS_ENUM(NSUInteger ,buyStyle) {
    buyStyleOfScafferCredit,
    buyStyleOfProduct
};

@class DMScafferListModel;
@class DMHomeListModel;
@interface DMScatterConfirmBuyVC : LJQBaseViewVC

@property (nonatomic, copy)NSString *assetId; //产品id
@property (nonatomic, strong)DMScafferListModel *scafferModel;

@property (nonatomic, strong)DMHomeListModel *productModel;
@property (nonatomic, copy) NSString *guarantyStyle;

@property (nonatomic, assign)buyStyle ToBuyStyle;

@end
