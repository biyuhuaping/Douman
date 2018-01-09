//
//  DMRobtCell.h
//  豆蔓理财
//
//  Created by edz on 2017/7/17.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^robotBackBlock)();

@class DMRobtOpeningModel;
@interface DMRobtCell : UITableViewCell

@property (nonatomic, strong)DMRobtOpeningModel *openModel;
@property (nonatomic, copy)robotBackBlock robotBackAction;

@end
