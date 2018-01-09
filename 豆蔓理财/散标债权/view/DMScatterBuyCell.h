//
//  DMScatterBuyCell.h
//  豆蔓理财
//
//  Created by edz on 2017/6/28.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScatterAllBuyBlock)(NSString *balanceStr);
typedef void(^textFieldChangeBlock)(NSString *inputString);

@class DMScafferListModel;
@class DMHomeListModel;
@interface DMScatterBuyCell : UITableViewCell

@property (nonatomic, copy)ScatterAllBuyBlock scatterAllBuy;
@property (nonatomic, copy)textFieldChangeBlock changeStringBlock;

@property (nonatomic, copy)NSString *AvailableBalance;
@property (nonatomic, strong)DMScafferListModel *listModel;
@property (nonatomic, strong)DMHomeListModel *productModel;

@property (nonatomic, assign)BOOL isOrHidden;
@end
