//
//  LJQPlatFormNoticeCell.h
//  豆蔓理财
//
//  Created by mac on 2016/12/26.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJQPlanformNoticeModel;
@interface LJQPlatFormNoticeCell : UITableViewCell

@property (nonatomic, assign)BOOL isRead;
@property (nonatomic, assign)BOOL isShow;
@property (nonatomic, strong)LJQPlanformNoticeModel *model;

@end
