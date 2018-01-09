//
//  GZActivityTableCell.h
//  豆蔓理财
//
//  Created by armada on 2017/5/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZActivityTableCell : UITableViewCell

/** 活动标题 */
@property(nonatomic, strong) UILabel *activityTitleLabel;
/** 活动时间 */
@property(nonatomic, strong) UILabel *activityTimeStampLabel;
/** 活动logo */
@property(nonatomic, strong) UIImageView *activityLogoImageView;

@end
