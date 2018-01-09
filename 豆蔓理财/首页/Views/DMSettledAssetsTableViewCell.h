//
//  DMSettledAssetsTableViewCell.h
//  豆蔓理财
//
//  Created by edz on 2016/12/12.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DMSettledAssetsModel;
@interface DMSettledAssetsTableViewCell : UITableViewCell


@property (nonatomic, strong)DMSettledAssetsModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
