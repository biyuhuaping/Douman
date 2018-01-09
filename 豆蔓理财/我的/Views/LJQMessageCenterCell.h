//
//  LJQMessageCenterCell.h
//  豆蔓分解页面
//
//  Created by mac on 2016/12/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJQSystemMessageModel.h"

@interface LJQMessageCenterCell : UITableViewCell

@property (nonatomic, assign)BOOL isShow;

@property (nonatomic, strong)UIImageView *selectedPitcure;

@property (nonatomic, strong)LJQSystemMessageModel *Messagemodel;

@end
