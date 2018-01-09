//
//  DMRobtServiceCell.h
//  豆蔓理财
//
//  Created by edz on 2017/7/17.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedSegmentEvent)(NSInteger index);
@interface DMRobtServiceCell : UITableViewCell

@property (nonatomic, copy)selectedSegmentEvent touchSegment;

@end
