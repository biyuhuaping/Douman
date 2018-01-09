//
//  DMHoldTableCell.h
//  zaiquan
//
//  Created by wujianqiang on 2016/12/6.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DMCreditAssetListModel;
@interface DMHoldTableCell : UITableViewCell

@property (nonatomic, strong) UILabel *periodLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *assetLabel;
@property (nonatomic, strong) UILabel *creditLabel;
@property (nonatomic, strong) UIImageView *detailImage;

@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic, strong) DMCreditAssetListModel *listModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
