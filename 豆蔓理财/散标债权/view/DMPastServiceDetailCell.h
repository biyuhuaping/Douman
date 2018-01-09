//
//  DMPastServiceDetailCell.h
//  豆蔓理财
//
//  Created by edz on 2017/7/20.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMRobtEndDetailModel;
@interface DMPastServiceDetailCell : UITableViewCell

@property (nonatomic, strong)DMRobtEndDetailModel *model;
- (CGFloat)returnRowHeight;

@end
