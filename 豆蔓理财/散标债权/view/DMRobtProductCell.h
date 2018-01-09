//
//  DMRobtProductCell.h
//  豆蔓理财
//
//  Created by edz on 2017/7/14.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^immediatelyJoinBlock)(NSString *string);
typedef void(^lookPastServiceBlock)();

typedef void(^selectedCycleBlock)(NSInteger index);

@class DMRobtOpeningModel;
@interface DMRobtProductCell : UITableViewCell

@property (nonatomic, strong)NSMutableArray *infoArr;
@property (nonatomic, strong)DMRobtOpeningModel *openModel;
@property (nonatomic, copy)immediatelyJoinBlock robtJoin;
@property (nonatomic, copy)lookPastServiceBlock pastService;
@property (nonatomic, copy)selectedCycleBlock selectedCycle;

@property (nonatomic, copy)NSString *SelectedGuarantyStyle;


@property (nonatomic, strong)UIButton *joinButton;

@end
