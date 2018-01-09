//
//  LJQUserInfoCell.h
//  豆蔓理财
//
//  Created by mac on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImmediatelyRealNameBlock)(UIButton *button);
@interface LJQUserInfoCell : UITableViewCell

@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *infoLabel;
@property (nonatomic, copy)ImmediatelyRealNameBlock realNameBlock;
@property (nonatomic, assign)BOOL isRealName;

@end
