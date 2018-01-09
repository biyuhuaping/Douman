//
//  GZReviewedListNoRecordTableViewCell.h
//  豆蔓理财
//
//  Created by armada on 2017/1/12.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface GZReviewedListNoRecordTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *noRecordLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
