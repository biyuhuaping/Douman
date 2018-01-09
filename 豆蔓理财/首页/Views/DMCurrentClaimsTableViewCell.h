//
//  DMCurrentClaimsTableViewCell.h
//  豆蔓理财
//
//  Created by edz on 2016/12/7.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GZLoanListModel;
@interface DMCurrentClaimsTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel *Num;
@property (nonatomic, strong)UILabel *Name;
@property (nonatomic, strong)UILabel *Money;

@property (nonatomic, strong)UIImageView *img;

@property (nonatomic, strong)GZLoanListModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
