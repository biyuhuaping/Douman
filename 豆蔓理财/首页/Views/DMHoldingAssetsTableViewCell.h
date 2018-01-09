//
//  DMHoldingAssetsTableViewCell.h
//  豆蔓理财
//
//  Created by edz on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DMHoldingAssetsModel;
@interface DMHoldingAssetsTableViewCell : UITableViewCell

@property (nonatomic, strong)DMHoldingAssetsModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
