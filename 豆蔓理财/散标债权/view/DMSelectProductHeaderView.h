//
//  DMSelectProductHeaderView.h
//  豆蔓理财
//
//  Created by edz on 2017/7/28.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^selectedBtnEvent)(NSInteger index);

@class DMHomeListModel;
@interface DMSelectProductHeaderView : UIView

@property (nonatomic, copy)selectedBtnEvent touchAction;

@property (nonatomic, strong)DMHomeListModel *assetModel;

@end
