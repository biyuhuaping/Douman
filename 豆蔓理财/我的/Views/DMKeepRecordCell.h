//
//  DMKeepRecordCell.h
//  豆蔓理财
//
//  Created by bluesky on 2017/8/25.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^checkTheDetailBlcok)(); //查看详情

@class DMKeepRecordModel;
@interface DMKeepRecordCell : UITableViewCell

@property (nonatomic, strong)DMKeepRecordModel *keepModel;
@property (nonatomic, copy)checkTheDetailBlcok checkTheDetail;

@end
