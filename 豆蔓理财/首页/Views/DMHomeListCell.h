//
//  DMHomeListCell.h
//  豆蔓理财
//
//  Created by wujianqiang on 2017/7/26.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMRobtOpeningModel;
@class DMHomeListModel;

@protocol DMHomeListCellDelegate <NSObject>

- (void)didSelectMoreWithIndex:(NSInteger)index;

- (void)didSelectBuyNowWithIndex:(NSInteger)index;

@end

@interface DMHomeListCell : UITableViewCell

@property (nonatomic, strong) DMRobtOpeningModel *robotModel;
@property (nonatomic, strong) DMHomeListModel *listModel;


@property (nonatomic, weak) id<DMHomeListCellDelegate>delegate;



@end
