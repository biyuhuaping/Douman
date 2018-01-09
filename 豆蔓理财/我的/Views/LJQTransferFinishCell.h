//
//  LJQTransferFinishCell.h
//  豆蔓理财
//
//  Created by mac on 2017/5/5.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^confirmTransferBlock)(UIButton *sender);
@interface LJQTransferFinishCell : UITableViewCell

@property (nonatomic, copy)confirmTransferBlock confirmTransfer;

@end
