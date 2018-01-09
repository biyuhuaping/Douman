//
//  GZReviewedListTableViewCell.h
//  豆蔓理财
//
//  Created by armada on 2016/12/8.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZReviewedListTableViewCell : UITableViewCell

@property(nonatomic,strong) UITableView *tableView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setMarkNewImgViewHidden:(BOOL)hidden;

- (void)setCellWithReviewedListModel:(GZProductListModel *)model;

- (void)setProgress:(double)progress;

@end
