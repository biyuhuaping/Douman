//
//  GZDashboardTableCell.h
//  豆蔓理财
//
//  Created by armada on 2017/5/4.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZDashboardTableCell : UITableViewCell

/** 公告标题 */
@property(nonatomic, strong) UILabel *notificationTitleLabel;
/** 公告时间 */
@property(nonatomic, strong) UILabel *notificationTimeStampLabel;
/** 公告内容 */
@property(nonatomic, strong) UILabel *notificationSummaryLabel;

@end
