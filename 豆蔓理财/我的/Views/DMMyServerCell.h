//
//  DMMyServerCell.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/14.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMMyServerHoldListModel;
@interface DMMyServerCell : UITableViewCell

@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) DMMyServerHoldListModel *holdModel;

@property (nonatomic, copy) void(^GetAgreement)(NSInteger index);


@end
