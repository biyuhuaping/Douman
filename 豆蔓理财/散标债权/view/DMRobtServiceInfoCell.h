//
//  DMRobtServiceInfoCell.h
//  豆蔓理财
//
//  Created by edz on 2017/7/17.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMRobtOpeningModel;
@interface DMRobtServiceInfoCell : UITableViewCell

@property (nonatomic, strong)DMRobtOpeningModel *openModel;
- (CGFloat)returnRowHeight;

@property (nonatomic, copy) void(^ContactAction)();


@end
