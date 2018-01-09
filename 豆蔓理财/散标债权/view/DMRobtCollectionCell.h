//
//  DMRobtCollectionCell.h
//  豆蔓理财
//
//  Created by edz on 2017/7/17.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMRobtOpenInfoModel;
@interface DMRobtCollectionCell : UICollectionViewCell

@property (nonatomic, strong)DMRobtOpenInfoModel *infoModel;
@property (nonatomic, assign)BOOL isSelected;

@end
